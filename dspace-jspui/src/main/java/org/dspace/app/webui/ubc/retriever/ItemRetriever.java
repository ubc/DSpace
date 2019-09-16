/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.retriever;

import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;


import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.dspace.app.webui.ubc.license.UBCLicenseInfo;
import org.dspace.app.webui.ubc.license.UBCLicenseUtil;
import org.dspace.ubc.RelatedResourceManager;

import org.dspace.content.Item;

import org.dspace.ubc.UBCAccessChecker;
import org.dspace.content.DCDate;
import org.dspace.core.Context;
import org.dspace.ubc.content.Comment;

import org.dspace.core.Constants;
import org.dspace.statistics.Dataset;
import org.dspace.statistics.content.StatisticsTable;
import org.dspace.statistics.content.DatasetDSpaceObjectGenerator;
import org.dspace.statistics.content.StatisticsDataVisits;

/**
 * JSP helper for getting all metadata and files associated with an item.
 * Basically a unifier for ItemBitstreamRetriever and ItemMetadataRetriever.
 * Also the place to specify what data we want to expose to JSPs.
 *
 */
public class ItemRetriever {
    /** log4j logger */
    private static Logger log = Logger.getLogger(ItemMetadataRetriever.class);

	public static final String RELATED_RESOURCE_HEADER = RelatedResourceManager.HEADER;

	private Item item;
	private HttpServletRequest request;

	private ItemMetadataRetriever metadataRetriever;
	private ItemBitstreamRetriever bitstreamRetriever;

	private String title = "";
	private String summary = "";
	private String description = "";
	private String thumbnail = "";
	private String url = "";
	private String whatWeLearned = "";
	private DCDate dateCreated;
	private DCDate dateSubmitted;
	private DCDate dateStarted;
	private DCDate dateApproved;
	private String license = "";
	private String packageZipURL = "";
	private String resourceURL = ""; // if this item is about a resource located at some url, store that url here
	private boolean isRestricted = false;
	private boolean hasPlaceholderThumbnail = true;
	private List<SubjectResult> subjects = new ArrayList<>();
	private List<BitstreamResult> files;
	private List<String> resourceTypes = new ArrayList<>();
	private List<String> prereqs = new ArrayList<>();
	private List<String> objectives = new ArrayList<>();
	private List<String> authors = new ArrayList<>();
	private List<String> relatedMaterials = new ArrayList<>();
	private List<String> alternativeLanguages = new ArrayList<>();
	private List<String> keywords = new ArrayList<>();
	private List<Comment> comments = new ArrayList<>();
	private List<RelatedResource> relatedResources = new ArrayList<>();
	private double avgRating;
	private int activeCommentCount;
	private int activeRatingCount;
	private int visitCount;

	public ItemRetriever(Context context, HttpServletRequest request, Item item) throws SQLException, UnsupportedEncodingException {
		this.item = item;
		this.request = request;
		metadataRetriever = new ItemMetadataRetriever(item);
		bitstreamRetriever = new ItemBitstreamRetriever(context, request, item);
		initMetadata(context);
		packageZipURL = "/zippackage/" + item.getID();
	}

