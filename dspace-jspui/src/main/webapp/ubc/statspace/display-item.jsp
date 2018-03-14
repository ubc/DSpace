<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Renders a whole HTML page for displaying item metadata.  Simply includes
  - the relevant item display component in a standard HTML page.
  -
  - Attributes:
  -    display.all - Boolean - if true, display full metadata record
  -    item        - the Item to display
  -    collections - Array of Collections this item appears in.  This must be
  -                  passed in for two reasons: 1) item.getCollections() could
  -                  fail, and we're already committed to JSP display, and
  -                  2) the item might be in the process of being submitted and
  -                  a mapping between the item and collection might not
  -                  appear yet.  If this is omitted, the item display won't
  -                  display any collections.
  -    admin_button - Boolean, show admin 'edit' button
  --%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Metadatum" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.handle.HandleManager" %>
<%@ page import="org.dspace.license.CreativeCommons" %>
<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@page import="org.dspace.versioning.Version"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="org.dspace.app.webui.util.VersionUtil"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@page import="org.dspace.authorize.AuthorizeManager"%>
<%@page import="java.util.List"%>
<%@page import="org.dspace.core.Constants"%>
<%@page import="org.dspace.eperson.EPerson"%>
<%@page import="org.dspace.versioning.VersionHistory"%>

<%@page import="org.dspace.app.webui.ubc.statspace.retriever.ItemRetriever"%>

<%
    // Attributes
    Boolean displayAllBoolean = (Boolean) request.getAttribute("display.all");
    boolean displayAll = (displayAllBoolean != null && displayAllBoolean.booleanValue());
    Boolean suggest = (Boolean)request.getAttribute("suggest.enable");
    boolean suggestLink = (suggest == null ? false : suggest.booleanValue());
    Item item = (Item) request.getAttribute("item");
    Collection[] collections = (Collection[]) request.getAttribute("collections");
    Boolean admin_b = (Boolean)request.getAttribute("admin_button");
    boolean admin_button = (admin_b == null ? false : admin_b.booleanValue());
    
    // get the workspace id if one has been passed
    Integer workspace_id = (Integer) request.getAttribute("workspace_id");

    // get the handle if the item has one yet
    String handle = item.getHandle();

    // CC URL & RDF
    String cc_url = CreativeCommons.getLicenseURL(item);
    String cc_rdf = CreativeCommons.getLicenseRDF(item);

    // Full title needs to be put into a string to use as tag argument
    String title = "";
    if (handle == null)
 	{
		title = "Workspace Item";
	}
	else 
	{
		Metadatum[] titleValue = item.getDC("title", null, Item.ANY);
		if (titleValue.length != 0)
		{
			title = titleValue[0].value;
		}
		else
		{
			title = "Item " + handle;
		}
	}
    
    Boolean versioningEnabledBool = (Boolean)request.getAttribute("versioning.enabled");
    boolean versioningEnabled = (versioningEnabledBool!=null && versioningEnabledBool.booleanValue());
    Boolean hasVersionButtonBool = (Boolean)request.getAttribute("versioning.hasversionbutton");
    Boolean hasVersionHistoryBool = (Boolean)request.getAttribute("versioning.hasversionhistory");
    boolean hasVersionButton = (hasVersionButtonBool!=null && hasVersionButtonBool.booleanValue());
    boolean hasVersionHistory = (hasVersionHistoryBool!=null && hasVersionHistoryBool.booleanValue());
    
    Boolean newversionavailableBool = (Boolean)request.getAttribute("versioning.newversionavailable");
    boolean newVersionAvailable = (newversionavailableBool!=null && newversionavailableBool.booleanValue());
    Boolean showVersionWorkflowAvailableBool = (Boolean)request.getAttribute("versioning.showversionwfavailable");
    boolean showVersionWorkflowAvailable = (showVersionWorkflowAvailableBool!=null && showVersionWorkflowAvailableBool.booleanValue());
    
    String latestVersionHandle = (String)request.getAttribute("versioning.latestversionhandle");
    String latestVersionURL = (String)request.getAttribute("versioning.latestversionurl");
    
    VersionHistory history = (VersionHistory)request.getAttribute("versioning.history");
    List<Version> historyVersions = (List<Version>)request.getAttribute("versioning.historyversions");
