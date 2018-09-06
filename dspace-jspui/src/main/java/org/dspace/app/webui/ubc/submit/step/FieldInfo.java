/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.submit.step;

import java.util.ArrayList;
import java.util.List;
import javafx.util.Pair;
import org.apache.log4j.Logger;
import org.dspace.app.util.DCInput;
import org.dspace.app.util.SubmissionInfo;
import org.dspace.content.DCDate;
import org.dspace.content.DCPersonName;
import org.dspace.content.Item;
import org.dspace.content.Metadatum;

/**
 *
 * @author john
 */
public class FieldInfo {
    private static Logger log = Logger.getLogger(FieldInfo.class);
	
	public static final String INPUT_TYPE_NAME = "name";
	public static final String INPUT_TYPE_DATE = "date";
	public static final String INPUT_TYPE_SERIES = "series";
	public static final String INPUT_TYPE_QUALDROP = "qualdrop_value";
	public static final String INPUT_TYPE_TEXTAREA = "textarea";
	public static final String INPUT_TYPE_DROPDOWN = "dropdown";
	public static final String INPUT_TYPE_ONEBOX = "onebox";
	public static final String INPUT_TYPE_TWOBOX = "twobox";
	public static final String INPUT_TYPE_LIST = "list";

	private DCInput input;
	private boolean isVisible = true;
	private boolean hasValidationError = false;

	private String fieldID = "";
	private String submissionMode = "";
	private String validationErrorMsg = "Please fill in this required field.";

	private List<String> values = new ArrayList<String>();
	private List<Pair<String,String>> options = new ArrayList<Pair<String,String>>();

	public FieldInfo(SubmissionInfo submissionInfo, DCInput input)
	{
		this.input = input;
		this.submissionMode = submissionInfo.isInWorkflow() ? "workflow" : "submit";
		setIsVisible();
		// TODO: also a good place for refactoring
		String dcSchema = input.getSchema();
		String dcElement = input.getElement();
		String dcQualifier = input.getQualifier();
		this.fieldID = dcSchema + "_" + dcElement;
		if (dcQualifier != null && !dcQualifier.equals("*"))
			this.fieldID += '_' + dcQualifier;

		String vocabulary = input.getVocabulary();

		// primitive form validation, check if required fields are filled in
		boolean passValidation = true;
		if ((submissionInfo.getMissingFields() != null) &&
			(submissionInfo.getMissingFields().contains(fieldID)))
		{ // this field is a required field that wasn't filled in
			hasValidationError = true;
			if(input.getWarning() != null)
			{
				this.validationErrorMsg = input.getWarning();
			}
		}
		// get values
		Item item = submissionInfo.getSubmissionItem().getItem();
		Metadatum[] storedValues = item.getMetadata(dcSchema, dcElement, dcQualifier, Item.ANY);
		for (Metadatum metadatum : storedValues)
		{
			values.add(metadatum.value);
		}
		// get options for dropdowns, the raw options comes in a 1d array, so
		// we have to pair them up manually. The first one is the option's displayed
		// value, the second one is the option's actual stored value.
		setOptions(input.getPairs());
	}

	private void setIsVisible()
	{
		isVisible = true;
		// DSpace considers readonly elements to be "invisible". Doesn't make
		// sense to me, so I'm treating readonly elements as visible.
		if (!input.isVisible(submissionMode) &&
			!input.isReadOnly(submissionMode))
			isVisible = false;
	}

	private void setOptions(List<String> optionsRaw)
	{
		if (optionsRaw == null) return;
		for (int i = 0; i < optionsRaw.size(); i+=2)
		{
			String displayedValue = optionsRaw.get(i);
			String storedValue = optionsRaw.get(i+1);
			// we're treating the displayedValue as the key, and the storedValue as the value
			Pair<String,String> pair = new Pair<String,String>(displayedValue, storedValue);
			options.add(pair);
		}
	}

	public boolean getHasAddMore()
	{
		if (!getIsRepeatable()) return false;
		// dropdowns don't need "Add More" repeatables since <select>
		// elements already has multi-select ability
		if (getInputType().equals(INPUT_TYPE_DROPDOWN)) return false;
		return true;
	}

	/**
	 * Only useful for name fields, stuff the field value into a DCPersonName so
	 * it'll split it into first and last name for us.
	 * @return Will always return a list with at least one empty name. This is
	 * because the UI needs at least one element in values to draw the input elements.
	 */
	public List<DCPersonName> getNames() 
	{
		List<DCPersonName> names = new ArrayList<DCPersonName>();
		for (String value : getValues())
		{
			names.add(new DCPersonName(value));
		}
		return names;
	}
	/**
	 * If there are no pre-existing values, will return a list with one empty
	 * string. This is because the UI needs at least one element in values
	 * to draw the input elements.
	 * @return 
	 */
	public List<String> getValues() 
	{
		if (values.isEmpty()) values.add("");
		return values;
	}
	/**
	 * Get the first stored value.
	 * @return the first stored value for this field as a string.
	 */
	public String getValue() { return getValues().get(0); }
	/**
	 * Interpret the first stored value as a date.
	 * @return A DCDate object.
	 */
	public DCDate getDate() { return new DCDate(getValue()); }
	/**
	 * Only useful for dropdowns, get the available options for this dropdown.
	 * @return 
	 */
	public List<Pair<String,String>> getOptions() { return options; }

	public boolean getHasValidationError() { return hasValidationError; }
	public boolean getIsReadOnly() { return input.isReadOnly(submissionMode); }
	public boolean getIsRequired() { return input.isRequired(); }
	public boolean getIsRepeatable() { return input.isRepeatable(); }
	public boolean getIsVisible() { return isVisible; }

	public String getHint() { return input.getHints(); }
	public String getInputID() { return fieldID; }
	public String getInputWrapperID() { return fieldID + "_wrapper"; }
	public String getInputAddMoreButtonID() { return fieldID + "_addmore_button"; }
	public String getInputType() { return input.getInputType(); }
	public String getLabel() { return input.getLabel(); }
	public String getValidationErrorMsg() { return validationErrorMsg; }

	public String getINPUT_TYPE_NAME()		{ return INPUT_TYPE_NAME; }
	public String getINPUT_TYPE_DATE()		{ return INPUT_TYPE_DATE; }
	public String getINPUT_TYPE_SERIES()	{ return INPUT_TYPE_SERIES; }
	public String getINPUT_TYPE_QUALDROP()	{ return INPUT_TYPE_QUALDROP; }
	public String getINPUT_TYPE_TEXTAREA()	{ return INPUT_TYPE_TEXTAREA; }
	public String getINPUT_TYPE_DROPDOWN()	{ return INPUT_TYPE_DROPDOWN; }
	public String getINPUT_TYPE_ONEBOX()	{ return INPUT_TYPE_ONEBOX; }
	public String getINPUT_TYPE_TWOBOX()	{ return INPUT_TYPE_TWOBOX; }
	public String getINPUT_TYPE_LIST()		{ return INPUT_TYPE_LIST; }
}
