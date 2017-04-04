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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/video-example.jsp">Video Example</a> <span class="text-muted">&raquo;</span> <a href="/WV-ConfidenceIntervals.jsp">Web Visualization: Confidence Intervals of the Mean</a> <span class="text-muted">&raquo; What We Learned</span></p>

	<div class="row">  
	    <div class="col-md-8">
	    
		<h1>What We Learned</h1>
		<div class="row descriptions">
	       <div class="col-md-12">
               <p>Six students were selected to participate in a pilot study conducted on an introductory (200 level) statistics class in the Fall 2015 semester. The study was carried out to gather information about how students use the simulation and how it might be improved. Volunteers were exposed to two web visualizations, first the “Sampling from a Normally distributed population” and then the “Confidence intervals of the mean” web visualization, during 50-minute long interviews. Students were asked to “think-aloud” while exploring the applets. Pre-questions were provided about the topics prior to use of the simulation and more questions, taken from the NSF-funded Web ARTIST project, were given after exploration of the tool.</p>
               <p>After implementing changes to the two simulations based on feedback from the first set of interviews, a second set of interviews was conducted on a 300 level introductory stat course in January 2016. The same format as the first set was followed (pre-questions, “think-aloud” exploration, post questions) however students were given only one of the two applets to allow for more time during the interviews. Four students were selected to try the “Confidence intervals of the mean” web visualization.</p>
               <h3>Enhancements made to simulations based on feedback from the first set of interviews:</h3>
               <ul>
                   <li>Questions provided at the very beginning to frame the purpose of the tutorial reduced student confusion, and helped students focus on the important features of the tutorial.</li>
                   <li>Some students initially found the repeated sampling too slow and were confused about the sampling process, such as when they should stop sampling. Clearer instructions helped the sampling process hit the right balance in terms of speed and reduced confusion. There were no complaints about the repeated sampling during the second set of interviews, other than from one student.</li>
                   <ul>
                       <br><p>“The part that really didn’t work well is the creating repeated samples…otherwise we don’t know when to click on stop and worried and stuff…”’</p>
                       <p>“Kind of going on for too long. Should point out the stop button sooner. Kind of get the idea of what’s happening” </p>
                   </ul>
               </ul>
               <h3>Enhancements made to simulations based on feedback from the second set of interviews:</h3>
               <ul>
                   <li>Minor errors were fixed and cosmetic changes were made to the applet. For instance, one student mentioned the questions provided at the start of the tutorial to frame the purpose of the activity could be given as a list rather than a block of text.</li>
               </ul>
               <h3>General observations:</h3>
               <ul>
                   <li>Students liked the interactive, hands-on nature of visualizations. Most of the students commented that the simulation was good for visualizing the effect certain parameters or confidence level had on the width of the confidence intervals.</li>
                   <ul>
                       <br><p>“Cool. Never seen anything like it! Pretty straight forward. Like how fish changes to bar graph, sliders, drop down thing. … [Repeated Sampling Process] Really liked it. Good that they have slower and faster buttons.”</p>
                       <p>“Creating of all the samples is fun to watch…”</p>
                   </ul>
                   <li>	It is recommended that “Sampling from a Normally distributed population” web visualization be used as a primer for the Confidence interval web visualization. From our interviews, we found students who interacted with the Sampling from Normal simulation prior to the Confidence Interval web visualization had a better understanding of the context of these proceeding simulations (i.e. how the samples are drawn, what the population mean represents with respect to the example). Students using only the Confidence Interval applet during the second set of interviews requested more explanation about the population mean and standard deviation at the end of the tutorial. One student commented that they did not understand what μ represented with respect to the example suggesting they did not understand the basic premise of the simulation.</li>
                   <ul>
                       <br><p>“Confidence interval part was much more difficult than the sampling distribution of means… sampling distribution of means was more clear. Sampling distribution of means… there was more section of how sampling is really happening…. More instruction in the sampling part is helpful.”</p>
                   </ul>
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
			<h3 class="panel-title"><i class="glyphicon glyphicon-open"></i>&nbsp; Contribute materials</h3>
		    </div>
		    <div class="panel-body">
			<p>Easily share introductory statistics material&mdash;including <strong>copyright-cleared simulations, video, data sets</strong>, and more&mdash;with other educators and get meaningful feedback.</p>
		    </div>
		</div>
	      
		<div class="panel panel-info">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-comment"></i> &nbsp;Evaluate what you use</h3>
		    </div>
		    <div class="panel-body">
			<p>Evaluate the introductory statistics material in StatSpace by giving <strong>detailed private feedback</strong> for any resources you use, to help other educators improve their designs.</p>
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
		<a href="/register" class="btn btn-success btn-lg">Join</a> &nbsp;or&nbsp; <a href="/mydspace" class="btn btn-success btn-lg">Sign In</a>
	    </div>
	    
	</div>

    </div>

</dspace:layout>
