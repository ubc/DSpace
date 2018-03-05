/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.ubc.statspace;

public class BitstreamResult {
	private String name;
	private String link;
	private String size;
	private String thumbnail;

	public BitstreamResult(String name, String link, String thumbnail, String size) {
		setName(name);
		setLink(link);
		setThumbnail(thumbnail);
		setSize(size);
	}

	public String getName() {
		return name;
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

	public void setName(String name) {
		this.name = name;
	}
	public void setLink(String link) {
		this.link = link;
	}
	public void setThumbnail(String thumbnail) {
		this.thumbnail = thumbnail;
	}
	public void setSize(String size) {
		this.size = size;
	}
	
}
