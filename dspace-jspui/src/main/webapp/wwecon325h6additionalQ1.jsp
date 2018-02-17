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
        <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/WebWork_Questions.jsp">WeBWorK Questions</a> <span class="text-muted">&raquo; WWECON325H6AdditionalQ1</span></p>

        <div class="row">  
            <div class="col-md-8">

                <h1>WeBWorK Question ECON 325 HW6 additional Q1</h1>

                <div class="row description">
                    <div class="col-md-12">
                        <img class="pull-left zoology-fish" src="image/econ325_hw6_displayimage.JPG" width="500">
                    </div>
                </div>
                <div class="row">
                    <a href="pdf_folder/ECON325HW6additionalQ1.pdf" class="btn btn-success btn-lg">More details on this question</a><br>
                    <h2><a href="#jump"><span class="glyphicon glyphicon-new-window"></span> Click to see more WeBWorK questions</a></h2><br><br> 
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
                            <h3 class="panel-title"><a href="/ContributeError.jsp"><i class="glyphicon glyphicon-open"></i>&nbsp; Contribute materials</a></h3>
                        </div>
                        <div class="panel-body">
                            <p>Easily share introductory statistics material&mdash;including <strong>copyright-cleared simulations, video, data sets</strong>, and more&mdash;with other educators and get meaningful feedback.</p>
                        </div>
                    </div>

                    <div class="panel panel-info" >
                        <div class="panel-heading">
                            <h3 class="panel-title"><a href="https://ubc.ca1.qualtrics.com/jfe/form/SV_6J4ans7VBN2hpt3"><i class="glyphicon glyphicon-open"></i>&nbsp;Survey</a></h3>
                        </div>
                        <div class="panel-body">
                            <p>When you have explored StatSpace, we would appreciate your opinion, via a brief <a href="https://ubc.ca1.qualtrics.com/jfe/form/SV_6J4ans7VBN2hpt3">survey</a>.<span class="glyphicon glyphicon-new-window"></span></p>
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
                    <p>Questions are not currently tagged with pre-req knowledge</p>

                    <h2>Learning Objectives</h2>
                    <ul>
                        <p>Find the standard error of a sample mean, identify which density function graphic indicates a lower tail probability for the sample mean, find the probability that the sample mean is less than a given value, decide whether the standard error would increase or decrease by increasing the sample size, decide if a tail probability for the sample mean would increase or decrease by changing the sample size.</p>
                    </ul>

                    <h2>Suggested use(s) and tips</h2>
                    <ul>
                        <li>The question was devised to be used in the on-line homework system WeBWorK, and the suggested number of attempts permitted is given in the question’s PG file.</li>
                        <li>The question could also be used on tests or for homework.</li>
                    </ul>

                    <h2>About this resource</h2>
                    <ul>
                        <p>Created 2015/10/25</p>
                        <li>Credits: Eugenia Yu, Diana Whistler, Bruce Dunham, Nelson Chen. The question is available in the Open Problem Library (OPL) in WeBWorK. </li>
                        <li>Question includes randomisation.</li>
                        <li>Solutions available in WeBWorK.</li>    
                    </ul>    
                </div>

                <div class="col-md-4 tags">

                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Tags</h3>
                        </div>
                        <div class="panel-body">
                            <p><strong>Subject:</strong> Statistics<br>
                                <strong>Chapter:</strong> <br>
                                <strong>Section:</strong> </p>
                        </div>
                    </div>

                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="glyphicon glyphicon-link"></i> Related materials</h3>
                        </div>
                        <div class="panel-body">
                            <ul>
                                <li><a href="http://www.webwork.maa.org/">MAA WeBWorK Homepage<span class="glyphicon glyphicon-new-window"></span></a></li>
                                <li><a href="http://wiki.ubc.ca/Documentation:WeBWork/The_WeBWorKiR_Project:_Integrating_WeBWorK_with_R/Installation_guide">UBC Wiki: WeBWork <span class="glyphicon glyphicon-new-window"></span></a></li>
                                <li><a href="http://webwork.maa.org/wiki/Using_R_Integration_with_WeBWorK">MAA Wiki: R in WeBWork <span class="glyphicon glyphicon-new-window"></span></a></li>
                                <li>WeBWorK Question ECON 325 HW6 additional Q2</li>
                            </ul>
                        </div>
                    </div>

                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h3 class="panel-title"><i class="glyphicon glyphicon-book"></i> What we learned</h3>
                        </div>
                        <div class="panel-body">
                            <p>We learned a lot about this resource from trialling with students. All questions from UBC have been trialed extensively on students before submitting to the OPL.</p>
                        </div>
                    </div>     

                </div>	
            </div>

            <div class="row">
                <h2>Other WeBWorK Questions :</h2>
                <a id="jump"></a>
            </div>

            <div class="row featured-items">
                <div class="col-md-3 text-center">
                    <div class="thumbnail">
                        <div class="col-md-12 text-center">
                            <img align="top" src="image/Stat200_displayimage.JPG" class="sim-image" width="150" align="center"></div>
                        <div class="caption">
                            <h5>STAT 200 revised2016/Linguistics Question Q9 </h5><br>
                            <p class="see-more"><a href="/wwstat200revisedlinguisticsQ9.jsp" class="btn btn-primary">Access &raquo;</a></p>
                        </div>     
                    </div>
                </div>
                <div class="col-md-3 text-center">
                    <div class="thumbnail">
                        <div class="col-md-12 text-center">
                            <img align="top" src="image/stat300_displayimage.JPG" class="sim-image" width="150" align="center"></div>
                        <div class="caption">
                            <h5>STAT 300 HW6 Question Q1</h5><br>
                            <p class="see-more"><a href="/wwstat300hw6Q1.jsp" class="btn btn-primary">Access &raquo;</a></p>
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
