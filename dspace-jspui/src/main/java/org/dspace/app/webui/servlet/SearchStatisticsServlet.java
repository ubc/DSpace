/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.util.List;
import java.sql.SQLException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.ServletException;
import org.dspace.authorize.AuthorizeException;

import org.apache.log4j.Logger;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.eperson.Group;

import org.dspace.content.DSpaceObject;
import org.dspace.handle.HandleManager;

import org.dspace.statistics.Dataset;
import org.dspace.statistics.content.DatasetSearchGenerator;
import org.dspace.statistics.content.DatasetTimeGenerator;
import org.dspace.statistics.content.StatisticsDataSearches;
import org.dspace.statistics.content.StatisticsDisplay;
import org.dspace.statistics.content.StatisticsListing;
import org.dspace.statistics.content.StatisticsTable;
import org.dspace.statistics.content.filter.StatisticsSolrDateFilter;

import org.dspace.app.webui.components.StatisticsBean;
import org.dspace.app.webui.util.JSPManager;

/**
 *
 * 
 * @author Kim Shepherd
 * @version $Revision: 4386 $
 */
public class SearchStatisticsServlet extends DSpaceServlet
{
    /** log4j logger */
    private static Logger log = Logger.getLogger(SearchStatisticsServlet.class);


    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        // is the statistics data publically viewable?
        boolean privatereport = ConfigurationManager.getBooleanProperty("usage-statistics", "authorization.admin.usage");

        // is the user a member of the Administrator (1) group?
        boolean admin = Group.isMember(context, 1);

        if (!privatereport || admin) {
            displayStatistics(context, request, response);
        }
        else {
            throw new AuthorizeException();
        }
    }


    protected void displayStatistics(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        DSpaceObject dso = null;
        String handle = request.getParameter("handle");

        if ("".equals(handle) || handle == null) {
            // We didn't get passed a handle parameter.
            // That means we're looking at /handle/*/*/statistics
            // with handle injected as attribute from HandleServlet
            handle = (String) request.getAttribute("handle");
        }

        if (handle != null) {
            dso = HandleManager.resolveToObject(context, handle);
        }

        displaySearchStats(dso, context, request, response);
    }


    private void displaySearchStats(DSpaceObject dso,
                                    Context context,
                                    HttpServletRequest request,
                                    HttpServletResponse response)
        throws ServletException, IOException, SQLException, AuthorizeException
    {
        StatisticsBean statsTerms = new StatisticsBean();

        try {
            // Handle the optional time filter
            StatisticsSolrDateFilter dateFilter = null;
            // TODO: read from the optional request parameter
            
            StatisticsTable statisticsTable = new StatisticsTable(
                new StatisticsDataSearches(dso));

            statisticsTable.setTitle("Search Statistics");
            statisticsTable.setId("list1");

            DatasetSearchGenerator queryGenerator = new DatasetSearchGenerator();
            queryGenerator.setType("query");
            queryGenerator.setMax(10);
            queryGenerator.setMode(DatasetSearchGenerator.Mode.SEARCH_OVERVIEW);
            queryGenerator.setPercentage(true);
            queryGenerator.setRetrievePageViews(true);
            statisticsTable.addDatasetGenerator(queryGenerator);

            if (dateFilter != null) {
                statisticsTable.addFilter(dateFilter);
            }
            statsTerms = makeStatisticsBean(context, statisticsTable);
        } catch (Exception e) {
            log.error(
                      "Error occurred while creating statistics for dso with ID: "
                      + dso.getID() + " and type " + dso.getType()
                      + " and handle: " + dso.getHandle(), e);
        }
        
        request.setAttribute("statsTerms", statsTerms);
        
        JSPManager.showJSP(request, response, "display-search-statistics.jsp");
    }

    private StatisticsBean makeStatisticsBean(Context context,
            StatisticsDisplay statisticsTable) throws Exception {
        Dataset dataset = statisticsTable.getDataset();

        if (dataset == null) {
            dataset = statisticsTable.getDataset(context);
        }

        StatisticsBean stats = new StatisticsBean();
        if (dataset != null) {
            String[][] matrix = dataset.getMatrix();
            List<String> colLabels = dataset.getColLabels();
            List<String> rowLabels = dataset.getRowLabels();

            stats.setMatrix(matrix);
            stats.setColLabels(colLabels);
            stats.setRowLabels(rowLabels);
        }
        return stats;
    }
}
