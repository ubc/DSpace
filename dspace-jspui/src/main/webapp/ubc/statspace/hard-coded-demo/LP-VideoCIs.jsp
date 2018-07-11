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
        <p><a href="<c:url value="/home.jsp" />">Home</a> <span class="text-muted">&raquo;</span> <a href="<c:url value='/demo/video-example.jsp' />">Video Example</a> <span class="text-muted">&raquo; Video: Confidence Interval for a Population Mean</span></p>
		
        <div class="row">  
            <div class="col-md-8">

                <h1>Video: Confidence Interval for a Population Mean</h1>

                <div class="row description">
                    <div class="col-md-12">
                        <iframe class="pull-left fake-video" src="https://player.vimeo.com/video/196027604?byline=0&portrait=0" width="300" height="169" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>

                        <p class="intro-text">This video discusses the concept of a confidence interval for a population mean. It emphasizes the interpretation of a confidence interval and explores the connections between the interval width, margin of error and sample size.</p>

                        <p class="text-center access-btn"><a class="btn btn-success btn-md" href="https://vimeo.com/196027604">Access Resource</a></p>

                    </div>
                </div> 

                <div class="row">
                    <h2><a href="#jump"><span class="glyphicon glyphicon-new-window"></span> Click to check out more Videos</a></h2><br><br>
                    <div class="col-md-12">
                        <div class="divider"></div>
                    </div>  
                </div>

                <div class="details">
                    <h2>Prerequisite Knowledge</h2>
                    <p>Students should</p>
                    <ul>
                        <li>be able to identify and distinguish between a population and a sample, and between parameters and statistics;</li>
                        <li>be familiar with methods of summarizing data sets, such as mean, standard deviation and histograms;</li>
                        <li>be able to recognize probability models as distributions with shape, centre, and spread particularly the Normal distribution;</li>
                        <li>be able to explain the concepts of sampling variability and sampling distribution.</li>
                    </ul>
                    <h2>Learning Objectives</h2>
                    <ul>
                        <li>Interpret a confidence interval and confidence level</li>
                        <li>Identify features that determine the width of a confidence interval</li>
                    </ul>

                    <h2>Suggested use(s) and tips</h2>
                    <ul>
                        <li>Students can watch the video before class, giving them the flexibility to engage with the video in the way that suits them (pausing, rewinding). Students are primed for class and lecture time can be spent applying that knowledge in engaging and collaborative ways. </li>
                        <li>Students can watch the video after they have learned the material in lecture. The video could be used as a refresher of the material before an exam or to review concepts they didn’t understand in class.</li>
                    </ul>
                    
                    <h2>About this resource</h2>
                    <p>
                        <b>Written by&colon;</b> Mike Marin, Zachary Rothman &amp; Stephen Gillis<br>
                        <b>Performed by&colon;</b> Mike Marin<br>
                        <b>Puppets built and Performed&colon;</b> Dusty Hagerud<br>
                        <b>Production Design and Conceptual Drawings&colon;</b> Jelena Sihvonen<br>
                        <b>Camera&colon;</b> Paul Milaire, Zachary Rothman, &amp; Stephen Gillis<br>
                        <b>Editing&colon;</b> Stephon Gillis<br>
                        <b>Visual Effects&colon;</b> Paul Milaire<br>
                        <b>Audio Edit and Mix&colon;</b> Stephan Gills &amp; Cornelius Wolinsky<br>
                        <b>UBC Intro Stats Project Team&colon;</b> Mike Marin, Nancy Heckman, Bruce Dunham, Eugenia Yu, Melissa Lee, Michael Whitlock, Gaitri Yapa, Fred Cutler, Andrew Owen, Diana Whistler, Andy Leung, Gillian Gerhard &amp; Noureddine Elouazizi<br>
                        <b>Special Thanks&colon;</b> Gary Rosborough, Saeed Dyanatkar, Andrew Wang, David Li, Kian Marin, Ladan Hamadani &amp; UBC Statistics Department<br>
                        <b>Produced and Directed by&colon;</b> Zachary Rothman<br>
                        <b>Associate Producer&colon;</b> Stephen Gillis
                    </p>
                    <p>This video is part of the UBC Intro Stats Project funded by the University of British Columbia’s Teaching and Learning Enhancement Fund, The Faculty of Medicine, The Faculty of Science, and The Faculty of Arts</p>
                    <p>Copyright UBC 2017<br>License Creative Commons<br>Share-alike, Non-Derivs &amp; Non-commercial
                </div>

            </div>

            <div class="col-md-4">
                    <div class="tags">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
                            </div>
                            <div class="panel-body">
                                <p>
                                    <strong>Topics:</strong> <br>&bull; Confidence intervals - One sample mean t
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
                                    <li><a href="<c:url value='/demo/WV-ConfidenceIntervals.jsp' />">Web visualization: Confidence intervals for the mean <span class="glyphicon glyphicon-new-window"></span></a></li>
                                   <!--Removed for soft launch
                                    <li><a href="/LP-VideoCIs.jsp"><i>Activity: Understanding confidence intervals <span class="glyphicon glyphicon-new-window"></span></i></a></li>-->
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>			
            </div>

        <div class="row">
            <h2>More Videos:</h2>
            <a id="jump"></a>
        </div>


        <div class="row featured-items">
            <div class="col-md-4 text-center">
                <div class="thumbnail video-iframe">
                    <iframe src="https://player.vimeo.com/video/196027417?byline=0&portrait=0" width="300" height="169" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
                    <div class="caption">
                        <h5>Video: Sampling distribution of the mean</h5>
                        <p class="text-left"><strong>Topics:</strong> <br>&bull; Sampling distribution - Sample mean</p> 
                        <p class="see-more"><a href="<c:url value='/demo/video-example.jsp' />" class="btn btn-primary">Read more &raquo;</a></p>
                    </div>
                </div>
            </div>

            <div class="col-md-4 text-center">
                <div class="thumbnail video-iframe">
                    <iframe src="https://player.vimeo.com/video/196470101?byline=0&portrait=0" width="300" height="169" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
                    <div class="caption">
                        <h5>Video: One Sample T-Test</h5>
                        <p class="text-left"><strong>Topics:</strong> <br>&bull; Hypothesis tests - One sample/paired - One sample mean t</p>
                        <p class="see-more"><a href="<c:url value='/demo/LP-VideoOne-Sample-T-Test.jsp' />" class="btn btn-primary">Read more &raquo;</a></p>
                    </div>
                </div>
            </div>
        </div>

    </div>

</dspace:layout>