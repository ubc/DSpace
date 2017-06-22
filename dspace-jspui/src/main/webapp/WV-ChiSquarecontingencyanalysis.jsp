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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/video-example.jsp">Video Example</a> <span class="text-muted">&raquo; Web Visualization: Chi-square contingency analysis</span></p>

	<div class="row">  
	    <div class="col-md-8">
	    
		<h1>Web Visualization: Chi-square contingency analysis</h1>
		<p class="text-muted contributors">Contributor(s): <a href="mailto:">Jane Doe</a>, <a href="mailto:">John Doe</a></p>
		
		<div class="row description">
		    <div class="col-md-12">

					
			<p class="text-center access-btn"><a class="btn btn-success btn-md">Access Resource</a></p>
		  
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
	
	<div class="row">
	    <div class="col-md-12">
		<div class="divider"></div>
	    </div>
	</div>
	
	<div class="row details">
	    <div class="col-md-8">
		<h2>Intended audience</h2>
		<p>Students using this visualization should&colon;</p>
        <ul>
            <li>recognize when a contingency table is an appropriate way to summarize a data set;</li>
            <li>identify and distinguish between a population and a sample, and between parameters and statistics;</li>
            <li>explain the concepts of sampling variability and sampling distribution.</li>
        </ul>    
        <h2>Learning outcomes</h2>
		<ul>
            <li>Investigate the chi-squared test for independence between categorical variables,including the sampling distribution of the test statistic.</li>
            <li>Interpret the meaning of the P-value associated with a contingency analysis.</li>
            <li>Explain the two types of error possible and the power of a hypothesis test.</li>
            <li>Investigate the effects of the sample size and population parameters on the power of the chi-squared test.</li>
		</ul>
		
		<h2>Suggested uses</h2>
            <p>These resources are intended to be used in a number of ways&colon;</p>
		<ul>
            <li>As a visual aid during lectures</li>
            <li>As an open-ended learning tool for active learning</li>
            <li>As a guided learning experience, using either the built-in tutorials or an instructor-written set of instructions.</li>
            <ul>
                <li><i>Bruce's Assignment Questions</i></li>
            </ul>

		</ul>
		
		<h2>Complementary materials</h2>
		<ul>
            <li>Webwork Questions&colon; </li>
            <li>iClicker Questions&colon; </li>
            
           
		</ul>
            
        <h2>About this Resource</h2>
		<ul>
            <p>
            <strong>Funding </strong>University of British Columbia <br>
            <strong>Project Leader </strong>Mike Whitlock<br>
            <strong>Programmers </strong>Boris Dalstein, Mike Whitlock, Zahraa Almasslawi<br>
            <strong>Art </strong>Derek Tan<br>
            <strong>Translation </strong>Rémi Matthey-Doret<br>
            <strong>Testing </strong>Melissa Lee, Gaitri Yapa, Bruce Dunham<br>
            <strong>Thanks to </strong>Darren Irwin, Dolph Schluter, Nancy Heckman, Kaylee Byers, Brandon Doty, Kim Gilbert, Sally Otto, Wilson Whitlock, Jeff Whitlock, Jeremy Draghi, Karon MacLean, Fred Cutler, Diana Whistler, Andrew Owen, Mike Marin, Leslie Burkholder, Eugenia Yu, Doug Bonn, Michael Scott, the UBC Physics Learning Group, and the UBC Flex Stats initiative for numerous suggestions and improvements.<br>
            </p>
           
		</ul>    
	    </div>
	    
	    <div class="col-md-4 tags">
	    
		<div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
		    </div>
		    <div class="panel-body">
			<p><strong>Assessment Method:</strong> Method Type<br>
			<strong>Topics:</strong> Hypothesis tests,Goodness-of-fit, Chi-squared test for independence<br>
			<strong>Keywords:</strong> Keyword 1, Keyword 2, Keyword 3</p>
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