	private void initMetadata(Context context) throws SQLException, UnsupportedEncodingException {
		thumbnail = request.getContextPath() + "/image/ubc-logo-xl.png";
		files = bitstreamRetriever.getBitstreams();
		if (!files.isEmpty()) {
			for (BitstreamResult file: files) {
				String tmpThumb = file.getThumbnail();
				if (!tmpThumb.isEmpty()) {
					thumbnail = tmpThumb;
					hasPlaceholderThumbnail = false;
					break;
				}
			}
		}
		url = request.getContextPath() + "/handle/" + item.getHandle();

		MetadataResult result = metadataRetriever.getField("dc.subject");
		for (String subject : result.getValues()) {
			String otherSubject = getSingleValue("dc.subject.other");
			SubjectResult subjectResult = new SubjectResult(subject, otherSubject);
			subjects.add(subjectResult);
		}

		title = getSingleValue("dc.title");
		summary = getSingleValue("dc.description.abstract");
		description = getSingleValue("dc.description");
		whatWeLearned = getSingleValue("dcterms.instructionalMethod");
		dateCreated = getDCDate("dc.date.created");
		license = getSingleValue("dc.rights");
		isRestricted = UBCAccessChecker.isRestricted(item);
		resourceURL = getSingleValue("dc.relation.uri");

		dateStarted = getDCDate("dc.date.issued");
		dateSubmitted = getDCDate("dc.date.submitted");
		dateApproved = getDCDate("dc.date.accessioned");

		initStringList("dcterms.type", resourceTypes);
		initStringList("dcterms.requires", prereqs);
		initStringList("dcterms.coverage", objectives);
		initStringList("dc.contributor.author", authors);
		initStringList("dcterms.isFormatOf", alternativeLanguages);
		initStringList("dcterms.subject", keywords);

		// resource types "Other" allows a user entered value, check if user entered a value and if so, add it in
		int resourceTypeOtherIndex = resourceTypes.indexOf("Other");
		if (resourceTypeOtherIndex >= 0) {
			String resourceTypeOther = getSingleValue("ubc.resourceTypeOther");
			if (!resourceTypeOther.isEmpty())
				resourceTypes.set(resourceTypeOtherIndex, "Other (" + resourceTypeOther + ")");
		}

		initRelatedMaterials(context);

		UBCAccessChecker curatorCheck = new UBCAccessChecker(context);
		if (curatorCheck.hasCuratorAccess()) {
			initCommentList("ubc.comments", context, comments);
		} else {
			initCommentList("ubc.comments", context, comments, true);
		}
		avgRating = getDoubleValue("ubc.avgRating");
		activeCommentCount = 0;
		activeRatingCount = 0;
		for (Comment c : comments) {
			if (c.getStatus() == Comment.Status.ACTIVE) {
				activeCommentCount++;
				if (c.getRating() > 0) {
					activeRatingCount++;
				}
			}
		}

		this.visitCount = 0;
		StatisticsTable statisticsTable = new StatisticsTable(new StatisticsDataVisits(this.item));
		statisticsTable.setTitle("Visits");

		DatasetDSpaceObjectGenerator dsoAxis = new DatasetDSpaceObjectGenerator();
		dsoAxis.addDsoChild(Constants.ITEM, 10, false, -1);
		statisticsTable.addDatasetGenerator(dsoAxis);
		try {
			Dataset dataSet = statisticsTable.getDataset(context);
			if (dataSet != null) {
				int numRow = dataSet.getNbRows();
				int numCol = dataSet.getNbCols();
				if (numRow == 1 && numCol == 1) {
					String[][] matrix = dataSet.getMatrix();
					this.visitCount = Integer.parseInt(matrix[0][0]);
				}
			}
		} catch (Exception e) {
			// ignore
		}
	}

	private String getSingleValue(String field) {
		MetadataResult result = metadataRetriever.getField(field);
		return result.getValue();
	}

    private double getDoubleValue(String field) {
        MetadataResult result = metadataRetriever.getField(field);
        try {
            return Double.parseDouble(result.getValue());
        } catch (Exception e) {
            return 0.0;
        }
    }

	private void initStringList(String field, List<String> list) {
		MetadataResult result = metadataRetriever.getField(field);
		list.addAll(result.getValues());
	}

	private DCDate getDCDate(String field) {
		String storedDate = getSingleValue(field);
		DCDate date = new DCDate(storedDate);
		// for some reason, empty dates give you the string "null" instead of an empty string or even just null?!
		if (date.toString().equals("null")) return null;
		return date;
	}

    private void initCommentList(String field, Context context, List<Comment> list) {
        initCommentList(field, context, list, false);
    }

