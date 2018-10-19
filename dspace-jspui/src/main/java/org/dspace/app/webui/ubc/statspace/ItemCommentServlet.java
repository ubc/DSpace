package org.dspace.app.webui.ubc.statspace;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.ArrayList;

import javax.mail.MessagingException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import org.apache.commons.validator.EmailValidator;
import org.apache.log4j.Logger;

import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.ubc.retriever.ItemRetriever;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Item;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.core.Email;
import org.dspace.core.I18nUtil;
import org.dspace.core.LogManager;
import org.dspace.eperson.EPerson;

import org.dspace.ubc.content.Comment;
import org.dspace.ubc.UBCAccessChecker;

/**
 * Handle actions on item comments. Instead of using doDelete and doPut,
 * use special case in doDSPost to handle delete and create requests
 **/
public class ItemCommentServlet extends DSpaceServlet {
    private static Logger log = Logger.getLogger(ItemCommentServlet.class);

    protected void doDSPost(Context context, HttpServletRequest request,
        HttpServletResponse response) throws ServletException, IOException,
        SQLException, AuthorizeException {

        // quick check and reject to avoid cpu hog
        boolean commentingEnabled = ConfigurationManager.getBooleanProperty("commenting.enabled", true);
        if (!commentingEnabled) {
            sendJSONError(response, "Permission denied.", HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        UBCAccessChecker accessChecker = new UBCAccessChecker(context);
        if (!accessChecker.isLoggedIn()) {
            sendJSONError(response, "Permission denied.", HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Parse json data from request
        StringBuffer sb = new StringBuffer();
        try {
            String line = null;
            BufferedReader reader = request.getReader();
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        } catch (Exception e) { /* ignore read error */ }
        JsonObject jsonObject = new JsonParser().parse(sb.toString()).getAsJsonObject();
        String action = jsonObject.get("action").getAsString();
        JsonObject data = jsonObject.get("data").getAsJsonObject();

        int item_id = data.get("item_id").getAsInt();
        if (action == null || action.isEmpty()) {
            send400Error(response, "Missing action parameter.");
            return;
        }
        if (item_id == 0) {
            send400Error(response, "Missing item ID parameter.");
            return;
        }

        Context ctx = new Context();
        Item item = Item.find(ctx, item_id);
        if (item == null) {
            send400Error(response, "Invalid item.");
            return;
        }
        // if the current user can't access the item, can't perform comment related actions on it
        if (!accessChecker.hasItemAccess(item)) {
            sendJSONError(response, "Permission denied.", HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        switch (action) {
            case "create":
                // are there too many comments?
                ItemRetriever itemRetriever = new ItemRetriever(context, request, item);
                if (ConfigurationManager.getIntProperty("commenting.max-comment-per-item", 10000) <=
                    itemRetriever.getActiveCommentCount()) {
                    send400Error(response, "Too many comments.");
                    return;
                }

                Comment newCreateComment = payloadToComment(context,
                    context.getCurrentUser(), data);
                if (newCreateComment == null) {
                    send400Error(response, "Invalid parameters.");
                    return;
                }

                ctx.turnOffAuthorisationSystem();
                Comment.addCommentToItem(ctx, item, newCreateComment);
                ctx.complete();
                break;

            case "delete":
                if (!accessChecker.hasCuratorAccess()) {
                    sendJSONError(response, "Permission denied.", HttpServletResponse.SC_FORBIDDEN);
                    return;
                }

                String commentUuid = data.get("commentUuid").getAsString();
                if (commentUuid == null || commentUuid.equals("")) {
                    send400Error(response, "Invalid comment id.");
                    return;
                }
                String deleteReason = data.get("deleteReason").getAsString();

                ctx.turnOffAuthorisationSystem();
                try {
                    Comment.deleteCommentFromItem(ctx, item, commentUuid, deleteReason);
                    log.info(LogManager.getHeader(context, "comment_deleted", "commentUuid="
                            + commentUuid) + ":deletedBy=" + context.getCurrentUser().getID());
                } catch (IllegalArgumentException e) {
                    send400Error(response, "Cannot find the comment.");
                    return;
                }
                ctx.complete();

                try {
                    Comment deletedComment = Comment.findCommentByUuid(context, item, commentUuid);
                    notifyCommentDeleted(context, item, deletedComment, deleteReason);
                } catch (Exception e) {
                    log.error("Problem sending notification after deleting comment");
                }
                break;

            default:
                send400Error(response, "Invalid action parameter.");
                return;
        }

        response.setContentType("application/json");
        PrintWriter out = response.getWriter();
        out.print("{ \"success\": \"done\" }");
        out.flush();
    }

    private Comment payloadToComment(Context context, EPerson commenter, JsonObject data) throws SQLException {
        int commenterId = commenter.getID();
        int rating = data.get("rating").getAsInt();
        if (rating < 0) {
            rating = 0;
        }
        if (rating > 5) {
            rating = 5;
        }
        String title = data.get("title").getAsString();
        if (title == null) {
            title = "";
        }
        title = title.trim();
        String detail = data.get("detail").getAsString();
        if (detail == null) {
            detail = "";
        }
        detail = detail.trim();

        // needs either rating or comment details
        if (rating == 0 && detail.isEmpty()) {
            return null;
        }
        // over max length?
        if (title.length() > Integer.valueOf(ConfigurationManager.getIntProperty("commenting.title.max-length", 120)) ||
            detail.length() > Integer.valueOf(ConfigurationManager.getIntProperty("commenting.detail.max-length", 10000))) {
            return null;
        }

        // comment anonymously, unless commenter can leave comment with real name and enabled it explicitly
        String anonymousDisplayName = Comment.generateAnonymousDisplayName(context, commenter);
        if (Comment.canCommentWithRealName(context, commenter) && !data.get("isAnnonymousComment").getAsBoolean()) {
            anonymousDisplayName = null;
        }

        Comment comment = new Comment(commenterId, rating, title, detail, Comment.Status.ACTIVE, anonymousDisplayName);
        return comment;
    }

    private boolean notifyCommentDeleted(Context context, Item item, Comment comment, String reason) throws IOException {
        EmailValidator ev = EmailValidator.getInstance();

        EPerson commenter = comment.getCommenter();
        String commenterEmail = commenter.getEmail();

        Email email = Email.getEmail(I18nUtil.getEmailFilename(context.getCurrentLocale(), "delete_comment_notification"));
        List<String> recipients = new ArrayList<>();

        // find recipients for the notification email
        if ((commenterEmail == null) || commenterEmail.equals("")
                || !ev.isValid(commenterEmail)) {
            log.info(LogManager.getHeader(context, "notify_comment_deleted",
                    "No valid commenter email. Skipping."));
        } else {
            recipients.add(commenterEmail);
        }
        String curatorEmail = ConfigurationManager
                .getProperty("commenting.delete.curator.email");
        if ((curatorEmail == null) || curatorEmail.equals("")
                || !ev.isValid(curatorEmail)) {
            log.info(LogManager.getHeader(context, "notify_comment_deleted",
                    "No valid curator email commenting.delete.curator.email defined in configuration file. Skipping."));
        } else {
            recipients.add(curatorEmail);
        }

        if (recipients.size() == 0) {
            return false;
        }
        for (String recipient : recipients) {
            email.addRecipient(recipient);
        }

        try {
            SimpleDateFormat dateformat = new SimpleDateFormat("MMM dd, yyyy");
            email.addArgument(ConfigurationManager.getProperty("dspace.name")); // app name
            email.addArgument(commenter.getFullName());
            email.addArgument(item.getName()); // resource name
            email.addArgument(comment.getTitle());
            email.addArgument(comment.getDetail());
            email.addArgument(dateformat.format(comment.getCreated())); // comment date
            email.addArgument(reason); // reason
            email.addArgument(ConfigurationManager.getProperty("commenting.delete.curator.email")); // reply-to
            email.addArgument(ConfigurationManager.getProperty("mail.from.address"));  // sender email
            email.addArgument(ConfigurationManager.getProperty("commenting.policy.url"));  // policy url

            // if there is no curator email set, set Reply-to as the dspace feedback
            if ((curatorEmail == null) || curatorEmail.equals("")
                    || !ev.isValid(curatorEmail)) {
                 email.setReplyTo(ConfigurationManager
                         .getProperty("feedback.recipient"));
             } else {
                 email.setReplyTo(curatorEmail);
             }

            email.send();

            log.info(LogManager.getHeader(context, "notify_comment_deleted", "commentUuid="
                    + comment.getUuid()));
        } catch (MessagingException me) {
            log.warn(LogManager.getHeader(context,
                    "error_mailing_comment_deleted", ""), me);
            return false;
        }

        return true;
    }

    private void sendJSONError(HttpServletResponse response, String msg, int status) throws IOException {
        response.setContentType("application/json");
        response.setStatus(status);
        PrintWriter out = response.getWriter();
        out.print("{\"error\":\""+ msg +"\"}");
        out.flush();
    }

    private void send400Error(HttpServletResponse response, String msg) throws IOException {
        sendJSONError(response, msg, HttpServletResponse.SC_BAD_REQUEST);
    }

}