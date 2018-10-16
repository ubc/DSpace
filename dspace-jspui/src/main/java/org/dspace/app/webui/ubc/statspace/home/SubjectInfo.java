package org.dspace.app.webui.ubc.statspace.home;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.ArrayList;
import java.util.List;
import org.apache.log4j.Logger;
import org.dspace.app.util.DCInput;
import org.dspace.app.util.DCInputsReader;
import org.dspace.app.util.DCInputsReaderException;

/**
 * Stores subject information to be used by the home page jsp.
 * Convenience object to centralize the subjects information needed by the home
 * page jsp.
 */
public class SubjectInfo
{
    private static Logger log = Logger.getLogger(SubjectInfo.class);

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

	public static List<SubjectInfo> getSubjects() throws DCInputsReaderException, UnsupportedEncodingException
	{
		// get the list of bio subjects from input-forms.xml
		// for showing the explore section on the home page
		List<SubjectInfo> subjects = new ArrayList<SubjectInfo>();
		DCInputsReader inputsReader = new DCInputsReader();
		DCInput[] inputs = inputsReader.getInputs("default").getPageRows(0, true, true);
		for (DCInput input : inputs)
		{
			if (input.getPairsType() != null && input.getPairsType().equals("biospace_subjects"))
			{
				List<String> pairs = input.getPairs();
				boolean skip = false;
				for (String entry : pairs)
				{
					if (skip)
					{
						skip = false;
						continue;
					}
					if (entry.equalsIgnoreCase("other")) continue;
					subjects.add(new SubjectInfo(entry));
					skip = true;
				}
			}
		}
		return subjects;
	}

}
