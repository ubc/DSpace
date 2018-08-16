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
import java.util.List;
import java.util.Locale;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.jsp.jstl.core.Config;
import org.apache.log4j.Logger;
import org.dspace.app.util.DCInput;
import org.dspace.app.util.DCInputsReader;
import org.dspace.app.util.DCInputsReaderException;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.core.PluginManager;
import org.dspace.plugin.SiteHomeProcessor;

/**
 *
 * @author john
 */
public class HomeServlet extends DSpaceServlet {
    private static Logger log = Logger.getLogger(HomeServlet.class);
	
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

			setSubjectAttribute(request);

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
	 * Retrieve subjects information to be used in the "Explore" section of the 
	 * home page. Reads the subjects list from input-forms.xml and then set it
	 * as an attribute to be used by the home page jsp.
	 */
	private void setSubjectAttribute(HttpServletRequest request) throws ServletException, UnsupportedEncodingException
	{
			// get the list of bio subjects from input-forms.xml
			// for showing the explore section on the home page
			List<SubjectInfo> subjects = new ArrayList<SubjectInfo>();
			try {
				DCInputsReader inputsReader = new DCInputsReader();
				DCInput[] inputs = inputsReader.getInputs("default").getPageRows(0, true, true);
				log.debug("Checking Inputs: " + inputs.length);
				for (DCInput input : inputs)
				{
					if (input.getPairsType() != null && input.getPairsType().equals("biospace_subjects"))
					{
						List<String> pairs = input.getPairs();
						boolean skip = false;
						for (String entry : pairs)
						{
							if (skip)
							{
								skip = false;
								continue;
							}
							if (entry.equalsIgnoreCase("other")) continue;
							subjects.add(new SubjectInfo(entry));
							skip = true;
						}
					}
				}
			} catch (DCInputsReaderException ex) {
				log.error(ex);
				throw new ServletException(ex);
			}
			request.setAttribute("subjects", subjects);
			
	}
}
