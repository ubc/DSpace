package org.dspace.app.webui.ubc.statspace.home;

import java.io.IOException;
import java.util.Locale;
import java.util.ResourceBundle;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.ubc.statspace.BlurbManager;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.core.Context;
import org.dspace.core.NewsManager;

public class ContactUsServlet extends DSpaceServlet
{
    private static Logger log = Logger.getLogger(ContactUsServlet.class);
	
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException
    {
		request.setAttribute("content", BlurbManager.getBlurb(request, BlurbManager.CONTACT_US));

		JSPManager.showJSP(request, response, "/ubc/biospace/contact-us.jsp");
	}
}
