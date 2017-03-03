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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/sim-example.jsp">Simulation Example</a> <span class="text-muted">&raquo; Web Visualization: Sampling from a non-Normally Distributed Population(CLT)</span></p>

	<div class="row">  
	    <div class="col-md-8">
	    
		<h1>Web Visualization: Sampling from a non-Normally distributed population (CLT)</h1>
		<p class="text-muted contributors">Contributor(s): <a href="mailto:">Jane Doe</a>, <a href="mailto:">John Doe</a></p>
		
		<div class="row description">
		    <div class="col-md-12">
			<iframe class="pull-left fake-video" src="https://player.vimeo.com/video/196470101?byline=0&portrait=0" width="300" height="169" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
			
			<p class="intro-text">This video gives students a brief and simplified overview of statistics. This resource is especially useful for those outside of math-heavy disciplines to get a high-level understanding of statistics without the overwhelm typically associated introductory videos.</p>
			
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
            <li>Be familiar with methods of summarizing data sets, such as mean and standard deviation</li>
            <li>Be able to recognize probability models as distributions with shape, centre, and spread</li>
            <li>Be able to recall the key properties of the Normal model</li>
            <li>Be able to distinguish between a population and a sample, and between parameters and statistics</li>
        </ul>
		<h2>Learning outcomes</h2>
		<ul>
            <li>Describe properties of the sampling distribution of the sample mean in general situations, using the Central Limit Theorem</li>
            <li>For the sample mean, explain whether and how the population distribution and the sample size influence the sampling distribution of the sample mean</li>
		</ul>
		
		<h2>Suggested uses</h2>
            <p>These apps are intended to be used in a number of ways&colon;</p>
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
            <li>Video&colon; <a href="https://vimeo.com/196027417">Sampling Distribution of the Mean<span class="glyphicon glyphicon-new-window"></span></a></li>
            <li>Activity: Introducint the sampling distribution (French protest)</li>
            <li>It is recommended that the “Sampling from a Normal distribution” app be used first to introduce some of the basic concepts and the visual metaphors used in the CLT app.</li>
            <ul>
                <li><a href="http://www.zoology.ubc.ca/~whitlock/kingfisher/SamplingNormal.htm">Web visualization: Sampling from a Normally distributed population <span class="glyphicon glyphicon-new-window"></span></a></li>
            </ul>
		</ul>
	    </div>
	    
	    <div class="col-md-4 tags">
	    
		<div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
		    </div>
		    <div class="panel-body">
			<p><strong>Assessment Method:</strong> Method Type<br>
			<strong>Topics:</strong> Central Limit Theorem, sampling distribution of the sample mean<br>
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
            
        <div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-book"></i> What we learned</h3>
		    </div>
		    <div class="panel-body">
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
