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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/sim-example.jsp">Simulation Example</a> <span class="text-muted">&raquo; What We Learned</span></p>

	<div class="row">  
	    <div class="col-md-8">
	    
		<h1>What We Learned</h1>
		<div class="row descriptions">
	       <div class="col-md-12">
               <p>Six students were selected to participate in a pilot study conducted on an introductory (200 level) statistics class in the Fall 2015 semester. The study was carried out to gather information about how students use the simulation and how it might be improved. Volunteers were exposed to two web visualizations, first the “Sampling from a Normally distributed population” and then the “Confidence intervals of the mean” web visualization during 50-minute long interviews. Students were asked to “think-aloud” while exploring the applets. Pre-questions were provided about the topics prior to use of the simulation and more questions, taken from the NSF-funded Web ARTIST project, were given after exploration of the tool.</p>
               <p>Six students were selected to participate in a pilot study conducted on an introductory (200 level) statistics class in the Fall 2015 semester. The study was carried out to gather information about how students use the simulation and how it might be improved. Volunteers were exposed to two web visualizations, first the “Sampling from a Normally distributed population” and then the “Confidence intervals of the mean” web visualization during 50-minute long interviews. Students were asked to “think-aloud” while exploring the applets. Pre-questions were provided about the topics prior to use of the simulation and more questions, taken from the NSF-funded Web ARTIST project, were given after exploration of the tool.</p>
               <h3>Enhancements made to simulations based on feedback from the first set of interviews:</h3>
               <ul>
                   <li>More description about the purpose of the applet provided at the start of the tutorial reduced student confusion, and helped students focus on the important features of the tutorial.</li>
                   <ul>
                       <br><p>"… initially I don’t know what the next steps so I’m just following and I don’t know what’s going on at first."</p>
                   </ul>
                   <li>Some students initially found the repeated sampling too slow and were confused about the sampling process, such as how many fish to sample. Clearer instructions helped the sampling hit the right balance in terms of speed and reduced confusion. There were no complaints about the repeated sampling during the second set of interviews, other than from one student.</li>
                   <ul>
                       <br><p>[When asked during the tutorial to make a sample of 10 individuals in total] “How many are we taking? Do we click on calculate mean here?”</p>
                       <p>“... I don’t know how many they want us to do… very confusing…”</p>
                       <p>“The process to add a button to calculate a lot of sample means at once could come a bit earlier.” [In reference to CALCULATE MANY MEANS button]</p>
                   </ul>
               </ul>
               <h3>Enhancements made to simulations based on feedback from the second set of interviews:</h3>
               <ul>
                   <li>Some terminology was adjusted as students did not understanding their meaning, for instance, the term “Calculate Many Means” was changed to “Means for Many Samples”.</li>
               </ul>
               <h3>General observations:</h3>
               <ul>
                   <li>The “Sampling from a Normally distributed population” simulation was effective in reinforcing some fundamental ideas about mean, standard deviation and histograms. All of the students interviewed commented in some way about how the simulation helped visualize the effect certain parameters had on the distribution. For instance, students liked to see how changing the population standard deviation or mean affected the resulting histogram. Visualizing each fish being measured then dropping down to create the histogram was especially helpful and made the concepts seem less abstract.</li>
                   <ul>
                       <br><p>“Intuitive. Shows how mean and standard deviation relate… Really helps to see how sample size affects the mean. Same with standard deviation.”</p>
                       <p>“Really useful. In class, that's what he [instructor] tried to explain. Not clear to me [at that time]. … Really good. Illustrated the points it was trying to make.”</p>
                   </ul>
                   <li>	It is recommended that “Sampling from a Normally distributed population” web visualization be used as a primer for the proceeding applets (Confidence intervals & CLT). From our interviews, we found students who interacted with the Sampling from Normal simulation prior to the CLT or Confidence Interval web visualization had a better understanding of the context of these proceeding simulations (i.e. how the samples are drawn, what the population mean represents with respect to the example). Students using only the Confidence Interval applet during the second set of interviews requested more explanation about the population mean and standard deviation at the end of the tutorial. One student commented that they did not understand what μ represented with respect to the example suggesting they did not understand the basic premise of the simulation.</li>
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
