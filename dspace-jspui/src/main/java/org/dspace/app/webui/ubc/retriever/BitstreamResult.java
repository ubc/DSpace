/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.ubc.retriever;

import org.apache.log4j.Logger;
import org.dspace.app.webui.ubc.IdentifyMediaType;
import org.dspace.ubc.UBCAccessChecker;
import org.dspace.content.Bitstream;
import org.dspace.content.Item;

public class BitstreamResult {
    /** log4j logger */
    private static final Logger log = Logger.getLogger(BitstreamResult.class);

	private String name;
	private String description;
	private String link;
	private String size;
	private String thumbnail;
	private Bitstream bitstream;

	private boolean isRestricted = false;
	// if these are html5 supported media files which are browser playable
	private boolean isPlayableVideo = false;
	private boolean isPlayableAudio = false;
	private boolean isImage = false;
	private boolean isViewableImage = false;

	public BitstreamResult(Item item, Bitstream bitstream, String link, String thumbnail, String size) {
		this.bitstream = bitstream;
		this.link = link;
		this.thumbnail = thumbnail;
		this.size = size;
		this.isRestricted = UBCAccessChecker.isRestricted(item, bitstream);
		this.isPlayableAudio = IdentifyMediaType.isStreamableAudio(bitstream);
		this.isPlayableVideo = IdentifyMediaType.isStreamableVideo(bitstream);
		this.isImage = IdentifyMediaType.isImage(bitstream);
		this.isViewableImage = IdentifyMediaType.isViewableImage(bitstream);
	}

	public String getName() {
		return bitstream.getName();
	}
	public String getId() {
		return Integer.toString(bitstream.getID());
	}
	public String getDescription() {
		return bitstream.getDescription();
	}
	public String getLink() {
		return link;
	}
	public String getThumbnail() {
		return thumbnail;
	}
	public String getSize() {
		return size;
	}
	public boolean getIsRestricted() {
		return isRestricted;
	}

	public boolean getIsPlayableVideo() {
		return isPlayableVideo;
	}

	public boolean getIsPlayableAudio() {
		return isPlayableAudio;
	}

	public boolean getIsImage() {
		return isImage;
	}

	public boolean getIsViewableImage() {
		return isViewableImage;
	}

	public String getMimeType() {
		return bitstream.getFormat().getMIMEType();
	}
	
	public Bitstream getBitstream() {
		return bitstream;
	}
}