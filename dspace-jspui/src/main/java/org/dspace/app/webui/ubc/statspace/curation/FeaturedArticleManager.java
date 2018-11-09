package org.dspace.app.webui.ubc.statspace.curation;

import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.security.InvalidParameterException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.servlet.http.HttpServletRequest;
import org.apache.log4j.Logger;
import org.dspace.app.webui.ubc.retriever.ItemRetriever;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Item;
import org.dspace.content.Metadatum;
import org.dspace.core.Context;
import org.dspace.handle.HandleManager;
import org.dspace.ubc.MetadataFieldSplitter;


/**
 * Manages all aspect of saving/deleting featured articles.
 * 
 * Featured articles are stored in each Collection's metadata.
 * 
 */
public class FeaturedArticleManager
{
    private static Logger log = Logger.getLogger(FeaturedArticleManager.class);

	/** The metadata field to store references to the featured articles. */
	public static final String FIELD_ARTICLES = "ubc.featuredArticle";
	/** Articles are submitted by form control under this name. */
	public static final String PARAM_ADD_ARTICLE = "featuredArticleAdd";
	public static final String PARAM_REMOVE_ARTICLE = "featuredArticleRemove";
	public static final String PARAM_COLLECTION = "featuredArticleCollection";
	/** Featured article values stored in the metadata are prefixed by this string */
	public static final String HEADER = "----- ARTICLE ITEM ID: ";

	private Context context;
	private HttpServletRequest request;
	private MetadataFieldSplitter field = new MetadataFieldSplitter(FIELD_ARTICLES);

	public FeaturedArticleManager(Context context, HttpServletRequest request)
	{
		this.context = context;
		this.request = request;
	}


	/**
	 * Get all featured articles from all collections.
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public List<ItemRetriever> getAllArticles() throws SQLException, UnsupportedEncodingException
	{
		List<ItemRetriever> articles = new ArrayList<ItemRetriever>();
		List<Collection> collections = getAllCollections();
		for (Collection collection : collections)
		{
			articles.addAll(getArticles(collection));
		}
		return articles;
	}

	/**
	 * Get featured articles from a collection identified by an ID string.
	 * 
	 * @param collection
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public List<ItemRetriever> getArticles(String collectionIDStr) throws SQLException, UnsupportedEncodingException
	{
		Collection collection = getCollectionFromIDStr(collectionIDStr);
		return getArticles(collection);
	}

	/**
	 * Get featured articles from a Collection.
	 * @param collection
	 * @return
	 * @throws SQLException
	 * @throws UnsupportedEncodingException 
	 */
	public List<ItemRetriever> getArticles(Collection collection) throws SQLException, UnsupportedEncodingException
	{
		List<Item> items = getItems(collection);
		List<ItemRetriever> articles = new ArrayList<ItemRetriever>();
		for (Item item : items)
		{
			ItemRetriever article = new ItemRetriever(context, request, item);
			articles.add(article);
		}
		return articles;
	}

	/**
	 * Process the form post request to add an item to featured articles.
	 * @param collection 
	 */
	public void addArticle(String collectionIDStr, String articleURL) throws SQLException, AuthorizeException
	{
		Collection collection = getCollectionFromIDStr(collectionIDStr);
		if (collection == null) throw new InvalidParameterException("Invalid collection ID.");
		Item item = getItemFromURL(articleURL);
		if (item == null)
		{
			log.error("Could not add featured article: " + articleURL);
			throw new InvalidParameterException("Invalid article ID.");
		}
		addArticle(collection, item);
		context.commit();
	}

	/**
	 * Process the form request to remove an item from featured articles.
	 * @param collection 
	 */
	public void removeArticle(String collectionIDStr, String articleID) throws SQLException, AuthorizeException
	{
		Collection collection = getCollectionFromIDStr(collectionIDStr);
		if (collection == null) throw new InvalidParameterException("Invalid collection ID.");
		Item item = getItemFromValue(articleID);
		if (item == null)
		{
			log.error("Could not remove featured article: " + articleID);
			throw new InvalidParameterException("Invalid article ID.");
		}
		removeArticle(collection, item);
		context.commit();
	}

