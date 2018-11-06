package org.dspace.ubc;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Item;
import org.dspace.content.Metadatum;
import org.dspace.core.Context;

/**
 * Handles storing, removing and retrieving related resources.
 * 
 * Note: Related Materials refer to anything in the dcterms.relation field.
 * I'm using Related Resource to specifically refer to these relation links
 * with other DSpace resource items.
 * 
 * TODO: Edge case where if admin/curator deletes an archived item, there will
 * be hanging references to that item
 */
public class RelatedResourceManager {
    /** log4j logger */
    private static Logger log = Logger.getLogger(RelatedResourceManager.class);

	public static final String HEADER = "----- RELATED RESOURCE ITEM ID: ";

	// values used in the form to indicate what type of link the user wants
	public static final String OPTION_UNIDIRECTIONAL = "unidirectional"; // this resource links to the other
	public static final String OPTION_BIDIRECTIONAL = "bidirectional"; // the other resource also links back

	// keys for retrieving the values passed by the html form post requests
	public static final String LINK_TYPE_PARAM_KEY = "dcterms_relation_link";
	public static final String RELATED_MATERIAL_PARAM_KEY = "dcterms_relation";

	// metadata field used to store the two types of links in an item
	public static final String FIELD_UNIDIRECTIONAL = "dcterms.relation";
	public static final String FIELD_BIDIRECTIONAL = "dc.relation.isreferencedby";

	private Context context;
	private Item item;

	public RelatedResourceManager(Context context, Item item)
	{
		this.context = context;
		this.item = item;
	}

	/**
	 * Handles the saving of bidirectional links. Because bidirectional links 
	 * are stored in the target item, they have to be treated specially. 
	 * Unidirectional links can be handled by the regular save, so we don't
	 * worry about that here.
	 * 
	 * Bidirectional links are composed of two unidirectional links. One from
	 * this item to the target item. And one from the target item to this item.
	 * We store the link in the target item in a separate field from the other
	 * links, so we can distinguish them from the normal links added during the 
	 * original submission.
	 * 
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	public void saveBidirectional(HttpServletRequest request) throws SQLException, AuthorizeException
	{
		// Find out which links need bidirectionality. Since bidirectional links
		// are indicated by a checkbox, it doesn't send any values if it isn't
		// checked. To get around this, there's a hidden field with the same
		// name that has the unidirectional value. Because the form parameter
		// order is preserved, this lets us work backwards and figure out which
		// fields are bidirectional enabled.
		List<Boolean> wantBidirectionalLink = new ArrayList<Boolean>();
		String[] linkTypes = request.getParameterValues(LINK_TYPE_PARAM_KEY);
		if (linkTypes == null) return;
		int curIndex = -1; // tracks which resource link we're on right now
		for (String link : linkTypes)
		{
			if (link.equals(OPTION_UNIDIRECTIONAL))
			{
				wantBidirectionalLink.add(Boolean.FALSE);
				curIndex++;
			}
			else if (link.equals(OPTION_BIDIRECTIONAL))
			{
				wantBidirectionalLink.set(curIndex, Boolean.TRUE);
			}
			else
			{
				log.error("Unknown related resource link type.");
			}
		}
		// get the resources the submitter want to link from the form request
		List<String> resources = new ArrayList<String>();
		String[] materials = request.getParameterValues(RELATED_MATERIAL_PARAM_KEY);
		for (String material : materials)
		{
			if (isResource(material)) resources.add(material);
		}
		// Two ways to remove a bidirectional link, one is unchecking the
		// checkbox, the other is removing the entire link. Removing the
		// entire link means it won't be in the form request anymore, so the 
		// only way we'd know this is happening is by comparing the form request
		// with what was already stored. Unchecking the checkbox is handled in
		// the next section, this section handles the entire link being removed.
		Metadatum[] results = item.getMetadataByMetadataString(FIELD_UNIDIRECTIONAL);
		List<Item> itemsToRemove = new ArrayList<Item>();
		for (Metadatum result : results)
		{
			String value = result.value;
			if (!isResource(value)) continue;
			if (resources.contains(value)) continue;
			itemsToRemove.add(getTargetItem(value));
		}
		for (Item removeItem : itemsToRemove)
		{
			removeBidirectionalLinkWith(removeItem);
		}
		// Process the resources sent by the form request
		for (int i = 0; i < resources.size(); i++)
		{
			Item targetItem = getTargetItem(resources.get(i));
			if (targetItem == null)
			{
				log.error("A bidirectional link returned an invalid resource: " + resources.get(i));
				continue;
			}
			if (wantBidirectionalLink.get(i))
			{
				if (hasBidirectionalLinkWith(targetItem)) continue; // already linked
				addBidirectionalLinkWith(targetItem); // not linked, so add it
			}
			else
			{
				if (hasBidirectionalLinkWith(targetItem)) removeBidirectionalLinkWith(targetItem); // already linked, so remove it
				continue; // not linked
			}
		}

		context.commit();
	}

	/**
	 * Returns a map that indicates which one of the links stored in this item
	 * is supposed to be a bidirectional link.
	 * @return 
	 */
	public Map<String, Boolean> getBidirectionalLinksMap() throws SQLException
	{
		Map<String, Boolean> hasBidirectionalLinksMap = new HashMap<String, Boolean>();
		Metadatum[] results = item.getMetadataByMetadataString(FIELD_UNIDIRECTIONAL);
		for (Metadatum result : results)
		{
			String value = result.value;
			if (!isResource(value)) continue;
			hasBidirectionalLinksMap.put(value, Boolean.FALSE);
			Item targetItem = getTargetItem(value);
			if (hasBidirectionalLinkWith(targetItem))
				hasBidirectionalLinksMap.put(value, Boolean.TRUE);
		}
		return hasBidirectionalLinksMap;
	}

