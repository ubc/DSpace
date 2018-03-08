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

import org.dspace.content.Item;


/**
 * JSP helper for getting all metadata and files associated with an item.
 * Basically a unifier for ItemBitstreamRetriever and ItemMetadataRetriever.
 * Also the place to specify what data we want to expose to JSPs.
 *
 */
public class ItemRetriever {

	private Item item;
	private PageContext pageContext;

	private ItemMetadataRetriever metadataRetriever;
	private ItemBitstreamRetriever bitstreamRetriever;

	private String title = "";
	private String description = "";
	private String thumbnail = "";
	private String url = "";
	private List<String> subjects = new ArrayList<>();
	private List<BitstreamResult> files;

	public ItemRetriever(Item item, PageContext pageContext) throws SQLException, UnsupportedEncodingException {
		this.item = item;
		this.pageContext = pageContext;
		metadataRetriever = new ItemMetadataRetriever(item, pageContext);
		bitstreamRetriever = new ItemBitstreamRetriever(item, pageContext);
		initMetadata();
	}

	private void initMetadata() throws SQLException, UnsupportedEncodingException {
		HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();

		MetadataResult result = metadataRetriever.getField("dc.title");
		title = result.getValue();
		result = metadataRetriever.getField("dc.description.abstract");
		description = result.getValue();
		files = bitstreamRetriever.getBitstreams();
		url = request.getContextPath() + "/handle/" + item.getHandle();

		thumbnail = request.getContextPath() + "/image/ubc-logo-lg.png";
		if (!files.isEmpty()) {
			thumbnail = files.get(0).getThumbnail();
		}

		result = metadataRetriever.getField("dc.subject");
		subjects = result.getValues();
	}

	public List<BitstreamResult> getFiles() {
		return files;
	}
	public String getTitle() {
		return title;
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
	public List<String> getSubjects() {
		return subjects;
	}
	
}
