package org.dspace.app.webui.ubc.statspace;

import java.util.Locale;
import java.util.ResourceBundle;
import javax.servlet.http.HttpServletRequest;
import org.dspace.core.NewsManager;

/**
 * Helper class to load blurbs. Realized there was a lot of code duplication now
 * that we're using blurbs in more places.
 */
public class BlurbManager {

	public static final String CONTACT_US = "news-contact.html";
	public static final String HOME_PAGE = "news-top.html";
	public static final String HOW_TO_SUBMIT = "news-submit.html";
	public static final String INSTRUCTOR_ACCESS = "news-instructor-access.html";
	
	public static String getBlurb(HttpServletRequest request, String blurb)
	{
		Locale locale = request.getLocale();
		ResourceBundle msgs = ResourceBundle.getBundle("Messages", locale);
		String content = NewsManager.readNewsFile(msgs.getString(blurb));
		return content;
	}
}
