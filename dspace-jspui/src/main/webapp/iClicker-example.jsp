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
        <p><a href="/">Home</a> <span class="text-muted">&raquo; iClicker</span></p>

	<div class="row">  
	    <div class="col-md-8">
	    
		<h1>Interactive engagement (clicker) questions: Sampling distributions of means</h1>
		
		<div class="row description">
		    <div class="col-md-12">
			<h2>Sample Question</h2>
                <p>Suppose that we are to draw many random samples of 120 employees from a large company. The average of the hourly wages of the 120 employees is computed for each sample. Below is the sampling distribution of the average values from the repeated samples.</p>
                <div class="col-md-12">
			     <img class="pull-left zoology-fish" src="image/sample_question_image.JPG" width="225">
			     </div>
                <div class="col-md-12">
			     <p class="text-center access-btn"><a class="btn btn-success btn-md" href="/iClicker_question.jsp">See More</a></p>
		       </div>
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
            
            <div class="panel panel-info">
		      <div class="panel-heading">
                <h3 class="panel-title"><a href="/register"><i class="glyphicon glyphicon-open"></i>&nbsp; Contribute materials</a></h3>
                </div>
		      <div class="panel-body">
			     <p>Easily share introductory statistics material&mdash;including <strong>copyright-cleared simulations, video, data sets</strong>, and more&mdash;with other educators and get meaningful feedback.</p>
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
		<p>Students should</p>
            <ul>
            <li>be able to recognize probability models as distributions with shape, centre, and spread</li>
            <li>be able to recall key properties of the Normal model</li>
            <li>be able to distinguish between a population and a sample, and between parameters and statistics</li>
		  </ul>
		<h2>Learning Objectives</h2>
		<ul>
            <li>Identify the population, sample, parameters and statistics in a given scenario</li>
            <li>Recall the sampling distribution of the mean of a sample from a Normal distribution</li>
            <li>Describe properties of the sampling distribution of the sample mean in general situations, using the Central Limit Theorem</li>
            <li>For the sample mean, explain whether and how the population distribution and the sample size influence the sampling distribution of the sample mean</li>
            <li>Apply the Central Limit Theorem to problems involving averages of variables from arbitrary distributions.</li>
        </ul>
            		
		<h2>Suggested uses</h2>
            <p>These resources are intended to be used in a number of ways&colon;</p>
		<ul>
		    <li>as stand-alone clicker questions during lectures&semi;</li>
		    <li>as assessment questions during and outside of class (e.g., pre-lecture quiz after students complete pre-lecture reading or other assigned tasks)&semi;</li>
            <li>as questions to be adapted for use in guided in-class activities [link to Fred’s material] or other instructor-supplied material</li>
		</ul>
		
		<h2>Complementary materials</h2>
		          <ul>
                    <li>Web visualization&colon; Instructors may assign the following accompanying web visualizations as homework before teaching the topic in class</li>
                        <ul>
                            <li><a target="_blank" href="WV-ConfidenceIntervals.jsp">Confidence intervals of the mean<span class="glyphicon glyphicon-new-window"></span></a></li>
                            <li><a target="_blank" href="/WV-SamplingNon-Normal.jsp"> Sampling from a non-Normally distributed population (CLT)<span class="glyphicon glyphicon-new-window"></span></a></li>
                            <li><a target="_blank" href="/sim-example.jsp">Sampling from a Normal distribution<span class="glyphicon glyphicon-new-window"></span></a></li>
                        </ul>
                    <li><a target="_blank" href="/video-example.jsp">Video: Sampling Distribution of the Mean<span class="glyphicon glyphicon-new-window"></span></a></li>            
                    <li><a target="_blank" href="http://www.zoology.ubc.ca/~whitlock/kingfisher/SamplingNormal.htm">Activity: Introducing the sampling distribution (French protest)<span class="glyphicon glyphicon-new-window"></span></a></li>
                </ul>
            
        <h2>About this resource</h2>
            <p>
                <b>Funding&colon;</b> University of British Columbia<br>
                <b>Project Leader&colon;</b> Eugenia Yu<br>
                <b>Thanks To&colon;</b> Nancy Heckman, Bruce Dunham, Melissa Lee, Gaitri Yapa, Mike Whitlock, Fred Cutler, Diana Whistler, Andrew Owen, Mike Marin, Leslie Burkholder, Doug Bonn, the UBC Flex Stats initiative for numerous suggestions and improvements.<br>
            </p>          
            
	    </div>
	    
	    <div class="col-md-4 tags">
	    
		<div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
		    </div>
		    <div class="panel-body">
			<p>Probability -- Laws, theory -- Central Limit Theorem<br>
                Sampling distributions -- Sample mean<br>
		    </div>
		</div>
	      
		<div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-link"></i> Related materials</h3>
		    </div>
		    <div class="panel-body">
			<ul>
			    <li><a href="http://www.cwsei.ubc.ca/resources/clickers.htm">iClicker Resources <span class="glyphicon glyphicon-new-window"></span></a></li>
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
