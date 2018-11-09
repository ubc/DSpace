/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.ubc.retriever;

import org.apache.log4j.Logger;
import org.dspace.content.Metadatum;
import org.dspace.content.Item;
import org.dspace.core.I18nUtil;
import org.dspace.ubc.MetadataFieldSplitter;

public class ItemMetadataRetriever
{
    /** log4j logger */
    private static Logger log = Logger.getLogger(ItemMetadataRetriever.class);

	private Item item;

    public ItemMetadataRetriever(Item item) {
		this.item = item;
	}

	/**
	 * Takes a metadata field, e.g.: dc.title, and retrieves the human readable
	 * label and value associated with it.
	 * @param field - A metadata registry string, e.g.: dc.description.abstract
	 * @return A MetadataResult object containing the label and the value. 
	 */
	public MetadataResult getField(String field) {
		MetadataResult result = new MetadataResult("");

		// Try to parse the field into its components.
		MetadataFieldSplitter splitter = new MetadataFieldSplitter(field);

		// Retrieve the metadata based on the field components.
		Metadatum[] values = item.getMetadata(splitter.schema, splitter.element, splitter.qualifier, Item.ANY);
		// Try to retrieve the human readable metadata label
		String label = field; // defaults to metadata registry if unable to localize
		// Don't need i18n support so skipped checking for it
		label = I18nUtil.getMessage("metadata." + field);

		// Try to set the value
		if (values.length == 0) {
			// There was no value recorded for this field.
			return result;
		}
		if (values.length > 0)
		{
			// only need to read the first value
			result.setValues(values);
		}
		return result;
	}
}