	/**
	 * Returns a list of Item linked to by this item's bidirectional metadata
	 * field.
	 * 
	 * @return
	 * @throws SQLException 
	 */
	public List<Item> getMyBidirectionalMetadataItems() throws SQLException
	{
		List<Item> items = new ArrayList<Item>();
		Metadatum[] results = item.getMetadataByMetadataString(FIELD_BIDIRECTIONAL);
		for (Metadatum result : results)
		{
			String value = result.value;
			if (!isResource(value)) continue;
			Item relatedItem = getTargetItem(value);
			items.add(relatedItem);
		}
		return items;
	}

	/**
	 * Delete all the bidirectional links. This is for deleting in-progress
	 * submissions, we need to remove the now dead bidirectional links.
	 */
	public void cleanUpBidirectionalLinks() throws SQLException, AuthorizeException
	{
		Map<String, Boolean> bidirectionalMap = getBidirectionalLinksMap();
		List<Item> items = new ArrayList<Item>();
		for (Map.Entry<String, Boolean> entry : bidirectionalMap.entrySet())
		{
			if (entry.getValue())
			{
				Item targetItem = getTargetItem(entry.getKey());
				items.add(targetItem);
			}
		}
		for (Item deleteLinkItem : items)
		{
			removeBidirectionalLinkWith(deleteLinkItem);
		}
		context.commit();
	}

	/**
	 * Check to see if we have a bidirectional link with the given item.
	 * Edge case: if the given item already links to us unidirectionally, then
	 * we consider the bidirectional link established.
	 * @param item
	 * @return 
	 */
	private boolean hasBidirectionalLinkWith(Item targetItem)
	{
		if (targetItem == null) return false;
		// first check the edge case where if they already link to us
		// unidirectionally, then we don't have to do anything.
		if (isUnidirectionallyLinkedToBy(targetItem)) return true;
		// then check if we're linked bidirectionally
		Metadatum[] results = targetItem.getMetadataByMetadataString(FIELD_BIDIRECTIONAL);
		for (Metadatum result : results)
		{
			String value = result.value;
			if (!isResource(value)) continue;
			int itemID = parseItemID(value);
			if (itemID == item.getID()) return true;
		}
		return false;
	}

