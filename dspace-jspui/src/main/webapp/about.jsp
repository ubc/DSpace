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

    <div class="row landing-page">  
	<div class="col-md-8">
		
	    <h1>About StatSpace</h1>
	    
	    <p>StatSpace brings together open, vetted and adaptable resources for teaching and learning introductory statistics.  StatSpace also provides suggestions for use including teaching pitfalls and how students use and misuse resources.</p>
	    
	    <p>StatSpace grew out of the University of British Columbia Statistics Department’s goal of improving cross-campus introductory statistics education.  At UBC, as in many universities, introductory statistics is taught not only in the Statistics Department but also in other units, as a complete course or as a component of a domain area course to provide in-context learning.  Some instructors are experts in statistics, in statistics education and in their domain area of application.  Other instructors are not.  And many instructors work alone in their units.  The Statistics Department believes in the importance of a cross-campus community for collaboration in teaching introductory statistics, to sharing teaching resources, experiences and best practices.  Such collaboration improves statistics instruction, reduces isolation and saves instructors’ from re-inventing the wheel.   As part of its vision, in 2008 the Department founded the cross-unit Introductory Statistics Discussion Group.  Members of this group received UBC funding in 2014 and became the Flexible Learning Introductory Statistics (FLIS) project team.</p>
        
        <p>FLIS is led by a team of experienced statistics instructors, with homes in five different departments in three different faculties.   These instructors have student audiences ranging from second year statistics majors to third year political science majors to first year medical students.  The team has been challenged by the diversity of approaches and terminology.  But this diversity has enriched the project, forcing members to focus on the core statistical concepts that bridge all disciplines and to produce material that is truly cross-disciplinary and accessible to students of a variety of levels and interests.   The project team chose to focus on concepts rather than computations starting with the concept of sampling variability, which is fundamental to all of statistical inference.</p>
        
        <p>All materials were vetted through team discussion informed by our own experiences and by the education literature -  especially the statistics education literature (when it existed!).  Many of the resources were also vetted by students through interviews, through focus groups and through trialing in a range of courses.  With each resource on StatSpace we’ve included comments on what we’ve found out about how students learn.</p>
	</div>
    <div class="col-md-4 intro-sidebar">
	    
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
	    
	    </div>
    </div>

</dspace:layout>
