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
	<p><a href="/">Home</a> <span class="text-muted">&raquo; WeBWork Questions</span></p>

	<div class="row">  
	    <div class="col-md-8">
	    
		<h1>WeBWorK Questions</h1>
		
		<div class="row description">
		    <div class="col-md-12">
			
			<i class="glyphicon glyphicon-sort-by-order data-icon pull-left"></i>
			
			<p class="intro-text">WeBWorK is a free on-line individualized assessment tool that provides students with automatic feedback on their work and is used at over 700 institutions globally. Faculty members at UBC have enhanced WeBWorK by incorporating R functionality and have created over 200 WeBWorK questions for use in introductory statistics courses.  All questions are available in WeBWorK's Open Problem Library. Details of a sample of these questions can be found here.</p>
			
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
		<h2>Prerequisite knowledge</h2>
		<p>TEXT FROM BRUCE THAT HE WILL SUPPLY WHEN HE SEES HOW THIS LOOKS ON STATSPACE</p>
		
		<h2>Learning Objectives</h2>
		<ul>
            <p>TEXT FROM BRUCE THAT HE WILL SUPPLY WHEN HE SEES HOW THIS LOOKS ON STATSPACE</p>
        </ul>
        <h3>About this resource</h3>
        <ul>
            <p>TEXT FROM BRUCE THAT HE WILL SUPPLY WHEN HE SEES HOW THIS LOOKS ON STATSPACE</p>
		</ul>
		
		<h2>Suggested uses</h2>
		<ul>
		    <li>TEXT FROM BRUCE THAT HE WILL SUPPLY WHEN HE SEES HOW THIS LOOKS ON STATSPACE</li>
		</ul>
            
		<h2>Complementary materials</h2>
        <p>For sample questions, please see the following.</p>
		<ul>
		    
            <li><a href="/wwecon325h6additionalQ1.jsp">WeBWorK Question ECON 325 HW6 additional Q1 <span class="glyphicon glyphicon-new-window"></span></a></li>
            <li><a href="/wwstat200revisedlinguisticsQ9.jsp">WeBWorK Question STAT 200 revised2016/Linguistics Question Q9 <span class="glyphicon glyphicon-new-window"></span></a></li>
            <li><a href="/wwstat300hw6Q1.jsp">WeBWorK Question STAT 300 HW6 Question Q1<span class="glyphicon glyphicon-new-window"></span></a></li>
		</ul>
	    </div>
	    
	    <div class="col-md-4 tags">
	    
		<div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
		    </div>
		    <div class="panel-body">
			<p><strong>DBsubject:</strong> Statistics<br>
			<strong>DBChapter:</strong> Hypothesis Testing<br>
			<strong>DBSection:</strong>One-way ANOVA</p>
		    </div>
		</div>
	      
		<div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-link"></i> Related materials</h3>
		    </div>
		    <div class="panel-body">
			<ul>
			    <li><a href="">Linked Title of External Resource <span class="glyphicon glyphicon-new-window"></span></a></li>
                <li><a href="">Linked Title of External Resource <span class="glyphicon glyphicon-new-window"></span></a></li>
                <li><a href="">Linked Title of External Resource <span class="glyphicon glyphicon-new-window"></span></a></li>
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
