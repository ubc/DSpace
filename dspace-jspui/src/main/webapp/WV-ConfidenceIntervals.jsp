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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/sim-example.jsp">Simulation Example</a> <span class="text-muted">&raquo; Web Visualization: Confidence Intervals for the Mean</span></p>

        <div class="row">  
            <div class="col-md-8">

                <h1>Web Visualization: Confidence intervals for the mean</h1> <br><br>

                <div class="row description">
                    <div class="col-md-12">

                        <img class="pull-left zoology-fish" src="image/confidence_interval_image.JPG" class="sim-image" width="225">

                        <p class="intro-text">This web visualization shows the meaning of a confidence interval, calculating confidence intervals of the means of repeated samples.</p>

                        <p class="text-center access-btn"><a class="btn btn-success btn-md" href="http://www.zoology.ubc.ca/~whitlock/kingfisher/CIMean.htm">Access Resource</a></p>

                    </div>
                </div>

                <div class="row">
                    <h2><a href="#jump"><span class="glyphicon glyphicon-new-window"></span> Click to check out more Web Visualizations</a></h2><br><br>
                    <div class="col-md-12">
                        <div class="divider"></div>
                    </div>  
                </div>

                <div class="details"> 
                    <h2>Prerequisite Knowledge</h2>
                    <p>Students using this visualization should</p>
                    <ul>
                        <li>be familiar with methods of summarizing data sets, such as mean and standard deviation;</li>
                        <li>identify and distinguish between a population and a sample, and between parameters and statistics.</li> 
                    </ul>    
                    <h2>Learning Objectives</h2>
                    <ul>
                        <li>Interpret a confidence interval and confidence level
                        <li>Identify features that determine the width of a confidence interval
                    </ul>

                    <h2>Suggested use(s) and tips</h2>
                    <p>These apps are intended to be used in a number of ways</p>
                    <ul>
                        <li>as a visual aid during lectures;</li>
                        <li>as an open-ended learning tool for active learning;</li>
                        <li>as a guided learning experience, using either the built-in tutorials, guided activity sheet (click here for <a target="_blank" href="/pdf_folder/Applet3InstructorGuide.pdf">Instructor Guide<span class="glyphicon glyphicon-new-window"></span></a> and <a target="_blank" href="/pdf_folder/Applet3Qs.pdf">Activity Sheet<span class="glyphicon glyphicon-new-window"></span>)</a>, or other instructor-supplied material.</li>
                    </ul>

                    <h2>About this Resource</h2>
                    <ul>
                        <p>
                            <strong>Funding&colon; </strong>University of British Columbia <br>
                            <strong>Project Leader&colon; </strong>Mike Whitlock<br>
                            <strong>Programmers&colon; </strong>Boris Dalstein, Mike Whitlock &amp; Zahraa Almasslawi<br>
                            <strong>Art&colon; </strong>Derek Tan<br>
                            <strong>Translation&colon; </strong>Rémi Matthey-Doret<br>
                            <strong>Testing&colon; </strong>Melissa Lee, Gaitri Yapa &amp; Bruce Dunham<br>
                            <strong>Thanks to&colon; </strong>Darren Irwin, Dolph Schluter, Nancy Heckman, Kaylee Byers, Brandon Doty, Kim Gilbert, Sally Otto, Wilson Whitlock, Jeff Whitlock, Jeremy Draghi, Karon MacLean, Fred Cutler, Diana Whistler, Andrew Owen, Mike Marin, Leslie Burkholder, Eugenia Yu, Doug Bonn, Michael Scott, the UBC Physics Learning Group &amp; the UBC Flex Stats initiative for numerous suggestions and improvements.<br>
                        </p>

                    </ul> 
                </div>
            </div>

            <div class="col-md-4">
                <div class=" value-prop">
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
                        <div class="panel panel-info" >
                            <div class="panel-heading">
                                <h3 class="panel-title"><a href="https://survey.ubc.ca/s/statspace/"><i class="glyphicon glyphicon-open"></i>&nbsp;Survey</a></h3>
                            </div>
                            <div class="panel-body">
                                <p>When you have explored StatSpace, we would appreciate your opinion, via a brief <a href="https://survey.ubc.ca/s/statspace/">survey</a>.<span class="glyphicon glyphicon-new-window"></span></p>
                            </div>
                        </div>
                    </div>
                    
                    <div class="tags">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
                            </div>
                            <div class="panel-body">
                                <p>
                                    <strong>Topics:</strong><br>&bull; Confidence intervals - One sample mean t
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
                                    <li><a href="/LP-VideoCIs.jsp">Video: Confidence Interval for a Population Mean<span class="glyphicon glyphicon-new-window"></span></a></li>
                                </ul>
                            </div>
                        </div>

                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="glyphicon glyphicon-book"></i> What we learned</h3>
                            </div>
                            <div class="panel-body">
                                <p>We learned a lot about this resource from trialling with students. Students often have trouble interpreting confidence intervals and hold some common misconception. For instance, many students believe, for the same data and parameter of interest, a 90% confidence interval is wider than a 95% confidence interval.<br><a target="_blank" href="/ConfInt_WhatWeLearned.jsp">Read More <span class="glyphicon glyphicon-new-window"></span></a></p>
                            </div>
                        </div>     
                    </div>
                </div>			
            </div>

            <div class="row">
                <div class="col-md-12">
                    <div class="divider"></div>
                </div>
            </div>

            <div class="row">
                <h2>More Web Visualizations:</h2>
                <a id="jump"></a>
            </div>

            <div class="row featured-items">
                <div class="col-md-3 text-center">
                    <div class="thumbnail">
                        <div class="col-md-12 text-center">
                            <img src="http://www.zoology.ubc.ca/~whitlock/Kingfisher/Common/Images/coffee.svg" class="sim-image-large" width="110"></div>
                        <div class="caption">
                            <h5>Web visualization: Sampling from a non-Normally distributed population (CLT)</h5>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Probability - Laws, Theory - Central Limit Theorem <br>&bull; Sampling distributions - Sample mean</p><br><br> 
                            <p class="see-more"><a href="/WV-SamplingNon-Normal.jsp" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>
                    </div>
                </div>

                <div class="col-md-3 text-center">
                    <div class="thumbnail">
                        <img src="image/contingency_analysis_image.jpg" class="sim-image-large" width="170" >
                        <div class="caption">
                            <h5>Web Visualization: Chi-square contingency analysis</h5>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Hypothesis tests - Goodness of fit - Chi-squared test for independence</p><br><br><br><br> 
                            <p class="see-more"><a href="/WV-ChiSquarecontingencyanalysis.jsp" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>     
                    </div>
                </div>
                <div class="col-md-3 text-center">
                    <div class="thumbnail">
                        <img src="http://www.zoology.ubc.ca/~whitlock/kingfisher/Common/Images/fish.svg" class="sim-image-fish" width="170">
                        <div class="caption">
                            <br>
                            <h5>Web Visualization: Sampling from a Normal distribution</h5>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Sampling distributions - Sample mean <br>&bull; Exploratory data analysis/Classifying data - Graphical representations - Histograms</p><br>
                            <p class="see-more"><a href="/sim-example.jsp" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>     
                    </div>
                </div>
            </div>

            <div class="row">
                <h3>Web Visualizations are also available in <a target="_blank" href="http://www.zoology.ubc.ca/~whitlock/Kingfisher/KFhomepage_FR.htm">French</a> and <a target="_blank" href="http://www.zoology.ubc.ca/~whitlock/Kingfisher/KFhomepage_ES.htm">Spanish</a></h3>
            </div>

            <div class="row text-center">
                <div class="col-md-12">
                    <h4 class="more-heading">To see more resources:</h4>
                    <a href="https://survey.ubc.ca/surveys/37-ebe7b07545dc43f1e9090f86433/statspace-user-analytics/" class="btn btn-success btn-lg">Join</a> <!-- &nbsp;or&nbsp; <a href="/mydspace" class="btn btn-success btn-lg">Sign In</a>-->
                </div>
            </div>

        </div>

</dspace:layout>
