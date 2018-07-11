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
        <p><a href="/">Home</a> <span class="text-muted">&raquo; iClicker</span></p>
        <div class="row">  
            <div class="col-md-8">
                <h1>Interactive engagement (clicker) questions: Sampling distributions of means</h1>
                <div class="row description">
                    <div class="col-md-12"> 
                        <div class="row">
                            <h2>Sample Question</h2>
                        </div>
                        <img class="pull-left zoology-fish" src="<c:url value='/image/sample_question_image.JPG' />" width="220">
                        <p class="intro-text">Suppose that we are to draw many random samples of 120 employees from a large company. The average of the hourly wages of the 120 employees is computed for each sample. Below is the sampling distribution of the average values from the repeated samples.</p>
                        <p class="text-center access-btn"><a target="_blank" class="btn btn-success btn-md" href="<c:url value='/demo/iClicker_question.jsp' />">See More</a></p>   
                    </div>
                </div>

                <div class="row">
                    <h2><a href="#jump"><span class="glyphicon glyphicon-new-window"></span> Click to check out more interactive engagement (clicker) questions</a></h2><br><br>
                    <div class="col-md-12">
                        <div class="divider"></div>
                    </div>  
                </div>                

                <div class="details">
                    <h2>Prerequisite knowledge</h2>
                    <p>Students should&colon;</p>
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
                        <li>Apply the Central Limit Theorem to problems involving averages of variables from arbitrary distributions</li>
                    </ul>

                    <h2>Suggested use(s) and tips</h2>
                    <p>These resources are intended to be used in a number of ways&colon;</p>
                    <ul>
                        <li>as stand-alone clicker questions during lectures&semi;</li>
                        <li>as assessment questions during and outside of class (e.g., pre-lecture quiz after students complete pre-lecture reading or other assigned tasks)&semi;</li>
                        <li>as questions to be adapted for use in guided in-class activities or other instructor-supplied material</li>
                    </ul>

                    <h2>About this resource</h2>
                    <p>
                        <b>Funding&colon;</b> University of British Columbia<br>
                        <b>Project Leader&colon;</b> Eugenia Yu<br>
                        <b>Thanks To&colon;</b> Nancy Heckman, Bruce Dunham, Melissa Lee, Gaitri Yapa, Mike Whitlock, Fred Cutler, Diana Whistler, Andrew Owen, Mike Marin, Leslie Burkholder, Doug Bonn, the UBC Flex Stats initiative for numerous suggestions and improvements.<br>
                    </p>
                </div>
            </div>

            <div class="col-md-4">                
                    <div class="details tags">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
                            </div>
                            <div class="panel-body">
                                <p>
                                    <strong>Topics:</strong> <br>&bull; Probability -- Laws, theory -- Central Limit Theorem <br>&bull; Sampling distributions -- Sample mean 
                                </p>
                            </div>
                        </div>

                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="glyphicon glyphicon-link"></i> Related materials</h3>
                            </div>
                            <div class="panel-body">
                                <ul>
                                    <li><a href="http://www.cwsei.ubc.ca/resources/clickers.htm">iClicker Resources <span class="glyphicon glyphicon-new-window"></span></a></li>
                                    <li>Web visualization&colon; Instructors may assign the following accompanying web visualizations as homework before teaching the topic in class</li>
                                    <ul>
                                        <li><a target="_blank" href="<c:url value='/demo/WV-SamplingNon-Normal.jsp' />"> Sampling from a non-Normally distributed population (CLT)<span class="glyphicon glyphicon-new-window"></span></a></li>
                                        <li><a target="_blank" href="<c:url value='/demo/sim-example.jsp' />">Sampling from a Normal distribution<span class="glyphicon glyphicon-new-window"></span></a></li>
                                    </ul>
                                    <li><a target="_blank" href="<c:url value='/demo/video-example.jsp' />">Video: Sampling Distribution of the Mean<span class="glyphicon glyphicon-new-window"></span></a></li>            
                                    <!-- removed for soft launch
                                    <li><a target="_blank" href="http://www.zoology.ubc.ca/~whitlock/kingfisher/SamplingNormal.htm">Activity: Introducing the sampling distribution (French protest)<span class="glyphicon glyphicon-new-window"></span></a></li>-->
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>			
            </div>

            <div class="row">
                <h2>More interactive engagement (clicker) questions:</h2>
                <a id="jump"></a>
            </div>

            <div class="row featured-items">
                <div class="col-md-4 text-center">
                    <div class="thumbnail">
                        <div class="col-md-12 text-center">
                            <img src="<c:url value='/image/canadian_shopping.JPG' />" class="sim-image-large" width="220">
                        </div>
                        <div class="caption">
                            <h5>Interactive engagement (clicker) questions: Confidence intervals for means</h5>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Confidence intervals – One sample mean – t <br>&bull; Confidence intervals – One sample mean – z <br>&bull; Confidence intervals – Concepts – Sample size <br>&bull; Confidence intervals – Concepts – Standard error</p><br><br><br> 
                            <p class="see-more"><a href="<c:url value='/demo/iClicker-example-2-ConfidenceIntervals.jsp' />" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 text-center">
                    <div class="thumbnail">
                        <img src="<c:url value='/image/olli_jam.jpg' />" class="sim-image-large" width="220">
                        <div class="caption">
                            <h5>Interactive engagement (clicker) questions: Hypothesis testing for means</h5>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Hypothesis tests – One sample / paired – One sample mean - t <br>&bull; Hypothesis tests – One sample / paired – One sample mean - z <br>&bull; Hypothesis tests – Concepts – P-value and significance level <br>&bull; Hypothesis tests – Type I / type II errors and power</p> 
                            <p class="see-more"><a href="<c:url value='/demo/iClicker-example-3-Hypothesistesting.jsp' />" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>     
                    </div>
                </div>
            </div>

        </div>

</dspace:layout>
