/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.ubc.submit.step;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.dspace.app.util.DCInputsReader;
import org.dspace.app.util.DCInputsReaderException;
import org.dspace.app.util.SubmissionInfo;
import org.dspace.app.webui.submit.JSPStep;
import org.dspace.app.webui.submit.JSPStepManager;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Bitstream;
import org.dspace.content.BitstreamFormat;
import org.dspace.content.Collection;
import org.dspace.content.FormatIdentifier;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.submit.step.UploadStep;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Map;
import org.dspace.ubc.UBCAccessChecker;
import org.dspace.app.webui.ubc.retriever.ItemRetriever;
import org.dspace.content.Item;
import org.dspace.content.Metadatum;
import org.dspace.core.I18nUtil;

/**
 * Upload step for DSpace JSP-UI. Handles the pages that revolve around uploading files
 * (and verifying a successful upload) for an item being submitted into DSpace.
 * <P>
 * This JSPStep class works with the SubmissionController servlet
 * for the JSP-UI
 * <P>
 * The following methods are called in this order:
 * <ul>
 * <li>Call doPreProcessing() method</li>
 * <li>If showJSP() was specified from doPreProcessing(), then the JSP
 * specified will be displayed</li>
 * <li>If showJSP() was not specified from doPreProcessing(), then the
 * doProcessing() method is called and the step completes immediately</li>
 * <li>Call doProcessing() method on appropriate AbstractProcessingStep after
 * the user returns from the JSP, in order to process the user input</li>
 * <li>Call doPostProcessing() method to determine if more user interaction is
 * required, and if further JSPs need to be called.</li>
 * <li>If there are more "pages" in this step then, the process begins again
 * (for the new page).</li>
 * <li>Once all pages are complete, control is forwarded back to the
 * SubmissionController, and the next step is called.</li>
 * </ul>
 *
 * @see org.dspace.app.webui.servlet.SubmissionController
 * @see org.dspace.app.webui.submit.JSPStep
 * @see org.dspace.submit.step.UploadStep
 *
 * @author Tim Donohue
 * @version $Revision$
 */
public class JSPUploadStep extends JSPStep
{
    /** JSP to choose files to upload * */
    //private static final String CHOOSE_FILE_JSP = "/submit/choose-file.jsp";
    private static final String CHOOSE_FILE_JSP = "/ubc/submit/choose-file.jsp";

    /** JSP to show files that were uploaded * */
    //private static final String UPLOAD_LIST_JSP = "/submit/upload-file-list.jsp";
    private static final String UPLOAD_LIST_JSP = "/ubc/submit/upload-file-list.jsp";

    /** JSP to single file that was upload * */
    private static final String UPLOAD_FILE_JSP = "/submit/show-uploaded-file.jsp";

    /** JSP to edit file description * */
    //private static final String FILE_DESCRIPTION_JSP = "/submit/change-file-description.jsp";
    private static final String FILE_DESCRIPTION_JSP = "/ubc/submit/change-file-description.jsp";

    /** JSP to edit file format * */
    private static final String FILE_FORMAT_JSP = "/submit/get-file-format.jsp";

    /** JSP to show any upload errors * */
    protected static final String UPLOAD_ERROR_JSP = "/submit/upload-error.jsp";

    /** JSP to show any upload errors * */
    protected static final String VIRUS_CHECKER_ERROR_JSP = "/submit/virus-checker-error.jsp";

    /** JSP to show any upload errors * */
    protected static final String VIRUS_ERROR_JSP = "/submit/virus-error.jsp";
    
    /** JSP to review uploaded files * */
    private static final String REVIEW_JSP = "/submit/review-upload.jsp";

    /** log4j logger */
    private static Logger log = Logger.getLogger(JSPUploadStep.class);

    /**
     * Do any pre-processing to determine which JSP (if any) is used to generate
     * the UI for this step. This method should include the gathering and
     * validating of all data required by the JSP. In addition, if the JSP
     * requires any variable to passed to it on the Request, this method should
     * set those variables.
     * <P>
     * If this step requires user interaction, then this method must call the
     * JSP to display, using the "showJSP()" method of the JSPStepManager class.
     * <P>
     * If this step doesn't require user interaction OR you are solely using
     * Manakin for your user interface, then this method may be left EMPTY,
     * since all step processing should occur in the doProcessing() method.
     *
     * @param context
     *            current DSpace context
     * @param request
     *            current servlet request object
     * @param response
     *            current servlet response object
     * @param subInfo
     *            submission info object
     */
    public void doPreProcessing(Context context, HttpServletRequest request,
            HttpServletResponse response, SubmissionInfo subInfo)
            throws ServletException, IOException, SQLException,
            AuthorizeException
    {
        // pass on the fileupload setting
        if (subInfo != null)
        {
            Collection c = subInfo.getSubmissionItem().getCollection();
            try
            {
                DCInputsReader inputsReader = new DCInputsReader();
                request.setAttribute("submission.inputs", inputsReader.getInputs(c
                        .getHandle()));
            }
            catch (DCInputsReaderException e)
            {
                throw new ServletException(e);
            }

            // show whichever upload page is appropriate
            // (based on if this item already has files or not)
            showUploadPage(context, request, response, subInfo);
        }
        else
        {
            throw new IllegalStateException("SubInfo must not be null");
        }
    }
    