    private void initCommentList(String field, Context context, List<Comment> list, boolean activeOnly) {
		MetadataResult result = metadataRetriever.getField(field);
		for (String val : result.getValues()) {
            Comment c = Comment.fromJson(context, val);
            if (activeOnly && c.getStatus() != Comment.Status.ACTIVE) {
                continue;
            }
			list.add(c);
		}
        // sort the comment list by date in reverse order
        Collections.sort(list, new Comparator<Comment>() {
            public int compare(Comment c1, Comment c2) {
                return c2.getCreated().compareTo(c1.getCreated());
            }
        });
    }

	private void initRelatedMaterials(Context context) throws SQLException, UnsupportedEncodingException {
		initStringList("dcterms.relation", relatedMaterials);
		for (int i = 0; i < relatedMaterials.size(); i++)
		{
			String material = relatedMaterials.get(i);
			if (material.startsWith(RELATED_RESOURCE_HEADER))
			{
				String itemIDStr = material.replace(RELATED_RESOURCE_HEADER, "");
				int itemID = Integer.parseInt(itemIDStr);
				Item relatedItem = Item.find(context, itemID);
				if (relatedItem == null)
				{
					relatedMaterials.remove(i);
					continue;
				}
				RelatedResource resource = new RelatedResource(context, request, relatedItem);
				relatedResources.add(resource);
				relatedMaterials.set(i, "<a href='"+resource.getURL()+"'>"+ resource.getTitle() +"</a>");
			}
		}
		RelatedResourceManager relatedResourceManager = new RelatedResourceManager(context, item);
		List<Item> relatedItems = relatedResourceManager.getMyBidirectionalMetadataItems();
		for (Item relatedItem : relatedItems)
		{
			RelatedResource resource = new RelatedResource(context, request, relatedItem);
			relatedResources.add(resource);
		}
	}

	public List<BitstreamResult> getFiles() {
		return files;
	}
	public String getTitle() {
		return title;
	}
	public String getSummary() {
		return summary;
	}
	public String getDescription() {
		return description;
	}
	public String getThumbnail() {
		return thumbnail;
	}
	public String getUrl() {
		return url;
	}
	public String getWhatWeLearned() {
		return whatWeLearned;
	}
	public DCDate getDateCreated() {
		return dateCreated;
	}
	public DCDate getDateSubmitted() {
		return dateSubmitted;
	}
	public DCDate getDateStarted() {
		return dateStarted;
	}
	public DCDate getDateApproved() {
		return dateApproved;
	}
	public String getLicense() {
		return license;
	}
	public String getPackageZipURL() {
		return packageZipURL;
	}
	public String getResourceURL() {
		return resourceURL;
	} 
	public UBCLicenseInfo getLicenseInfo() {
		return UBCLicenseUtil.getLicense(license);
	}
	public boolean getIsRestricted() {
		return isRestricted;
	}
	/**
	 * True if we default to the placeholder thumbnail cause this item doesn't 
	 * have files that has a thumbnail. Used so we can apply a fadeout to the
	 * placeholder thumbnail, making it obvious it's a placeholder.
	 * @return 
	 */
	public boolean getHasPlaceholderThumbnail() {
		return hasPlaceholderThumbnail;
	}
	public List<SubjectResult> getSubjects() {
		return subjects;
	}
	public List<String> getResourceTypes() {
		return resourceTypes;
	}
	public List<String> getPrereqs() {
		return prereqs;
	}
	public List<String> getObjectives() {
		return objectives;
	}
	public List<String> getAuthors() {
		return authors;
	}
	public List<String> getRelatedMaterials() {
		return relatedMaterials;
	}
	public List<String> getAlternativeLanguages() {
		return alternativeLanguages;
	}
	public List<String> getKeywords() {
		return keywords;
	}
    public List<Comment> getComments() {
        return comments;
    }
	public List<RelatedResource> getRelatedResources() {
		return relatedResources;
	}
	public double getAvgRating() {
		return avgRating;
	}
	public int getActiveCommentCount() {
		return activeCommentCount;
	}
	public int getActiveRatingCount() {
		return activeRatingCount;
	}
	public int getVisitCount() {
		return visitCount;
	}
	public Item getItem() {
		return item;
	}

}
