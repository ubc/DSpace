/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.text.MessageFormat;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.ResourceBundle;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.dspace.app.util.SyndicationFeed;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.authorize.AuthorizeManager;
import org.dspace.browse.BrowseEngine;
import org.dspace.browse.BrowseException;
import org.dspace.browse.BrowseIndex;
import org.dspace.browse.BrowseInfo;
import org.dspace.browse.BrowserScope;
import org.dspace.sort.SortOption;
import org.dspace.sort.SortException;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DCDate;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.handle.HandleManager;
import org.dspace.search.Harvest;
import org.dspace.eperson.Group;

import com.sun.syndication.io.FeedException;

/**
 * Servlet for handling requests for a syndication feed. The Handle of the collection
 * or community is extracted from the URL, e.g: <code>/feed/rss_1.0/1234/5678</code>.
 * Currently supports only RSS feed formats.
 * 
 * @author Ben Bosman, Richard Rodgers
 * @version $Revision$
 */
public class FeedServlet extends DSpaceServlet
{
	//	key for site-wide feed
	public static final String SITE_FEED_KEY = "site";
	
	// one hour in milliseconds
	private static final long HOUR_MSECS = 60 * 60 * 1000;
    /** log4j category */
    private static Logger log = Logger.getLogger(FeedServlet.class);
    private String clazz = "org.dspace.app.webui.servlet.FeedServlet";

    
    // are syndication feeds enabled?
    private static boolean enabled = false;
    // number of DSpace items per feed
    private static int itemCount = 0;
    // optional cache of feeds
    private static Map<String, CacheFeed> feedCache = null;
    // maximum size of cache - 0 means caching disabled
    private static int cacheSize = 0;
    // how many days to keep a feed in cache before checking currency
    private static int cacheAge = 0;
    // supported syndication formats
    private static List<String> formats = null;
    // Whether to include private items or not
    private static boolean includeAll = true;
    