	public void setJSPAtrributes() throws SQLException
	{
		request.setAttribute("featuredArticleParamAdd", PARAM_ADD_ARTICLE);
		request.setAttribute("featuredArticleParamRemove", PARAM_REMOVE_ARTICLE);
		request.setAttribute("featuredArticleParamCollection", PARAM_COLLECTION);
		request.setAttribute("featuredArticleCollections", getAllCollections());
	}

	/**
	 * Add the given item to featured articles.
	 * @param collection 
	 */
	private void addArticle(Collection collection, Item item) throws SQLException, AuthorizeException
	{
		// don't add duplicates
		List<Item> existingItems = getItems(collection);
		for (Item existingItem : existingItems)
		{
			if (existingItem.getID() == item.getID()) return;
		}
		// not a duplicate, add it
		collection.addMetadata(field.schema, field.element, field.qualifier, Item.ANY, getMetadataValueString(item.getID()));
		collection.update();
	}

	/**
	 * Remove the given item from featured articles.
	 * Looks like the only way to do this is clear the metadata field and then
	 * readd everything except the item we want to remove.
	 * @param collection
	 * @param itemToRemove
	 * @throws SQLException 
	 */
	private void removeArticle(Collection collection, Item itemToRemove) throws SQLException, AuthorizeException
	{
		List<Item> items = getItems(collection);
		collection.clearMetadata(field.schema, field.element, field.qualifier, Item.ANY);
		for (Item item : items)
		{
			if (item.getID() == itemToRemove.getID()) continue;
			addArticle(collection, item);
		}
		collection.update();
	}

	/**
	 * Get a list of all collections in the repo.
	 * @return 
	 */
	private List<Collection> getAllCollections() throws SQLException
	{
		Collection[] collections = Collection.findAll(context);
		return Arrays.asList(collections);
	}
	
	/**
	 * Convert an ID string into an integer id and then find the collection the id points to.
	 * @param collectionIDStr
	 * @return 
	 */
	private Collection getCollectionFromIDStr(String collectionIDStr) throws SQLException
	{
		if (collectionIDStr == null || collectionIDStr.isEmpty()) return null;
		int collectionID;
		try
		{
			collectionID = Integer.parseInt(collectionIDStr);
		} catch(NumberFormatException ex)
		{
			return null;
		}
		return Collection.find(context, collectionID);
	}

	/**
	 * Read the featured articles metadata from collection and return a list of
	 * featured articles as items.
	 * @param collection
	 * @return 
	 */
	private List<Item> getItems(Collection collection) throws SQLException
	{
		Metadatum[] metadata = collection.getMetadataByMetadataString(FIELD_ARTICLES);
		List<Item> articles = new ArrayList<Item>();
		for (Metadatum metadatum : metadata)
		{
			Item item = getItemFromValue(metadatum.value);
			if (item == null) continue;
			articles.add(item);
		}
		return articles;
	}

	/**
	 * Given a handle url, find the item that the url is supposed to point to.
	 * @param url
	 * @return
	 * @throws IllegalStateException
	 * @throws SQLException 
	 */
	private Item getItemFromURL(String url) throws IllegalStateException, SQLException
	{
		URL parsedURL;
		try {
			parsedURL = new URL(url);
		} catch (MalformedURLException ex) {
			log.error(ex);
			return null;
		}
        String path = parsedURL.getPath();

		if (path == null || path.isEmpty()) return null;

		String handle = path.substring(path.indexOf("handle"));
		handle = handle.substring(handle.indexOf("/")+1);

		if (handle.isEmpty()) return null;
		return (Item) HandleManager.resolveToObject(context, handle);
	}

	/**
	 * Parse the raw string stored in the metadata and find the item it points to and return it.
	 * @param storedValue
	 * @return 
	 */
	private Item getItemFromValue(String storedValue) throws SQLException
	{
		if (storedValue == null || storedValue.isEmpty()) return null;
		String itemIDStr = storedValue.replace(HEADER, "");
		int itemID = Integer.parseInt(itemIDStr);
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
	
}
