<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - HTML header for main home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.util.List"%>
<%@ page import="java.util.Enumeration"%>
<%@ page import="org.dspace.app.webui.util.JSPManager" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.util.Util" %>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.*" %>

<%
    String title = (String) request.getAttribute("dspace.layout.title");
    String navbar = (String) request.getAttribute("dspace.layout.navbar");
    boolean locbar = ((Boolean) request.getAttribute("dspace.layout.locbar")).booleanValue();

    String siteName = ConfigurationManager.getProperty("dspace.name");
    String feedRef = (String)request.getAttribute("dspace.layout.feedref");
    boolean osLink = ConfigurationManager.getBooleanProperty("websvc.opensearch.autolink");
    String osCtx = ConfigurationManager.getProperty("websvc.opensearch.svccontext");
    String osName = ConfigurationManager.getProperty("websvc.opensearch.shortname");
    List parts = (List)request.getAttribute("dspace.layout.linkparts");
    String extraHeadData = (String)request.getAttribute("dspace.layout.head");
    String extraHeadDataLast = (String)request.getAttribute("dspace.layout.head.last");
    String dsVersion = Util.getSourceVersion();
    String generator = dsVersion == null ? "DSpace" : "DSpace "+dsVersion;
    String analyticsKey = ConfigurationManager.getProperty("jspui.google.analytics.key");
%>

<!DOCTYPE html>
<html>
    <head>
        <title><%= title %> | <%= siteName %></title>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <meta name="Generator" content="<%= generator %>" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <link rel="shortcut icon" href="//cdn.ubc.ca/clf/7.0.4/img/favicon.ico" />
	    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/jquery-ui-1.10.3.custom/redmond/jquery-ui-1.10.3.custom.css" type="text/css" />
	    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/bootstrap.min.css" type="text/css" />
	    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/bootstrap-theme.min.css" type="text/css" />
	    <link rel="stylesheet" href="<%= request.getContextPath() %>/static/css/bootstrap/dspace-theme.css" type="text/css" />
	    <link rel="stylesheet" href='<c:url value="/static/ubc/ubc-custom.css" />' type="text/css" />
<%
    if (!"NONE".equals(feedRef))
    {
        for (int i = 0; i < parts.size(); i+= 3)
        {
%>
        <link rel="alternate" type="application/<%= (String)parts.get(i) %>" title="<%= (String)parts.get(i+1) %>" href="<%= request.getContextPath() %>/feed/<%= (String)parts.get(i+2) %>/<%= feedRef %>"/>
<%
        }
    }
    
    if (osLink)
    {
%>
        <link rel="search" type="application/opensearchdescription+xml" href="<%= request.getContextPath() %>/<%= osCtx %>description.xml" title="<%= osName %>"/>
<%
    }

    if (extraHeadData != null)
        { %>
<%= extraHeadData %>
<%
        }