    static
    {
    	enabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");

        // read rest of config info if enabled
        if (enabled)
        {
            String fmtsStr = ConfigurationManager.getProperty("webui.feed.formats");
            if ( fmtsStr != null )
            {
                formats = new ArrayList<String>();
                String[] fmts = fmtsStr.split(",");
                for (int i = 0; i < fmts.length; i++)
                {
                    formats.add(fmts[i]);
                }
            }

            itemCount = ConfigurationManager.getIntProperty("webui.feed.items");
            cacheSize = ConfigurationManager.getIntProperty("webui.feed.cache.size");
            if (cacheSize > 0)
            {
                feedCache = new HashMap<String, CacheFeed>();
                cacheAge = ConfigurationManager.getIntProperty("webui.feed.cache.age");
            }
        }
    }
    
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
	{
        includeAll = ConfigurationManager.getBooleanProperty("harvest.includerestricted.rss", true);
        String path = request.getPathInfo();
        String feedType = null;
        String handle = null;

        // build label map from localized Messages resource bundle
            Locale locale = request.getLocale();
        ResourceBundle msgs = ResourceBundle.getBundle("Messages", locale);
        Map<String, String> labelMap = new HashMap<String, String>();
        labelMap.put(SyndicationFeed.MSG_UNTITLED, msgs.getString(clazz + ".notitle"));
        labelMap.put(SyndicationFeed.MSG_LOGO_TITLE, msgs.getString(clazz + ".logo.title"));
        labelMap.put(SyndicationFeed.MSG_FEED_DESCRIPTION, msgs.getString(clazz + ".general-feed.description"));
        labelMap.put(SyndicationFeed.MSG_UITYPE, SyndicationFeed.UITYPE_JSPUI);
        for (String selector : SyndicationFeed.getDescriptionSelectors())
        {
            labelMap.put("metadata." + selector, msgs.getString(SyndicationFeed.MSG_METADATA + selector));
        }
        
        if (path != null)
        {
            // substring(1) is to remove initial '/'
            path = path.substring(1);
            int split = path.indexOf('/');
            if (split != -1)
            {
            	feedType = path.substring(0,split);
            	handle = path.substring(split+1);
            }
        }

        DSpaceObject dso = null;
        
        //as long as this is not a site wide feed, 
        //attempt to retrieve the Collection or Community object
        if(handle != null && !handle.equals(SITE_FEED_KEY))
        { 	
        	// Determine if handle is a valid reference
        	dso = HandleManager.resolveToObject(context, handle);
                if (dso == null)
                {
                    log.info(LogManager.getHeader(context, "invalid_handle", "path=" + path));
                    JSPManager.showInvalidIDError(request, response, handle, -1);
                    return;
        }
        }
        
        if (! enabled || (dso != null && 
        	(dso.getType() != Constants.COLLECTION && dso.getType() != Constants.COMMUNITY)) )
        {
            log.info(LogManager.getHeader(context, "invalid_id", "path=" + path));
            JSPManager.showInvalidIDError(request, response, path, -1);
            return;
        }
        
        // Determine if requested format is supported
        if( feedType == null || ! formats.contains( feedType ) )
        {
            log.info(LogManager.getHeader(context, "invalid_syndformat", "path=" + path));
            JSPManager.showInvalidIDError(request, response, path, -1);
            return;
        }
        
        if (dso != null &&  dso.getType() == Constants.COLLECTION)
        {
            labelMap.put(SyndicationFeed.MSG_FEED_TITLE,
                MessageFormat.format(msgs.getString(clazz + ".feed.title"),
                                     new Object[]{ msgs.getString(clazz + ".feed-type.collection"),
                                                   ((Collection)dso).getMetadata("short_description")}));
        }
        else if (dso != null &&  dso.getType() == Constants.COMMUNITY)
        {
            labelMap.put(SyndicationFeed.MSG_FEED_TITLE,
                MessageFormat.format(msgs.getString(clazz + ".feed.title"),
                                     new Object[]{ msgs.getString(clazz + ".feed-type.community"),
                                                   ((Community)dso).getMetadata("short_description")}));
        }

        // Lookup or generate the feed
        // Cache key is handle + locale
        String cacheKey = (handle==null?"site":handle)+"."+locale.toString();
        SyndicationFeed feed = null;
        if (feedCache != null)
        {
                CacheFeed cFeed = feedCache.get(cacheKey);
        	if (cFeed != null)  // cache hit, but...
        	{
        		// Is the feed current?
        		boolean cacheFeedCurrent = false;
        		if (cFeed.timeStamp + (cacheAge * HOUR_MSECS) < System.currentTimeMillis())
        		{
        			cacheFeedCurrent = true;
        		}
        		// Not current, but have any items changed since feed was created/last checked?
        		else if ( ! itemsChanged(context, dso, cFeed.timeStamp))
        		{
        			// no items have changed, re-stamp feed and use it
          			cFeed.timeStamp = System.currentTimeMillis();
          			cacheFeedCurrent = true;
        		}
        		if (cacheFeedCurrent)
        		{
                                feed = cFeed.access();
        		}
        	}
        }
        
        // either not caching, not found in cache, or feed in cache not current
        if (feed == null)
        {
                feed = new SyndicationFeed(SyndicationFeed.UITYPE_JSPUI);
                feed.populate(request, dso, getItems(context, dso), labelMap);
        	if (feedCache != null)
        	{
                        cache(cacheKey, new CacheFeed(feed));
        	}
        }
        
        // set the feed to the requested type & return it
        try
        {
                feed.setType(feedType);
        	response.setContentType("text/xml; charset=UTF-8");
                feed.output(response.getWriter());
        }
        catch( FeedException fex )
        {
        	throw new IOException(fex.getMessage(), fex);
        }
    }
       
    private boolean itemsChanged(Context context, DSpaceObject dso, long timeStamp)
            throws SQLException
    {
        // construct start and end dates
        DCDate dcStartDate = new DCDate( new Date(timeStamp) );
        DCDate dcEndDate = new DCDate( new Date(System.currentTimeMillis()) );

        // convert dates to ISO 8601, stripping the time
        String startDate = dcStartDate.toString().substring(0, 10);
        String endDate = dcEndDate.toString().substring(0, 10);
        
        // this invocation should return a non-empty list if even 1 item has changed
        try {
            return (Harvest.harvest(context, dso, startDate, endDate,
        		                0, 1, !includeAll, false, false, includeAll).size() > 0);
        }
        catch (ParseException pe)
        {
        	// This should never get thrown as we have generated the dates ourselves
        	return false;
        }
    }
    
