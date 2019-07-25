<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Community home JSP
  -
  - Attributes required:
  -    community             - Community to render home page for
  -    collections           - array of Collections in this community
  -    subcommunities        - array of Sub-communities in this community
  -    last.submitted.titles - String[] of titles of recently submitted items
  -    last.submitted.urls   - String[] of URLs of recently submitted items
  -    admin_button - Boolean, show admin 'edit' button
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>

<%@ page import="org.dspace.app.webui.servlet.admin.EditCommunitiesServlet" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.browse.BrowseIndex" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.*" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%
    // Retrieve attributes
    Community community = (Community) request.getAttribute( "community" );
    Collection[] collections =
        (Collection[]) request.getAttribute("collections");
    Community[] subcommunities =
        (Community[]) request.getAttribute("subcommunities");
    
    Boolean editor_b = (Boolean)request.getAttribute("editor_button");
    boolean editor_button = (editor_b == null ? false : editor_b.booleanValue());
    Boolean add_b = (Boolean)request.getAttribute("add_button");
    boolean add_button = (add_b == null ? false : add_b.booleanValue());
    Boolean remove_b = (Boolean)request.getAttribute("remove_button");
    boolean remove_button = (remove_b == null ? false : remove_b.booleanValue());

	// get the browse indices
    BrowseIndex[] bis = BrowseIndex.getBrowseIndices();

    // Put the metadata values into guaranteed non-null variables
    String name = community.getMetadata("name");
    String intro = community.getMetadata("introductory_text");
    String copyright = community.getMetadata("copyright_text");
    String sidebar = community.getMetadata("side_bar_text");
    Bitstream logo = community.getLogo();
    
    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "comm:" + ConfigurationManager.getProperty("webui.feed.formats");
    }
    
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));
%>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<dspace:layout locbar="commLink" title="<%= name %>" feedData="<%= feedData %>">
<div class="well">
	<div class="row">
		<div class="col-md-8">
			<h2><%= name %>
			<%
				if(ConfigurationManager.getBooleanProperty("webui.strengths.show"))
				{
	%>
					: [<%= ic.getCount(community) %>]
	<%
				}
	%>
			<small><fmt:message key="jsp.community-home.heading1"/></small>
			<%-- <a class="statisticsLink btn btn-info" href="<%= request.getContextPath() %>/handle/<%= community.getHandle() %>/statistics"><fmt:message key="jsp.community-home.display-statistics"/></a> --%>
			</h2>
				
			<% if (StringUtils.isNotBlank(intro)) { %>
			<%= intro %>
			<% } %>
		</div>
	<%  if (logo != null) { %>
		 <div class="col-md-4">
			<img class="img-responsive" alt="Logo" src="<%= request.getContextPath() %>/retrieve/<%= logo.getID() %>" />
		 </div> 
	<% } %>
	</div>
</div>
<p class="copyrightText"><%= copyright %></p>
	<div class="row">
	<div class="col-md-4">
    	<%= sidebar %>
	</div>
</div>	

<%-- Browse --%>
<div class="panel panel-primary">
	<div class="panel-heading"><fmt:message key="jsp.general.browse"/></div>
	<div class="panel-body">
   				<%-- Insert the dynamic list of browse options --%>
<%
	for (int i = 0; i < bis.length; i++)
	{
		String key = "browse.menu." + bis[i].getName();
%>
	<form method="get" action="<%= request.getContextPath() %>/handle/<%= community.getHandle() %>/browse" class='inline-block mr2'>
		<input type="hidden" name="type" value="<%= bis[i].getName() %>"/>
		<%-- <input type="hidden" name="community" value="<%= community.getHandle() %>" /> --%>
		<input class="btn btn-default" type="submit" name="submit_browse" value="<fmt:message key="<%= key %>"/>"/>
	</form>
<%	
	}
%>
			
	</div>
</div>

<form action="<c:url value='/mydspace'/>" method="post">
	<input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE %>" />
	<button class="btn btn-success col-md-12" type="submit" name="submit_new" value="<fmt:message key="jsp.mydspace.main.start.button"/>">
		<fmt:message key="jsp.mydspace.main.start.button"/></button>
