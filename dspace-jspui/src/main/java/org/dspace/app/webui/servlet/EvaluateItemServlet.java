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

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Evaluation;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.eperson.EPerson;

/**
 * Servlet for handling editing user profiles
 * 
 * @author Robert Tansley
 * @version $Revision$
 */
public class EvaluateItemServlet extends DSpaceServlet
{
    /** Logger */
    private static final Logger log = Logger.getLogger(EvaluateItemServlet.class);

    @Override
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        doDSPost(context, request, response);
    }

    @Override
    protected void doDSPost(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        log.info(LogManager.getHeader(context, "evaluate_item", 
                request.getParameter("item_id")));

        // get the values out of the request
        int itemId = UIUtil.getIntParameter(request, "item_id");
        Item item = Item.find(context, itemId);

    	String buttonPressed = UIUtil.getSubmitButton(request, "submit_evaluate");
    	
    	if (buttonPressed.equals("submit")) {
            processEvaluation(context, request, response, item);
        }
        else if (buttonPressed.equals("submit_view")) {
            viewEvaluation(context, request, response);
        }
        else {
            showEvaluationForm(request, response, item);
        }
     }
    
    
    private void showEvaluationForm(HttpServletRequest request,
            HttpServletResponse response, Item item) 
        throws ServletException, IOException, SQLException, AuthorizeException
    {
        request.setAttribute("item", item);
        JSPManager.showJSP(request, response, "/mydspace/evaluate-item.jsp");
    }
    
    
    private void viewEvaluation(Context context,
            HttpServletRequest request,
            HttpServletResponse response)
        throws ServletException, IOException, SQLException, AuthorizeException
    {
        // get the values out of the request
        int evaluationId = UIUtil.getIntParameter(request, "evaluation_id");
        Evaluation evaluation = Evaluation.find(context, evaluationId);

        request.setAttribute("evaluation", evaluation);
        JSPManager.showJSP(request, response, "/display-evaluation.jsp");
    }
    
    
    private void processEvaluation(Context context, HttpServletRequest request,
            HttpServletResponse response, Item item)
        throws ServletException, IOException, SQLException, AuthorizeException
    {
        // Get the user - authentication should have happened
        EPerson eperson = context.getCurrentUser();

        String evaluation = request.getParameter("item-evaluation");
        
        if (request.getParameter("submit") != null && !StringUtils.isEmpty(evaluation)) {
            // record submission
            Evaluation.create(context, eperson, item, evaluation);
            
            log.info(LogManager.getHeader(context, "evaluate_item", "completed"));
            
            // Show confirmation
            JSPManager.showJSP(request, response, "/mydspace/task-complete.jsp");

            context.complete();
        }
        else {
            log.info(LogManager.getHeader(context, "evaluate_item", "incomplete"));

            request.setAttribute("incomplete", Boolean.TRUE);
            showEvaluationForm(request, response, item);
        }
    }
}