%>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<dspace:layout title="<%= title %>">
<%
    if (handle != null)
    {
%>

		<%		
		if (newVersionAvailable)
		   {
		%>
		<div class="alert alert-warning"><b><fmt:message key="jsp.version.notice.new_version_head"/></b>		
		<fmt:message key="jsp.version.notice.new_version_help"/><a href="<%=latestVersionURL %>"><%= latestVersionHandle %></a>
		</div>
		<%
		    }
		%>
		
		<%		
		if (showVersionWorkflowAvailable)
		   {
		%>
		<div class="alert alert-warning"><b><fmt:message key="jsp.version.notice.workflow_version_head"/></b>		
		<fmt:message key="jsp.version.notice.workflow_version_help"/>
		</div>
		<%
		    }
		%>
		

                <%-- <strong>Please use this identifier to cite or link to this item:
                <code><%= HandleManager.getCanonicalForm(handle) %></code></strong>--%>
                <div class="well"><fmt:message key="jsp.display-item.identifier"/>
                <code><%= HandleManager.getCanonicalForm(handle) %></code></div>
<%
        if (admin_button)  // admin edit button
        { %>
        <dspace:sidebar>
            <div class="panel panel-warning">
            	<div class="panel-heading"><fmt:message key="jsp.admintools"/></div>
            	<div class="panel-body">
                <form method="get" action="<%= request.getContextPath() %>/tools/edit-item">
                    <input type="hidden" name="item_id" value="<%= item.getID() %>" />
                    <%--<input type="submit" name="submit" value="Edit...">--%>
                    <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.edit.button"/>" />
                </form>
                <form method="post" action="<%= request.getContextPath() %>/mydspace">
                    <input type="hidden" name="item_id" value="<%= item.getID() %>" />
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_EXPORT_ARCHIVE %>" />
                    <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.mydspace.request.export.item"/>" />
                </form>
                <form method="post" action="<%= request.getContextPath() %>/mydspace">
                    <input type="hidden" name="item_id" value="<%= item.getID() %>" />
                    <input type="hidden" name="step" value="<%= MyDSpaceServlet.REQUEST_MIGRATE_ARCHIVE %>" />
                    <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.mydspace.request.export.migrateitem"/>" />
                </form>
                <form method="post" action="<%= request.getContextPath() %>/dspace-admin/metadataexport">
                    <input type="hidden" name="handle" value="<%= item.getHandle() %>" />
                    <input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.metadataexport.button"/>" />
                </form>
					<% if(hasVersionButton) { %>       
                	<form method="get" action="<%= request.getContextPath() %>/tools/version">
                    	<input type="hidden" name="itemID" value="<%= item.getID() %>" />                    
                    	<input class="btn btn-default col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.version.button"/>" />
                	</form>
                	<% } %> 
                	<% if(hasVersionHistory) { %>			                
                	<form method="get" action="<%= request.getContextPath() %>/tools/history">
                    	<input type="hidden" name="itemID" value="<%= item.getID() %>" />
                    	<input type="hidden" name="versionID" value="<%= history.getVersion(item)!=null?history.getVersion(item).getVersionId():null %>" />                    
                    	<input class="btn btn-info col-md-12" type="submit" name="submit" value="<fmt:message key="jsp.general.version.history.button"/>" />
                	</form>         	         	
					<% } %>
             </div>
          </div>
        </dspace:sidebar>
<%      } %>

<%
    }

    String displayStyle = (displayAll ? "full" : "");
%>

<%
	// all this should be done in the servlet and set as attributes, but
	// I want to keep servlet modifications to a minimum
	ItemRetriever itemRetriever = new ItemRetriever(item, pageContext);
	pageContext.setAttribute("itemRetriever", itemRetriever);
