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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/sim-example.jsp">Simulation Example</a> <span class="text-muted">&raquo; Web Visualization: Confidence Intervals of the Mean</span></p>

	<div class="row">  
	    <div class="col-md-8">
	    
		<h1>Web Visualization: Confidence intervals of the mean</h1>
		
		<div class="row description">
		    <div class="col-md-12">
			<img class="pull-left zoology-fish" src="http://www.zoology.ubc.ca/~whitlock/kingfisher/Common/Images/fish.svg" width="220">
			
			<p class="intro-text">This video gives students a brief and simplified overview of statistics. This resource is especially useful for those outside of math-heavy disciplines to get a high-level understanding of statistics without the overwhelm typically associated introductory videos.</p>
			
			<p class="text-center access-btn"><a class="btn btn-success btn-md" href="http://www.zoology.ubc.ca/~whitlock/kingfisher/CIMean.htm">Access Resource</a></p>
		  
		    </div>
		</div> 
	    
	    </div>
	    
	    <div class="col-md-4 value-prop">
	    
		<div class="panel panel-info">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-stats"></i> About StatSpace</h3>
		    </div>
		    <div class="panel-body">
			<p>StatSpace brings together vetted open education materials for use across disciplines. Members of our community can <strong>search and use materials</strong> in the repository, <strong>contribute materials</strong> of their own, and <strong>evaluate materials</strong> they use.</p>
			<label>Search StatSpace now:</label>
			<%-- Search Box --%>
			<form method="get" action="<%= request.getContextPath() %>/simple-search">
			    <div class="input-group">
				<input type="text" class="form-control" placeholder="Enter keywords" name="query" id="tequery"/>
				<span class="input-group-btn">
				    <button type="submit" class="btn btn-primary">
					<span class="glyphicon glyphicon-search"></span>
				    </button>
				</span>
			    </div>
			</form>		
		    </div>
		</div>
	    
	    </div>			
	</div>
	
    <div class="row featured-items">
        <h2>Check out more Web Visualizations:</h2>
	    <div class="col-md-4 text-center">
		<div class="thumbnail">
		    <img src="http://www.zoology.ubc.ca/~whitlock/Kingfisher/Common/Images/coffee.svg" class="sim-image" width="162" height="180" align="center">
		    <div class="caption">
			<h5>Web visualization: Sampling from a non-Normally distributed population (CLT)</h5>
			<p class="text-left"><strong>Topics:</strong> <br>&bull; Probability - Laws, Theory - Central Limit Theorem <br>&bull; Sampling distributions - Sample mean</p> 
			<p class="see-more"><a href="/WV-SamplingNon-Normal.jsp" class="btn btn-primary">Read more &raquo;</a></p>
		    </div>
		</div>
	    </div>
	    
	    <div class="col-md-4 text-center">
		<div class="thumbnail">
		    <img src="image/contingency_analysis_image.jpg" class="sim-image" width="250">
		    <div class="caption">
			<h5>Web Visualization: Chi-square contingency analysis</h5>
			<p class="text-left"><strong>Topics:</strong> <br>&bull; Hypothesis tests - Goodness of fit - Chi-squared test for independence</p> 
			<p class="see-more"><a href="/WV-ChiSquarecontingencyanalysis.jsp" class="btn btn-primary">Read more &raquo;</a></p>
		    </div>     
		</div>
	    </div>
	    <div class="col-md-4 text-center">
		<div class="thumbnail">
		    <img src="http://www.zoology.ubc.ca/~whitlock/kingfisher/Common/Images/fish.svg" class="sim-image" width="250">
		    <div class="caption">
			<h5>Web Visualization: Sampling from a Normal distribution</h5>
			<p class="text-left"><strong>Topics:</strong> <br>&bull; Sampling distributions - Sample mean <br>&bull; Exploratory data analysis/Classifying data - Graphical representations - Histograms</p> 
			<p class="see-more"><a href="/sim-example.jsp" class="btn btn-primary">Read more &raquo;</a></p>
		    </div>     
		</div>
	    </div>
	</div>
        
	<div class="row">
	    <div class="col-md-12">
		<div class="divider"></div>
	    </div>
	</div>
	
	<div class="row details">
	    <div class="col-md-8">
		<h2>Prerequisite Knowledge</h2>
		<p>Students using this visualization should</p>
        <ul>
            <li>be familiar with methods of summarizing data sets, such as mean and standard deviation;</li>
            <li>identify and distinguish between a population and a sample, and between parameters and statistics.</li> 
        </ul>    
        <h2>Learning Objectives</h2>
		<ul>
            <li>Interpret a confidence interval and confidence level
            <li>Identify features that determine the width of a confidence interval
		</ul>
		
		<h2>Suggested use(s) and tips</h2>
            <p>These apps are intended to be used in a number of ways</p>
		<ul>
            <li>as a visual aid during lectures;</li>
            <li>as an open-ended learning tool for active learning;</li>
            <li>as a guided learning experience, using either the built-in tutorials or the guided <a href="/WV-ConfidenceIntervals.jsp">activity sheet <span class="glyphicon glyphicon-new-window"></span></a> or other instructor-supplied material.</li>
    	</ul>
		
		<h2>Complementary materials</h2>
		<ul>
            <li><a href="/LP-VideoCIs.jsp">Video: Confidence intervals for the mean <span class="glyphicon glyphicon-new-window"></span></a></li>
            <li>Activity: Understanding confidence intervals</li>
		</ul>
            
        <h2>About this Resource</h2>
		<ul>
            <p>
            <strong>Funding&colon; </strong>University of British Columbia <br>
            <strong>Project Leader&colon; </strong>Mike Whitlock<br>
            <strong>Programmers&colon; </strong>Boris Dalstein, Mike Whitlock &amp; Zahraa Almasslawi<br>
            <strong>Art&colon; </strong>Derek Tan<br>
            <strong>Translation&colon; </strong>Rémi Matthey-Doret<br>
            <strong>Testing&colon; </strong>Melissa Lee, Gaitri Yapa &amp; Bruce Dunham<br>
            <strong>Thanks to&colon; </strong>Darren Irwin, Dolph Schluter, Nancy Heckman, Kaylee Byers, Brandon Doty, Kim Gilbert, Sally Otto, Wilson Whitlock, Jeff Whitlock, Jeremy Draghi, Karon MacLean, Fred Cutler, Diana Whistler, Andrew Owen, Mike Marin, Leslie Burkholder, Eugenia Yu, Doug Bonn, Michael Scott, the UBC Physics Learning Group &amp; the UBC Flex Stats initiative for numerous suggestions and improvements.<br>
            </p>
           
		</ul>    
	    </div>
	    
	    <div class="col-md-4 tags">
	    
		<div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
		    </div>
		    <div class="panel-body">
			<p>
			<strong>Topics:</strong><br>&bull; Confidence intervals - One sample mean t
            </p>
		    </div>
		</div>
	      
		<div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-link"></i> Related materials</h3>
		    </div>
		    <div class="panel-body">
			<ul>
			    <li><a href="http://www.cwsei.ubc.ca/resources/files/Demo_WorkshopSummary_CWSEI-EOY2015.pdf">“Making the most of demonstrations, videos, animations, or simulations in lectures and laboratories” J. Maxwell and J. Stang <span class="glyphicon glyphicon-new-window"></span></a></li>
		      </ul>
		    </div>
		</div>
	    
        <div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-book"></i> What we learned</h3>
		    </div>
		    <div class="panel-body">
                <p>Students often have trouble interpreting confidence intervals and often have some misconceptions. For instance, many students believe, for the same data and parameter of interest, a 90% confidence interval is wider than a 95% confidence interval.<br><a target="_blank" href="/ConfInt_WhatWeLearned.jsp">Read More <span class="glyphicon glyphicon-new-window"></span></a></p>
		    </div>
		</div>     
            
	    </div>	
	</div>
	
	<div class="row text-center">
	    <div class="col-md-12">
		<h4 class="more-heading">To see more resources:</h4>
		<a href="/register" class="btn btn-success btn-lg">Join</a> &nbsp;or&nbsp; <a href="/mydspace" class="btn btn-success btn-lg">Sign In</a>
	    </div>
	    
	</div>

    </div>

</dspace:layout>
