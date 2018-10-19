package org.dspace.ubc.content;

import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import java.sql.SQLException;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.annotations.SerializedName;
import com.google.gson.annotations.Expose;
import org.apache.log4j.Logger;

import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Item;
import org.dspace.content.Metadatum;
import org.dspace.core.Context;
import org.dspace.core.I18nUtil;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Group;

import org.dspace.ubc.UBCAccessChecker;

/**
 * Class representing comments.
 *
 */
public class Comment
{
    public enum Status {
        @SerializedName("active")
        ACTIVE,
        @SerializedName("hidden")
        HIDDEN
    }

    private static String DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
    /** log4j logger */
    private static Logger log = Logger.getLogger(Comment.class);

    @Expose(serialize = false, deserialize = false)
    private String commenterDisplayName;
    @Expose(serialize = false, deserialize = false)
    private EPerson commenter;

    private int commenterId;
    private Date created;
    private int rating;
    private String title;
    private String detail;
    private Status status;
    private String uuid;
    private Date deleted;
    private String deleteReason;
    private String anonymousDisplayName;

    public static Comment fromJson(Context context, String jsonString) {
        Gson gson = new GsonBuilder().setDateFormat(DATE_FORMAT).create();
        Comment comment = gson.fromJson(jsonString, Comment.class);
        comment.populateCommenterDetailsById(context);
        return comment;
    }

    public static void addCommentToItem(Context ctx, Item item, Comment comment) throws SQLException, AuthorizeException {
        item.addMetadata("ubc", "comments", null, null,
            new String[] { comment.toJson() });

        double newAvgRating = Comment.calculateAvgRating(ctx, item);
        newAvgRating = (double)Math.round(newAvgRating * 100d) / 100d;  // round to 2 decimal places for storage
        item.clearMetadata("ubc", "avgRating", null, null);
        item.addMetadata("ubc", "avgRating", null, null, Double.toString(newAvgRating));

        item.update();
    }

    public static void deleteCommentFromItem(Context ctx, Item item, String commentUuid, String deleteReason) throws SQLException, AuthorizeException, IllegalArgumentException {
        Metadatum existingCommentMeta = Comment.findCommentMetaByUuid(ctx, item, commentUuid);
        if (existingCommentMeta == null) {
            throw new IllegalArgumentException("Cannot find the comment to delete");
        }
        Comment existingComment = Comment.fromJson(ctx, existingCommentMeta.value);

        Comment newInactiveComment = existingComment.copy();
        newInactiveComment.setStatus(Comment.Status.HIDDEN);
        newInactiveComment.setDeleted(new Date());
        newInactiveComment.setDeleteReason(deleteReason);
        Metadatum newInactiveCommentMeta = existingCommentMeta.copy();
        newInactiveCommentMeta.value = newInactiveComment.toJson();
        item.replaceMetadataValue(existingCommentMeta, newInactiveCommentMeta);

        double newAvgRating = Comment.calculateAvgRating(ctx, item);
        newAvgRating = (double)Math.round(newAvgRating * 10d) / 10d;  // round to 1 decimal place for storage
        item.clearMetadata("ubc", "avgRating", null, null);
        item.addMetadata("ubc", "avgRating", null, null, Double.toString(newAvgRating));

        item.update();
    }

    public static double calculateAvgRating(Context context, Item item) {
        Metadatum[] comments = item.getMetadataByMetadataString("ubc.comments");
        double sum = 0.0;
        double count = 0.0;
        for (Metadatum m : comments) {
            Comment c = Comment.fromJson(context, m.value);
            if (c.getStatus() == Comment.Status.ACTIVE && c.getRating() > 0) {
                sum += c.getRating();
                count += 1;
            }
        }
        if (count > 0) {
            return sum / count;
        } else {
            return 0.0;
        }
    }

    public static Metadatum findCommentMetaByUuid(Context context, Item item, String uuid) {

        if (uuid == null || uuid.equals("") || item == null) {
            return null;
        }

        Metadatum[] comments = item.getMetadataByMetadataString("ubc.comments");
        for (Metadatum m : comments) {
            Comment c = Comment.fromJson(context, m.value);
            if (c.getUuid() != null && c.getUuid().equals(uuid)) {
                return m;
            }
        }

        // can't find the comment
        return null;
    }

    public static Comment findCommentByUuid(Context context, Item item, String uuid) {
        Metadatum meta = findCommentMetaByUuid(context, item, uuid);
        if (meta == null) {
            return null;
        }

        return Comment.fromJson(context, meta.value);
    }