</form>

<div class="row">
	<%@ include file="/discovery/static-tagcloud-facet.jsp" %>
</div>
	
<div class="row">
<%
	boolean showLogos = ConfigurationManager.getBooleanProperty("jspui.community-home.logos", true);
	if (subcommunities.length != 0)
    {
%>
	<div class="col-md-6">

		<h3><fmt:message key="jsp.community-home.heading3"/></h3>
   
        <div class="list-group">
<%
        for (int j = 0; j < subcommunities.length; j++)
        {
%>
			<div class="list-group-item row">  
<%  
		Bitstream logoCom = subcommunities[j].getLogo();
		if (showLogos && logoCom != null) { %>
			<div class="col-md-3">
		        <img alt="Logo" class="img-responsive" src="<%= request.getContextPath() %>/retrieve/<%= logoCom.getID() %>" /> 
			</div>
			<div class="col-md-9">
<% } else { %>
			<div class="col-md-12">
<% }  %>		

	      <h4 class="list-group-item-heading"><a href="<%= request.getContextPath() %>/handle/<%= subcommunities[j].getHandle() %>">
	                <%= subcommunities[j].getMetadata("name") %></a>
<%
                if (ConfigurationManager.getBooleanProperty("webui.strengths.show"))
                {
%>
                    [<%= ic.getCount(subcommunities[j]) %>]
<%
                }
%>
	    		<% if (remove_button) { %>
	                <form class="btn-group" method="post" action="<%=request.getContextPath()%>/tools/edit-communities">
			          <input type="hidden" name="parent_community_id" value="<%= community.getID() %>" />
			          <input type="hidden" name="community_id" value="<%= subcommunities[j].getID() %>" />
			          <input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_DELETE_COMMUNITY%>" />
	                  <button type="submit" class="btn btn-xs btn-danger"><span class="glyphicon glyphicon-trash"></span></button>
	                </form>
	    		<% } %>
			    </h4>
                <p class="collectionDescription"><%= subcommunities[j].getMetadata("short_description") %></p>
            </div>
         </div> 
<%
        }
%>
   </div>
</div>
<%
    }
%>


<c:if test='${!empty collections}'>
	<h3><fmt:message key="jsp.community-home.heading2"/></h3>
	<div class="col-md-12">
		<!-- Always visible non-empty collections -->
		<div class="list-group">
			<c:forEach items='${nonEmptyCollections}' var='collection'>
				<div class="list-group-item row">  
					<c:if test='${!empty collection.logo}'>
						<div class="col-md-3">
							<img alt="Logo" class="img-responsive" src="<c:url value='/retrieve/${collection.logo.ID}' />" /> 
						</div>
					</c:if>
					<h4 class="list-group-item-heading">
						<a href="<c:url value='/handle/${collection.handle}' />">
							${collection.name}
						</a>
							
						<c:if test='${remove_button}'>
							<form class="inline-block right" method="post" action="<c:url value='/tools/edit-communities' />">
								<input type="hidden" name="parent_community_id" value="${community.ID}" />
								<input type="hidden" name="community_id" value="${community.ID}" />
								<input type="hidden" name="collection_id" value="${collection.ID}" />
								<input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_DELETE_COLLECTION%>" />
								<button type="submit" class="btn btn-xs btn-danger"><span class="glyphicon glyphicon-trash"></span></button>
							</form>
						</c:if>
					</h4>
					<p class="collectionDescription">${collection.getMetadata("short_description")}</p>
				</div>
			</c:forEach>
		</div>

		<!-- Accordion initially hidden empty collections -->
		<c:if test='${!empty emptyCollections}'>
			<a href='#emptyCollectionsList' data-toggle="collapse" data-target="#emptyCollectionsList">
				<h4>Empty Collections (show/hide)</h4>
			</a>
			<div class="list-group collapse out" id='emptyCollectionsList'>
				<c:forEach items='${emptyCollections}' var='collection'>
					<div class="list-group-item row">  
						<c:if test='${!empty collection.logo}'>
							<div class="col-md-3">
								<img alt="Logo" class="img-responsive" src="<c:url value='/retrieve/${collection.logo.ID}' />" /> 
							</div>
						</c:if>
						<h4 class="list-group-item-heading">
							<a href="<c:url value='/handle/${collection.handle}' />">
								${collection.name}
							</a>
								
							<c:if test='${remove_button}'>
								<form class="inline-block right" method="post" action="<c:url value='/tools/edit-communities' />">
									<input type="hidden" name="parent_community_id" value="${community.ID}" />
									<input type="hidden" name="community_id" value="${community.ID}" />
									<input type="hidden" name="collection_id" value="${collection.ID}" />
									<input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_DELETE_COLLECTION%>" />
									<button type="submit" class="btn btn-xs btn-danger"><span class="glyphicon glyphicon-trash"></span></button>
								</form>
							</c:if>
						</h4>
						<p class="collectionDescription">${collection.getMetadata("short_description")}</p>
					</div>
				</c:forEach>
			</div>
		</c:if>

	</div>
