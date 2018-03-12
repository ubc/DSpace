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
import java.util.List;
import org.apache.log4j.Logger;

/**
 *
 * @author john
 */
public class SubjectsJson {

    /** log4j logger */
    private static Logger log = Logger.getLogger(SubjectsJson.class);

	private List<String> subjects;

	public SubjectsJson(List<String> subjects) {
		this.subjects = subjects;

	}

	/**
	 * Returns true if we were given a list of subjects, false otherwise.
	 * This is a simple test, just checking to see if we have two of the >>>
	 * delimiters.
	 * @return Returns true if we were given a list of subjects, false otherwise.
	 */
	public boolean isSubjects() {
		if (subjects == null || subjects.isEmpty()) return false;
		String sample = subjects.get(0);
		String[] components = sample.split(" >>> ");
		if (components.length != 3) {
			log.debug("Sample " + sample + " judged not to be a subjects list.");
			return false;
		}
		return true;
	}

	/**
	 * The subjects are organized in a tree, get the JSON representation of it.
	 * @param subjects
	 * @return 
	 */
	public String getTreeJson() {
		JsonObject json = new JsonObject();
		if (!isSubjects()) {
			log.warn("Requesting subjects json when not given a subjects list.");
			return "{}";
		} // only proceed if dealing with subjects
		for (int i = 0; i < subjects.size(); i += 2)
		{
			String display = subjects.get(i);
			String value = subjects.get(i+1);
			log.debug("Display: " + display);
			log.debug("Value: " + value);
			String[] components = display.split(" >>> ");
			if (components.length != 3) {
				log.warn("Unrecongized entry in StatSpace subjects list: " + display);
				continue;
			}
			String top = components[0];
			String mid = components[1];
			String bot = components[2];
			if (!json.has(top)) json.add(top, new JsonObject());
			JsonObject topJson = json.get(top).getAsJsonObject();
			if (!topJson.has(mid)) topJson.add(mid, new JsonObject());
			JsonObject midJson = topJson.get(mid).getAsJsonObject();
			if (!midJson.has(bot)) midJson.add(bot, new JsonPrimitive(value));
		}
		return json.toString();
	}
	
}
