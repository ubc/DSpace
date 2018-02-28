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
       <p><a href="/">Home</a> <span class="text-muted">&raquo;</span> <a href="/iClicker-example-3-Hypothesistesting.jsp">Interactive engagement (clicker) questions: Hypothesis testing for means</a> <span class="text-muted">&raquo; Sample Question: Hypothesis testing for means</span></p>

        <div class="row">  
            <div class="col-md-8">
                <div class="col-md-12">
                    <div class="row">
                        <h2>Sample Question</h2>
                        <p>The label on Olliberry jam jars lists a content weight of 269 grams. A sample of 100 jars was selected from the main factory and weighed. The content weights had an average of 264 grams. We will test that the Olliberry jam jar label correctly identifies the content weight.</p>
                    </div> 
                    <div class="row">
                        <p>What is the null hypothesis? 
                        </p><br><br><br>
                        <ul>
                            <p>
                                A&colon; The weight of a single Olliberry jam jar is 269 grams. <br>
                                B&colon; The mean weight of the sampled Olliberry jam jars is 264 grams.  <br>
                                C&colon; The mean weight of the sampled Olliberry jam jars is 269 grams.  <br>
                                D&colon; The mean weight of Olliberry jam jars produced in the main factory is 264 grams.<br>
                                <b>E&colon; The mean weight of Olliberry jam jars produced in the main factory is 269 grams. </b><br>
                            </p>    
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

            <div class="row">
                 <p><b>Explanation&colon;<br><br> 
                        We want to test if the label correctly identifies the content weight. The null hypothesis states that the difference between the value of an observed sample mean (264 grams) and that of the population mean (269 grams) is due to chance. Hence, the null hypothesis will be that the population mean weight is equal to 269 grams (μ=269).</b>
                </p>
            </div> 

            <div class="row text-center">
                <div class="col-md-12">
                    <h4 class="more-heading">To see more resources:</h4>
                    <a href="https://ubc.ca1.qualtrics.com/jfe/form/SV_6J4ans7VBN2hpt3" class="btn btn-success btn-lg">Join</a><!-- &nbsp;or&nbsp; <a href="/mydspace" class="btn btn-success btn-lg">Sign In</a>-->
                </div>	    
            </div>

        </div>

</dspace:layout>
