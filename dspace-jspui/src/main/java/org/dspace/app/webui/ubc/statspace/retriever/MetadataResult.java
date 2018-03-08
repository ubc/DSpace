/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.ubc.statspace.retriever;

import java.util.ArrayList;
import java.util.List;
import org.dspace.content.Metadatum;

public class MetadataResult {

	private String label = "";
	private List<String> values = new ArrayList<>();

	public MetadataResult(String label) {
		this.label = label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public void setValues(Metadatum[] values) {
		for (Metadatum value : values) {
			this.values.add(value.value);
		}
	}

	public String getLabel() {
		return label;
	}
	
	public String getValue() {
		if (values.isEmpty())
			return "";
		return values.get(0);
	}

	public List<String> getValues() {
		return values;
	}
}
