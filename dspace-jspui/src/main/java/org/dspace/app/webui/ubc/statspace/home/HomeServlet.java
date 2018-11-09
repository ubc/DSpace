/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace.home;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.ResourceBundle;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.jstl.core.Config;
import org.apache.log4j.Logger;
import org.dspace.app.util.DCInputsReaderException;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.ubc.retriever.ItemRetriever;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Item;
import org.dspace.content.ItemIterator;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.core.NewsManager;
import org.dspace.core.PluginManager;
import org.dspace.plugin.SiteHomeProcessor;
import org.postgresql.util.PSQLException;

/**
 *
 * @author john
 */
public class HomeServlet extends DSpaceServlet {
    private static Logger log = Logger.getLogger(HomeServlet.class);

	public static final int FEATURED_ARTICLES_COUNT = 3;
	
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
		Locale sessionLocale = UIUtil.getSessionLocale(request);
		Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
		
		try
		{
			// Obtain a context so that the location bar can display log in status
			context = UIUtil.obtainContext(request);
			
			try
			{
				SiteHomeProcessor[] chp = (SiteHomeProcessor[]) PluginManager.getPluginSequence(SiteHomeProcessor.class);
				for (int i = 0; i < chp.length; i++)
				{
					chp[i].process(context, request, response);
				}
			}
			catch (Exception e)
			{
				log.error("caught exception: ", e);
				throw new ServletException(e);
			}

			try {
				request.setAttribute("subjects", SubjectInfo.getSubjects());
			} catch (DCInputsReaderException ex) {
				log.error(ex);
				throw new ServletException(ex);
			} catch (UnsupportedEncodingException ex) {
				log.error(ex);
				throw new ServletException(ex);
			}

			setFeaturedArticlesAttribute(context, request);

			ResourceBundle msgs = ResourceBundle.getBundle("Messages", sessionLocale);
			String homeIntro = NewsManager.readNewsFile(msgs.getString("news-top.html"));
			request.setAttribute("homeIntro", homeIntro);

			// Show home page JSP
			JSPManager.showJSP(request, response, "/home.jsp");
		}
		catch (SQLException se)
		{
			// Database error occurred.
			log.warn(LogManager.getHeader(context,
					"database_error",
					se.toString()), se);
			
			// Also email an alert
			UIUtil.sendAlert(request, se);
			
			JSPManager.showInternalError(request, response);
		}
		finally
		{
			if (context != null)
			{
				context.abort();
			}
		}
	}

	/**
	 * Randomly select resources to be shown on the featured articles carousel.
	 * @param context
	 * @param request 
	 */
	private void setFeaturedArticlesAttribute(Context context, HttpServletRequest request)
		throws UnsupportedEncodingException, SQLException
	{
		Random random = new Random();
		int totalItemCount = 0;
		Set<Integer> selectedNums = new HashSet<Integer>();

		// find out how many resources in total we have
		Collection[] collections = Collection.findAll(context);
		for (Collection collection : collections)
		{
			totalItemCount += collection.countItems();
		}

		if (!(totalItemCount > 0)) return; // nothing to feature

		// randomly pick which articles to feature
		int numRandomArticles = FEATURED_ARTICLES_COUNT;
		if (totalItemCount < FEATURED_ARTICLES_COUNT)
		{
			numRandomArticles = totalItemCount;
		}
		while (selectedNums.size() < numRandomArticles)
		{ // while loop insertion into a set in order to prevent repeats
			selectedNums.add(random.nextInt(totalItemCount));
		}

		int curCount = 0;
		List<Item> itemsToRetrieve = new ArrayList<Item>();
		// Since DSpace only provides an ItemIterator that doesn't let you skip
		// instantiating the item object, we need to go through the iterator
		// creating a whole bunch of unnecessary item objects until we find the
		// random one we picked.
		// Kinda stupid and wouldn't scale well with larger collections, but
		// this should be a temporary measure as we want to be able to pick
		// featured articles in the future.
		for (Collection collection : collections)
		{
			ItemIterator iter = collection.getAllItems();
			try {
				while (iter.hasNext())
				{
					Item item = iter.next();
					if (selectedNums.contains(curCount))
					{
						itemsToRetrieve.add(item);
						selectedNums.remove(curCount);
					}
					if (selectedNums.isEmpty()) break;
					curCount++;
				}
				if (selectedNums.isEmpty()) break;
			} catch (PSQLException ex)
			{ // TODO: figure out why it's throwing this on verf but not on dev
				log.error(ex);
				break;
			}
		}

		// Instantiating the item retriever here because it was throwing
		// exceptions when I was doing this inside the ItemIterator loop.
		// The exceptions only occur on verf, not on my dev setup. I'm guessing
		// that verf has an older jdbc driver. It probably has something to do
		// with the driver only being able to keep one result set open for each
		// sql statement. Since ItemRetriever does a bnuch of sql queries, some
		// of them might be conflicting with ItemIterator. Unfortunately, this
		// only reduced the exceptions and didn't eliminate it, maybe it's
		// conflicting with the Quartz job for packaging items?
		List<ItemRetriever> featuredArticles = new ArrayList<ItemRetriever>();
		for (Item item : itemsToRetrieve)
		{
			ItemRetriever retriever = new ItemRetriever(context, request, item);
			featuredArticles.add(retriever);
		}
		request.setAttribute("featuredArticles", featuredArticles);
		
	}
}
