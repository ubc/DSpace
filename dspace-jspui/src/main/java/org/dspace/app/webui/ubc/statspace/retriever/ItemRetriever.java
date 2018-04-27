/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace.retriever;

import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;
import org.apache.log4j.Logger;

import org.dspace.content.Item;

import org.dspace.app.webui.ubc.statspace.UBCAccessChecker;
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
	private String dateCreated = "";
	private String dateSubmitted = "";
	private boolean instructorOnly = false;
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
		dateCreated = getSingleValue("dc.date.created");
		instructorOnly = UBCAccessChecker.isInstructorOnly(item);

		dateSubmitted = getSingleValue("dc.date.submitted");
		if (!dateSubmitted.isEmpty()) {
			DCDate tmpDate = new DCDate(dateSubmitted);
			SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm a");
			dateSubmitted = dateFormat.format(tmpDate.toDate());
		}

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
	public String getDateCreated() {
		return dateCreated;
	}
	public String getDateSubmitted() {
		return dateSubmitted;
	}
	public boolean getInstructorOnly() {
		return instructorOnly;
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
	
}
