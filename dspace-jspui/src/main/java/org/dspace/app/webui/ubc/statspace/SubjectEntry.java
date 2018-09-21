package org.dspace.app.webui.ubc.statspace;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

public class SubjectEntry
{
    /** log4j logger */
    private static Logger log = Logger.getLogger(SubjectEntry.class);

	private String label = "";
	private String value = "";
	private int level = 0;
	// since this is being used in a subject tree, there can be sub-subjects under this subject
	private Map<String, SubjectEntry> subjects = new LinkedHashMap<String, SubjectEntry>();

	public SubjectEntry(String label, String value)
	{
		this(label, value, 0);
	}

	public SubjectEntry(String label, String value, int level)
	{
		this.label = label;
		this.value = value;
		this.level = level;
	}

	public SubjectEntry addSubject(String label, String value)
	{
		SubjectEntry entry = new SubjectEntry(label, value, getLevel() + 1);
		subjects.put(value, entry);
		return entry;
	}

	public List<SubjectEntry> getSubjects()
	{
		return new ArrayList<SubjectEntry>(subjects.values());
	}

	public int getLevel() { return level; }
	public String getLabel() { return label; }
	public String getValue() { return value; }
	
	public boolean hasSubject(String value) { return subjects.containsKey(value); };
}
