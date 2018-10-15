/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.ubc;

import org.dspace.ubc.UBCAccessChecker;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.LinkedHashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.xml.transform.Transformer;
import javax.xml.transform.TransformerException;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.dspace.app.bulkedit.DSpaceCSV;
import org.dspace.app.bulkedit.MetadataExport;
import org.dspace.app.util.OpenSearch;
import org.dspace.app.util.SyndicationFeed;
import org.dspace.app.webui.discovery.DiscoverUtility;
import org.dspace.app.webui.search.SearchProcessorException;
import org.dspace.app.webui.search.SearchRequestProcessor;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.authorize.AuthorizeManager;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.content.ItemIterator;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.core.I18nUtil;
import org.dspace.core.LogManager;
import org.dspace.discovery.DiscoverQuery;
import org.dspace.discovery.DiscoverResult;
import org.dspace.discovery.SearchServiceException;
import org.dspace.discovery.SearchUtils;
import org.dspace.discovery.configuration.DiscoveryConfiguration;
import org.dspace.discovery.configuration.DiscoverySearchFilter;
import org.dspace.discovery.configuration.DiscoverySearchFilterFacet;
import org.dspace.discovery.configuration.DiscoverySortFieldConfiguration;
import org.dspace.app.webui.ubc.retriever.ItemRetriever;
import org.dspace.app.webui.ubc.statspace.SubjectEntry;
import org.dspace.app.webui.ubc.statspace.SubjectsTreeParser;
import org.dspace.app.webui.ubc.statspace.search.PaginationInfo;
import org.dspace.discovery.DiscoverResult.FacetResult;
import org.dspace.sort.SortOption;
import org.w3c.dom.Document;

public class UBCDiscoverySearchRequestProcessor implements SearchRequestProcessor
{
    private static final int ITEMMAP_RESULT_PAGE_SIZE = 50;

    private static String msgKey = "org.dspace.app.webui.servlet.FeedServlet";

    /** log4j category */
    private static Logger log = Logger.getLogger(UBCDiscoverySearchRequestProcessor.class);

    // locale-sensitive metadata labels
    private Map<String, Map<String, String>> localeLabels = null;

    private List<String> searchIndices = null;

	public static final int PAGINATION_RANGE = 3;
	public static final int MAX_RESULTS_PER_PAGE = 100;

	public static final String VIEW_TYPE_LIST = "list";
	public static final String VIEW_TYPE_TILE = "tile";

    
    public synchronized void init()
    {
        if (localeLabels == null)
        {
            localeLabels = new HashMap<String, Map<String, String>>();
        }
        
        if (searchIndices == null)
        {
            searchIndices = new ArrayList<String>();
            DiscoveryConfiguration discoveryConfiguration = SearchUtils
                    .getDiscoveryConfiguration();
            searchIndices.add("any");
            for (DiscoverySearchFilter sFilter : discoveryConfiguration.getSearchFilters())
            {
                searchIndices.add(sFilter.getIndexFieldName());
            }
        }
    }

    public void doOpenSearch(Context context, HttpServletRequest request,
            HttpServletResponse response) throws SearchProcessorException,
            IOException, ServletException
    {
        init();
        
        // dispense with simple service document requests
        String scope = request.getParameter("scope");
        if (scope != null && "".equals(scope))
        {
            scope = null;
        }
        String path = request.getPathInfo();
        if (path != null && path.endsWith("description.xml"))
        {
            String svcDescrip = OpenSearch.getDescription(scope);
            response.setContentType(OpenSearch
                    .getContentType("opensearchdescription"));
            response.setContentLength(svcDescrip.length());
            response.getWriter().write(svcDescrip);
            return;
        }

        // get enough request parameters to decide on action to take
        String format = request.getParameter("format");
        if (format == null || "".equals(format))
        {
            // default to atom
            format = "atom";
        }

        // do some sanity checking
        if (!OpenSearch.getFormats().contains(format))
        {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST);
            return;
        }

        // then the rest - we are processing the query
        DSpaceObject container;
        try
        {
            container = DiscoverUtility.getSearchScope(context,
                    request);
        }
        catch (Exception e)
        {
            throw new SearchProcessorException(e.getMessage(), e);
        }
        DiscoverQuery queryArgs = DiscoverUtility.getDiscoverQuery(context,
                request, container, false);
        String query = queryArgs.getQuery();

