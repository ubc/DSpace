/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.importer;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.fileupload.FileUploadBase;

import org.apache.log4j.Logger;

import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.util.FileUploadRequest;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;

/**
 *
 * @author john
 */
public class ImportCommunitiesCollectionsServlet extends DSpaceServlet {
	
    /** Logger */
    private static Logger log = Logger.getLogger(ImportCommunitiesCollectionsServlet.class);

	private static String TOGGLE_COMMUNITIES_COLLECTIONS =
			"importCommunitiesOrCollectionsToggle";
	private static String IMPORT_COLLECTIONS = "ImportCollections";
	private static String IMPORT_COMMUNITIES = "ImportCommunities";

    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
		setImportTypeConstants(request);
		setCSVHeaderConstants(request);
		JSPManager.showJSP(request, response,
				"/ubc/import-communities-collections.jsp");
	}
	
    protected void doDSPost(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
		boolean isSuccess = true;
		List<String> errorMsgs = new ArrayList<String>();

        String contentType = request.getContentType();
        if ((contentType != null) &&
			(contentType.indexOf("multipart/form-data") != -1))
		{
			log.debug("I think this request has a file upload");
		}
		else
		{
			log.debug("This request doesn't seem to have a file upload");
		}
		try {
			// Don't know how to use the fancier resumable.js upload, so using
			// the simple upload type. This might cause issues on our deployment
			// servers as the load balancer has a request size limit of 1MiB, so
			// files larger than that might fail. Given that the initial CWSEI
			// import file tops out at 557KiB, I'm not going to worry about
			// larger files for now.
			log.debug("Processing Communities/Collections CSV Import File.");
			FileUploadRequest fileUploadReq = new FileUploadRequest(request);
			File csvFile = fileUploadReq.getFile("file");
			CommunityAndCollectionCSVImporter csvImporter =
					new CommunityAndCollectionCSVImporter(context);

			String importToggle =
					fileUploadReq.getParameter(TOGGLE_COMMUNITIES_COLLECTIONS);
			log.debug("Import Toggle: " + importToggle);
			if (csvFile == null)
			{
				isSuccess = false;
				log.error("No file uploaded Communities & Collections import.");
				request.setAttribute("error", "No file uploaded!");
			}
			else if (importToggle.equals(IMPORT_COMMUNITIES))
			{
				log.debug("Importing Communities");
				csvImporter.importCommunities(csvFile);
			}
			else
			{
				log.debug("Importing Collections");
				csvImporter.importCollections(csvFile);
			}
		} catch (FileUploadBase.FileSizeLimitExceededException ex) {
			isSuccess = false;
			log.error(ex);
			request.setAttribute("error",
					"File size too large: " + ex.getMessage());
		} catch (FileNotFoundException ex) {
			isSuccess = false;
			log.error(ex);
			request.setAttribute("error",
				"Upload failed with server error, couldn't find uploaded CSV");
		} catch (ImportCSVException ex) {
			isSuccess = false;
			log.error(ex);
			request.setAttribute("error", ex.getMessage());
		}
		setImportTypeConstants(request);
		setCSVHeaderConstants(request);
		request.setAttribute("isSuccess", isSuccess);
		JSPManager.showJSP(request, response,
				"/ubc/import-communities-collections.jsp");
    }

	private void setImportTypeConstants(HttpServletRequest request)
	{
		request.setAttribute("IMPORT_COLLECTIONS", IMPORT_COLLECTIONS);
		request.setAttribute("IMPORT_COMMUNITIES", IMPORT_COMMUNITIES);
		request.setAttribute("TOGGLE_COMMUNITIES_COLLECTIONS",
				TOGGLE_COMMUNITIES_COLLECTIONS);
	}

	/**
	 * We expect the CSV to use certain headers, calling this function makes
	 * those header constants available for use by the JSP.
	 * @param request 
	 */
	private void setCSVHeaderConstants(HttpServletRequest request)
	{
		request.setAttribute("COMMUNITY_NAME_HEADER",
				CommunityAndCollectionCSVImporter.COMMUNITY_NAME_HEADER);
		request.setAttribute("COMMUNITY_DESC_HEADER",
				CommunityAndCollectionCSVImporter.COMMUNITY_DESC_HEADER);
		request.setAttribute("COMMUNITY_INTRO_HEADER",
				CommunityAndCollectionCSVImporter.COMMUNITY_INTRO_HEADER);
		request.setAttribute("COMMUNITY_COPYRIGHT_HEADER",
				CommunityAndCollectionCSVImporter.COMMUNITY_COPYRIGHT_HEADER);
		request.setAttribute("COMMUNITY_SIDEBAR_HEADER",
				CommunityAndCollectionCSVImporter.COMMUNITY_SIDEBAR_HEADER);
		request.setAttribute("COLLECTION_NAME_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_NAME_HEADER);
		request.setAttribute("COLLECTION_DESC_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_DESC_HEADER);
		request.setAttribute("COLLECTION_INTRO_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_INTRO_HEADER);
		request.setAttribute("COLLECTION_COPYRIGHT_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_COPYRIGHT_HEADER);
		request.setAttribute("COLLECTION_SIDEBAR_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_SIDEBAR_HEADER);
		request.setAttribute("COLLECTION_LICENCE_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_LICENCE_HEADER);
		request.setAttribute("COLLECTION_PROVENANCE_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_PROVENANCE_HEADER);
		request.setAttribute("COLLECTION_ENABLE_ACCEPT_REJECT_STEP_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_ENABLE_ACCEPT_REJECT_STEP_HEADER);
		request.setAttribute("COLLECTION_ENABLE_ACCEPT_REJECT_EDIT_STEP_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_ENABLE_ACCEPT_REJECT_EDIT_STEP_HEADER);
		request.setAttribute("COLLECTION_ENABLE_EDIT_STEP_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_ENABLE_EDIT_STEP_HEADER);
		request.setAttribute("COLLECTION_GROUPS_AUTHORIZED_TO_SUBMIT_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_GROUPS_AUTHORIZED_TO_SUBMIT_HEADER);
		request.setAttribute("COLLECTION_GROUPS_ADMIN_HEADER",
				CommunityAndCollectionCSVImporter.COLLECTION_GROUPS_ADMIN_HEADER);
		request.setAttribute("COLLECTION_DEFAULT_METADATA_HEADER_PREFIX",
				CommunityAndCollectionCSVImporter.COLLECTION_DEFAULT_METADATA_HEADER_PREFIX);
	}
}
