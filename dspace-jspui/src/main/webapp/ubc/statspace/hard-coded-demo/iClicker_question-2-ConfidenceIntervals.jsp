<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - About page JSP
  -
  - Attributes:
  -    ?
  --%>

<%@page import="org.dspace.core.Utils"%>
<%@page import="org.dspace.content.Bitstream"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>

<%
    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }
%>

<dspace:layout locbar="nolink" titlekey="jsp.about.title" feedData="<%= feedData %>">

    <div class="example">
		<p><a href="<c:url value='/home.jsp'/>">Home</a> <span class="text-muted">&raquo;</span> <a href="<c:url value='/demo/iClicker-example-2-ConfidenceIntervals.jsp'/>">Interactive engagement (clicker) questions: Confidence intervals for means</a> <span class="text-muted">&raquo; Sample Question: Confidence intervals for means</span></p>

        <div class="row">  
            <div class="col-md-8">
                <div class="col-md-12">
                    <div class="row">
                        <h2>Sample Question</h2>
                        <p>A news article reported the following: “The poll of 500 Canadians using random-digit dialling of both mobile phones and land lines gave a mean expenditure on holiday shopping of 652 dollars.  The numbers are considered accurate plus or minus 169 dollars, 19 times out of 20.”</p>
                    </div> 
                    <div class="row">
                        <p>Which of the following is/are correct?
                        </p><br><br><br>
                        <ul>
                            <p>
                                <b>A&colon; The 95% confidence interval for the true mean expenditure on holiday shopping by Canadians is (483,    821) dollars.</b><br>
                                B&colon; Based on the confidence interval, one can conclude that it is unusual for a Canadian to spend over $1000 on holiday shopping.  <br>
                                C&colon; 95% of Canadians spend between $483 and $821 on holiday shopping. <br>
                                D&colon; Both (A) and (B).<br>
                                E&colon; Both (A) and (C).<br>
                            </p>    
                        </ul>
                    </div> 
                </div>	
            </div> 


            <div class="col-md-4 value-prop">

            </div>

            <div class="row">
                <div class="col-md-12">
                    <div class="divider"></div>
                </div>
            </div>

            <div class="row">
                <p><b>Explanation&colon;</b><br><br> 
                        (A) &colon; The confidence interval has a margin of error of 169 dollars. The phrase "19 times out of 20" implies a 95% confidence level. Hence, the 95% confidence interval based on the poll results is given by 652 +-169, i.e. (482,821) dollars<br>
                        (B)&colon; This statement is incorrect because a confidence interval is used to estimate the true mean expenditure and it does not tell how the expenditures of the individual Canadians are distributed. We are unable to infer if the value $1000 is unusual in the expenditure distribution.<br>
                        (C)&colon; This is an incorrect statement. As indicated in the explanation for (B), the confidence interval does not give information on the expenditure distribution of all Canadians.<br>
                </p>
            </div> 

        </div>

    </dspace:layout>
