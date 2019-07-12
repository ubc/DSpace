/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.retriever;

import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.dspace.app.webui.ubc.license.UBCLicenseInfo;
import org.dspace.app.webui.ubc.license.UBCLicenseUtil;

import org.dspace.content.Item;

import org.dspace.ubc.UBCAccessChecker;
import org.dspace.content.DCDate;
import org.dspace.core.Context;

/**
 * JSP helper for getting all metadata and files associated with an item.
 * Basically a unifier for ItemBitstreamRetriever and ItemMetadataRetriever.
 * Also the place to specify what data we want to expose to JSPs.
 *
 */
public class ItemRetriever {
    /** log4j logger */
    private static Logger log = Logger.getLogger(ItemMetadataRetriever.class);

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
	private String license = "";
	private String collectionName = "";
	private boolean isRestricted = false;
	private List<SubjectResult> subjects = new ArrayList<>();
	private List<BitstreamResult> files;
	private List<String> resourceTypes = new ArrayList<>();
	private List<String> prereqs = new ArrayList<>();
	private List<String> objectives = new ArrayList<>();
	private List<String> authors = new ArrayList<>();
	private List<String> relatedMaterials = new ArrayList<>();
	private List<String> alternativeLanguages = new ArrayList<>();

	public ItemRetriever(Context context, HttpServletRequest request, Item item) throws SQLException, UnsupportedEncodingException {
		this.item = item;
		this.request = request;
		metadataRetriever = new ItemMetadataRetriever(item);
		bitstreamRetriever = new ItemBitstreamRetriever(context, request, item);
		initMetadata();
	}

	private void initMetadata() throws SQLException, UnsupportedEncodingException {
		thumbnail = request.getContextPath() + "/image/ubc-logo-lg.png";
		files = bitstreamRetriever.getBitstreams();
		if (!files.isEmpty()) {
			thumbnail = files.get(0).getThumbnail();
		}
		url = request.getContextPath() + "/handle/" + item.getHandle();

		MetadataResult result = metadataRetriever.getField("dc.subject");
		for (String subject : result.getValues()) {
			SubjectResult subjectResult = new SubjectResult(subject);
			subjects.add(subjectResult);
		}


		title = getSingleValue("dc.title");
		summary = getSingleValue("dc.description.abstract");
		description = getSingleValue("dc.description");
		whatWeLearned = getSingleValue("dcterms.instructionalMethod");
		dateCreated = getDCDate("dc.date.issued");
		license = getSingleValue("dc.rights");
		isRestricted = UBCAccessChecker.isRestricted(item);

		dateStarted = getDCDate("dc.date.created");
		dateSubmitted = getDCDate("dc.date.submitted");

		initStringList("dcterms.type", resourceTypes);
		initStringList("dcterms.requires", prereqs);
		initStringList("dcterms.coverage", objectives);
		initStringList("dc.contributor.author", authors);
		initStringList("dcterms.relation", relatedMaterials);
		initStringList("dcterms.isFormatOf", alternativeLanguages);
	}

	private String getSingleValue(String field) {
		MetadataResult result = metadataRetriever.getField(field);
		return result.getValue();
	}

	private void initStringList(String field, List<String> list) {
		MetadataResult result = metadataRetriever.getField(field);
		for (String val : result.getValues()) {
			list.add(val);
		}
	}

	private DCDate getDCDate(String field) {
		String storedDate = getSingleValue(field);
		DCDate date = new DCDate(storedDate);
		// for some reason, empty dates give you the string "null" instead of an empty string or even just null?!
		if (date.toString().equals("null")) return null;
		return date;
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
	public String getLicense() {
		return license;
	}
	public String getCollectionName() throws SQLException {
		if (collectionName.isEmpty() && item.getOwningCollection() != null)
		{
			collectionName = item.getOwningCollection().getName();
		}
		return collectionName;
	}
	public UBCLicenseInfo getLicenseInfo() {
		return UBCLicenseUtil.getLicense(license);
	}
	public boolean getIsRestricted() {
		return isRestricted;
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
	public void setCollectionName(String name) {
		collectionName = name;
	}
}