%>
	<!-- SUBMISSION TITLE -->
	<div class='row'>
		<div class='col-md-12'>
			<div class='page-header'>
				<h1>${itemRetriever.title}</h1> 
			</div>
		</div>
	</div>
	
	<div class='row'> 
		<!-- START SUBMISSION MAIN BODY -->
		<div class='col-md-7'> 
			<!-- Summary Main Body-->
			<div class='lead panel panel-default'> 
				<div class='panel-body'>
					${itemRetriever.summary}
				</div>
			</div> 

			<!-- Files List -->
			<c:forEach items="${itemRetriever.files}" var="result">
				<div class="media">
					<div class="pull-left media-left">
						<c:choose>
							<c:when test="${empty result.thumbnail}">
								<div class="text-center displayItemThumbnailPlaceholder">
									<%-- table is a simple but stupid workaround for vertical centering placeholder image --%>
									<table>
										<tr>
											<td>
												<span class="glyphicon glyphicon-file"></span>
											</td>
										</tr>
									</table>
								</div>
							</c:when>
							<c:otherwise>
								<img class="media-objec img-thumbnail" src="${result.thumbnail}" />
							</c:otherwise>
						</c:choose>
					</div>
					<div class="media-body">
						<h4 class="media-heading">${result.name} <span class="badge">${result.size}</span></h4>
						<a class="btn btn-primary" href="${result.link}">Open/View</a>
					</div>
				</div>
			</c:forEach>

			<hr />

			<!-- Pre-Reqs Main Body -->
			<c:if test="${!empty itemRetriever.prereqs}">
			<div class='panel panel-default'>
				<div class='panel-heading'>
					Pre-Requisite Knowledge
				</div> 
				<ul class='list-group'>
					<c:forEach items="${itemRetriever.prereqs}" var="prereq">
						<li class='list-group-item'>${prereq}</li>
					</c:forEach>
				</ul>
			</div>
			</c:if>

			<!-- Learning Objectives Main Body -->
			<c:if test="${!empty itemRetriever.objectives}">
			<div class='panel panel-default'>
				<div class='panel-heading'>
					Learning Objectives
				</div> 
				<ul class='list-group'>
					<c:forEach items="${itemRetriever.objectives}" var="prereq">
						<li class='list-group-item'>${prereq}</li>
					</c:forEach>
				</ul>
			</div>
			</c:if>
		</div> 
		<!-- END SUBMISSION MAIN BODY -->

		<!-- START RIGHT SIDE BAR -->
		<div class='col-md-5'> 
			<!-- Tags Side Bar -->
			<div class="panel panel-info">
				<div class="panel-heading">
					<h3 class="panel-title"><i class="glyphicon glyphicon-tag"></i> Subjects</h3>
				</div>
				<ul class="list-group subjectsList">
					<c:forEach items="${itemRetriever.subjects}" var="subject">
						<li class="list-group-item">
							<span class="label label-default level1">${subject.level1}</span>
							<span class="label label-default level2">${subject.level2}</span>
							<span class="label label-default level3"><div>${subject.level3}</div></span>
						</li>
					</c:forEach>
				</ul>
			</div>

			<!-- Resource Types -->
			<div class="panel panel-default">
				<div class="panel-heading">
					<h3 class="panel-title"><i class="glyphicon glyphicon-bookmark"></i> Resource Types</h3>
				</div>
				<div class="panel-body">
					<c:forEach items="${itemRetriever.resourceTypes}" var="type">
						<span class="label label-default labelResource">
							${type}
						</span>
					</c:forEach>
				</div>
			</div>

			<%-- Not implemented
			<!-- Related Materials Side Bar -->
			<div class="panel panel-warning">
				<div class="panel-heading">
					<h3 class="panel-title"><i class="glyphicon glyphicon-link"></i> Related Materials</h3>
				</div>
				<div class="panel-body">
					<ul>
						<li><a target="_blank" href="http://www.cwsei.ubc.ca/resources/files/Demo_WorkshopSummary_CWSEI-EOY2015.pdf">"Making the most of demonstrations, videos, animations, or simulations in lectures and laboratories" (J. Maxwell and J. Stang) <span class="glyphicon glyphicon-new-window"></span></a></li>
						<li><a target="_blank" href="video-example.jsp">Video: Sampling Distribution of the Mean <span class="glyphicon glyphicon-new-window"></span></a></li>
						<li><a target="_blank" href="pdf_folder/Applet1InstructorGuide.pdf">Instructor Guide</a> and <a target="_blank" href="pdf_folder/Applet1Qs.pdf">Activity Sheet</a></li>
					</ul>
				</div>
			</div>
			--%>
		</div> 
		<!-- END RIGHT SIDE BAR -->

	</div> 

	<!-- SUBMISSION FOOTER -->
	<h2><i class="glyphicon glyphicon-list-alt"></i> Description</h2>
	<div>
		${itemRetriever.description}
	</div>

	<!-- What We Learned Side Bar -->
	<c:if test="${!empty itemRetriever.whatWeLearned}">
	<h3><i class="glyphicon glyphicon-book"></i> Suggested Uses, Tips and Discoveries</h3>
	<div>
		${itemRetriever.whatWeLearned}
	</div>
	</c:if>

	<h3><i class="glyphicon glyphicon-pencil"></i> About This Resource</h3> 
	<p> 
	Created By: 
		<c:forEach items="${itemRetriever.authors}" var="author" varStatus="loop">
			${author}<c:if test="${!loop.last}">;</c:if>
		</c:forEach>
	</p> 
	<p>Date: ${itemRetriever.date}</p>
	<%-- Not implemented yet, should considering moving some of the right side bar here
	<div class='row'> 
		<div class='col-md-12'> 
			<h3>More RESOURCE TYPE</h3> 
			<p> 
			Some Resource Type 
			</p> 
			<h3>Available in Other Languages</h3> 
			<p> 
			Some Other Languages 
			</p> 
		</div> 
	</div>
	--%>

