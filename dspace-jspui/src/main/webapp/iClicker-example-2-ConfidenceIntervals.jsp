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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/iClicker-example.jsp">Interactive engagement (clicker) questions: Sampling distributions of means</a> <span class="text-muted">&raquo; Interactive engagement (clicker) questions: 
            Confidence intervals for means</span></p>

        <div class="row">  
            <div class="col-md-8">
                <h1>Interactive engagement (clicker) questions: Confidence intervals for means</h1>
                <div class="row description">
                    <div class="col-md-12"> 
                        <div class="row">
                            <h2>Sample Question</h2><br>
                            <img class="pull-left zoology-fish" href="image/canadian_shopping.JPG" class="sim-image" width="220">
                        </div>           
                        <p>A news article reported the following: “The poll of 500 Canadians using random-digit dialling of both mobile phones and land lines gave a mean expenditure on holiday shopping of 652 dollars.  The numbers are considered...”</p>
                        <p class="text-center access-btn"><a target="_blank" class="btn btn-success btn-md" href="/iClicker_question-2-ConfidenceIntervals.jsp">See More</a></p>
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
                        <li>Construct confidence intervals given relevant sample data</li>
                        <li>Interpret a confidence interval and confidence level</li>
                        <li>Identify features that determine the width of a confidence interval</li>
                        <li>Recall the assumptions for construction of a confidence interval</li>
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
                <div class="value-prop">
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

                    <div class="details tags">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
                            </div>
                            <div class="panel-body">
                                <p>
                                    <strong>Topics:</strong> <br>&bull; Confidence intervals – One sample mean – t <br>&bull; Confidence intervals – One sample mean – z <br>&bull; Confidence intervals – Concepts – Sample size <br>&bull;
                                    Confidence intervals – Concepts – Standard error
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
                                    <li>Web visualization&colon; Instructors may assign this accompanying web visualization as homework before teaching the topic in class</li>
                                    <ul>
                                        <li><a target="_blank" href="/WV-ConfidenceIntervals.jsp"> Confidence intervals for the mean <span class="glyphicon glyphicon-new-window"></span></a></li>
                                    </ul>
                                    <li><a target="_blank" href="/LP-VideoCIs.jsp">Video: Confidence Intervals for a Population Mean<span class="glyphicon glyphicon-new-window"></span></a></li>            
                                    <!--Removed for soft launch
                                    <li><a target="_blank" href="/wwstat200revisedlinguisticsQ9.jsp">Activity: Understanding Confidence Intervals<span class="glyphicon glyphicon-new-window"></span></a></li>-->
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
                            <img src="image/iClicker_home_image.JPG" class="sim-image-large" width="220">
                        </div>
                        <div class="caption">
                            <h5>Interactive engagement (clicker) questions: Sampling distributions of means</h5>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Probability -- Laws, theory -- Central Limit Theorem <br>&bull; Sampling distributions -- Sample mean </p><br><br><br><br> 
                            <p class="see-more"><a href="/iClicker-example.jsp" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>
                    </div>
                </div>

                <div class="col-md-4 text-center">
                    <div class="thumbnail">
                        <img src="image/olli_jam.jpg" class="sim-image-large" width="220">
                        <div class="caption">
                            <h5>Interactive engagement (clicker) questions: Hypothesis testing for means</h5>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Hypothesis tests – One sample / paired – One sample mean - t <br>&bull; Hypothesis tests – One sample / paired – One sample mean - z <br>&bull; Hypothesis tests – Concepts – P-value and significance level <br>&bull; Hypothesis tests – Type I / type II errors and power</p> 
                            <p class="see-more"><a href="/iClicker-example-3-Hypothesistesting.jsp" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>     
                    </div>
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
