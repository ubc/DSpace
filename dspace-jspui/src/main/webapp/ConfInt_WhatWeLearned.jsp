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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/sim-example.jsp">Simulation Example</a> <span class="text-muted">&raquo;</span> <a href="/WV-ConfidenceIntervals.jsp">Web Visualization: Confidence Intervals for the Mean</a> <span class="text-muted">&raquo; What We Learned</span></p>

	<div class="row">  
	    <div class="col-md-8">
        <h1>Web Visualization: Confidence intervals for the mean</h1>
		<h2>What We Learned</h2>
		<div class="row descriptions">
	       <div class="col-md-12">
                  <p>Students often have trouble interpreting confidence intervals and hold some common misconception. For instance, many students believe, for the same data and parameter of interest, a 90% confidence interval is wider than a 95% confidence interval. This visualization was designed to help mitigate some of these misconceptions with confidence intervals.</p>
                    <p>Comments about what we learned from trialing the resource&colon;</p>
               <ul>
                   <li>Students need clear instructions when taking repeated samples. Some students were confused about the sampling process, such as how long to keep sampling and when they should stop (<i>“The part that really didn’t work well is the creating repeated samples…otherwise we don’t know when to click on ‘stop’… worried and stuff…”</i>). Clearer instructions were provided to prevent the student from moving away from repeated sampling process too soon, and helped them gauge how long to keep sampling.
                    </li>
                   <li>Some students found the repeated sampling too slow. The sampling process was adjusted to hit the right balance in terms of speed to allow enough time for students to grasp what was happening on the screen, but without letting the sampling run too long so that the student disengages.
                   </li>
                   <ul>
                       <br><p><i><b>“Kind of going on for too long. Should point out the stop button sooner. Kind of get the idea of what’s happening”</b></i></p>
                   </ul>
                   
                 <li>Students liked the interactive, hands-on nature of visualizations. Most of the students commented that the simulation was good for visualizing the effect the confidence level, standard deviation and sample size had on the width of the confidence intervals.
                   </li>
                   <ul>
                       <br><p><i><b>“Cool. Never seen anything like it! Pretty straight forward. Like how fish changes to bar graph, sliders, drop down thing. … [Repeated Sampling Process] Really liked it. Good that they have slower and faster buttons.”</b></i></p>
                       <br><p><i><b>“Creating all of the samples is fun to watch”</b></i></p>
                   </ul>
                   
                   <li>We recommend that the “Sampling from a Normally distributed population” web visualization be used as a primer for the Confidence Interval web visualization. From our interviews, we found students who interacted with the Sampling from Normal web visualization prior to the Confidence Interval web visualization had a better understanding of the context of these proceeding simulations (i.e. how the samples are drawn, what the population mean represents with respect to the example). Students using only the Confidence Interval applet requested more explanation about the population mean and standard deviation. For instance, one student commented that he did not understand what represented with respect to the example, which suggests that he did not understand the basic premise of the simulation.
                   </li>
                   <ul>
                       <br><p><i><b>“Confidence interval part was much more difficult than the sampling distribution of means… sampling distribution of means was more clear. Sampling distribution of means… there was more section of how sampling is really happening…. More instruction in the sampling part is helpful.”</b></i></p>
                   </ul>
               </ul>     
          
	       </div>	
	   </div>
            <div class="row">
	           <div class="col-md-12">
		      <div class="divider"></div>
	           </div>
	        </div>
           <h2>How We Learned</h2> 
            <p>In the Fall of 2015, we conducted a pilot study to understand how students interact with the resource. We selected six students from an introductory statistics course for second year students in a variety of majors in the Faculty of Science. During 50-minute long individual interviews, each student was exposed to two web visualizations, first the “Sampling from a Normally Distributed Population” and then the “Confidence Intervals of the Mean” web visualization. Students were asked to “think-aloud” while exploring the applets. To probe student understanding, we asked questions at the beginning and end of the interviews. The post-questions were taken from the NSF-funded Web ARTIST project.</p>
            <p>We then implemented some changes based on what we saw, and conducted a second set of interviews in January 2016. The students were registered in an introductory statistics course intended for third year biology majors. These interviews followed the same format as the first set (pre-questions, “think-aloud” exploration, post questions). However students were given only one of the two visualizations to allow for more time during the interviews. Four students were selected to try the “Confidence Intervals” web visualization.</p>
            
            
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
                <h3 class="panel-title"><a href="/ContributeError.jsp"><i class="glyphicon glyphicon-open"></i>&nbsp; Contribute materials</a></h3>
		    </div>
		    <div class="panel-body">
			<p>Easily share introductory statistics material&mdash;including <strong>copyright-cleared simulations, video, data sets</strong>, and more&mdash;with other educators and get meaningful feedback.</p>
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
	   <!--will use at a later date   
		<div class="panel panel-info">
		    <div class="panel-heading">
                <h3 class="panel-title"><a href="/register"><i class="glyphicon glyphicon-comment"></i> &nbsp;Evaluate what you use</a></h3>
		    </div>
		    <div class="panel-body">
			<p>Evaluate the introductory statistics material in StatSpace by giving <strong>detailed private feedback</strong> for any resources you use, to help other educators improve their designs.</p>
		    </div>
		</div>
	   --> 
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
		<a href="/register" class="btn btn-success btn-lg">Join</a><!-- &nbsp;or&nbsp; <a href="/mydspace" class="btn btn-success btn-lg">Sign In</a>-->
	    </div>
	    
	</div>

    </div>

</dspace:layout>