</c:if>


</div>
    <dspace:sidebar>
    <% if(editor_button || add_button)  // edit button(s)
    { %>
		 <div class="panel panel-warning">
             <div class="panel-heading">
             	<fmt:message key="jsp.admintools"/>
             	<span class="pull-right">
             		<dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.site-admin\")%>"><fmt:message key="jsp.adminhelp"/></dspace:popup>
             	</span>
             	</div>
             <div class="panel-body">
             <% if(editor_button) { %>
	            <form method="post" action="<%=request.getContextPath()%>/tools/edit-communities">
		          <input type="hidden" name="community_id" value="<%= community.getID() %>" />
		          <input type="hidden" name="action" value="<%=EditCommunitiesServlet.START_EDIT_COMMUNITY%>" />
                  <%--<input type="submit" value="Edit..." />--%>
                  <input class="btn btn-default col-md-12" type="submit" value="<fmt:message key="jsp.general.edit.button"/>" />
                </form>
             <% } %>
             <% if(add_button) { %>

				<form method="post" action="<%=request.getContextPath()%>/tools/collection-wizard">
		     		<input type="hidden" name="community_id" value="<%= community.getID() %>" />
                    <input class="btn btn-default col-md-12" type="submit" value="<fmt:message key="jsp.community-home.create1.button"/>" />
                </form>
                
                <form method="post" action="<%=request.getContextPath()%>/tools/edit-communities">
                    <input type="hidden" name="action" value="<%= EditCommunitiesServlet.START_CREATE_COMMUNITY%>" />
                    <input type="hidden" name="parent_community_id" value="<%= community.getID() %>" />
                    <%--<input type="submit" name="submit" value="Create Sub-community" />--%>
                    <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.community-home.create2.button"/>" />
                 </form>
             <% } %>
            <% if( editor_button ) { %>
                <form method="post" action="<%=request.getContextPath()%>/mydspace">
                  <input type="hidden" name="community_id" value="<%= community.getID() %>" />
                  <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_EXPORT_ARCHIVE %>" />
                  <input class="btn btn-default col-md-12" type="submit" value="<fmt:message key="jsp.mydspace.request.export.community"/>" />
                </form>
              <form method="post" action="<%=request.getContextPath()%>/mydspace">
                <input type="hidden" name="community_id" value="<%= community.getID() %>" />
                <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_MIGRATE_ARCHIVE %>" />
                <input class="btn btn-default col-md-12" type="submit" value="<fmt:message key="jsp.mydspace.request.export.migratecommunity"/>" />
              </form>
               <form method="post" action="<%=request.getContextPath()%>/dspace-admin/metadataexport">
                 <input type="hidden" name="handle" value="<%= community.getHandle() %>" />
                 <input class="btn btn-default col-md-12" type="submit" value="<fmt:message key="jsp.general.metadataexport.button"/>" />
               </form>
			<% } %>
			</div>
		</div>
    <% } %>

	<%
		int discovery_panel_cols = 12;
		int discovery_facet_cols = 12;
	%>
	<%@ include file="/discovery/static-sidebar-facet.jsp" %>
  </dspace:sidebar>
</dspace:layout>
