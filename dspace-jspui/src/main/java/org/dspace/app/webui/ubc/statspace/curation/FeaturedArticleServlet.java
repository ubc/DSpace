package org.dspace.app.webui.ubc.statspace.curation;

import com.google.gson.JsonArray;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import java.io.IOException;
import java.io.PrintWriter;
import java.security.InvalidParameterException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.ubc.retriever.ItemRetriever;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;
import org.dspace.ubc.UBCAccessChecker;

public class FeaturedArticleServlet extends DSpaceServlet
{
    private static Logger log = Logger.getLogger(FeaturedArticleServlet.class);
	
	/**
	 * Returns a JSON list of featured articles given a collection.
	 * @param context
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
    protected void doDSGet(Context context, HttpServletRequest request,
    					   HttpServletResponse response)
        throws ServletException, IOException, SQLException, AuthorizeException
    {
		String collection = request.getParameter(FeaturedArticleManager.PARAM_COLLECTION);
		if (collection == null)
		{
			send400Error(response, "Missing collection, please select a collection.");
			return;
		}
		FeaturedArticleManager featuredArticleManager = new FeaturedArticleManager(context, request);
		List<ItemRetriever> articles = featuredArticleManager.getArticles(collection);
		JsonArray articlesJson = new JsonArray();
		for (ItemRetriever article : articles)
		{
			JsonObject articleJson = new JsonObject();
			articleJson.add("ID", new JsonPrimitive(article.getItem().getID()));
			articleJson.add("title", new JsonPrimitive(article.getTitle()));
			articleJson.add("summary", new JsonPrimitive(article.getSummary()));
			articleJson.add("URL", new JsonPrimitive(article.getUrl()));
			articlesJson.add(articleJson);
		}

		sendJSON(response, articlesJson.toString());
	}

	/**
	 * Saves an article to a collection's featured articles metadata.
	 * 
	 * @param context
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
    protected void doDSPost(Context context, HttpServletRequest request,
    					   HttpServletResponse response)
        throws ServletException, IOException, SQLException, AuthorizeException
    {
		// Check to see if the user has permission to do this
		UBCAccessChecker accessChecker = new UBCAccessChecker(context);
		if (!accessChecker.hasCuratorAccess()) 
		{
			sendJSONError(response, "Permission denied.", HttpServletResponse.SC_FORBIDDEN);
			return;
		}
		// Check the parameters to see if they're missing
		String collection = request.getParameter(FeaturedArticleManager.PARAM_COLLECTION);
		String articleURL = request.getParameter(FeaturedArticleManager.PARAM_ADD_ARTICLE);
		if (collection == null || collection.isEmpty()) 
		{
			send400Error(response, "Missing collection, please select a collection.");
			return;
		}
		if (articleURL == null || articleURL.isEmpty()) 
		{
			send400Error(response, "Empty article URL, please fill it in.");
			return;
		}
		FeaturedArticleManager featuredArticleManager = new FeaturedArticleManager(context, request);
		try 
		{
			featuredArticleManager.addArticle(collection, articleURL);
		} catch(InvalidParameterException | SQLException | AuthorizeException e) {
			send400Error(response, e.getMessage());
			return;
		}
		JsonObject json = new JsonObject();
		json.add("status", new JsonPrimitive("success"));
		sendJSON(response, json.toString());
	}

	/**
	 * Delete an article given a collection and article ID.
	 * @param context
	 * @param request
	 * @param response
	 * @throws ServletException
	 * @throws IOException 
	 */
	protected void doDSDelete(Context context, HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException
	{
		String collection = request.getParameter(FeaturedArticleManager.PARAM_COLLECTION);
		String articleID = request.getParameter(FeaturedArticleManager.PARAM_REMOVE_ARTICLE);
		if (collection == null || collection.isEmpty()) 
		{
			send400Error(response, "Missing collection, please select a collection.");
			return;
		}
		if (articleID == null || articleID.isEmpty()) 
		{
			send400Error(response, "Error, empty article ID.");
			return;
		}
		FeaturedArticleManager featuredArticleManager = new FeaturedArticleManager(context, request);
		try 
		{
			featuredArticleManager.removeArticle(collection, articleID);
		} catch(InvalidParameterException | SQLException | AuthorizeException e) {
			send400Error(response, e.getMessage());
			return;
		}
		JsonObject json = new JsonObject();
		json.add("status", new JsonPrimitive("success"));
		sendJSON(response, json.toString());
	}

	private void sendJSON(HttpServletResponse response, String data) throws IOException
	{
		response.setContentType("application/json");
		PrintWriter out = response.getWriter();
		out.print(data);
		out.flush();
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
