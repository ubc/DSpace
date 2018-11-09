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
import org.dspace.app.webui.ubc.statspace.curation.FeaturedArticleManager;
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

			ResourceBundle msgs = ResourceBundle.getBundle("Messages", sessionLocale);
			String homeIntro = NewsManager.readNewsFile(msgs.getString("news-top.html"));
			request.setAttribute("homeIntro", homeIntro);

			FeaturedArticleManager featuredArticleManager = new FeaturedArticleManager(context, request);
			request.setAttribute("featuredArticles", featuredArticleManager.getAllArticles());
			
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

}
