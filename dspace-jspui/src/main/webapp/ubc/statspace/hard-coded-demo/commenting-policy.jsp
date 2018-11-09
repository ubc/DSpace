<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Commenting Poilcy
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
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.webui.servlet.RegisterServlet" %>

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

<dspace:layout locbar="nolink" titlekey="jsp.commenting-policy.title" feedData="<%= feedData %>">

    <div class="row landing-page">
        <div class="col-md-12"> <br><br>
            <h1>Commenting Policy</h1>
            <p>
            We at StatSpace welcome your comments, questions, and constructive criticism.  Our goal is to share high-quality open educational materials, which would not be possible without the contributions of the broader statistics education community.  The ability for members of the community to share their thoughts on these resources is therefore essential to the success of StatSpace.
            </p>
            <p>
            We reserve the right to moderate comments for civility, in keeping with UBC's <a href="http://www.hr.ubc.ca/respectful-environment/" target="_blank">Respectful Environment Statement <span class="glyphicon glyphicon-new-window"></span></a>.  Comments will be deleted if the content is derogatory, obscene, completely off-topic, or contains commercial content or spam.
            </p>
        </div>
    </div>


</dspace:layout>