	/**
	 * Check to see if the given item already links to us unidirectionally.
	 * @param targetItem
	 * @return 
	 */
	private boolean isUnidirectionallyLinkedToBy(Item targetItem)
	{
		if (targetItem == null) return false;
		Metadatum[] results = targetItem.getMetadataByMetadataString(FIELD_UNIDIRECTIONAL);
		for (Metadatum result : results)
		{
			String value = result.value;
			if (!isResource(value)) continue;
			int itemID = parseItemID(value);
			if (itemID == item.getID()) return true;
		}
		return false;
	}

	/**
	 * Given the raw string stored in metadata, determine if it's supposed to be a related resource.
	 */
	private boolean isResource(String storedValue)
	{
		if (storedValue == null || storedValue.isEmpty()) return false;
		if (storedValue.startsWith(HEADER))
			return true;
		return false;
	}

	/**
	 * Given the raw string stored in metadata, find and return the targeted item.
	 * @param resource
	 * @return null if it couldn't find the item, the item object otherwise
	 */
	private Item getTargetItem(String storedValue) throws SQLException
	{
		if (!isResource(storedValue)) return null;
		int itemID = parseItemID(storedValue);
		Item item = Item.find(context, itemID);
		return item;
	}

	/**
	 * Create a string that will be stored in the metadata.
	 * @return 
	 */
	private String getMetadataValueString(int itemID)
	{
		return HEADER + itemID;
	}

	/**
	 * Parse the raw string stored in the metadata and return the item ID.
	 * @param storedValue
	 * @return 
	 */
	private int parseItemID(String storedValue)
	{
		String itemIDStr = storedValue.replace(HEADER, "");
		int itemID = Integer.parseInt(itemIDStr);
		return itemID;
	}

	/**
	 * Modify the given item so that we're bidirectionally linked with it.
	 * This will NOT check for duplicates, so it is assumed that we've already
	 * confirmed that there are no duplicates.
	 * @param targetItem 
	 */
	private void addBidirectionalLinkWith(Item targetItem) throws SQLException, AuthorizeException 
	{
		if (targetItem == null) return;
		MetadataFieldSplitter field = new MetadataFieldSplitter(FIELD_BIDIRECTIONAL);
		String value = getMetadataValueString(item.getID());
		context.turnOffAuthorisationSystem();
		targetItem.addMetadata(field.schema, field.element, field.qualifier, Item.ANY, value);
		targetItem.update();
		context.restoreAuthSystemState();
	}

	/**
	 * Modify the given item to remove the bidrectional link with it.
	 * 
	 * @param targetItem
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	private void removeBidirectionalLinkWith(Item targetItem) throws SQLException, AuthorizeException 
	{
		if (targetItem == null) return;
		// there's no way to just remove a single value, so have to just remove everything and then
		// readd the ones that we don't want to remove
		Metadatum[] existingValues = targetItem.getMetadataByMetadataString(FIELD_BIDIRECTIONAL);

		MetadataFieldSplitter field = new MetadataFieldSplitter(FIELD_BIDIRECTIONAL);
		targetItem.clearMetadata(field.schema, field.element, field.qualifier, Item.ANY);

		context.turnOffAuthorisationSystem();
		String toBeRemoved = getMetadataValueString(item.getID());
		for (Metadatum existingValue : existingValues)
		{
			if (existingValue.value.equals(toBeRemoved)) continue;
			targetItem.addMetadata(field.schema, field.element, field.qualifier, Item.ANY, existingValue.value);
		}
		targetItem.update();
		context.restoreAuthSystemState();
	}
	
}
