package org.dspace.ubc;

/**
 * Given a metadata field string, eg "dc.relation.isreferencedby", split it into the 3 components delimited by the periods.
 */
public class MetadataFieldSplitter {
	public String schema = null;
	public String element = null;
	public String qualifier = null;
	
	public MetadataFieldSplitter(String field)
	{
		String[] eq = field.split("\\.");
		if (eq.length <= 1) {
			throw new IllegalArgumentException("Metadata field is not in a recognizable metadata registry entry string.");
		}
		schema = eq[0];
		element = eq[1];
		qualifier = null;
		if (eq.length > 2)
		{
			qualifier = eq[2];
		}
	}
}
