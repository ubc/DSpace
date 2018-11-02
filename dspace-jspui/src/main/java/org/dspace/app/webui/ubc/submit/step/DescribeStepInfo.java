package org.dspace.app.webui.ubc.submit.step;

import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.dspace.app.util.DCInput;
import org.dspace.app.util.DCInputSet;
import org.dspace.app.util.SubmissionInfo;
import org.dspace.app.webui.servlet.SubmissionController;
import org.dspace.app.webui.ubc.retriever.ItemRetriever;
import org.dspace.app.webui.ubc.retriever.RelatedResource;
import org.dspace.content.Item;
import org.dspace.content.ItemIterator;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;

public class DescribeStepInfo
{
    private static Logger log = Logger.getLogger(DescribeStepInfo.class);

	private boolean hasValidationErrors = false;
	private boolean isFirstStep = false;
	private int pageNum = 0;
	private List<FieldInfo> fields = new ArrayList<FieldInfo>();
	private List<RelatedResource> submitterItems = new ArrayList<RelatedResource>();

	public DescribeStepInfo(Context context, HttpServletRequest request, DCInputSet inputSet)
			throws SQLException, ServletException, UnsupportedEncodingException
	{
		SubmissionInfo si = SubmissionController.getSubmissionInfo(context, request);
		Item item = si.getSubmissionItem().getItem();
		final int halfWidth = 23;
		final int fullWidth = 50;
		final int twothirdsWidth = 34;

		Integer pageNumStr = (Integer) request.getAttribute("submission.page");
		this.pageNum = pageNumStr.intValue();
    
		// owning Collection ID for choice authority calls
		int collectionID = si.getSubmissionItem().getCollection().getID();
		
		// Fetch the document type (dc.type)
		String documentType = "";
		if( (item.getMetadataByMetadataString("dc.type") != null) && (item.getMetadataByMetadataString("dc.type").length >0) )
		{
			documentType = item.getMetadataByMetadataString("dc.type")[0].value;
		}

		// collect information on all the input fields
		// TODO: Rename variable, scope is too vague
		String scope = si.isInWorkflow() ? "workflow" : "submit";
		DCInput[] inputs = inputSet.getPageRows(pageNum - 1, si.getSubmissionItem().hasMultipleTitles(),
				si.getSubmissionItem().isPublishedBefore() );
		for (DCInput input : inputs)
		{
			// Skip fields not allowed for this document type
			if(!input.isAllowedFor(documentType)) continue;
			// Skip fields invisible in this scope. For some stupid reason, 
			// readonly can override visible. If a field is invisible but set
			// as readonly, then it's actually visible but set to readonly. The
			// docs are shitty so I can't be sure if that's intentional, but the
			// original code has that effect, so I'm following the code.
			if (!input.isVisible(scope) && !input.isReadOnly(scope)) continue;
			FieldInfo field = new FieldInfo(si, input);
			fields.add(field);
			if (field.getHasValidationError()) hasValidationErrors = true;
		}

		// for deciding what control buttons to enable
		isFirstStep = SubmissionController.isFirstStep(request, si);

		// get all of this submitter's previous submitted & archived items
		setSubmitterItems(context, request, si);
	}

	public List<FieldInfo> getFields() { return fields; }
	public List<RelatedResource> getSubmitterItems() { return submitterItems; }

	public String getRELATED_RESOURCE_HEADER() { return ItemRetriever.RELATED_RESOURCE_HEADER; };

	public boolean getHasValidationErrors() { return hasValidationErrors; }
	public boolean getIsFirstStep() { return isFirstStep; }
	public int getPageNum() { return pageNum; }

	private void setSubmitterItems(Context context, HttpServletRequest request, SubmissionInfo subInfo) throws SQLException, UnsupportedEncodingException
	{
		submitterItems.clear();
		EPerson submitter = subInfo.getSubmissionItem().getSubmitter();
		ItemIterator iter = Item.findBySubmitter(context, submitter);
		while (iter.hasNext())
		{
			Item item = iter.next();
			RelatedResource retriever = new RelatedResource(context, request, item);
			submitterItems.add(retriever);
		}
		Collections.sort(submitterItems, new RelatedResourceComparator());
	}
}
