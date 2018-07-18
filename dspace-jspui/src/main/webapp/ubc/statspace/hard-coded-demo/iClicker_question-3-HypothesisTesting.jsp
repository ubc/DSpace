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
		<p><a href="<c:url value='/home.jsp'/>">Home</a> <span class="text-muted">&raquo;</span> <a href="<c:url value='/demo/iClicker-example-3-Hypothesistesting.jsp'/>">Interactive engagement (clicker) questions: Hypothesis testing for means</a> <span class="text-muted">&raquo; Sample Question: Hypothesis testing for means</span></p>

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

        </div>

</dspace:layout>
