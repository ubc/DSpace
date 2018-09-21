/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace;

import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;

/**
 *
 * @author john
 */
public class SubjectsTreeParser {

    /** log4j logger */
    private static Logger log = Logger.getLogger(SubjectsTreeParser.class);

	private List<String> subjects = new ArrayList<String>();

	public static final String DELIMITER = " >>> ";

	public SubjectsTreeParser(List<String> subjects) {
		this.subjects = subjects;
	}

	/**
	 * Flatten the tree into an array where the nodes are ordered in a depth first manner.
	 * 
	 * @return 
	 */
	public List<SubjectEntry> getDepthFirstFlatTree() {
		List<SubjectEntry> tree = getTree();
		List<SubjectEntry> flattened = new ArrayList<SubjectEntry>();
		for (SubjectEntry level1 : tree) {
			flattened.add(level1);
			for (SubjectEntry level2 : level1.getSubjects()) {
				flattened.add(level2);
				for (SubjectEntry level3 : level2.getSubjects()) {
					flattened.add(level3);
				}
			}
		}
		return flattened;
	}

	/**
	 * Get a hierarchical subject tree representation.
	 * @return 
	 */
	public List<SubjectEntry> getTree() {
		List<SubjectEntry> subjectsTree = new ArrayList<SubjectEntry>();
		Map<String, SubjectEntry> flatSubjectsMap = new HashMap<String, SubjectEntry>();
		for (String subject : subjects) {
			addSubjectToTree(subject, subjectsTree, flatSubjectsMap);
		}
		return subjectsTree;
	}

	/**
	 * Helper method for getTree, recursively add the given subject and its parents to the tree.
	 * @param subject - the full subject value
	 * @param tree - SubjectEntry list, uses SubjectEntry to maintain a hierarchical subject view structure
	 * @param map - flat maping of subject to their SubjectEntry, used to quickly determine if we're inserting duplicates
	 */
	private void addSubjectToTree(String subject, List<SubjectEntry> tree, Map<String, SubjectEntry> map) {
		if (map.containsKey(subject)) return; // we've already added this entry
		String[] components = subject.split(DELIMITER);
		if (components.length == 1) {
			SubjectEntry entry = new SubjectEntry(subject, subject);
			tree.add(entry);
			map.put(subject, entry);
		}
		else if (components.length == 2) {
			addSubjectToTree(components[0], tree, map);
			SubjectEntry parent = map.get(components[0]);
			SubjectEntry entry = parent.addSubject(components[1], subject);
			map.put(subject, entry);
		}
		else if (components.length == 3) {
			String parentKey = components[0] + DELIMITER + components[1];
			addSubjectToTree(parentKey, tree, map);
			SubjectEntry parent = map.get(parentKey);
			SubjectEntry entry = parent.addSubject(components[2], subject);
			map.put(subject, entry);
		}
		else {
			log.warn("Unrecognized entry in StatSpace subjects list: " + subject);
		}
	}

	/**
	 * Returns true if we were given a list of subjects, false otherwise.
	 * This is a simple test, just checking to see if we have two of the >>>
	 * delimiters.
	 * @return Returns true if we were given a list of subjects, false otherwise.
	 */
	public boolean isSubjects(String fieldName) {
		if (fieldName.equals("dc_subject")) return true;
		return false;
	}

	/**
	 * The subjects are organized in a tree, get the JSON representation of it.
	 * @param subjects
	 * @return 
	 */
	public String getTreeJson() {
		JsonObject json = new JsonObject();
		if (subjects.isEmpty()) {
			log.warn("Requesting subjects json when not given a subjects list.");
			return "{}";
		} // only proceed if dealing with subjects
		for (int i = 0; i < subjects.size(); i += 2)
		{
			String display = subjects.get(i);
			String value = subjects.get(i+1);
			String[] components = display.split(DELIMITER);
			String top = "";
			String mid = "";
			String bot = "";
			if (components.length == 1) {
				top = components[0];
			}
			else if (components.length == 2) {
				top = components[0];
				mid = components[1];
			}
			else if (components.length == 3) {
				top = components[0];
				mid = components[1];
				bot = components[2];
			}
			else {
				log.warn("Unrecognized entry in StatSpace subjects list: " + display);
				continue;
			}
			if (!json.has(top)) json.add(top, new JsonObject());

			JsonObject topJson = json.get(top).getAsJsonObject();
			if (mid.isEmpty()) continue; // second level doesn't exist, skip
			if (!topJson.has(mid)) topJson.add(mid, new JsonObject());

			JsonObject midJson = topJson.get(mid).getAsJsonObject();
			if (!midJson.has(bot) && !bot.isEmpty()) midJson.add(bot, new JsonPrimitive(value));
		}
		return json.toString();
	}
	
}