        // Perform the search
        DiscoverResult qResults = null;
        try
        {
            qResults = SearchUtils.getSearchService().search(context,
                    container, queryArgs);
        }
        catch (SearchServiceException e)
        {
            log.error(
                    LogManager.getHeader(context, "opensearch", "query="
                            + queryArgs.getQuery() + ",scope=" + scope
                            + ",error=" + e.getMessage()), e);
            throw new RuntimeException(e.getMessage(), e);
        }

        // Log
        log.info(LogManager.getHeader(context, "opensearch",
                "scope=" + scope + ",query=\"" + query + "\",results=("
                        + qResults.getTotalSearchResults() + ")"));

        // format and return results
        Map<String, String> labelMap = getLabels(request);
        DSpaceObject[] dsoResults = new DSpaceObject[qResults
                .getDspaceObjects().size()];
        qResults.getDspaceObjects().toArray(dsoResults);
        Document resultsDoc = OpenSearch.getResultsDoc(format, query,
                (int)qResults.getTotalSearchResults(), qResults.getStart(),
                qResults.getMaxResults(), container, dsoResults, labelMap);
        try
        {
            Transformer xf = TransformerFactory.newInstance().newTransformer();
            response.setContentType(OpenSearch.getContentType(format));
            xf.transform(new DOMSource(resultsDoc),
                    new StreamResult(response.getWriter()));
        }
        catch (TransformerException e)
        {
            log.error(e);
            throw new ServletException(e.toString());
        }
    }

    private Map<String, String> getLabels(HttpServletRequest request)
    {
        // Get access to the localized resource bundle
        Locale locale = UIUtil.getSessionLocale(request);
        Map<String, String> labelMap = localeLabels.get(locale.toString());
        if (labelMap == null)
        {
            labelMap = getLocaleLabels(locale);
            localeLabels.put(locale.toString(), labelMap);
        }
        return labelMap;
    }

    private Map<String, String> getLocaleLabels(Locale locale)
    {
        Map<String, String> labelMap = new HashMap<String, String>();
        labelMap.put(SyndicationFeed.MSG_UNTITLED, I18nUtil.getMessage(msgKey + ".notitle", locale));
        labelMap.put(SyndicationFeed.MSG_LOGO_TITLE, I18nUtil.getMessage(msgKey + ".logo.title", locale));
        labelMap.put(SyndicationFeed.MSG_FEED_DESCRIPTION, I18nUtil.getMessage(msgKey + ".general-feed.description", locale));
        labelMap.put(SyndicationFeed.MSG_UITYPE, SyndicationFeed.UITYPE_JSPUI);
        for (String selector : SyndicationFeed.getDescriptionSelectors())
        {
            labelMap.put("metadata." + selector, I18nUtil.getMessage(SyndicationFeed.MSG_METADATA + selector, locale));
        }
        return labelMap;
    }
    
    public void doSimpleSearch(Context context, HttpServletRequest request,
            HttpServletResponse response) throws SearchProcessorException,
            IOException, ServletException, UnsupportedEncodingException
    {
        Item[] resultsItems;
        Collection[] resultsCollections;
        Community[] resultsCommunities;
        DSpaceObject scope;
        try
        {
            scope = DiscoverUtility.getSearchScope(context, request);
        }
        catch (IllegalStateException e)
        {
            throw new SearchProcessorException(e.getMessage(), e);
        }
        catch (SQLException e)
        {
            throw new SearchProcessorException(e.getMessage(), e);
        }

        DiscoveryConfiguration discoveryConfiguration = SearchUtils
                .getDiscoveryConfiguration(scope);
        List<DiscoverySortFieldConfiguration> sortFields = discoveryConfiguration
                .getSearchSortConfiguration().getSortFields();
        List<String> sortOptions = new ArrayList<String>();
        for (DiscoverySortFieldConfiguration sortFieldConfiguration : sortFields)
        {
            String sortField = SearchUtils.getSearchService().toSortFieldIndex(
                    sortFieldConfiguration.getMetadataField(),
                    sortFieldConfiguration.getType());
            sortOptions.add(sortField);
        }
        request.setAttribute("sortOptions", sortOptions);
        
        DiscoverQuery queryArgs = DiscoverUtility.getDiscoverQuery(context,
                request, scope, true);

        queryArgs.setSpellCheck(discoveryConfiguration.isSpellCheckEnabled()); 
        
        List<DiscoverySearchFilterFacet> availableFacet = discoveryConfiguration
                .getSidebarFacets();
        
        request.setAttribute("facetsConfig",
                availableFacet != null ? availableFacet
                        : new ArrayList<DiscoverySearchFilterFacet>());
        int etal = UIUtil.getIntParameter(request, "etal");
        if (etal == -1)
        {
            etal = ConfigurationManager
                    .getIntProperty("webui.itemlist.author-limit");
        }

        request.setAttribute("etal", etal);

        String query = queryArgs.getQuery();
		if (query == null) query = "";
        request.setAttribute("query", query);
        request.setAttribute("queryArgs", queryArgs);
        List<DiscoverySearchFilter> availableFilters = discoveryConfiguration
                .getSearchFilters();
        request.setAttribute("availableFilters", availableFilters);

        List<String[]> appliedFilters = DiscoverUtility.getFilters(request);
        request.setAttribute("appliedFilters", appliedFilters);
        List<String> appliedFilterQueries = new ArrayList<String>();
        for (String[] filter : appliedFilters)
        {
            appliedFilterQueries.add(filter[0] + "::" + filter[1] + "::"
                    + filter[2]);
        }
        request.setAttribute("appliedFilterQueries", appliedFilterQueries);
        List<DSpaceObject> scopes = new ArrayList<DSpaceObject>();
        if (scope == null)
        {
            Community[] topCommunities;
            try
            {
                topCommunities = Community.findAllTop(context);
            }
            catch (SQLException e)
            {
                throw new SearchProcessorException(e.getMessage(), e);
            }
            for (Community com : topCommunities)
            {
                scopes.add(com);
            }
        }
        else
        {
            try
            {
                DSpaceObject pDso = scope.getParentObject();
                while (pDso != null)
                {
                    // add to the available scopes in reverse order
                    scopes.add(0, pDso);
                    pDso = pDso.getParentObject();
                }
                scopes.add(scope);
                if (scope instanceof Community)
                {
                    Community[] comms = ((Community) scope).getSubcommunities();
                    for (Community com : comms)
                    {
                        scopes.add(com);
                    }
                    Collection[] colls = ((Community) scope).getCollections();
                    for (Collection col : colls)
                    {
                        scopes.add(col);
                    }
                }
            }
            catch (SQLException e)
            {
                throw new SearchProcessorException(e.getMessage(), e);
            }
        }
        request.setAttribute("scope", scope);
        request.setAttribute("scopes", scopes);

		// Exclude instructor only items if user doesn't have access
		try {
			UBCAccessChecker accessChecker = new UBCAccessChecker(context);
			if (!accessChecker.hasRestrictedAccess()) {
				String newFilterQuery = SearchUtils.getSearchService()
						.toFilterQuery(context, "accessRights", "notcontains",
								UBCAccessChecker.ACCESS_RESTRICTED)
						.getFilterQuery();
				queryArgs.addFilterQueries(newFilterQuery);
			}
		} catch (SQLException ex) {
			log.error(ex);
		}

        // Perform the search
        DiscoverResult qResults = null;
        try
        {
            qResults = SearchUtils.getSearchService().search(context, scope,
                    queryArgs);
            
            List<Community> resultsListComm = new ArrayList<Community>();
            List<Collection> resultsListColl = new ArrayList<Collection>();
            List<Item> resultsListItem = new ArrayList<Item>();

            for (DSpaceObject dso : qResults.getDspaceObjects())
            {
                if (dso instanceof Item)
                {
                    resultsListItem.add((Item) dso);
                }
                else if (dso instanceof Collection)
                {
                    resultsListColl.add((Collection) dso);

                }
                else if (dso instanceof Community)
                {
                    resultsListComm.add((Community) dso);
                }
            }

            // Make objects from the handles - make arrays, fill them out
            resultsCommunities = new Community[resultsListComm.size()];
            resultsCollections = new Collection[resultsListColl.size()];
            resultsItems = new Item[resultsListItem.size()];

            resultsCommunities = resultsListComm.toArray(resultsCommunities);
            resultsCollections = resultsListColl.toArray(resultsCollections);
            resultsItems = resultsListItem.toArray(resultsItems);

            // Log
            log.info(LogManager.getHeader(context, "search", "scope=" + scope
                    + ",query=\"" + query + "\",results=("
                    + resultsCommunities.length + ","
                    + resultsCollections.length + "," + resultsItems.length
                    + ")"));

            // Pass in some page qualities
            // total number of pages
            long pageTotal = 1 + ((qResults.getTotalSearchResults() - 1) / qResults
                    .getMaxResults());

            // current page being displayed
            long pageCurrent = 1 + (qResults.getStart() / qResults
                    .getMaxResults());

            // pageLast = min(pageCurrent+3,pageTotal)
            long pageLast = ((pageCurrent + PAGINATION_RANGE) > pageTotal) ? pageTotal
                    : (pageCurrent + PAGINATION_RANGE);

            // pageFirst = max(1,pageCurrent-PAGINATION_RANGE)
            long pageFirst = ((pageCurrent - PAGINATION_RANGE) > 1) ? (pageCurrent - PAGINATION_RANGE) : 1;

            // Pass the results to the display JSP
            request.setAttribute("items", resultsItems);
            request.setAttribute("communities", resultsCommunities);
            request.setAttribute("collections", resultsCollections);

            request.setAttribute("pagetotal", new Long(pageTotal));
            request.setAttribute("pagecurrent", new Long(pageCurrent));
            request.setAttribute("pagelast", new Long(pageLast));
            request.setAttribute("pagefirst", new Long(pageFirst));
            request.setAttribute("spellcheck", qResults.getSpellCheckQuery());
            
            request.setAttribute("queryresults", qResults);

            try
            {
                if (AuthorizeManager.isAdmin(context))
                {
                    // Set a variable to create admin buttons
                    request.setAttribute("admin_button", new Boolean(true));
                }
            }
            catch (SQLException e)
            {
                throw new SearchProcessorException(e.getMessage(), e);            }

            if ("submit_export_metadata".equals(UIUtil.getSubmitButton(request,
                    "submit")))
            {
                exportMetadata(context, response, resultsItems);
            }






			// new simple search params
			// items
			List<ItemRetriever> results = new ArrayList<ItemRetriever>();
			for (Item item : resultsItems)
			{
				ItemRetriever retriever = new ItemRetriever(context, request, item);
				results.add(retriever);
			}
			// pagination
			request.setAttribute("numResults", qResults.getTotalSearchResults());
			request.setAttribute("results", results);
			request.setAttribute("queryStr", query);

			String searchScope = scope!=null?scope.getHandle():"";
			setPaginationAttributes(request, searchScope, appliedFilters, queryArgs, qResults);

			// params for 'sorted by' dropdown
			String sortedBy = queryArgs.getSortField();
			request.setAttribute("sortedBy", sortedBy);
			// sort order
			String sortOrder = queryArgs.getSortOrder().toString();
			boolean isSortedAscending = SortOption.ASCENDING.equalsIgnoreCase(sortOrder);
			request.setAttribute("sortOrder", sortOrder);
			request.setAttribute("isSortedAscending", isSortedAscending);
			// advanced filters
			setAdvancedFilterAttributes(request, availableFilters);
			// request filters
			setResultFilterAttributes(request, availableFacet, qResults, appliedFilterQueries);
			// autocomplete for filters
			String autocompleteURL = "/json/discovery/autocomplete?query="+ URLEncoder.encode(query,"UTF-8") + getFiltersAsURLParams(appliedFilters).replaceAll("&amp;","&");
			request.setAttribute("autocompleteURL", autocompleteURL);
			request.setAttribute("searchScope", searchScope);
			// whether we should be in list view or tile view
			String viewType = getViewType(request);
			request.setAttribute("viewType", viewType);

			// params for 'results per page' dropdown
			List<Integer> resultsPerPageOptions = new ArrayList<Integer>();
			int defaultRpp = (new DiscoveryConfiguration()).getDefaultRpp();
			for (int i = defaultRpp; i <= MAX_RESULTS_PER_PAGE; i += defaultRpp)
			{
				resultsPerPageOptions.add(i);
			}
			request.setAttribute("resultsPerPageOptions", resultsPerPageOptions);
			request.setAttribute("resultsPerPage", queryArgs.getMaxResults());

        }
        catch (SearchServiceException e)
        {
            log.error(
                    LogManager.getHeader(context, "search", "query="
                            + queryArgs.getQuery() + ",scope=" + scope
                            + ",error=" + e.getMessage()), e);
            request.setAttribute("search.error", true);
            request.setAttribute("search.error.message", e.getMessage());
        } catch (SQLException e) {
            log.error(
                    LogManager.getHeader(context, "search", "query="
                            + queryArgs.getQuery() + ",scope=" + scope
                            + ",error=" + e.getMessage()), e);
            request.setAttribute("search.error", true);
            request.setAttribute("search.error.message", e.getMessage());
		}

        //JSPManager.showJSP(request, response, "/search/discovery.jsp");
		request.setAttribute("context", context);
		JSPManager.showJSP(request, response, "/ubc/statspace/simple-search.jsp");
    }

	/**
	 * Set attributes required for search filters.
	 * @param request
	 * @param availableFilters 
	 */
	private void setAdvancedFilterAttributes(HttpServletRequest request, List<DiscoverySearchFilter> availableFilters)
	{
		List<String> filterNameOptions = new ArrayList<String>();
		for (DiscoverySearchFilter filter : availableFilters)
		{
			filterNameOptions.add(filter.getIndexFieldName());
		}

		List<String> filterTypeOptions = new ArrayList<String>(Arrays.asList(
			//"contains","equals","authority","notequals","notcontains","notauthority"
			"equals","contains","notequals","notcontains"
		));

		request.setAttribute("filterNameOptions", filterNameOptions);
		request.setAttribute("filterTypeOptions", filterTypeOptions);
	}

	/**
	 * Set attributes needed to render the sidebar results filter.
	 * @param request
	 * @param facetsConf
	 * @param qResults
	 * @param appliedFilterQueries 
	 */
	private void setResultFilterAttributes(HttpServletRequest request, List<DiscoverySearchFilterFacet> facetsConf, DiscoverResult qResults, List<String> appliedFilterQueries)
	{
		if (facetsConf == null) return;
		if (qResults == null) return;
		Map<String, List<FacetResult>> facetNameToResults = new LinkedHashMap<String, List<FacetResult>>();
		Map<String, Boolean> appliedFiltersMap = new HashMap<String, Boolean>();
			
		for (DiscoverySearchFilterFacet facetConf : facetsConf)
		{
			String facetName = facetConf.getIndexFieldName();
			List<FacetResult> facetResults = qResults.getFacetResult(facetName);
			// guessing weird workaround for some stupid behaviour around year?! idk, so not touching it.
			if (facetResults.size() == 0)
			{
				facetResults = qResults.getFacetResult(facetName+".year");
				if (facetResults.size() == 0) continue;
			}
			// there's options available for filtering, make it available to the jsp
			facetNameToResults.put(facetName, facetResults);
			// find out what filters are currently in use, so we can hide them
			for (FacetResult fvalue : facetResults)
			{ 
				String filterKey = facetName+"::"+fvalue.getFilterType()+"::"+fvalue.getAsFilterQuery();
				if(appliedFilterQueries.contains(filterKey))
				{
					appliedFiltersMap.put(filterKey, Boolean.TRUE);
				}
			}
			// statspace subject tree display needs additional parameters
			if (facetName.equals("subject")) {
				List<String> subjects = new ArrayList<String>();
				Map<String, FacetResult> subjectToFacetResults = new HashMap<String, FacetResult>();
				for (FacetResult result : facetResults)
				{
					subjects.add(result.getDisplayedValue());
					subjectToFacetResults.put(result.getDisplayedValue(), result);
				}
				SubjectsTreeParser subjectsTreeParser = new SubjectsTreeParser(subjects);
				List<SubjectEntry> subjectsTree = subjectsTreeParser.getDepthFirstFlatTree();
				request.setAttribute("filterResultsSubjects", subjectsTree);
				request.setAttribute("filterResultsSubjectToFacetResults", subjectToFacetResults);
			}
		}
		request.setAttribute("facetNameToResults", facetNameToResults);
		request.setAttribute("appliedFiltersMap", appliedFiltersMap);
	}

	/**
	 * Configure the parameters required to generate the pagination controls.
	 * @param request
	 * @param scope
	 * @param appliedFilters
	 * @param qArgs
	 * @param qResults
	 * @param pageCurrent - page user is currently on
	 * @param pageTotal - total number of pages
	 * @param pageFirst - we only show a sliding range to the user, this is the smallest page number we'll show to the user
	 * @param pageLast - we only show a sliding range to the user, this is the largest page number we'll show to the user
	 * @throws UnsupportedEncodingException 
	 */
	private void setPaginationAttributes(HttpServletRequest request, String searchScope, List<String[]> appliedFilters,
			DiscoverQuery qArgs, DiscoverResult qResults)
		throws UnsupportedEncodingException
	{
		// total number of pages
		long pageTotal = 1 + ((qResults.getTotalSearchResults() - 1) / qResults.getMaxResults());
		// current page being displayed
		long pageCurrent = 1 + (qResults.getStart() / qResults.getMaxResults());
		// pageLast = min(pageCurrent+3,pageTotal)
		long pageRangeEnd = ((pageCurrent + PAGINATION_RANGE) > pageTotal) ? pageTotal : (pageCurrent + PAGINATION_RANGE);
		// pageFirst = max(1,pageCurrent-PAGINATION_RANGE)
		long pageRangeStart = ((pageCurrent - PAGINATION_RANGE) > 1) ? (pageCurrent - PAGINATION_RANGE) : 1;

		String query = qArgs.getQuery();
		if (query == null) query = "";
		int rpp          = qArgs.getMaxResults();
		int etAl         = ((Integer) request.getAttribute("etal")).intValue();
		String sortedBy = qArgs.getSortField();
		String order = qArgs.getSortOrder().toString();
		String httpFilters = getFiltersAsURLParams(appliedFilters);
		String viewType = getViewType(request);

		// create the URLs accessing the previous and next search result pages
		String baseURL =  request.getContextPath()
				+ (!searchScope.equals("") ? "/handle/" + searchScope : "")
				+ "/simple-search?query="
				+ URLEncoder.encode(query,"UTF-8")
				+ httpFilters
				+ "&amp;sort_by=" + sortedBy
				+ "&amp;order=" + order
				+ "&amp;rpp=" + rpp
				+ "&amp;etal=" + etAl
				+ "&amp;viewType=" + viewType
				+ "&amp;start=";
		
		// previous page from current
		String prevURL = baseURL
				+ (pageCurrent-2) * qResults.getMaxResults();
		// next page from current
		String nextURL = baseURL
				+ (pageCurrent) * qResults.getMaxResults();
		// page 1, note this is NOT the firstPage param passed in, as that might not be page 1
		String firstURL = baseURL +"0";
		// very last page, note this is NOT the lastPage param passed in, as lagePage can be a smaller page number
		String lastURL = baseURL + (pageTotal-1) * qResults.getMaxResults();
		// one page beyond lastPage
		String skipForwardURL = baseURL + (pageRangeEnd) * qResults.getMaxResults();
		// one page behind firstPage
		String skipBackURL = baseURL + (pageRangeStart - 2) * qResults.getMaxResults();

		PaginationInfo paginationInfo = new PaginationInfo();
		paginationInfo.setBaseURL(baseURL);
		paginationInfo.setFirstPageURL(firstURL);
		paginationInfo.setLastPageURL(lastURL);
		paginationInfo.setNextPageURL(nextURL);
		paginationInfo.setPreviousPageURL(prevURL);
		paginationInfo.setSkipForwardURL(skipForwardURL);
		paginationInfo.setSkipBackURL(skipBackURL);
		paginationInfo.setMultiplier(qResults.getMaxResults());
		paginationInfo.setPageCurrent(pageCurrent);
		paginationInfo.setPageTotal(pageTotal);
		paginationInfo.setPageRangeStart(pageRangeStart);
		paginationInfo.setPageRangeEnd(pageRangeEnd);
		request.setAttribute("pagination", paginationInfo);
	}

	/**
	 * Get the string that indicates whether user is in list view or tile view.
	 * @param request
	 * @return 
	 */
	private String getViewType(HttpServletRequest request) {
		String viewType = request.getParameter("viewType");
		if (viewType != null && viewType.equalsIgnoreCase(VIEW_TYPE_TILE))
			viewType = VIEW_TYPE_TILE;
		else
			viewType = VIEW_TYPE_LIST;
		return viewType;
	}

	/**
	 * For encoding the currently applied search filters into url params.
	 * @param appliedFilters
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	private String getFiltersAsURLParams(List<String[]> appliedFilters) throws UnsupportedEncodingException {
		String httpFilters = "";
		if (appliedFilters != null && appliedFilters.size() >0 )
		{
			int idx = 1;
			for (String[] filter : appliedFilters)
			{
				httpFilters += "&amp;filtername="+URLEncoder.encode(filter[0],"UTF-8");
				httpFilters += "&amp;filtertype="+URLEncoder.encode(filter[1],"UTF-8");
				httpFilters += "&amp;filterquery="+URLEncoder.encode(filter[2],"UTF-8");
				idx++;
			}
		}
		return httpFilters;
	}

    /**
     * Export the search results as a csv file
     * 
     * @param context
     *            The DSpace context
     * @param response
     *            The request object
     * @param items
     *            The result items
     * @throws IOException
     * @throws ServletException
     */
    protected void exportMetadata(Context context,
            HttpServletResponse response, Item[] items) throws IOException,
            ServletException
    {
        // Log the attempt
        log.info(LogManager.getHeader(context, "metadataexport",
                "exporting_search"));

        // Export a search view
        ArrayList iids = new ArrayList();
        for (Item item : items)
        {
            iids.add(item.getID());
        }
        ItemIterator ii = new ItemIterator(context, iids);
        MetadataExport exporter = new MetadataExport(context, ii, false);

        // Perform the export
        DSpaceCSV csv = exporter.export();

        // Return the csv file
        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition",
                "attachment; filename=search-results.csv");
        PrintWriter out = response.getWriter();
        out.write(csv.toString());
        out.flush();
        out.close();
        log.info(LogManager.getHeader(context, "metadataexport",
                "exported_file:search-results.csv"));
        return;
    }

    /**
     * Method for constructing the discovery advanced search form
     * 
     * author: Andrea Bollini
     */
    @Override
    public void doAdvancedSearch(Context context, HttpServletRequest request,
            HttpServletResponse response) throws SearchProcessorException,
            IOException, ServletException
            {
                // just redirect to the simple search servlet.
                // The advanced form is always displayed with Discovery togheter with
                // the search result
                // the first access to the advanced form performs a search for
                // "anythings" (SOLR *:*)
                response.sendRedirect(request.getContextPath() + "/simple-search");
            }

    /**
     * Method for searching authors in item map
     * 
     * author: gam
     */
    @Override
    public void doItemMapSearch(Context context, HttpServletRequest request,
            HttpServletResponse response) throws SearchProcessorException, ServletException, IOException
    {
        String queryString = (String) request.getParameter("query");
        Collection collection = (Collection) request.getAttribute("collection");
        int page = UIUtil.getIntParameter(request, "page")-1;
        int offset = page > 0? page * ITEMMAP_RESULT_PAGE_SIZE:0;
        String idx = (String) request.getParameter("index");
        if (StringUtils.isNotBlank(idx) && !idx.equalsIgnoreCase("any"))
        {
            queryString = idx + ":(" + queryString + ")";
        }
        DiscoverQuery query = new DiscoverQuery();
        query.setQuery(queryString);
        query.addFilterQueries("-location:l"+collection.getID());
        query.setMaxResults(ITEMMAP_RESULT_PAGE_SIZE);
        query.setStart(offset);

        DiscoverResult results = null;
        try
        {
            results = SearchUtils.getSearchService().search(context, query);
        }
        catch (SearchServiceException e)
        {
            throw new SearchProcessorException(e.getMessage(), e);
        }

        Map<Integer, Item> items = new HashMap<Integer, Item>();

        List<DSpaceObject> resultDSOs = results.getDspaceObjects();
        for (DSpaceObject dso : resultDSOs)
        {
            if (dso != null && dso.getType() == Constants.ITEM)
            {
                // no authorization check is required as discovery is right aware
                Item item = (Item) dso;
                items.put(Integer.valueOf(item.getID()), item);
            }
        }

        request.setAttribute("browsetext", queryString);
        request.setAttribute("items", items);
        request.setAttribute("more", results.getTotalSearchResults() > offset + ITEMMAP_RESULT_PAGE_SIZE);
        request.setAttribute("browsetype", "Add");
        request.setAttribute("page", page > 0 ? page + 1 : 1);
        
        JSPManager.showJSP(request, response, "itemmap-browse.jsp");
    }
    
    @Override
    public String getI18NKeyPrefix()
    {
        return "jsp.search.filter.";
    }
    
    @Override
    public List<String> getSearchIndices()
    {
        init();
        return searchIndices;
    }
}
