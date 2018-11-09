/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace.curation;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.ubc.UBCAccessChecker;

/**
 *
 * @author john
 */
public class ApproveUserServlet extends DSpaceServlet {
    /** log4j category */
    private static Logger log = Logger.getLogger(ApproveUserServlet.class);
	
    protected void doDSGet(Context context, HttpServletRequest request,
    					   HttpServletResponse response)
        throws ServletException, IOException, SQLException, AuthorizeException
    {
		response.setContentType("application/json");
		// Get the printwriter object from response to write the required json object to the output stream
		PrintWriter out = response.getWriter();
		// Assuming your json object is **jsonObject**, perform the following, it will return your json object
		out.print("{\"test\":1}");
		out.flush();
	}

    protected void doDSPost(Context context, HttpServletRequest request,
    					   HttpServletResponse response)
        throws ServletException, IOException, SQLException, AuthorizeException
    {
		// Check to see if the user has permission to do this
		UBCAccessChecker accessChecker = new UBCAccessChecker(context);
		if (!accessChecker.hasCuratorAccess()) {
			sendJSONError(response, "Permission denied.", HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		// Check the parameters to see if they're missing
		String action = request.getParameter("action");
		String useridStr = request.getParameter("userid");
		if (action == null) {
			send400Error(response, "Missing action parameter.");
			return;
		}
		if (useridStr == null) {
			send400Error(response, "Missing user ID parameter.");
			return;
		}

		// Check to see if we have a valid user
		int userid = Integer.parseInt(useridStr);
		EPerson person = EPerson.find(context, userid);
		if (person == null) {
			send400Error(response, "Couldn't find the user specified. Does this user still exist?");
			return;
		}

		ApproveUserUtil approveUtil = new ApproveUserUtil(context);
		String successMsg = "";
		if (action.equals(ApproveUserUtil.ACTION_GRANT)) {
			// if grant permission, add user to instructor group
			approveUtil.grantUserInstructorPermission(person);
			successMsg = "Granted user instructor permission.";
		}
		else if (action.equals(ApproveUserUtil.ACTION_DENY)) {
			// remove user from toBeVetted group
			approveUtil.denyUserInstructorPermission(person);
			successMsg = "Denied user instructor permission.";
		}
		else {
			send400Error(response, "Unknown action requested.");
			return;
		}
		
		response.setContentType("application/json");
		// Get the printwriter object from response to write the required json object to the output stream
		PrintWriter out = response.getWriter();
		// Assuming your json object is **jsonObject**, perform the following, it will return your json object
		out.print("{\"success\":\""+ successMsg +"\"}");
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
