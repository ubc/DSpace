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
import org.dspace.app.webui.ubc.packager.ItemPackager;
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
	private String dateCreated = "";
	private String dateSubmitted = "";
	private String dateStarted = "";
	private String license = "";
	private String packageZipUrl = "";
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

	public ItemRetriever(Context context, HttpServletRequest request, Item item) throws SQLException, UnsupportedEncodingException {
		this.item = item;
		this.request = request;
		metadataRetriever = new ItemMetadataRetriever(item);
		bitstreamRetriever = new ItemBitstreamRetriever(context, request, item);
		initMetadata();
		packageZipUrl = "/zippackage/" + item.getID();
	}

	private void initMetadata() throws SQLException, UnsupportedEncodingException {
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
		dateCreated = getSingleValue("dc.date.created");
		license = getSingleValue("dc.rights");
		isRestricted = UBCAccessChecker.isRestricted(item);

		dateStarted = getSingleValue("dc.date.issued");
		dateStarted = toReadableDate(dateStarted);
		dateSubmitted = getSingleValue("dc.date.submitted");
		dateSubmitted = toReadableDate(dateSubmitted);

		initStringList("dcterms.type", resourceTypes);
		initStringList("dcterms.requires", prereqs);
		initStringList("dcterms.coverage", objectives);
		initStringList("dc.contributor.author", authors);
		initStringList("dcterms.relation", relatedMaterials);
		initStringList("dcterms.isFormatOf", alternativeLanguages);
		initStringList("dcterms.subject", keywords);
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

	private String toReadableDate(String storedDate) {
		if (storedDate.isEmpty()) return "";
		DCDate tmpDate = new DCDate(storedDate);
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd hh:mm a");
		return dateFormat.format(tmpDate.toDate());
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
	public String getDateStarted() {
		return dateStarted;
	}
	public String getLicense() {
		return license;
	}
	public String getPackageZipUrl() {
		return packageZipUrl;
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
	
}
