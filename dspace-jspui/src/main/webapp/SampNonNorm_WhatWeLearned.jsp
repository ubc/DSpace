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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/sim-example.jsp">Simulation Example</a> <span class="text-muted">&raquo;</span> <a href="/WV-SamplingNon-Normal.jsp">Web Visualization: Sampling from a non-Normally Distributed Population(CLT)</a> <span class="text-muted">&raquo; What We Learned</span></p>

	<div class="row">  
	    <div class="col-md-8">
        <h1>Web Visualization: Sampling from a non-Normally distributed population (CLT)</h1>
		<h2>What We Learned</h2>
		<div class="row descriptions">
	       <div class="col-md-12">
               <p>Many students hold misconceptions related to the Central Limit Theorem. From our teaching, we have found that although students might be able to perform formal calculations, they often get confused with some of the concepts surrounding this topic. For instance, many students believe that, when larger samples are taken from a non-Normal distribution the distribution of the sampled data itself becomes Normally distributed. This visualization was designed to help with students’ conceptual understanding. </p>
               
               <p>Comments about what we learn from trialing the resource&colon;</p>
               <ul>
                   <li>Terminology needs to be precise so as not to confuse students. For instance, in the original version of the tutorial, students were confused by our use of the term “individual mean” rather than “mean of the population”. We adjusted wording in the tutorial to ensure the meaning of all vocabulary was clear.</li>
                   <li>Certain visual elements on the visualization caused some confusion, for example some users tried to drag the graphic of the pencil in “custom mode” over to use on the right. Instructions were reworded to make clear how to draw distributions in this mode.</li>
                   <li>Other visual features were added to help the user interact with the interface in a seamless manner. Buttons were highlighted or greyed out to strategically direct attention towards or away from certain items. </li>
                   <li>Students found the interactive visual elements especially helpful to understand this abstract concept.</li>
                   <ul>
                       <li><i><b>“It's quite interesting to see an animation simulation of the abstract stat concepts and it is really helpful to visualize the concept”</b></i></li>
                       <li><i><b>“It gives clear visual representations that help the user to understand what is happening”</b></i></li>
                   </ul>
                   <li>It is recommended that the Sampling from Normal web visualization be used prior to the CLT visualization to introduce the basic concepts and the visual metaphors used. We found students who interacted with the Sampling from Normal simulation prior to the CLT web visualization had a better grasp of the context in this simulation.</li>
               </ul>
               <h2>How We Learned</h2>
               <p>In the Summer of 2016, we conducted a pilot study to understand how students interact with the resource. We selected six students from an introductory statistics course for second year students in the Faculty of Applied Science. Students were recruited around the midpoint of their course and were exposed to the CLT web visualization during 50-minute long individual interviews. Each student was asked to “think-aloud” while exploring the visualization.  To probe student understanding, we asked questions at the beginning and end of the interviews.  The questions were taken from the NSF-funded Web ARTIST project.</p>
               
               <p>We then implemented some changes based on the feedback, and conducted a focus group in October 2016. We selected nine students who had been registered in an introductory statistics course in the past year. During the hour-long focus group, students were asked questions to check their understanding of topics prior to playing with the visualization. More questions were provided after exploration. Small groups were formed and students were given the opportunity to discuss the web visualization before providing feedback to the whole group. </p>
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
        
        <div class="panel panel-info" >
            <div class="panel-heading">
                <h3 class="panel-title"><a href="https://survey.ubc.ca/s/statspace/"><i class="glyphicon glyphicon-open"></i>&nbsp;Survey</a></h3>
            </div>
            <div class="panel-body">
                <p>When you have explored StatSpace, we would appreciate your opinion, via a brief <a href="https://survey.ubc.ca/s/statspace/">survey</a>.<span class="glyphicon glyphicon-new-window"></span></p>
            </div>
        </div>    
	   <!--Will use at a later date   
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
		<a href="https://survey.ubc.ca/surveys/37-ebe7b07545dc43f1e9090f86433/statspace-user-analytics/" class="btn btn-success btn-lg">Join</a><!-- &nbsp;or&nbsp; <a href="/mydspace" class="btn btn-success btn-lg">Sign In</a>-->
	    </div>
	    
	</div>

    </div>

</dspace:layout>
