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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/video-example.jsp">Video Example</a> <span class="text-muted">&raquo;</span> <a href="/WV-SamplingNon-Normal.jsp">Web Visualization: Sampling from a non-Normally Distributed Population(CLT)</a> <span class="text-muted">&raquo; What We Learned</span></p>

	<div class="row">  
	    <div class="col-md-8">
	    
		<h1>What We Learned</h1>
		<div class="row descriptions">
	       <div class="col-md-12">
               <p>Six student volunteers were recruited from an introductory (200 level) statistics class in the Summer 2016 term to test the web visualization. Students were recruited around the midpoint of their course and were exposed to the web visualization during 50-minute long interviews. Students were asked pre-questions about the topics prior to use of the simulation and more questions were given after exploration of the tool.</p>
               <p>After implementing changes to the simulation based on feedback from the interviews, a focus group was conducted with nine student volunteers selected from several introductory statistics courses in Fall 2016. </p>
               <h3>Enhancements made to simulations based on feedback from the first set of interviews:</h3>
               <ul>
                   <li>Wording in the tutorial mode was changed to reduce student confusion around certain terminology. For instance, students did not understand the use of the term “individual mean” in the question “Does the average of the distribution of sample means match the individual mean?” The term was changed to “mean of the population” to be more precise.</li>
                   <li>There was a need for certain settings to re-set once in the tutorial mode, otherwise the user would not see what was expected. For example, the value of the sample size needed to revert to a default value when entering the “custom mode”. Instructions were added when entering this mode to tell the user to reset the sample size before sampling.</li>
                   <li>Certain visual elements on the applet caused some confusion, for example some users tried to drag the graphic of the pencil in “custom mode” over to use on the right. Instructions were reworded to make clear how to draw distributions in this mode.</li>
                   <li>Other visual features were altered to direct the user’s eye, such as highlighting the “scenario buttons” in orange or greying out unneeded buttons to indicate where the user should click during the tutorial mode.</li>
               </ul>
               <h3>General observations:</h3>
               <ul>
                   <li>Student feedback from the interviews and focus group about the applet was generally quite positive. Students found the visual elements helpful to understand this concept.</li>
                   <ul>
                       <br><p>“It's quite interesting to see an animation simulation of the abstract stat concepts and it is really helpful to visualize the concept”</p>
                       <p>“It gives clear visual representations that help the user to understand what is happening”</p>
                   </ul>
                   <li>It is recommended that the Sampling from Normal web visualization be used as a prior to the CLT applet to introduce the basic concepts and the visual metaphors used in the CLT visualization. We found students who interacted with the Sampling from Normal simulation prior to the CLT web visualization had a better grasp of the context in this simulation.</li>
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