%>
        
	<script type='text/javascript' src="<%= request.getContextPath() %>/static/js/jquery/jquery-1.12.4.min.js"></script>
	<script type='text/javascript' src='<%= request.getContextPath() %>/static/js/jquery/jquery-ui-1.10.3.custom.min.js'></script>
	<script type='text/javascript' src='<%= request.getContextPath() %>/static/js/bootstrap/bootstrap.min.js'></script>
	<script type='text/javascript' src='<%= request.getContextPath() %>/static/js/holder.js'></script>
	<script type="text/javascript" src="<%= request.getContextPath() %>/utils.js"></script>
    <script type="text/javascript" src="<%= request.getContextPath() %>/static/js/choice-support.js"> </script>

	<%-- Bootstrap Datepicker --%>
	<script src="<c:url value='/static/ubc/lib/bootstrap-datepicker/js/bootstrap-datepicker.min.js' />"></script>
	<script src="<c:url value='/static/ubc/lib/bootstrap-datepicker/locales/bootstrap-datepicker.en-CA.min.js' />"></script>
	<link rel="stylesheet" href="<c:url value='/static/ubc/lib/bootstrap-datepicker/css/bootstrap-datepicker3.min.css' />" />

	<%-- Include TinyMCE only in submissions --%>
	<script src='<c:url value="/static/ubc/lib/tinymce/tinymce.min.js" />'></script>
	<script>
		tinymce.init({
			selector: 'textarea.tinyMCETextArea',
			browser_spellcheck: true,
			menubar: false,
			plugins: "autolink link lists code",
			min_height: 200,
			link_assume_external_targets: true,
			external_plugins: {
				'autolink': '<c:url value="/static/ubc/lib/tinymce/plugins/autolink/plugin.min.js" />',
				'code': '<c:url value="/static/ubc/lib/tinymce/plugins/code/plugin.min.js" />', // be able to edit raw html for power users
				'link': '<c:url value="/static/ubc/lib/tinymce/plugins/link/plugin.min.js" />',
				'lists': '<c:url value="/static/ubc/lib/tinymce/plugins/lists/plugin.min.js" />',
				'colorpicker': '<c:url value="/static/ubc/lib/tinymce/plugins/colorpicker/plugin.min.js" />', // dependency on textcolor,
				'textcolor': '<c:url value="/static/ubc/lib/tinymce/plugins/textcolor/plugin.min.js" />'
			},
			toolbar: 'undo redo styleselect bold italic alignleft aligncenter alignright bullist numlist outdent indent link code forecolor backcolor'
		});
		tinymce.init({
			selector: 'input.tinyMCEInput',
			browser_spellcheck: true,
			menubar: false,
			statusbar: false,
			min_height: 40,
			forced_root_block: false,
			plugins: "autolink link code",
			link_assume_external_targets: true,
			external_plugins: {
				'autolink': '<c:url value="/static/ubc/lib/tinymce/plugins/autolink/plugin.min.js" />',
				'code': '<c:url value="/static/ubc/lib/tinymce/plugins/code/plugin.min.js" />', // be able to edit raw html for power users
				'link': '<c:url value="/static/ubc/lib/tinymce/plugins/link/plugin.min.js" />',
			},
			toolbar: 'undo redo bold italic link code'
		});
	</script>

	<!-- Gives us the convenience of more modern CSS without interfering with the ancient bootstrap -->
	<link href="<c:url value='/static/ubc/lib/basscss/basscss.min.css' />" rel="stylesheet">
	
    <%--Gooogle Analytics recording.--%>
    <%
    if (analyticsKey != null && analyticsKey.length() > 0)
    {
    %>
        <script type="text/javascript">
            var _gaq = _gaq || [];
            _gaq.push(['_setAccount', '<%= analyticsKey %>']);
            _gaq.push(['_trackPageview']);

            (function() {
                var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
                ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
                var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
            })();
        </script>
    <%
    }
    if (extraHeadDataLast != null)
    { %>
		<%= extraHeadDataLast %>
		<%
		    }
    %>
    

<!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!--[if lt IE 9]>
  <script src="<%= request.getContextPath() %>/static/js/html5shiv.js"></script>
  <script src="<%= request.getContextPath() %>/static/js/respond.min.js"></script>
<![endif]-->
    </head>

    <%-- HACK: leftmargin, topmargin: for non-CSS compliant Microsoft IE browser --%>
    <%-- HACK: marginwidth, marginheight: for non-CSS compliant Netscape browser --%>
    <body>
<a class="sr-only" href="#content">Skip navigation</a>
<dspace:include page="/layout/ubc-banner.jsp" />
<header class="navbar navbar-inverse">    
    <%
    if (!navbar.equals("off"))
    {
%>
            <div class="container">
                <dspace:include page="<%= navbar %>" />
            </div>
<%
    }
    else
    {
    	%>
        <div class="container">
            <dspace:include page="/layout/navbar-minimal.jsp" />
        </div>
<%    	
    }
%>
</header>

<main id="content" role="main">
                <%-- Location bar --%>
<%
    if (locbar)
    {
%>
<div class="container">
                <dspace:include page="/layout/location-bar.jsp" />
</div>                
<%
    }
%>


        <%-- Page contents --%>
<div class="container">
<% if (request.getAttribute("dspace.layout.sidebar") != null) { %>
	<div class="row">
		<div class="col-md-9">
<% } %>		