    /**
     * Do any post-processing after the step's backend processing occurred (in
     * the doProcessing() method).
     * <P>
     * It is this method's job to determine whether processing completed
     * successfully, or display another JSP informing the users of any potential
     * problems/errors.
     * <P>
     * If this step doesn't require user interaction OR you are solely using
     * Manakin for your user interface, then this method may be left EMPTY,
     * since all step processing should occur in the doProcessing() method.
     *
     * @param context
     *            current DSpace context
     * @param request
     *            current servlet request object
     * @param response
     *            current servlet response object
     * @param subInfo
     *            submission info object
     * @param status
     *            any status/errors reported by doProcessing() method
     */
    public void doPostProcessing(Context context, HttpServletRequest request,
            HttpServletResponse response, SubmissionInfo subInfo, int status)
            throws ServletException, IOException, SQLException,
            AuthorizeException
    {
        String buttonPressed = UIUtil.getSubmitButton(request, UploadStep.NEXT_BUTTON);

        // Do we need to skip the upload entirely?
        boolean fileRequired = ConfigurationManager.getBooleanProperty("webui.submit.upload.required", true);
        
		// If we're not requiring a file, let the user skip file upload
        if (buttonPressed.equalsIgnoreCase(UploadStep.SUBMIT_UPLOAD_BUTTON) && !fileRequired) return; // return immediately, since we are skipping upload
        
        // If upload failed in JSPUI (just came from upload-error.jsp), user can retry the upload
        if (buttonPressed.equalsIgnoreCase("submit_retry")) showUploadPage(context, request, response, subInfo);

		// Redirect user to various error pages if necessary
		if (status != UploadStep.STATUS_COMPLETE)
		{
			showUploadPageWithError(context, request, response, subInfo, status);
			return;
		}
        
        // As long as there are no errors, clicking Next
        // should immediately send them to the next step
        if (status == UploadStep.STATUS_COMPLETE && buttonPressed.equals(UploadStep.NEXT_BUTTON))
        {
			// save file description and restriction settings
			String[] bitstreamIDs = request.getParameterValues("bitstreamID");
			String[] descriptions = request.getParameterValues("description");
			for (int i = 0; i < bitstreamIDs.length; i++)
			{
				String bitstreamID = bitstreamIDs[i];
				if (bitstreamID.isEmpty()) continue; // ignore the template
				// find the bitstream to update
                int id = Integer.parseInt(bitstreamID);
                Bitstream bitstream = Bitstream.find(context, id);
				if (bitstream == null)
				{
					log.error("Couldn't find bitstream to update description & restriction with! Bitstream ID: " + bitstreamID);
					continue;
				}
				bitstream.setDescription(descriptions[i]);
				String restricted = request.getParameter("restricted"+bitstreamID);
				if (restricted == null)
					bitstream.setAccessRights(UBCAccessChecker.ACCESS_EVERYONE);
				else
					bitstream.setAccessRights(UBCAccessChecker.ACCESS_RESTRICTED);
				bitstream.update();
			}
			String url = request.getParameter("url");
			if (url != null && !url.isEmpty())
			{
				Item item = subInfo.getSubmissionItem().getItem();
				// only allow one url
				Metadatum[] values = item.getMetadata("dc", "relation", "uri", Item.ANY);
				if (values.length > 0) {
					item.clearMetadata("dc", "relation", "uri", Item.ANY);
				}
				item.addMetadata("dc", "relation", "uri", Item.ANY, url);
				item.update();
			}
			context.commit();
            // just return, so user will continue on to next step!
            return;
        }

		// BY DEFAULT: just display the upload page
		showUploadPage(context, request, response, subInfo);
    }

    /**
     * Display the file upload page. 
	 * 
     * @param context
     *            the DSpace context object
     * @param request
     *            the request object
     * @param response
     *            the response object
     * @param subInfo
     *            the SubmissionInfo object
     * @param justUploaded
     *            true, if the user just finished uploading a file
     */
    protected void showUploadPage(Context context, HttpServletRequest request,
            HttpServletResponse response, SubmissionInfo subInfo) throws SQLException, ServletException,
            IOException
    {
		request.setAttribute("subInfo", subInfo);
		request.setAttribute("submissionItemID", subInfo.getSubmissionItem().getID());
		request.setAttribute("isInWorkflow", subInfo.isInWorkflow());

		ItemRetriever retriever = new ItemRetriever(context, request, subInfo.getSubmissionItem().getItem());
		setAccessRestrictionAttributes(context, request, retriever);
		request.setAttribute("files", retriever.getFiles());
		request.setAttribute("url", retriever.getResourceURL());

        JSPStepManager.showJSP(request, response, subInfo, CHOOSE_FILE_JSP);
    }

