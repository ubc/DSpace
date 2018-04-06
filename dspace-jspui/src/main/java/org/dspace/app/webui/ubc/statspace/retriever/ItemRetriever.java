/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace.retriever;

import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;
import org.apache.log4j.Logger;

import org.dspace.content.Item;


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
	private PageContext pageContext;

	private ItemMetadataRetriever metadataRetriever;
	private ItemBitstreamRetriever bitstreamRetriever;

	private String title = "";
	private String summary = "";
	private String description = "";
	private String thumbnail = "";
	private String url = "";
	private String whatWeLearned = "";
	private String date = "";
	private List<SubjectResult> subjects = new ArrayList<>();
	private List<BitstreamResult> files;
	private List<String> resourceTypes = new ArrayList<>();
	private List<String> prereqs = new ArrayList<>();
	private List<String> objectives = new ArrayList<>();
	private List<String> authors = new ArrayList<>();
	private List<String> relatedMaterials = new ArrayList<>();
	private List<String> alternativeLanguages = new ArrayList<>();

	public ItemRetriever(Item item, PageContext pageContext) throws SQLException, UnsupportedEncodingException {
		this.item = item;
		this.pageContext = pageContext;
		metadataRetriever = new ItemMetadataRetriever(item, pageContext);
		bitstreamRetriever = new ItemBitstreamRetriever(item, pageContext);
		initMetadata();
	}

	private void initMetadata() throws SQLException, UnsupportedEncodingException {
		HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();
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
		date = getSingleValue("dc.date.created");

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
	public String getDate() {
		return date;
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
