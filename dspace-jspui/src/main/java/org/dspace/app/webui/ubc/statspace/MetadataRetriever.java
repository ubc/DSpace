/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.ubc.statspace;

import javax.servlet.jsp.PageContext;
import javax.servlet.jsp.jstl.fmt.LocaleSupport;
import org.apache.log4j.Logger;
import org.dspace.content.Metadatum;
import org.dspace.content.Item;

public class MetadataRetriever
{
    /** log4j logger */
    private static Logger log = Logger.getLogger(MetadataRetriever.class);

	private PageContext pageContext;
	private Item item;

    public MetadataRetriever(Item item, PageContext pageContext) {
		this.pageContext = pageContext;
		this.item = item;
    }

	/**
	 * Takes a metadata field, e.g.: dc.title, and retrieves the human readable
	 * label and value associated with it.
	 * @param field - A metadata registry string, e.g.: dc.description.abstract
	 * @param item - The submission item we're looking up data for
	 * @return A MetadataResult object containing the label and the value. 
	 */
	public MetadataResult getSingleValueField(String field) {
		MetadataResult result = new MetadataResult("", "");

		// Try to parse the field into its components.
		String[] eq = field.split("\\.");
		if (eq.length <= 1) {
			throw new IllegalArgumentException("Metadata field is not in a recognizable metadata registry entry string.");
		}
		String schema = eq[0];
		String element = eq[1];
		String qualifier = null;
		if (eq.length > 2)
		{
			qualifier = eq[2];
		}

		// Retrieve the metadata based on the field components.
		Metadatum[] values = item.getMetadata(schema, element, qualifier, Item.ANY);
		// Try to retrieve the human readable metadata label
		String label = "";
		// Don't need i18n support so skipped checking for it
		label = LocaleSupport.getLocalizedMessage(pageContext,
				"metadata." + field);
		result.setLabel(label);

		// Try to set the value
		if (values.length == 0) {
			// There was no value recorded for this field.
			return result;
		}
		if (values.length > 0)
		{
			// only need to read the first value
			result.setValue(values[0].value);
		}
		return result;
	}
}
