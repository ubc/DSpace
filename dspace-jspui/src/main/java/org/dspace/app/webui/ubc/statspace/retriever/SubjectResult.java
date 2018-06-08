/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace.retriever;

/**
 *
 * @author john
 */
public class SubjectResult {

	private String level1;
	private String level2;
	private String level3;
	private String subject;

	public SubjectResult(String subject) {
		String[] splits = subject.split(" >>> ");
		if (splits.length == 2) {
			level1 = splits[0];
			level2 = splits[1];
		}
		else if (splits.length == 3) {
			level1 = splits[0];
			level2 = splits[1];
			level3 = splits[2];
		}
		else {
			level1 = "Error";
			level2 = "Invalid Subject";
			level3 = subject;
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
