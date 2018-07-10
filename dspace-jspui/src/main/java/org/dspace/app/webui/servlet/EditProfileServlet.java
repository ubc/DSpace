/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.dspace.app.webui.ubc.retriever.EPersonRetriever;
import org.dspace.app.webui.ubc.statspace.ApproveUserUtil;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.eperson.EPerson;

/**
 * Servlet for handling editing user profiles
 * 
 * @author Robert Tansley
 * @version $Revision$
 */
public class EditProfileServlet extends DSpaceServlet
{
    /** Logger */
    private static Logger log = Logger.getLogger(EditProfileServlet.class);

	//private static String EDIT_PROFILE_JSP = "/register/edit-profile.jsp";
	private static String EDIT_PROFILE_JSP = "/ubc/register/edit-profile.jsp";

    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        // A GET displays the edit profile form. We assume the authentication
        // filter means we have a user.
        log.info(LogManager.getHeader(context, "view_profile", ""));

        EPerson eperson = context.getCurrentUser();
        request.setAttribute("eperson", eperson);
		request.setAttribute("user", new EPersonRetriever(eperson));

        JSPManager.showJSP(request, response, EDIT_PROFILE_JSP);
    }

    protected void doDSPost(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        // Get the user - authentication should have happened
        EPerson eperson = context.getCurrentUser();

        // Find out if they're trying to set a new password
        boolean settingPassword = false;

        if (!eperson.getRequireCertificate() && !StringUtils.isEmpty(request.getParameter("password")))
        {
            settingPassword = true;
        }
		// check for request to be added to instructor access
		updateUserRequestInstructorAccess(context, eperson, request);

        // Set the user profile info
        boolean ok = updateUserProfile(eperson, request);

        if (!ok)
        {
            request.setAttribute("missing.fields", Boolean.TRUE);
        }

        if (ok && settingPassword)
        {
            // They want to set a new password.
            ok = confirmAndSetPassword(eperson, request);

            if (!ok)
            {
                request.setAttribute("password.problem", Boolean.TRUE);
            }
        }

        if (ok)
        {
            // Update the DB
            log.info(LogManager.getHeader(context, "edit_profile",
                    "password_changed=" + settingPassword));
            eperson.update();

            // Show confirmation
            request.setAttribute("password.updated", Boolean.valueOf(settingPassword));
            JSPManager.showJSP(request, response,
                    "/register/profile-updated.jsp");

            context.complete();
        }
        else
        {
            log.info(LogManager.getHeader(context, "view_profile",
                    "problem=true"));

            request.setAttribute("eperson", eperson);
			request.setAttribute("user", new EPersonRetriever(eperson));

            JSPManager.showJSP(request, response, EDIT_PROFILE_JSP);
        }
    }

	/**
	 * If a user requests instructor access, add them to the list of users to be vetted.
	 * @param context
	 * @param person 
	 */
	public static void updateUserRequestInstructorAccess(Context context, EPerson person, HttpServletRequest request) throws SQLException, AuthorizeException
	{
		String requestInstructorAccess = request.getParameter("requestInstructorAccess");
		if (requestInstructorAccess != null && !requestInstructorAccess.isEmpty())
		{ // someone is requesting instructor access
			ApproveUserUtil approveUser = new ApproveUserUtil(context);
			approveUser.addUserForApproval(person);
		}
	}

    /**
     * Update a user's profile information with the information in the given
     * request. This assumes that authentication has occurred. This method
     * doesn't write the changes to the database (i.e. doesn't call update.)
     * 
     * @param eperson
     *            the e-person
     * @param request
     *            the request to get values from
     * 
     * @return true if the user supplied all the required information, false if
     *         they left something out.
     */
    public static boolean updateUserProfile(EPerson eperson,
            HttpServletRequest request)
    {
        // Get the parameters from the form
        String lastName = request.getParameter("last_name");
        String firstName = request.getParameter("first_name");
        String phone = request.getParameter("phone");
        String role = request.getParameter("role");
        String unit = request.getParameter("unit");
        String institution = request.getParameter("institution");
        String language = request.getParameter("language");
        String institutionType = request.getParameter("institution_type");
        String institutionUrl = request.getParameter("institution_url");
        String institutionAddress = request.getParameter("institution_address");
        String supervisorContact = request.getParameter("supervisor_contact");
		String additionalInfo = request.getParameter("additional");
		String requestInstructorAccess = request.getParameter("requestInstructorAccess");

        // Update the eperson
        eperson.setFirstName(firstName);
        eperson.setLastName(lastName);
        eperson.setMetadata("phone", phone);
        eperson.setLanguage(language);

        eperson.clearMetadata("eperson", "role", null, "*");
        eperson.addMetadata("eperson", "role", null, "*", role);
        
        eperson.clearMetadata("eperson", "unit", null, "*");
        eperson.addMetadata("eperson", "unit", null, "*", unit);
        
        eperson.clearMetadata("eperson", "institution", null, "*");
        eperson.addMetadata("eperson", "institution", null, "*", institution);
        
        eperson.clearMetadata("eperson", EPersonRetriever.INSTITUTION_ELEMENT, EPersonRetriever.TYPE_QUALIFIER, "*");
        eperson.addMetadata("eperson", EPersonRetriever.INSTITUTION_ELEMENT, EPersonRetriever.TYPE_QUALIFIER, "*", institutionType);

        eperson.clearMetadata("eperson", EPersonRetriever.INSTITUTION_ELEMENT, EPersonRetriever.ADDRESS_QUALIFIER, "*");
        eperson.addMetadata("eperson", EPersonRetriever.INSTITUTION_ELEMENT, EPersonRetriever.ADDRESS_QUALIFIER, "*", institutionAddress);

        eperson.clearMetadata("eperson", EPersonRetriever.INSTITUTION_ELEMENT, EPersonRetriever.URL_QUALIFIER, "*");
        eperson.addMetadata("eperson", EPersonRetriever.INSTITUTION_ELEMENT, EPersonRetriever.URL_QUALIFIER, "*", institutionUrl);

        eperson.clearMetadata("eperson", EPersonRetriever.SUPERVISOR_ELEMENT, null, "*");
        eperson.addMetadata("eperson", EPersonRetriever.SUPERVISOR_ELEMENT, null, "*", supervisorContact);

        eperson.clearMetadata("eperson", EPersonRetriever.ADDITIONALINFO_ELEMENT, null, "*");
        eperson.addMetadata("eperson", EPersonRetriever.ADDITIONALINFO_ELEMENT, null, "*", additionalInfo);

        eperson.clearMetadata("eperson", EPersonRetriever.REQUEST_INSTRUCTOR_ACCESS_ELEMENT, null, "*");
        eperson.addMetadata("eperson", EPersonRetriever.REQUEST_INSTRUCTOR_ACCESS_ELEMENT, null, "*", requestInstructorAccess);
        // Check all required fields are there
        return (!StringUtils.isEmpty(lastName) && !StringUtils.isEmpty(firstName));
    }

    /**
     * Set an eperson's password, if the passwords they typed match and are
     * acceptible. If all goes well and the password is set, null is returned.
     * Otherwise the problem is returned as a String.
     * 
     * @param eperson
     *            the eperson to set the new password for
     * @param request
     *            the request containing the new password
     * 
     * @return true if everything went OK, or false
     */
    public static boolean confirmAndSetPassword(EPerson eperson,
            HttpServletRequest request)
    {
        // Get the passwords
        String password = request.getParameter("password");

        // Check it's there and long enough
        if ((password == null) || (password.length() < 8))
        {
            return false;
        }

        // Everything OK so far, change the password
        eperson.setPassword(password);

        return true;
    }
}
