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
	<p><a href="/">Home</a> <span class="text-muted">&raquo; Copyright Resources</span></p>

	<div class="row">  
	    <div class="col-md-12">
	    
		<h1>Copyright Resources</h1>
		<div class="row descriptions">
	       <div class="col-md-12">
              <h2>Information for StatSpace contributors</h2>
              <p>If you wish to contribute resources to StatSpace, you will have the option to add <a href="https://creativecommons.org/share-your-work/licensing-types-examples/">Creative Commons</a> License to your resources.  <b>Creative Commons licenses govern what people who read your work may then do with it.</b></p>
              <p>License Types&colon;</p>
              <ul>
                  <li>Creative Commons Attribution 4.0 International (CC BY 4.0)
                  <li>Creative Commons Attribution-NonCommercial 4.0 International (CC BY-NC 4.0)
                  <li>Creative Commons Attribution-ShareAlike 4.0 International (CC-BY-SA 4.0)
                  <li>Creative Commons Attribution-NoDerivatives 4.0 International (CC BY-ND 4.0)
                  <li>Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)
                  <li>Creative Commons Attribution NonCommercial-NoDerivatives 4.0 International (CC BY-NC-ND 4.0)
                  <li>Creative Commons Zero (CC0)
                  <li>Public Domain (Public Domain)
              </ul>

              <h2>Information for StatSpace users</h2>
              <p>If you wish to use resources that have been posted to StatSpace, please check the bottom of the resource page to see whether a Creative Commons License has been applied to the resource.  You can click on the license to learn more about what you may do with the resource.</p>

              <h2>UBC Library guides to copyright and permissions</h2>
              <p>For more information on how content copyright works for the resources available in StatSpace, please refer to these user guides, provided by the UBC Library&colon;</p>
              <ul>
                  <li>Copyright &amp; Permissions&colon; <a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Copyright_Permissions/Curated_Content">Copyright and Curated Content in Open Education Resource Repositories&nbsp;<span class="glyphicon glyphicon-new-window"></span></a></li>
                  <li>Copyright &amp; Permissions&colon; <a href="https://wiki.ubc.ca/Library:OERR/User_Guides/Copyright_Permissions/Self_Created_Content">Self-created content for open education repositories&nbsp;<span class="glyphicon glyphicon-new-window"></span></a></li>
		          <li>Finding &amp; Using Open Education Resources&colon; <a href="https://wiki.ubc.ca/Library:OERR/User_Guides/Curating/Define">What are open education resources?&nbsp;<span class="glyphicon glyphicon-new-window"></span></a></li>
		      </ul>
	       </div>	
	   </div>
		</div> 
	</div>

    </div>

</dspace:layout>
