package org.dspace.app.webui.ubc.statspace;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.commons.lang.StringEscapeUtils;
import org.apache.log4j.Logger;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;

public class HardCodedContentServlet extends DSpaceServlet {
	private static Logger log = Logger.getLogger(HardCodedContentServlet.class);

	private static final Set<String> ACCEPTABLE_PATHS = new HashSet<String>(
		Arrays.asList(
			"/ConfInt_WhatWeLearned.jsp",
			"/LP-VideoCIs.jsp",
			"/LP-VideoOne-Sample-T-Test.jsp",
			"/SampNonNorm_WhatWeLearned.jsp",
			"/SampNorm_WhatWeLearned.jsp",
			"/WV-SamplingNon-Normal.jsp",
			"/WV-ChiSquarecontingencyanalysis.jsp",
			"/WV-ConfidenceIntervals.jsp",
			"/WebWork_Questions.jsp",
			"/about.jsp",
			"/copyright.jsp",
			"/iClicker-example.jsp",
			"/iClicker-example-2-ConfidenceIntervals.jsp",
			"/iClicker-example-3-Hypothesistesting.jsp",
			"/iClicker_question.jsp",
			"/iClicker_question-2-ConfidenceIntervals.jsp",
			"/iClicker_question-3-HypothesisTesting.jsp",
			"/sim-example.jsp",
			"/video-example.jsp",
			"/wwecon325h6additionalQ1.jsp",
			"/wwstat200revisedlinguisticsQ9.jsp",
			"/wwstat300hw6Q1.jsp"
		)
	);
			
    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
		String pathInfo = request.getPathInfo();
		// only serve recognized paths
		if (ACCEPTABLE_PATHS.contains(pathInfo))
			JSPManager.showJSP(request, response, "/ubc/statspace/hard-coded-demo" + pathInfo);
		JSPManager.showInvalidIDError(request, response, StringEscapeUtils.escapeHtml(pathInfo), -1);
	}
}