    // returns recently changed items, checking for accessibility
    private Item[] getItems(Context context, DSpaceObject dso)
    		throws IOException, SQLException
    {
    	try
    	{
    		// new method of doing the browse:
    		String idx = ConfigurationManager.getProperty("recent.submissions.sort-option");
    		if (idx == null)
    		{
    			throw new IOException("There is no configuration supplied for: recent.submissions.sort-option");
    		}
    		BrowseIndex bix = BrowseIndex.getItemBrowseIndex();
    		if (bix == null)
    		{
    			throw new IOException("There is no browse index with the name: " + idx);
    		}
    		
    		BrowserScope scope = new BrowserScope(context);
    		scope.setBrowseIndex(bix);
                if (dso != null)
                {
                    scope.setBrowseContainer(dso);
                }

            for (SortOption so : SortOption.getSortOptions())
            {
                if (so.getName().equals(idx))
                {
                    scope.setSortBy(so.getNumber());
                }
            }
            scope.setOrder(SortOption.DESCENDING);
    		scope.setResultsPerPage(itemCount);
    		
            // gather & add items to the feed.
    		BrowseEngine be = new BrowseEngine(context);
    		BrowseInfo bi = be.browseMini(scope);
    		Item[] results = bi.getItemResults(context);

            if (includeAll)
            {
                return results;
            }
            else
                {
                    // Check to see if we can include this item
                //Group[] authorizedGroups = AuthorizeManager.getAuthorizedGroups(context, results[i], Constants.READ);
                //boolean added = false;
                List<Item> items = new ArrayList<Item>();
                for (Item result : results)
                    {
                checkAccess:
                    for (Group group : AuthorizeManager.getAuthorizedGroups(context, result, Constants.READ))
                        {
                        if ((group.getID() == Group.ANONYMOUS_ID))
                        {
                            items.add(result);
                            break checkAccess;
                        }
                    }
                }
                return items.toArray(new Item[items.size()]);
                }
            }
        catch (SortException se)
        {
            log.error("caught exception: ", se);
            throw new IOException(se.getMessage(), se);
        }
    	catch (BrowseException e)
    	{
    		log.error("caught exception: ", e);
    		throw new IOException(e.getMessage(), e);
    	}
    }
    
    /************************************************
     * private cache management classes and methods *
     ************************************************/
     
	/**
     * Add a feed to the cache - reducing the size of the cache by 1 to make room if
     * necessary. The removed entry has an access count equal to the minumum in the cache.
     * @param feedKey
     *            The cache key for the feed
     * @param newFeed
     *            The CacheFeed feed to be cached
     */ 
    private static void cache(String feedKey, CacheFeed newFeed)
    {
		// remove older feed to make room if cache full
		if (feedCache.size() >= cacheSize)
		{
	    	// cache profiling data
	    	int total = 0;
	    	String minKey = null;
	    	CacheFeed minFeed = null;
	    	CacheFeed maxFeed = null;
	    	
	    	Iterator<String> iter = feedCache.keySet().iterator();
	    	while (iter.hasNext())
	    	{
	    		String key = iter.next();
	    		CacheFeed feed = feedCache.get(key);
	    		if (minKey != null)
	    		{
	    			if (feed.hits < minFeed.hits)
	    			{
	    				minKey = key;
	    				minFeed = feed;
	    			}
	    			if (feed.hits >= maxFeed.hits)
	    			{
	    				maxFeed = feed;
	    			}
	    		}
	    		else
	    		{
	    			minKey = key;
	    			minFeed = feed;
                    maxFeed = feed;
	    		}
	    		total += feed.hits;
	    	}
	    	// log a profile of the cache to assist administrator in tuning it
	    	int avg = total / feedCache.size();
	    	String logMsg = "feedCache() - size: " + feedCache.size() +
	    	                " Hits - total: " + total + " avg: " + avg +
	    	                " max: " + maxFeed.hits + " min: " + minFeed.hits;
	    	log.info(logMsg);
	    	// remove minimum hits entry
	    	feedCache.remove(minKey);
		}
    	// add feed to cache
		feedCache.put(feedKey, newFeed);
    }
        
    /**
     * Class to instrument accesses & currency of a given feed in cache
     */  
    private static class CacheFeed
	{
    	// currency timestamp
    	public long timeStamp = 0L;
    	// access count
    	public int hits = 0;
    	// the feed
        private SyndicationFeed feed = null;
    	
        public CacheFeed(SyndicationFeed feed)
    	{
    		this.feed = feed;
    		timeStamp = System.currentTimeMillis();
    	}
    	    	
        public SyndicationFeed access()
    	{
    		++hits;
    		return feed;
    	}
	}
}
