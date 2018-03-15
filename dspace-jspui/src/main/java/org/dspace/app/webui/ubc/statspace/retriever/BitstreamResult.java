/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.ubc.statspace.retriever;

public class BitstreamResult {
	private String name;
	private String description;
	private String link;
	private String size;
	private String thumbnail;

	public BitstreamResult(String name, String description, String link, String thumbnail, String size) {
		setName(name);
		setDescription(description);
		setLink(link);
		setThumbnail(thumbnail);
		setSize(size);
	}

	public String getName() {
		return name;
	}
	public String getDescription() {
		return description;
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
	public void setDescription(String description) {
		this.description = description;
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
