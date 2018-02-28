<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%-- 
Google analytics snippet for inclusion in the header.
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%
    String analyticsKey = ConfigurationManager.getProperty("jspui.google.analytics.key");
%>

<%
if (analyticsKey != null && analyticsKey.length() > 0)
{
%>
<!-- Global site tag (gtag.js) - Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=<%= analyticsKey %>"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());

  gtag('config', '<%= analyticsKey %>');
</script>
<%
}
%>