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
	<p><a href="/">Home</a> <span class="text-muted">&raquo; Copyright Resources</span></p>

	<div class="row">  
	    <div class="col-md-8">
	    
		<h1>Copyright Resources</h1>
		<div class="row descriptions">
	       <div class="col-md-12">
		      <h2>Curating</h2>
		      <p>These are the links for copyright resources regarding curating: </p>
		      <ul>
                  <li>Copyright &amp; Permissions&colon; <a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Copyright_Permissions/Curated_Content">Copyright and Curated Content in Open Education Resource Repositories<span class="glyphicon glyphicon-new-window"></span></a></li>
                  <li>Finding &amp; Using Open Education Resources&colon; <a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Curating/Finding">Finding Open Education Resources<span class="glyphicon glyphicon-new-window"></span></a></li>
		          <li>Assessing &amp; Using Open Education Resources&colon; <a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Curating/Assessing">Assessing Open Education Resources<span class="glyphicon glyphicon-new-window"></span></a></li>
		      </ul>
		
		      <h2>Creating</h2>
              <p>These are the links for copyright resources regarding creating</p>
		      <ul>
		          <li>Copyright &amp; Permissions&colon; <a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Copyright_Permissions/Self_Created_Content">Self-Created Content for Open Education Repositories<span class="glyphicon glyphicon-new-window"></span></a></li>
                  <li>Copyright &amp; Permissions&colon; <a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Copyright_Permissions/Seeking_Permission">Seeking Permission for Copyright Content<span class="glyphicon glyphicon-new-window"></span></a></li>
		          <li>Finding &amp; Using Open Education Resources&colon; <a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Curating/Define">What are Open Education Resources<span class="glyphicon glyphicon-new-window"></span></a></li>
		      </ul>
	       </div>	
	   </div>
		</div> 
	    
	    
	    <div class="col-md-4 value-prop">
            
        <div class="panel panel-info">
		    <div class="panel-heading">
			<h3 class="panel-title">
				<i class="glyphicon glyphicon-search"></i>&nbsp; Search for materials
			</h3>
		    </div>
		    <div class="panel-body">
			<p>Search our high-quality archive of <strong>100+ curated introductory statistics materials</strong>.</p>
			<label>Search StatSpace now:</label>
			<%-- Search Box --%>
			<form method="get" action="<%= request.getContextPath() %>/SearchError.jsp">
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
            
        <div class="panel panel-info">
		    <div class="panel-heading">
                <h3 class="panel-title"><a href="/register"><i class="glyphicon glyphicon-open"></i>&nbsp; Contribute materials</a></h3>
		    </div>
		    <div class="panel-body">
			<p>Easily share introductory statistics material&mdash;including <strong>copyright-cleared simulations, video, data sets</strong>, and more&mdash;with other educators and get meaningful feedback.</p>
		    </div>
		</div>
	      
		<div class="panel panel-info">
		    <div class="panel-heading">
                <h3 class="panel-title"><a href="/register"><i class="glyphicon glyphicon-comment"></i> &nbsp;Evaluate what you use</a></h3>
		    </div>
		    <div class="panel-body">
			<p>Evaluate the introductory statistics material in StatSpace by giving <strong>detailed private feedback</strong> for any resources you use, to help other educators improve their designs.</p>
		    </div>
		</div>
            
        <div class="panel panel-info" >
            <div class="panel-heading">
                <h3 class="panel-title"><a href="https://survey.ubc.ca/s/statspace/"><i class="glyphicon glyphicon-open"></i>&nbsp;Survey</a></h3>
            </div>
            <div class="panel-body">
                <p>When you have explored StatSpace, we would appreciate your opinion, via a brief <a href="https://survey.ubc.ca/s/statspace/">survey</a>.<span class="glyphicon glyphicon-new-window"></span></p>
            </div>
        </div>    
	    
	    </div>			
	</div>
	
	<div class="row">
	    <div class="col-md-12">
		<div class="divider"></div>
	    </div>
	</div>
	
	
	
	<div class="row text-center">
	    <div class="col-md-12">
		<h4 class="more-heading">To see more resources:</h4>
		<a href="https://survey.ubc.ca/surveys/37-ebe7b07545dc43f1e9090f86433/statspace-user-analytics/" class="btn btn-success btn-lg">Join</a><!-- &nbsp;or&nbsp; <a href="/mydspace" class="btn btn-success btn-lg">Sign In</a>-->
	    </div>
	    
	</div>

    </div>

</dspace:layout>
