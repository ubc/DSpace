/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace;

import com.google.gson.JsonArray;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import com.google.gson.JsonPrimitive;
import java.util.ArrayList;
import java.util.List;
import org.apache.log4j.Logger;

/**
 *
 * @author john
 */
public class SubjectsJson {

    /** log4j logger */
    private static Logger log = Logger.getLogger(SubjectsJson.class);

	private List<String> subjects = new ArrayList<String>();

	public SubjectsJson(List<String> subjects) {
		this.subjects = subjects;

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
			String[] components = display.split(" >>> ");
			String top = "";
			String mid = "";
			String bot = "";
			if (components.length == 2) {
				top = components[0];
				mid = components[1];
			}
			else if (components.length == 3) {
				top = components[0];
				mid = components[1];
				bot = components[2];
			}
			else {
				log.warn("Unrecongized entry in StatSpace subjects list: " + display);
				continue;
			}
			if (!json.has(top)) json.add(top, new JsonObject());

			JsonObject topJson = json.get(top).getAsJsonObject();
			if (!topJson.has(mid)) topJson.add(mid, new JsonObject());

			JsonObject midJson = topJson.get(mid).getAsJsonObject();
			if (!midJson.has(bot) && !bot.isEmpty()) midJson.add(bot, new JsonPrimitive(value));
		}
		return json.toString();
	}
	
}
