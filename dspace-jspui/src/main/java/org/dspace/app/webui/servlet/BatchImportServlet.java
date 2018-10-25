/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.*;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.LinkedList;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.logging.Level;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.fileupload.FileUploadBase.FileSizeLimitExceededException;
import org.apache.commons.lang3.StringUtils;
import org.apache.log4j.Logger;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.FileUploadRequest;
import org.dspace.app.itemimport.BTEBatchImportService;
import org.dspace.app.itemimport.ItemImport;
import org.dspace.app.webui.ubc.fileupload.FlowJSHandler;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.core.*;
import org.dspace.utils.DSpace;

/**
 * Servlet to batch import metadata via the BTE
 *
 * @author Stuart Lewis
 */
public class BatchImportServlet extends DSpaceServlet
{
    /** log4j category */
    private static Logger log = Logger.getLogger(BatchImportServlet.class);

	public static String BATCH_IMPORT_JSP = "/ubc/dspace-admin/batchimport.jsp";

    /**
     * Respond to a post request for metadata bulk importing via csv
     *
     * @param context a DSpace Context object
     * @param request the HTTP request
     * @param response the HTTP response
     *
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     * @throws AuthorizeException
     */
    protected void doDSPost(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
		// Check what type of import we're dealing with.
		String TYPE_ZIP_URL = "ZIPURL"; // zip file hosted on a remote server
		String TYPE_FLOWJS = "FLOWJS"; // file uploaded by flow.js
		String TYPE_UNKNOWN = "UNKNOWN"; // unknown type
		String importType = TYPE_UNKNOWN;

		String inputType = request.getParameter("inputType");
		if (inputType != null && inputType.equals("saf")) 
			importType = TYPE_ZIP_URL;
		else if (FlowJSHandler.isFlowJSRequest(request))
			importType = TYPE_FLOWJS;
		
		// Stop here if we don't know what type of import
		if (importType.equals(TYPE_UNKNOWN))
		{
			request.setAttribute("has-error", "true");
			request.setAttribute("message", "Unknown import type being used.");
			JSPManager.showJSP(request, response, BATCH_IMPORT_JSP);
			return;
		}

		// Parse shared parameters that are necessary for calling the importer
		List<String> reqCollectionsTmp = getRepeatedParameter(request, "collections", "collections");
		String[] reqCollections = new String[reqCollectionsTmp.size()];
		String uploadId = request.getParameter("uploadId");
		Collection owningCollection = null;

		reqCollectionsTmp.toArray(reqCollections);

		if (request.getParameter("collection") != null) {
			int colId = Integer.parseInt(request.getParameter("collection"));
			if (colId > 0)
				owningCollection = Collection.find(context, colId);
		}

		// Deal with remotely hosted zip file url
		if (importType.equals(TYPE_ZIP_URL))
		{
			processZipUrl(context, request, response, owningCollection,
				reqCollections, uploadId);
			return;
		}

		// Deal with FlowJS uploaded file
		try {
			FlowJSHandler flowHandler = new FlowJSHandler(request);
			flowHandler.processChunk();
			if (!flowHandler.isComplete()) return; // wait for next chunk
			// FlowJS has finished uploading, let's process the file.
			ItemImport.processUIImport(flowHandler.getFile().getAbsolutePath(),
				owningCollection, reqCollections, uploadId, inputType, context);
		} catch (FileSizeLimitExceededException ex) {
			log.error(ex);
			sendJSON(response, false, ex.getMessage());
			return;
		} catch (Exception ex) {
			log.error(ex);
			sendJSON(response, false, ex.getMessage());
			return;
		}
		sendJSON(response, true, "");
		return;
    }

