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
        <p><a href="/">Home</a> <span class="text-muted">&raquo; Video Example</span></p>

	<div class="row">  
	    <div class="col-md-8">
	    
		<h1>Video: Sampling distribution of the mean</h1>
		
            <div class="row description">
                <div class="col-md-12">
                <iframe class="pull-left fake-video" src="https://player.vimeo.com/video/196027417?byline=0&portrait=0" width="300" height="169" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
                <p><a href="https://vimeo.com/196027417">Sampling Distribution of the Mean</a> from <a href="https://vimeo.com/ubcmedit">UBC MedIT</a> on <a href="https://vimeo.com">Vimeo</a>.</p>
			
                <p class="intro-text">This video explores the concept of a sampling distribution of the mean. It highlights how we can draw conclusions about a population mean based on a sample mean by understanding how sample means behave when we know the true values of the population. </p>
			
                <p class="text-center access-btn"><a class="btn btn-success btn-md" href="https://vimeo.com/196027417">Access Resource</a></p>
		  
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
	    
	    </div>			
	</div>
    <div class="row featured-items">
        <h2>Check out more Videos:</h2>
	    <div class="col-md-4 text-center">
		<div class="thumbnail video-iframe">
		   <iframe src="https://player.vimeo.com/video/196027604?byline=0&portrait=0" width="300" height="169" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
		    <div class="caption">
			<h5>Video: Confidence Interval for a Population Mean</h5>
			<p class="text-left"><strong>Topics:</strong> <br>&bull; Confidence intervals - One sample mean t</p> 
			<p class="see-more"><a href="/LP-VideoCIs.jsp" class="btn btn-primary">Read more &raquo;</a></p>
		    </div>
		</div>
	    </div>
	    
	    <div class="col-md-4 text-center">
		<div class="thumbnail video-iframe">
		   <iframe src="https://player.vimeo.com/video/196470101?byline=0&portrait=0" width="300" height="169" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
		    <div class="caption">
			<h5>Video: One Sample T-Test</h5>
			<p class="text-left"><strong>Topics:</strong> <br>&bull; Hypothesis tests - One sample/paired - One sample mean t
			<p class="see-more"><a href="/LP-VideoOne-Sample-T-Test.jsp" class="btn btn-primary">Read more &raquo;</a></p>
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
		<h2>Prerequisite Knowledge</h2>
		<p>Students using this visualization should</p>
        <ul>
            <li>be able to identify and distinguish between a population and a sample, and between parameters and statistics;</li>
            <li>be familiar with methods of summarizing data sets, such as mean, standard deviation and histograms;</li>
            <li>be able to recognize probability models as distributions with shape, centre, and spread particularly the Normal distribution.</li>
        </ul>
		<h2>Learning Objectives</h2>
		<ul>
            <li>Explain the concepts of sampling variability and sampling distribution.</li>
            <li>Describe properties of the sampling distribution of the sample mean when the sample size is large.</li>
            <li>Calculate the standard error of a sample mean.</li>
            <li>Explain how the sample size influences the sampling distribution of the mean.</li>
            <li>Distinguish between the sampling distribution of the mean and the distribution of a sample of n observations.</li>
		</ul>
		
		<h2>Suggested uses</h2>
		<ul>
            <li>Before class, students watch the video before class, giving them the flexibility to engage with the video in the way that suits them (pausing, rewinding). Students are primed for class and lecture time can be spent applying that knowledge in engaging and collaborative ways.</li>
            <li>After class, the students can watch the video after they have learned the material in lecture. The video could be used as a refresher of the material before an exam or to review concepts they didn’t understand in class.</li>
		</ul>
		
		<h2>Complementary materials</h2>
		<ul>
            <li><a href="/video-example.jsp"><i>Eugenia's Clicker Questions <span class="glyphicon glyphicon-new-window"></span></i></a></li>
		</ul>
        
             <h2>About this Resource</h2>
		<ul>
            <p>
            <strong>Written by&colon; </strong>Mike Marin, Zachary Rothman, Stephen Gillis<br>
            <strong>Performed by&colon; </strong>Mike Marin<br>
            <strong>Puppets Built and Performed&colon; </strong>Dusty Hagerud<br>
            <strong>Production Design&colon; </strong>Enigma Arcana<br>
            <strong>Origami Design and Conceptual Drawings&colon; </strong>Jelena Sihvonen<br>
            <strong>Camera&colon; </strong>Paul Milaire, Zachary Rothman &amp; Stephen Gillis<br>
            <strong>Editing&colon; </strong>Stephen Gillis<br>
            <strong>Visual Effects&colon; </strong>Paul Milaire<br>
            <strong>Audio Edit and Mix&colon; </strong>Stephen Gillis &amp; Cornelius Wolinsky<br>
            <strong>UBC Intro Stats Project Team&colon; </strong>Mike Marin, Nancy Heckman, Bruce Dunham, Eugenia Yu, Melissa Lee, Michael Whitlock, Gaitri Yapa, Fred Cutler, Andrew Owen,Diana Whistler, Andy Leung, Gillian Gerhard &amp; Noureddine Elouazizi<br>
            <strong>Special Thanks&colon; </strong>Gary Rosborough, Saeed Dyanatkar, Andrew Wang, David Li, Kian Marin, Ladan Hamadani &amp; UBC Statistics Department<br>
            <strong>Produced and Directed By&colon; </strong>Zachary Rothman<br>
            <strong>Associate Producer&colon; </strong>Stephen Gillis<br>
             <br>
              This video is part of the UBC Intro Stats Project funded by the University of British Columbia’s Teaching and Learning Enhancement Fund, The Faculty of Medicine,The Faculty of Science, and The Faculty of Arts<br>
                <br>
                Copyright UBC 2017<br>
                Licensed Creative Commons<br>
                Share-alike, Non-Derivs &amp; Non-commercial<br>
                
            </p>
           
		</ul>   
	    </div>
	    
	    <div class="col-md-4 tags">
	    
		<div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
		    </div>
		    <div class="panel-body">
			<p>
                <strong>Topics:</strong> <br>&bull; Sampling distribution - Sample mean
                </p>
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
       <!--     
        <div class="panel panel-default">
		    <div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-book"></i> What we learned</h3>
		    </div>
		    <div class="panel-body">
		    </div>
		</div> 
	    -->
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
