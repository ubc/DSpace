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
import org.dspace.app.webui.ubc.statspace.UBCAccessChecker;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.content.Bundle;
import org.dspace.content.Item;
import org.dspace.content.Bitstream;
import org.dspace.constants.Constants;
import org.dspace.core.Context;

/**
 * Helper to retrieve a list of files from an item.
 * Bitstreams are just files. DSpace just calls them bitstreams for some reason.
 */
public class ItemBitstreamRetriever {
    /** log4j logger */
    private static final Logger log = Logger.getLogger(ItemMetadataRetriever.class);

	private Item item;
	private Context context;
	private HttpServletRequest request;

	public ItemBitstreamRetriever(Context context, HttpServletRequest request, Item item) {
		this.item = item;
		this.context = context;
		this.request = request;
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
		UBCAccessChecker accessChecker = new UBCAccessChecker(context);
		List<BitstreamResult> results = new ArrayList<>();

		String handle = item.getHandle();

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
				if (!accessChecker.hasFileAccess(item, bitstream)) continue;
				BitstreamResult result = processBitstream(bitstream, handle,
						thumbs);
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
	 * @param thumbs - an array of thumbnail bundles, retrieved from item
	 * @return A BitstreamResult object with all relevant info
	 * @throws UnsupportedEncodingException 
	 */
	private BitstreamResult processBitstream(Bitstream bitstream, String handle,
		Bundle[] thumbs) throws UnsupportedEncodingException {
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
		return new BitstreamResult(item, bitstream, bsLink, bsThumb, size);
	}

}
