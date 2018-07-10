/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.retriever;

/**
 *
 * @author john
 */
public class SubjectResult {

	private static String OTHER = "Other";

	private String level1;
	private String level2;
	private String level3;
	private String subject;

	public SubjectResult(String subject, String other) {
		String[] splits = subject.split(" >>> ");
		if (splits.length == 1) {
			level1 = subject;
			level2 = "";
			level3 = "";
		}
		else if (splits.length == 2) {
			level1 = splits[0];
			level2 = splits[1];
		}
		else if (splits.length == 3) {
			level1 = splits[0];
			level2 = splits[1];
			level3 = splits[2];
		}
		else {
			level1 = "ERROR WITH SUBJECT";
			level2 = subject;
			level3 = "";
		}
		// custom display for fill-in-the-blank subjects, which only happens
		// when the user selects "Other" in the first or second level. 
		if (!other.isEmpty()) {
			if (level1.equals(OTHER)) {
				level1 += " (" + other + ")";
			}
			else if (level2.equals(OTHER)) {
				level2 += " (" + other + ")";
			}
		}
		this.subject = subject;
	}
	
	public String getSubject() {
		return subject;
	}
	public String getLevel1() {
		return level1;
	}
	public String getLevel2() {
		return level2;
	}
	public String getLevel3() {
		return level3;
	}
}