<%-- Not implemented yet

<div class="container row">
<%
    String locationLink = request.getContextPath() + "/handle/" + handle;

    if (displayAll)
    {
%>
<%
        if (workspace_id != null)
        {
%>
    <form class="col-md-2" method="post" action="<%= request.getContextPath() %>/view-workspaceitem">
        <input type="hidden" name="workspace_id" value="<%= workspace_id.intValue() %>" />
        <input class="btn btn-default" type="submit" name="submit_simple" value="<fmt:message key="jsp.display-item.text1"/>" />
    </form>
<%
        }
        else
        {
%>
    <a class="btn btn-default" href="<%=locationLink %>?mode=simple">
        <fmt:message key="jsp.display-item.text1"/>
    </a>
<%
        }
%>
<%
    }
    else
    {
%>
<%
        if (workspace_id != null)
        {
%>
    <form class="col-md-2" method="post" action="<%= request.getContextPath() %>/view-workspaceitem">
        <input type="hidden" name="workspace_id" value="<%= workspace_id.intValue() %>" />
        <input class="btn btn-default" type="submit" name="submit_full" value="<fmt:message key="jsp.display-item.text2"/>" />
    </form>
<%
        }
        else
        {
%>
    <a class="btn btn-default" href="<%=locationLink %>?mode=full">
        <fmt:message key="jsp.display-item.text2"/>
    </a>
<%
        }
    }

    if (workspace_id != null)
    {
%>
   <form class="col-md-2" method="post" action="<%= request.getContextPath() %>/workspace">
        <input type="hidden" name="workspace_id" value="<%= workspace_id.intValue() %>"/>
        <input class="btn btn-primary" type="submit" name="submit_open" value="<fmt:message key="jsp.display-item.back_to_workspace"/>"/>
    </form>
<%
    } else {

		if (suggestLink)
        {
%>
    <a class="btn btn-success" href="<%= request.getContextPath() %>/suggest?handle=<%= handle %>" target="new_window">
       <fmt:message key="jsp.display-item.suggest"/></a>
<%
        }
%>

    <a class="btn btn-default" href="<%= request.getContextPath() %>/handle/<%= handle %>/evaluations">Show item evaluations</a>

    <a class="statisticsLink  btn btn-primary" href="<%= request.getContextPath() %>/handle/<%= handle %>/statistics"><fmt:message key="jsp.display-item.display-statistics"/></a>

    <a class="btn btn-default" onclick="download_item()">Download</a>

    <div id="downloadProgressInfo" style="display: none">
        <p class="downloadInProgress">Item is being prepared for download...</p>
        <div class="progress">
            <div class="progress-bar progress-bar-striped active" role="progressbar" style="width: 100%">
                <span class="sr-only">In progress...</span>
            </div>
        </div>
        <p class="downloadError" style="display: none"></p>
    </div>
    
    <script type="text/javascript">
        function download_item() {
            var progressDiv = $("#downloadProgressInfo");
            progressDiv.show();
            progressDiv.find("div.progress").show();
            progressDiv.find("p.downloadInProgress").show();
            progressDiv.find("p.downloadError").hide();
            $.ajax("<%= request.getContextPath() %>/handle/<%= handle %>/download")
                .success(function(_, _, jqxhr) {
                    progressDiv.hide();
                    window.location.href = jqxhr.getResponseHeader("Location");
                })
                .error(function(jqxhr, status, errorText) {
                    progressDiv.find("div.progress").hide();
                    progressDiv.find("p.downloadInProgress").hide();
                    progressDiv.find("p.downloadError").show().text(status || errorText);
                });
            }
    </script>
    
    <!-- SFX Link -->
<%
    if (ConfigurationManager.getProperty("sfx.server.url") != null)
    {
        String sfximage = ConfigurationManager.getProperty("sfx.server.image_url");
        if (sfximage == null)
        {
            sfximage = request.getContextPath() + "/image/sfx-link.gif";
        }
%>
        <a class="btn btn-default" href="<dspace:sfxlink item="<%= item %>"/>" /><img src="<%= sfximage %>" border="0" alt="SFX Query" /></a>
<%
    }
    }
