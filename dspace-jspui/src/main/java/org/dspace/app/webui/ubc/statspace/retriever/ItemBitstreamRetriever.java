/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.ubc.statspace.retriever;

import java.io.UnsupportedEncodingException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.PageContext;
import org.apache.log4j.Logger;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.content.Bundle;
import org.dspace.content.Item;
import org.dspace.content.Bitstream;
import org.dspace.constants.Constants;

/**
 * Helper to retrieve a list of files from an item.
 * Bitstreams are just files. DSpace just calls them bitstreams for some reason.
 */
public class ItemBitstreamRetriever {
    /** log4j logger */
    private static final Logger log = Logger.getLogger(ItemMetadataRetriever.class);

	private final Item item;
	private final PageContext pageContext;

	public ItemBitstreamRetriever(Item item, PageContext pageContext) {
		this.item = item;
		this.pageContext = pageContext;
	}

	/**
	 * Get a list of files stored in the submission item. The file information
	 * will be stored in the convenience class BitstreamResult for use in 
	 * JSPs.
	 * @return A list of BitstreamResults.
	 * @throws SQLException 
	 * @throws java.io.UnsupportedEncodingException 
	 */
	public List<BitstreamResult> getBitstreams() throws SQLException, UnsupportedEncodingException {
		List<BitstreamResult> results = new ArrayList<>();

		String handle = item.getHandle();
		HttpServletRequest request = (HttpServletRequest) pageContext.getRequest();

		Bundle[] bundles = item.getBundles("ORIGINAL");
		Bundle[] thumbs = item.getBundles("THUMBNAIL");

		// Check if any files were uploaded for this submission.
		// Not sure if this is needed.
		boolean filesExist = false;
		for (Bundle bnd : bundles) {
			if (bnd.getBitstreams().length > 0) {
				filesExist = true;
				break;
			}
		}
		if (!filesExist) {
			// No files were uploaded for this submission
			return results;
		}
		// Get all the files
		for (Bundle bundle : bundles) {
			Bitstream[] bitstreams = bundle.getBitstreams();
			for (Bitstream bitstream : bitstreams) {
				if (bitstream.getFormat().isInternal()) continue;
				BitstreamResult result = processBitstream(bitstream, handle,
						request, thumbs);
				results.add(result);
			}
		}
		return results;
	}

	/**
	 * Helper for getBitstreams, convert a single Bitstream entry into a
	 * BitstreamResult.
	 * @param bitstream - the uploaded file being processed
	 * @param handle - the persistent ID for this submission, if it has one
	 * @param request - the web request object
	 * @param thumbs - an array of thumbnail bundles, retrieved from item
	 * @return A BitstreamResult object with all relevant info
	 * @throws UnsupportedEncodingException 
	 */
	private BitstreamResult processBitstream(Bitstream bitstream, String handle,
		HttpServletRequest request, Bundle[] thumbs) throws UnsupportedEncodingException {
		String bsName = bitstream.getName();
		String bsLink = request.getContextPath();
		String bsThumb = "";
		String size = UIUtil.formatFileSize(bitstream.getSize());
		// Skip internal types
		// Work out what the bitstream link should be
		// (persistent ID if item has Handle)
		if ((handle != null)
				&& (bitstream.getSequenceID() > 0)) {
			bsLink = bsLink + "/bitstream/" + item.getHandle() + "/" +
					bitstream.getSequenceID() + "/";
		}
		else {
			bsLink = bsLink + "/retrieve/" + bitstream.getID() + "/";
		}
		bsLink = bsLink + UIUtil.encodeBitstreamName(
				bitstream.getName(), Constants.DEFAULT_ENCODING);
		// Check to see if there's a thumbnail for this file.
		// Weird that it only uses the first thumbs bundle, but that's how it
		// was in the original code in ItemTag.
		if (thumbs.length > 0) {
			String tName = bitstream.getName() + ".jpg";
			Bitstream tb = thumbs[0].getBitstreamByName(tName);
			if (tb != null) {
				bsThumb = request.getContextPath() + "/retrieve/" +
						tb.getID() + "/" + UIUtil.encodeBitstreamName(
							tb.getName(), Constants.DEFAULT_ENCODING);
			}
		}
		return new BitstreamResult(bsName, bsLink, bsThumb, size);
	}

}
