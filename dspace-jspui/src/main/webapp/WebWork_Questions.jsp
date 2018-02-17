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
        <p><a href="/">Home</a> <span class="text-muted">&raquo; WeBWorK Questions</span></p>

        <div class="row">  
            <div class="col-md-8">
                <h1>WeBWorK</h1>
                <div class="row description">
                    <div class="col-md-4">
                        <img class="pull-left" src="image/webwork_logo_official.JPG"  width="175">
                    </div>
                    <div class="col-md-8">
                        <p class="intro-text">WeBWorK is a free on-line assessment tool presently used at over 700 institutions globally. Faculty members at UBC have created over 200 WeBWorK questions for use in introductory statistics courses, all of which are available in WeBWorK's Open Problem Library. Details of a sample of these questions can be found here.<br><br>The WeBWorKiR project was funded by UBC’s Teaching and Learning Enhancement Fund and involved the development of a wide range of homework questions for statistics courses. A key aspect of the project was augmenting WeBWorK to enable its communication with the statistical computing software R. This integration allows WeBWorK access to R's rich facilities for statistical data manipulation, analysis, and visualization, and hence permits the creation of probing and diverse problems in statistical science.</p>
                    </div>
                </div>

                <div class="row">
                    <h2><a href="#jump"><span class="glyphicon glyphicon-new-window"></span> Click to check out some sample WeBWorK Questions</a></h2><br><br>
                    <div class="col-md-12">
                        <div class="divider"></div>
                    </div>  
                </div>

                <div class="details">
                    <h2>About Resources</h2>
                    <p>Over 400 probability and statistics questions resulted from the WeBWorKiR project, more than half of which can be used for introductory courses. The questions can be found in the Open Problem Library via searching for homework sets commencing OpenProblemLibrary/UBC/STAT/. Most questions feature randomisation and customised solutions via R code, though R is not needed to attempt the questions.<br><br>Those interested in using WeBWorK should consult the installation and user guides linked on this page. Details on a small sample of questions are available above. </p>

                    <h2>Suggested use(s) and tips</h2>
                    <ul>
                        <li>Questions can be created by instructors or taken from WeBWorK's Open Problem Library.</li>
                        <li>The number of attempts per question can be set by the instructor.</li>
                        <li>In addition to homeworks, WeBWorK can also be used in labs and for time-constrained tests.</li>
                    </ul>  
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
                        <div class="panel panel-info" >
                            <div class="panel-heading">
                                <h3 class="panel-title"><a href="https://ubc.ca1.qualtrics.com/jfe/form/SV_6J4ans7VBN2hpt3"><i class="glyphicon glyphicon-open"></i>&nbsp;Survey</a></h3>
                            </div>
                            <div class="panel-body">
                                <p>When you have explored StatSpace, we would appreciate your opinion, via a brief <a href="https://ubc.ca1.qualtrics.com/jfe/form/SV_6J4ans7VBN2hpt3">survey</a>.<span class="glyphicon glyphicon-new-window"></span></p>
                            </div>
                        </div>
                    </div>

                    <div class="details tags">
                        <div class="panel panel-default">
                            <div class="panel-heading">
                                <h3 class="panel-title"><i class="glyphicon glyphicon-link"></i> Related Links</h3>
                            </div>
                            <div class="panel-body">
                                <ul>
                                    <li><a href="http://webwork.maa.org/">MAA WeBWorK Homepage<span class="glyphicon glyphicon-new-window"></span></a></li>
                                    <li><a href="http://wiki.ubc.ca/Documentation:WeBWorK">Wiki Guides to WeBWork <span class="glyphicon glyphicon-new-window"></span></a></li>
                                    <li><a href="http://iase-web.org/icots/9/proceedings/pdfs/ICOTS9_C178_DUNHAM.pdf">Article<span class="glyphicon glyphicon-new-window"></span></a></li>
                                    <li><a href="">Questions<span class="glyphicon glyphicon-new-window"></span></a></li>
                                </ul>
                            </div>
                        </div>                    
                    </div>        
                </div>			
            </div>

            <div class="row">
                <h2>Sample WeBWorK Questions :</h2>
                <a id="jump"></a>
            </div>

            <div class="row featured-items">
                <div class="col-md-3 text-center">
                    <div class="thumbnail">
                        <div class="col-md-12 text-center">
                            <img align="top" src="image/econ325_hw6_displayimage.JPG" class="sim-image" width="150" align="center"></div>
                        <div class="caption">
                            <h5>ECON 325 HW6 additional Q1</h5><br>
                            <p class="see-more"><a href="/wwecon325h6additionalQ1.jsp" class="btn btn-primary">Access &raquo;</a></p>
                        </div>
                    </div>
                </div>

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
