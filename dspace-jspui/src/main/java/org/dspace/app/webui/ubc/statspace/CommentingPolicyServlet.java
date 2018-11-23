package org.dspace.app.webui.ubc.statspace;

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

public class CommentingPolicyServlet extends DSpaceServlet {
    private static Logger log = Logger.getLogger(CommentingPolicyServlet.class);
	
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException, SQLException
    {
		BlurbManager blurb = new BlurbManager(context);
		request.setAttribute("content", blurb.getBlurb(BlurbManager.COMMENTING_POLICY));

		JSPManager.showJSP(request, response, "/ubc/biospace/commenting-policy.jsp");
	}
}