    /**
     * GET request is only ever used to show the upload form
     *
     * @param context
     *            a DSpace Context object
     * @param request
     *            the HTTP request
     * @param response
     *            the HTTP response
     *
     * @throws ServletException
     * @throws IOException
     * @throws SQLException
     * @throws AuthorizeException
     */
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
		setPageAttributes(context, request);
		// Show the upload screen
		JSPManager.showJSP(request, response, BATCH_IMPORT_JSP);
    }
    
    /**
     * Get repeated values from a form. If "foo" is passed in as the parameter,
     * values in the form of parameters "foo", "foo_1", "foo_2", etc. are
     * returned.
     * <P>
     * This method can also handle "composite fields" (metadata fields which may
     * require multiple params, etc. a first name and last name).
     *
     * @param request
     *            the HTTP request containing the form information
     * @param metadataField
     *            the metadata field which can store repeated values
     * @param param
     *            the repeated parameter on the page (used to fill out the
     *            metadataField)
     *
     * @return a List of Strings
     */
    protected List<String> getRepeatedParameter(HttpServletRequest request,
            String metadataField, String param)
    {
        List<String> vals = new LinkedList<String>();

        int i = 1;    //start index at the first of the previously entered values
        boolean foundLast = false;

        // Iterate through the values in the form.
        while (!foundLast)
        {
            String s = null;

            //First, add the previously entered values.
            // This ensures we preserve the order that these values were entered
            s = request.getParameter(param + "_" + i);

            // If there are no more previously entered values,
            // see if there's a new value entered in textbox
            if (s==null)
            {
                s = request.getParameter(param);
                //this will be the last value added
                foundLast = true;
            }

            // We're only going to add non-null values
            if (s != null)
            {
                boolean addValue = true;

                // Check to make sure that this value was not selected to be
                // removed.
                // (This is for the "remove multiple" option available in
                // Manakin)
                String[] selected = request.getParameterValues(metadataField
                        + "_selected");

                if (selected != null)
                {
                    for (int j = 0; j < selected.length; j++)
                    {
                        if (selected[j].equals(metadataField + "_" + i))
                        {
                            addValue = false;
                        }
                    }
                }

                if (addValue)
                {
                    vals.add(s.trim());
                }
            }

            i++;
        }

        log.debug("getRepeatedParameter: metadataField=" + metadataField
                + " param=" + metadataField + ", return count = "+vals.size());

        return vals;
    }

	/**
	 * Set attributes used to render the batchimport JSP. 
	 * @param context
	 * @param request 
	 */
	private void setPageAttributes(Context context, HttpServletRequest request)
		throws SQLException
	{
    	//Get all collections
		List<Collection> collections = null;
		String colIdS = request.getParameter("colId");
		if (colIdS!=null){
			collections = new ArrayList<Collection>();
			collections.add(Collection.find(context, Integer.parseInt(colIdS)));

		}
		else {
			collections = Arrays.asList(Collection.findAll(context));
		}

		request.setAttribute("collections", collections);

		//Get all the possible data loaders from the Spring configuration
		BTEBatchImportService dls  = new DSpace().getSingletonService(BTEBatchImportService.class);
		List<String> inputTypes = dls.getFileDataLoaders();
		request.setAttribute("input-types", inputTypes);
	}

	/**
	 * Respond with JSON for the FlowJS handlers.
	 * @param response
	 * @param isSuccess
	 * @param errorMsg
	 * @throws IOException 
	 */
	private void sendJSON(HttpServletResponse response, boolean isSuccess, String errorMsg) throws IOException
	{
		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		if (isSuccess)
		{
			response.getWriter().write("{\"success\":\"true\"}");
		}
		else 
		{
			response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
			response.getWriter().write("{\"error\":\""+errorMsg+"\"}");
		}
	}

	/**
	 * Process a zip file that's hosted on a remote server. Refactored out of
	 * the doPost method for cleaner organization.
	 * @param context
	 * @param request
	 * @param response
	 * @param owningCollection
	 * @param reqCollections
	 * @param uploadId
	 * @throws ServletException
	 * @throws IOException 
	 */
	private void processZipUrl(Context context, HttpServletRequest request,
		HttpServletResponse response, Collection owningCollection,
		String[] reqCollections, String uploadId)
		throws ServletException, IOException, SQLException
	{
		String zipurl = request.getParameter("zipurl");
		String message = "";
		setPageAttributes(context, request);
		if (StringUtils.isEmpty(zipurl)) {
			request.setAttribute("has-error", "true");
			Locale locale = request.getLocale();
			ResourceBundle msgs = ResourceBundle.getBundle("Messages", locale);
			try {
				message = msgs.getString("jsp.layout.navbar-admin.batchimport.fileurlempty");
			} catch (Exception e) {
				message = "???jsp.layout.navbar-admin.batchimport.fileurlempty???";
			}
			
			request.setAttribute("message", message);

			JSPManager.showJSP(request, response, BATCH_IMPORT_JSP);

			return;
		}
		try {
			String finalInputType = "saf";
			String filePath = zipurl;
			
			ItemImport.processUIImport(filePath, owningCollection, reqCollections, uploadId, finalInputType, context);
			
			request.setAttribute("has-error", "false");
			request.setAttribute("uploadId", null);

		} catch (Exception e) {
			request.setAttribute("has-error", "true");
			message = e.getMessage();
			e.printStackTrace();
		}
		request.setAttribute("message", message);
		JSPManager.showJSP(request, response, BATCH_IMPORT_JSP);
	}
}
