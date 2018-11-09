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
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

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

<% // disable browser cache for this page
   response.setHeader("Pragma", "no-cache");
   response.setHeader("Cache-Control", "no-cache");
   response.setDateHeader("Expires", 0);
%>

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

	pageContext.setAttribute("itemID", item.getID());
	pageContext.setAttribute("handle", handle);
	//pageContext.setAttribute("versionID", history.getVersion(item)!=null?history.getVersion(item).getVersionId():null);
	pageContext.setAttribute("hasAdminButton", admin_button);
	pageContext.setAttribute("hasVersionButton", hasVersionButton);
	pageContext.setAttribute("hasVersionHistory", hasVersionHistory);
	pageContext.setAttribute("stepExportArchive", MyDSpaceServlet.REQUEST_EXPORT_ARCHIVE);
	pageContext.setAttribute("stepMigrateArchive", MyDSpaceServlet.REQUEST_MIGRATE_ARCHIVE);
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
<%
    }

    String displayStyle = (displayAll ? "full" : "");
%>

		
	<c:if test="${admin_button}">
		<jsp:include page="/ubc/statspace/components/display-item/display-item-admin-tools.jsp">
			<jsp:param name="itemID" value="${itemID}" />
			<jsp:param name="handle" value="${handle}" />
			<jsp:param name="hasAdminButton" value="${hasAdminButton}" />
			<jsp:param name="hasVersionButton" value="${hasVersionButton}" />
			<jsp:param name="hasVersionHistory" value="${hasVersionHistory}" />
			<jsp:param name="stepExportArchive" value="${stepExportArchive}" />
			<jsp:param name="stepMigrateArchive" value="${stepMigrateArchive}" />
		</jsp:include>
	</c:if>
	<!-- Title & Summary Section -->
	<div class='media'>
		<div class='media-left ${itemRetriever.hasPlaceholderThumbnail?'fadedSection':''}'>
			<img class='media-object displayItemTitleThumbnail' src='${itemRetriever.thumbnail}' alt='thumbnail'>
		</div>
		<div class='media-body'>
			<h1 class="marginTopNone">${itemRetriever.title}</h1> 
            <c:if test="${commenting}">
                <fmt:formatNumber value="${itemRetriever.avgRating}" pattern="0.0" var="roundedAvgRating"/>
                <a href="#commentBlock" style="text-decoration:none;">
                <span class="starRating">
                    <c:set var="starDisplayed" value="${0}" />
                    <c:forEach begin="1" end="${(roundedAvgRating - (roundedAvgRating mod 1))}">
                        <span class="glyphicon glyphicon-star"></span>
                        <c:set var="starDisplayed" value="${starDisplayed+1}" />
                    </c:forEach>
                    <c:choose>
                        <c:when test="${(roundedAvgRating * 10) mod 10 ge 5}">
                            <span class="glyphicon glyphicon-star glyphicon-half-star"></span>
                            <c:set var="starDisplayed" value="${starDisplayed+1}" />
                        </c:when>
                    </c:choose>
                    <c:forEach begin="1" end="${5 - starDisplayed}">
                        <span class="glyphicon glyphicon-star-empty"></span>
                    </c:forEach>
                    (${itemRetriever.activeRatingCount})
                </span>
                </a>
            </c:if>
			<p>${itemRetriever.summary}</p>
			<c:if test='${!empty itemRetriever.resourceURL}'>
				<div class='panel panel-default' title="This resource's primary content is not in <fmt:message key='jsp.layout.header-default.alt' />, but located externally, please visit the link to see the content.">
					<div class="panel-body">
						<strong>Resource URL: <a href="${itemRetriever.resourceURL}">${itemRetriever.resourceURL}</a></strong>
					</div>
				</div>
			</c:if>
		</div>
	</div>
	<!-- Tabs Bar -->
	<ul class="nav nav-tabs displayItemTabsBar" role="tablist">
		<li role="presentation" class="active">
			<a href="#MetadataTab" aria-controls="MetadataTab" role="tab" data-toggle="tab">
				<i class="glyphicon glyphicon-list-alt"></i> About This Resource
			</a>
		</li>
		<li role="presentation">
			<a href="#FilesTab" aria-controls="FilesTab" role="tab" data-toggle="tab">
				<i class="glyphicon glyphicon-folder-open"></i> Files
			</a>
		</li>
		<li role="presentation">
			<a href="<c:url value='${itemRetriever.packageZipURL}' />">
				<i class="glyphicon glyphicon-save-file"></i> Download All Files
			</a>
		</li>
	</ul>
	<!-- Tabs Content -->
	<div class="tab-content displayItemTabsContent">
		<!-- Metadata Tab -->
		<div role="tabpanel" class="tab-pane active" id="MetadataTab">
			<div class='row'>
				<!-- Metadata Main Content -->
				<div class='col-sm-9'>
					<!-- Pre-Reqs -->
					<c:if test="${!empty itemRetriever.prereqs}">
						<h3 class='displayItemSectionHeader'>
							Pre-requisite Knowledge
						</h3> 
						<ul>
							<c:forEach items="${itemRetriever.prereqs}" var="prereq">
								<li>${prereq}</li>
							</c:forEach>
						</ul>
					</c:if>
					<!-- Learning Objectives -->
					<c:if test="${!empty itemRetriever.objectives}">
						<h3 class='displayItemSectionHeader'>
							Learning Objectives
						</h3>
						<ul>
							<c:forEach items="${itemRetriever.objectives}" var="prereq">
								<li>${prereq}</li>
							</c:forEach>
						</ul>
					</c:if>
					<!-- Description -->
					<c:if test="${!empty itemRetriever.description}">
						<h3 class="displayItemSectionHeader">Description</h3>
						<div> 
							${itemRetriever.description}
						</div>
					</c:if>
					<!-- Suggest Uses & Tips merged with What We Learned-->
					<c:if test="${!empty itemRetriever.whatWeLearned}">
						<h3 class="displayItemSectionHeader">Suggested Uses, Tips and Discoveries</h3>
						<div>
							${itemRetriever.whatWeLearned}
						</div>
					</c:if>
					<c:if test="${!empty itemRetriever.relatedResources}">
						<h3 class="displayItemSectionHeader">Related Resources</h3>
						<div class="row discovery-result-results">
							<div class="col-md-12 searchResultsWrap">
							<c:forEach items="${itemRetriever.relatedResources}" var="resource">
								<div class="col-md-4 col-sm-6 col-xs-12">
									<div class='panel panel-default'>
										<div class='panel-body'>
											<a class="center-block searchResultThumbnail img-rounded ${resource.hasPlaceholderThumbnail ? "SimpleSearchPlaceholderThumbnail":""}" href="${result.url}" 
											   style='background: center / contain no-repeat url(${resource.thumbnail});'>
												<div class="text-center searchResultThumbnailPlaceholder">
												</div>
											</a>

											<div class="caption">
												<h4 class="text-center">
													<a href="${resource.URL}">${resource.title}</a>
												</h4>
												<p class='text-center'>
													${resource.summary}
												</p>
											</div>
										</div>
									</div>
								</div>
							</c:forEach>
							</div>
						</div>
					</c:if>
				</div>
				<!-- Metadata Side Bar -->
				<div class='col-sm-3'>
					<jsp:include page="/ubc/statspace/components/display-item/metadata-sidebar.jsp">
						<jsp:param name="retrieverVar" value="itemRetriever" />
					</jsp:include>
				</div>
			</div>
		</div>
		<!-- Files Tab -->
		<div role="tabpanel" class="tab-pane" id="FilesTab">
			<ul class="nav nav-pills">
				<li role="presentation" class="active">
					<a href="#FilesTabTileView" aria-controls="FilesTabTileView" role="tab" data-toggle="tab">
						<i class="glyphicon glyphicon-th-large"></i>
					</a>
				</li>
				<li role="presentation">
					<a href="#FilesTabListView" aria-controls="FilesTabTileView" role="tab" data-toggle="tab">
						<i class="glyphicon glyphicon-th-list"></i>
					</a>
				</li>
			</ul>
			<c:if test='${empty itemRetriever.files}'>
				<div class="alert alert-info" role="alert"><strong>No Files Found!</strong> Files may be restricted to instructors only. </div>
			</c:if>
			<div class="tab-content">
				<div role="tabpanel" class="tab-pane active" id="FilesTabTileView">
					<jsp:include page="/ubc/statspace/components/display-item/files-tile-view.jsp">
						<jsp:param name="retrieverVar" value="itemRetriever" />
					</jsp:include>
				</div>
				<div role="tabpanel" class="tab-pane" id="FilesTabListView">
					<jsp:include page="/ubc/statspace/components/display-item/files-list-view.jsp">
						<jsp:param name="retrieverVar" value="itemRetriever" />
					</jsp:include>
				</div>
			</div>
		</div>
	</div>

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

    <c:if test="${commenting}">
        <fmt:parseNumber var="commentPage" value="${param.commentPage}" integerOnly="true"/>

        <jsp:include page="/ubc/statspace/components/display-item/comments-view.jsp">
            <jsp:param name="itemVar" value="item" />
            <jsp:param name="retrieverVar" value="itemRetriever" />
            <jsp:param name="canLeaveCommentVar" value="canLeaveComment" />
            <jsp:param name="canDeleteCommentVar" value="canDeleteComment" />
            <jsp:param name="commentPerPageVar" value="commentPerPage" />
            <jsp:param name="commentPageVar" value="${commentPage}" />
            <jsp:param name="maxTitleLengthVar" value="maxTitleLength" />
            <jsp:param name="maxDetailLengthVar" value="maxDetailLength" />
            <jsp:param name="canCommentWithRealNameVar" value="canCommentWithRealName" />
            <jsp:param name="commentingAnonymousDisplayNameVar" value="commentingAnonymousDisplayName" />
            <jsp:param name="commentingRealDisplayNameVar" value="commentingRealDisplayName" />
            <jsp:param name="ratingDescriptionMapVar" value="ratingDescriptionMap" />
        </jsp:include>
    </c:if>

    <%-- Create Commons Link --%>
