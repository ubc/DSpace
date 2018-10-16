/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace.home;

import java.io.IOException;
import java.util.Locale;
import java.util.ResourceBundle;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.core.Context;
import org.dspace.core.NewsManager;

/**
 *
 * @author john
 */
public class ContactPageServlet extends DSpaceServlet {
    private static Logger log = Logger.getLogger(HomeServlet.class);
	
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException
    {
		Locale locale = request.getLocale();
		ResourceBundle msgs = ResourceBundle.getBundle("Messages", locale);
		String content = NewsManager.readNewsFile(msgs.getString("news-contact.html"));
		request.setAttribute("content", content);

		JSPManager.showJSP(request, response, "/ubc/biospace/contact.jsp");
	}
}
