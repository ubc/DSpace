/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.retriever;

import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.dspace.content.Item;
import org.dspace.core.Context;

/**
 *
 * @author john
 */
public class RelatedResource {

	private String title = "";
	private String summary = "";
	private String thumbnail = "";
	private String url = "";

	private boolean hasPlaceholderThumbnail = true;

	private ItemBitstreamRetriever bitstreamRetriever;
	private ItemMetadataRetriever metadataRetriever;

	public RelatedResource(Context context, HttpServletRequest request, Item item) throws SQLException, UnsupportedEncodingException
	{
		metadataRetriever = new ItemMetadataRetriever(item);
		bitstreamRetriever = new ItemBitstreamRetriever(context, request, item);
		title = getSingleValue("dc.title");
		summary = getSingleValue("dc.description.abstract");
		url = request.getContextPath() + "/handle/" + item.getHandle();
		thumbnail = request.getContextPath() + "/image/ubc-logo-xl.png";

		List<BitstreamResult> files = bitstreamRetriever.getBitstreams();
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
	}

	private String getSingleValue(String field) {
		MetadataResult result = metadataRetriever.getField(field);
		return result.getValue();
	}

	public String getTitle() {
		return title;
	}
	public String getSummary() {
		return summary;
	}
	public String getThumbnail() {
		return thumbnail;
	}
	public String getURL() {
		return url;
	}
	public boolean getHasPlaceholderThumbnail() {
		return hasPlaceholderThumbnail;
	}
}
