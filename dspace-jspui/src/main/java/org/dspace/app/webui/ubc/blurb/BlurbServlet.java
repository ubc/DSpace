/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.blurb;

import java.io.IOException;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;

/**
 *
 * @author john
 */
public class BlurbServlet extends DSpaceServlet {
    private static Logger log = Logger.getLogger(BlurbServlet.class);

    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
		String blurbType = request.getParameter("blurb");
		if (blurbType == null || !BlurbManager.BLURB_TYPES.contains(blurbType))
		{
			JSPManager.showInvalidIDError(request, response, blurbType, -1);
			return;
		}
		BlurbManager blurb = new BlurbManager(context);
		request.setAttribute("blurbType", blurbType);
		request.setAttribute("blurb", blurb.getBlurb(blurbType));
		log.debug("Displaying blurb.jsp");
        JSPManager.showJSP(request, response, "/ubc/blurb/blurb.jsp");
    }

}