<%
    if (cc_url != null)
    {
%>
	<c:choose>
		<c:when test="${not empty licenseInfo}">
			<div class="submitFormHelp alert alert-info">
				<div class="media">
					<div class="media-left">
						<a href="<c:url value='${licenseInfo.licenseUrl}' />" target="_blank">
							<img src="<c:url value='${licenseInfo.badgeUrl}' />" alt="${licenseInfo.shortName} Commons" class="media-object" />
						</a>
					</div>
					<div class="media-body">
						<fmt:message key="jsp.display-item.text3"/>
						<a href="<c:url value='${licenseInfo.licenseUrl}' />">${licenseInfo.fullName} (${licenseInfo.shortName})</a>
					</div>
				</div>
			</div>
		</c:when>
		<c:otherwise>
			<p class="submitFormHelp alert alert-info"><fmt:message key="jsp.display-item.text3"/> <a href="<%= cc_url %>"><fmt:message key="jsp.display-item.license"/></a>
			<a href="<%= cc_url %>"><img src="<%= request.getContextPath() %>/image/cc-somerights.gif" border="0" alt="Creative Commons" style="margin-top: -5px;" class="pull-right"/></a>
			</p>
			<!--
			<%= cc_rdf %>
			-->
		</c:otherwise>
	</c:choose>
<%
    } else {
%>
    <p class="submitFormHelp alert alert-info"><fmt:message key="jsp.display-item.copyright"/></p>
<%
    } 
%>    

	<%-- <strong>Please use this identifier to cite or link to this item:
	<code><%= HandleManager.getCanonicalForm(handle) %></code></strong>--%>
	<div class="well"><fmt:message key="jsp.display-item.identifier"/>
	<code><%= HandleManager.getCanonicalForm(handle) %></code></div>

	<%-- DSpace restricts stats access to admins only by default, not sure if we want to change that --%>
	<c:if test="${hasAdminAccess}">
		<a class="statisticsLink  btn btn-primary" href="<%= request.getContextPath() %>/handle/<%= handle %>/statistics"><fmt:message key="jsp.display-item.display-statistics"/></a>
	</c:if>

</dspace:layout>