    public static boolean canCommentWithRealName(Context context, EPerson person) throws SQLException {
        UBCAccessChecker accessChecker = new UBCAccessChecker(context);
        return accessChecker.isInGroup(person, UBCAccessChecker.GROUP_NAME_CURATOR) ||
            accessChecker.isInGroup(person, UBCAccessChecker.GROUP_NAME_INSTRUCTOR);
    }

    public static String generateRealDisplayName(Context context, EPerson person) {
        return person.getFullName();
    }

    public static String generateAnonymousDisplayName(Context context, EPerson person) throws SQLException {
        UBCAccessChecker accessChecker = new UBCAccessChecker(context);
        if (accessChecker.isInGroup(person, UBCAccessChecker.GROUP_NAME_CURATOR)) {
            return "A member of Curator group";
        } else if (accessChecker.isInGroup(person, UBCAccessChecker.GROUP_NAME_INSTRUCTOR)) {
            return "A member of Instructor group";
        } else if (accessChecker.isInGroup(person, "admin")) {
            return "A member of Administrator group";
        }

        return "Anonymous user";
    }

    public static Map<Long, String> getRatingDescription(Locale locale) {
        Map<Long, String> result = new HashMap<Long, String>();
        for (int i = 1; i <= 5; i++) {
            result.put(new Long(i), I18nUtil.getMessage("commenting.rating.description."+Long.toString(i), locale));
        }
        return result;
    }

    public Comment() {
        this.status = Status.HIDDEN;        // default hidden
        this.created = new Date();
        this.uuid = UUID.randomUUID().toString();
    }

    public Comment(int commenterId, int rating, String title, String detail, Status status, String anonymousDisplayName) {
        this();
        this.commenterId = commenterId;
        this.rating = rating;
        this.title = title;
        this.detail = detail;
        this.status = status;
        this.anonymousDisplayName = anonymousDisplayName;
    }

    public String toJson() {
        Gson gson = new GsonBuilder().setDateFormat(DATE_FORMAT).create();
        return gson.toJson(this);
    }

    public String getCommenterDisplayName() {
        return this.commenterDisplayName;
    }

    public void setCommenterDisplayName(String commenterDisplayName) {
        this.commenterDisplayName = commenterDisplayName;
    }

    public EPerson getCommenter() {
        return this.commenter;
    }

    public void setCommenter(EPerson commenter) {
        this.commenter = commenter;
    }

    public int getCommenterId() {
        return this.commenterId;
    }

    public void setCommenterId(int commenterId) {
        this.commenterId = commenterId;
    }

    public Date getCreated() {
        return this.created;
    }

    public void setCreated(Date created) {
        this.created = created;
    }

    public int getRating() {
        return this.rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getTitle() {
        return this.title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDetail() {
        return this.detail;
    }

    public void setDetail(String detail) {
        this.detail = detail;
    }

    public Status getStatus() {
        return this.status;
    }

    public void setStatus(Status status) {
        this.status = status;
    }

    public String getUuid() {
        return this.uuid;
    }

    public void setUuid(String uuid) {
        this.uuid = uuid;
    }

    public Date getDeleted() {
        return this.deleted;
    }

    public void setDeleted(Date deleted) {
        this.deleted = deleted;
    }

    public String getDeleteReason() {
        return this.deleteReason;
    }

    public void setDeleteReason(String deleteReason) {
        this.deleteReason = deleteReason;
    }

    public Comment copy() {
        Comment newComment = new Comment(this.commenterId, this.rating, this.title, this.detail, this.status, this.anonymousDisplayName);
        newComment.uuid = this.uuid;    // clone the uuid too
        newComment.deleted = this.deleted;
        newComment.deleteReason = this.deleteReason;
        return newComment;
    }

    private void populateCommenterDetailsById(Context context) {
        if (this.commenterId == 0) {
            return;
        }

        try {
            this.commenter = EPerson.find(context, this.commenterId);
            UBCAccessChecker accessChecker = new UBCAccessChecker(context);

            if (this.commenter != null) {
                if (this.anonymousDisplayName != null && !this.anonymousDisplayName.isEmpty()) {
                    this.commenterDisplayName = this.anonymousDisplayName;
                    // append real name to anonymous display name if current user is sys admin / curator
                    if (accessChecker.hasAdminAccess() || accessChecker.hasCuratorAccess()) {
                        this.commenterDisplayName = this.commenterDisplayName +
                            " (" + this.commenter.getFullName() + ")";
                    }
                } else {
                    this.commenterDisplayName = Comment.generateRealDisplayName(context, this.commenter);
                }
            } else {
                this.commenterDisplayName = "Anonymous User";
            }

        } catch (Exception e) {
            log.error("Failed to find commenter with id " + this.commenterId, e);
            this.commenter = null;
            this.commenterDisplayName = I18nUtil.getMessage("Anonymous User");
        }
    }

}
