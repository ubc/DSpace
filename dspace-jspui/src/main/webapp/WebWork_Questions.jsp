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
	    
		<h1>Winning Numbers History: Florida lottery data through the years</h1>
		<p class="text-muted contributors">Contributor(s): <a href="mailto:">Jane Doe</a>, <a href="mailto:">John Doe</a></p>
		
		<div class="row description">
		    <div class="col-md-12">
			
			<i class="glyphicon glyphicon-sort-by-order data-icon pull-left"></i>
			
			<p class="intro-text">This data set contains the winning numbers from the Florida Lottery (through the end of 2008), as reported by the state lottery commission. Note that from its inception through 23 October 1999, the lottery was "pick 6 of 49." Thereafter, it was a "pick 6 of 53" lottery.</p>
			
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
		<p>These are the type of instructors who should use this material (disciplines this may apply to) and what kind of knowledge the instructors should already have in order to use this material well. </p>
		
		<h2>Learning outcomes</h2>
		<ul>
		    <li>An expected learning outcome of using this material in the classroom listed here. This is more information about the expected outcome.</li>
		    <li>A second expected learning outcome of using this material in the classroom listed here. This is more information about the alternative expected outcome.</li>
		</ul>
		
		<h2>Suggested uses</h2>
		<ul>
		    <li>One way to use this effectively in the classroom would be to use the suggestion listed here. This is more information about this suggestion.</li>
		    <li>Another suggestion of how to use this effectively in the classroom would be to use the idea listed here. This is more information about this suggestion.</li>
		</ul>
		
		<h2>Complementary materials</h2>
		<ul>
		    
            <li><a href="/wwecon325h6additionalQ1.jsp">WeBWorK Question ECON 325 HW6 additional Q1 <span class="glyphicon glyphicon-new-window"></span></a></li>
            <li><a href="/wwstat200revisedlinguisticsQ9.jsp">WeBWorK Question STAT 200 revised2016/Linguistics Question Q9 <span class="glyphicon glyphicon-new-window"></span></a></li>
            <li><a href="/wwstat300hw6Q1.jsp">WeBWorK Question STAT 300 HW6 Question Q1 <span class="glyphicon glyphicon-new-window"></span></a></li>
		</ul>
	    </div>
	    
	    <div class="col-md-4 tags">
	    
		<div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
		    </div>
		    <div class="panel-body">
			<p><strong>Assessment Method:</strong> Method Type<br>
			<strong>Topics:</strong> Topic One, Topic Two, Topic Three<br>
			<strong>Keywords:</strong> Keyword 1, Keyword 2, Keyword 3</p>
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