	/**
	 * Pass on information about per-file access restrictions to JSPs.
	 * 
	 * @param context
	 * @param request
	 * @param item
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	private void setAccessRestrictionAttributes(Context context,
			HttpServletRequest request, ItemRetriever retriever)
			throws SQLException, UnsupportedEncodingException
	{
		Item item = retriever.getItem();
		// Mark files that are restricted access
		Map<Integer, Boolean> isRestrictedAccess =
				new HashMap<Integer, Boolean>();
		Bitstream[] bitstreams = item.getNonInternalBitstreams();
		for (int i = 0; i < bitstreams.length; i++)
		{
			Bitstream file = bitstreams[i];
			isRestrictedAccess.put(file.getID(),
					UBCAccessChecker.isRestricted(item, file));
		}
		request.setAttribute("isRestrictedAccess", isRestrictedAccess);

		// Don't allow marking individual file restrictions if the entire item
		// is already restricted.
		request.setAttribute("disablePerFileRestriction",
				retriever.getIsRestricted());
	}

    /**
     * Show the page which allows the user to change the format of the file that
     * was just uploaded
     *
     * @param context
     *            context object
     * @param request
     *            the request object
     * @param response
     *            the response object
     * @param subInfo
     *            the SubmissionInfo object
     */
    protected void showGetFileFormat(Context context, HttpServletRequest request,
            HttpServletResponse response, SubmissionInfo subInfo)
            throws SQLException, ServletException, IOException
    {
        if (subInfo == null || subInfo.getBitstream() == null)
        {
            // We have an integrity error, since we seem to have lost
            // which bitstream was just uploaded
            log.warn(LogManager.getHeader(context, "integrity_error", UIUtil
                    .getRequestLogInfo(request)));
            JSPManager.showIntegrityError(request, response);
        }

        BitstreamFormat[] formats = BitstreamFormat.findNonInternal(context);

        request.setAttribute("bitstream.formats", formats);

        // What does the system think it is?
        BitstreamFormat guess = FormatIdentifier.guessFormat(context, subInfo
                .getBitstream());

        request.setAttribute("guessed.format", guess);

        // display choose file format JSP next
        JSPStepManager.showJSP(request, response, subInfo, FILE_FORMAT_JSP);
    }

    /**
     * Return the URL path (e.g. /submit/review-metadata.jsp) of the JSP
     * which will review the information that was gathered in this Step.
     * <P>
     * This Review JSP is loaded by the 'Verify' Step, in order to dynamically
     * generate a submission verification page consisting of the information
     * gathered in all the enabled submission steps.
     *
     * @param context
     *            current DSpace context
     * @param request
     *            current servlet request object
     * @param response
     *            current servlet response object
     * @param subInfo
     *            submission info object
     */
    public String getReviewJSP(Context context, HttpServletRequest request,
            HttpServletResponse response, SubmissionInfo subInfo)
    {
        return REVIEW_JSP;
    }

	private void showUploadPageWithError(Context context, HttpServletRequest request, HttpServletResponse response, SubmissionInfo subInfo, int status)
		throws ServletException, IOException, SQLException
	{
        String buttonPressed = UIUtil.getSubmitButton(request, UploadStep.NEXT_BUTTON);
		String errMsg = I18nUtil.getMessage("jsp.dspace-admin.metadataimport.unknownerror");
		if (status == UploadStep.STATUS_INTEGRITY_ERROR)
		{

			// Some type of integrity error occurred
			log.warn(LogManager.getHeader(context, "integrity_error",
					UIUtil.getRequestLogInfo(request)));
			JSPManager.showIntegrityError(request, response);
			return;
		}
		else if (status == UploadStep.STATUS_NO_FILES_ERROR)
		{
			// maybe the user removed all the files, if so, can safely ignore the error and let the user upload some other file
			if(buttonPressed.startsWith("submit_remove_"))
			{
				//if file was just removed, go back to upload page
				showUploadPage(context, request, response, subInfo);
				return;
			}
			errMsg = I18nUtil.getMessage("jsp.submit.file-required-error.info");
		}
		else if (status == UploadStep.STATUS_UPLOAD_ERROR)
		{
			// There was a problem uploading the file!
			errMsg = I18nUtil.getMessage("jsp.submit.upload-error.info");
		}
		else if (status == UploadStep.STATUS_VIRUS_CHECKER_UNAVAILABLE)
		{
			errMsg = I18nUtil.getMessage("jsp.submit.virus-checker-error.info");
		}
		else if (status == UploadStep.STATUS_CONTAINS_VIRUS)
		{
			errMsg = I18nUtil.getMessage("jsp.submit.virus-error.info");
		}
		else if (status == UploadStep.STATUS_UNKNOWN_FORMAT)
		{
			// user uploaded a file where the format is unknown to DSpace

			// forward user to page to request the file format
			showGetFileFormat(context, request, response, subInfo);
			return;
		}
		request.setAttribute("error", errMsg);
		showUploadPage(context, request, response, subInfo);
	}
}
