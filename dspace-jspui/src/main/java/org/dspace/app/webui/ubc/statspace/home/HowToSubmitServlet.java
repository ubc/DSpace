/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace.home;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.ubc.statspace.curation.BlurbManager;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.core.Context;

/**
 *
 * @author john
 */
public class HowToSubmitServlet extends DSpaceServlet
{
    private static Logger log = Logger.getLogger(HowToSubmitServlet.class);
	
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException, SQLException
    {
		BlurbManager blurb = new BlurbManager(context);
		request.setAttribute("content", blurb.getBlurb(BlurbManager.HOW_TO_SUBMIT));

		JSPManager.showJSP(request, response, "/ubc/biospace/how-to-submit.jsp");
	}
}
