package org.dspace.app.webui.ubc.statspace.home;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

/**
 * Stores subject information to be used by the home page jsp.
 * Convenience object to centralize the subjects information needed by the home
 * page jsp.
 */
public class SubjectInfo
{
	private String name;
	private String icon;
	private String searchURL;
	
	public SubjectInfo(String subject) throws UnsupportedEncodingException 
	{
		this.name = subject;
		this.icon = "/static/ubc/images/icons/subjects/" + name.toLowerCase() + ".png";
		String param = URLEncoder.encode(subject, "UTF-8");
		this.searchURL =
			"/simple-search?location=&query=&filtername=subject&filtertype=equals&filterquery=" +
			param +
			"&rpp=9&sort_by=score&order=desc";
	}

	public String getName() { return name; }
	public String getIcon() { return icon; }
	public String getSearchURL() { return searchURL; }

}
