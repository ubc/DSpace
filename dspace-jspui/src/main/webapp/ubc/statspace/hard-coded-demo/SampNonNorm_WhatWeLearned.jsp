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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
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
        <p><a href="<c:url value='/home.jsp'/>">Home</a> <span class="text-muted">&raquo;</span> <a href="<c:url value='/demo/sim-example.jsp'/>">Simulation Example</a> <span class="text-muted">&raquo;</span> <a href="<c:url value='/demo/WV-SamplingNon-Normal.jsp'/>">Web Visualization: Sampling from a non-Normally Distributed Population(CLT)</a> <span class="text-muted">&raquo; What We Learned</span></p>

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
            
	</div>
	
	<div class="row">
	    <div class="col-md-12">
		<div class="divider"></div>
	    </div>
	</div>
	
	

    </div>

</dspace:layout>