%>
</div>

--%>

<br/>
    <%-- Versioning table --%>
<%
    if (versioningEnabled && hasVersionHistory)
    {
        boolean item_history_view_admin = ConfigurationManager
                .getBooleanProperty("versioning", "item.history.view.admin");
        if(!item_history_view_admin || admin_button) {         
%>
	<div id="versionHistory" class="panel panel-info">
	<div class="panel-heading"><fmt:message key="jsp.version.history.head2" /></div>
	
	<table class="table panel-body">
		<tr>
			<th id="tt1" class="oddRowEvenCol"><fmt:message key="jsp.version.history.column1"/></th>
			<th 			
				id="tt2" class="oddRowOddCol"><fmt:message key="jsp.version.history.column2"/></th>
			<th 
				 id="tt3" class="oddRowEvenCol"><fmt:message key="jsp.version.history.column3"/></th>
			<th 
				
				id="tt4" class="oddRowOddCol"><fmt:message key="jsp.version.history.column4"/></th>
			<th 
				 id="tt5" class="oddRowEvenCol"><fmt:message key="jsp.version.history.column5"/> </th>
		</tr>
		
		<% for(Version versRow : historyVersions) {  
		
			EPerson versRowPerson = versRow.getEperson();
			String[] identifierPath = VersionUtil.addItemIdentifier(item, versRow);
		%>	
		<tr>			
			<td headers="tt1" class="oddRowEvenCol"><%= versRow.getVersionNumber() %></td>
			<td headers="tt2" class="oddRowOddCol"><a href="<%= request.getContextPath() + identifierPath[0] %>"><%= identifierPath[1] %></a><%= item.getID()==versRow.getItemID()?"<span class=\"glyphicon glyphicon-asterisk\"></span>":""%></td>
			<td headers="tt3" class="oddRowEvenCol"><% if(admin_button) { %><a
				href="mailto:<%= versRowPerson.getEmail() %>"><%=versRowPerson.getFullName() %></a><% } else { %><%=versRowPerson.getFullName() %><% } %></td>
			<td headers="tt4" class="oddRowOddCol"><%= versRow.getVersionDate() %></td>
			<td headers="tt5" class="oddRowEvenCol"><%= versRow.getSummary() %></td>
		</tr>
		<% } %>
	</table>
	<div class="panel-footer"><fmt:message key="jsp.version.history.legend"/></div>
	</div>
<%
        }
    }
%>
<br/>
    <%-- Create Commons Link --%>
<%
    if (cc_url != null)
    {
%>
    <p class="submitFormHelp alert alert-info"><fmt:message key="jsp.display-item.text3"/> <a href="<%= cc_url %>"><fmt:message key="jsp.display-item.license"/></a>
    <a href="<%= cc_url %>"><img src="<%= request.getContextPath() %>/image/cc-somerights.gif" border="0" alt="Creative Commons" style="margin-top: -5px;" class="pull-right"/></a>
    </p>
    <!--
    <%= cc_rdf %>
    -->
<%
    } else {
%>
    <p class="submitFormHelp alert alert-info"><fmt:message key="jsp.display-item.copyright"/></p>
<%
    } 
%>    
</dspace:layout>
