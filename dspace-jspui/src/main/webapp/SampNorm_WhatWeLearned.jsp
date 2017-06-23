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
               <p>The sampling distribution is a complex concept.  For instance, from our teaching, we have found that students often confuse the histogram of values from a random sample and the histogram of sample means from many random samples.  They often confuse the sample standard deviation and the standard error of the mean.  This visualization was carefully designed to reduce that confusion.</p>
               
               <p>Comments about what we learn from trialing the resource&colon;</p>
               <ul>
                   <li>Students benefit from some description of the purpose of the animation at the start of the tutorial.  When we inserted a description, we found students could more easily focus on the important features of the tutorial.  Without the description, some students were confused  (<i>“… initially I don’t know what the next steps so I’m just following and I don’t know what’s going on at first.”</i>). The description is now a part of the tutorial.</li>
                   
                   <li>Students need clear instructions in order to take repeated samples, with language carefully chosen.  To help students, we dropped our terminology “calculate many means” and instead used “calculate means for many samples”.</li>
                   
                   <li>In the tutorial, when students repeatedly sample one individual to form a random sample of size 10, the countdown of the number of fish left to be sampled appears.  This reinforces the idea that the students are creating one sample of 10 fish.</li>
                   
                   <li>In the tutorial, students are asked to repeatedly take a sample of size 10 and calculate the mean, with each sample mean dropping down to the histogram of the sampling distribution.  After students have had sufficient time to understand the difference between the top and bottom histograms, they can use the “means for many samples” button, to speed up the activity.</li>
                   
                   <li>The “Sampling from a Normally distributed population” simulation was effective in reinforcing some fundamental ideas about mean, standard deviation and histograms. All of the students interviewed commented in some way about how the simulation helped visualize the effect certain parameters had on the distribution. For instance, students liked to see how changing the population standard deviation or mean affected the resulting histogram. Visualizing each fish being measured then dropping down to create the histogram was especially helpful and made the concepts seem less abstract.</li>
                   <ul>
                       <p><i><b>“Intuitive. Shows how mean and standard deviation relate… Really helps to see how sample size affects the mean. Same with standard deviation.”</b></i></p>
                       <p><i><b>“Really useful. In class, that's what he [instructor] tried to explain. Not clear to me [at that time]. … Really good. Illustrated the points it was trying to make.”</b></i></p>
                   </ul>
                   
                   <li>Students should be required to use the resource “Sampling from a Normally distributed population” before using later animations (Confidence Intervals and Central Limit Theorem).   From our interviews, we found students who interacted with the Sampling from Normal resource prior to the CLT or Confidence Interval web visualization had a better understanding of how the samples are drawn and what the population mean represents with respect to the example. Students using only the Confidence Interval applet during our second set of interviews requested more explanation about the population mean and standard deviation at the end of the tutorial, suggesting they did not understand the basic premise of the simulation.</li>
               </ul>
               
               <h1>How We Learned</h1>
               
               <p>In the Fall of 2015, we conducted a pilot study to understand how students interact with the resource.  We selected six students from an introductory statistics course for second year students in a variety of majors in the Faculty of Science.  During 50-minute long individual interviews, each student was exposed to two web visualizations, first the “Sampling from a Normally distributed population” and then the “Confidence intervals of the mean” web visualization. Students were asked to “think-aloud” while exploring the visualizations.  To probe student understanding, we asked questions at the beginning and end of the interviews.  The post-questions were taken from the NSF-funded Web ARTIST project.</p>
               
               <p>We then implemented some changes based on what we saw, and conducted a second set of interview in January 2016.  The students were registered in an introductory statistics course intended for third year biology majors.  These interviews followed the same format as the first set (pre-questions, “think-aloud” exploration, post questions).  However students were given only one of the two visualizations to allow for more time during the interviews. Four students were selected to try the “Sampling from a Normally distributed population” web visualization.</p>
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
