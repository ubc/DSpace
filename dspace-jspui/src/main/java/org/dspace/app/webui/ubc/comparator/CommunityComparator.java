package org.dspace.app.webui.ubc.comparator;

import java.util.Comparator;
import org.dspace.content.Community;

public class CommunityComparator  implements Comparator<Community>
{

	// Since DSpace API's Community doesn't implement any of the interfaces that lets us use
	// the java standard libraries sorted collections, we have to implement it
	// ourselves. This is just an alphabetical comparison based on the collection's name.
	// Strangely, a Collection comparator exists at org.dspace.content.Collection.CollectionComparator
	// but there's no comparator for Community.
	@Override
	public int compare(Community a, Community b)
	{
		return a.getName().compareTo(b.getName());
	}
	
}
