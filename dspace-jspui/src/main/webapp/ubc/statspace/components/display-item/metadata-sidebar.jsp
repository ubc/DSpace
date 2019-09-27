<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<c:set var="itemRetriever" value="${requestScope[param.retrieverVar]}"></c:set>

<!-- Creator -->
<div class='panel panel-default'>
	<div class='panel-heading'>
		<h4 class='panel-title'><span class='glyphicon glyphicon-education'></span> Creator</h4>
	</div>
	<ul class='list-group'> 
		<c:forEach items="${itemRetriever.authors}" var="author" varStatus="loop">
			<li class='list-group-item'>${fn:escapeXml(author)}</li>
		</c:forEach>
	</ul> 
</div>
<!-- Subjects -->
<jsp:include page="/ubc/statspace/components/display-item/subjects-list.jsp">
	<jsp:param name="retrieverVar" value="itemRetriever" />
</jsp:include>
<!-- Resource Types -->
<div class='panel panel-default'>
	<div class='panel-heading'>
		<h4 class="panel-title"><span class='glyphicon glyphicon-bookmark'></span> Resource Type</h4>
	</div>
	<ul class='list-group'>
		<c:forEach items="${itemRetriever.resourceTypes}" var="type" varStatus="loopStatus">
			<li class='list-group-item'>
				<c:url value="/simple-search" var="url">
					<c:param name="filtername" value="resourceType" />
					<c:param name="filterquery" value="${type}" />
					<c:param name="filtertype" value="equals" />
				</c:url>

				<a class="resourceLink" href="${url}" target="_blank" title="${type}">
					${type}
				</a>
			</li>
		</c:forEach>
	</ul>
</div>
<!-- Related Materials -->
<c:if test="${!empty itemRetriever.relatedMaterials}">
	<div class='panel panel-default'>
		<div class='panel-heading'>
			<h4 class="panel-title"><span class='glyphicon glyphicon-link'></span> Related Resource</h4>
		</div>
		<ul class='list-group'>
			<c:forEach items="${itemRetriever.relatedMaterials}" var="prereq">
				<li class='list-group-item'>${prereq}</li>
			</c:forEach>
		</ul>
	</div>
</c:if>
<!-- Available in Alternative Languages -->
<c:if test="${!empty itemRetriever.alternativeLanguages}">
	<div class='panel panel-default'>
		<div class='panel-heading'>
			<h4 class="panel-title"><span class='glyphicon glyphicon-plane'></span> Alternative Language</h4>
		</div>
		<ul class='list-group'>
			<c:forEach items="${itemRetriever.alternativeLanguages}" var="altLangs">
				<li class='list-group-item'>${altLangs}</li>
			</c:forEach>
		</ul>
	</div>
</c:if>
<!-- Author, Dates, Access -->
<c:if test='${!empty itemRetriever.dateCreated}'>
	<div title='Date copyrighted/created.'>
		<h5 class="text-center">Date Created</h5>
		<p class='text-center'><small><dspace:date date="${itemRetriever.dateCreated}" notime="true" clientLocalTime="true" /></small></p>
	</div>
</c:if>
<c:if test='${!empty itemRetriever.dateApproved}'>
	<div title='Date accepted into <fmt:message key="jsp.layout.header-default.alt" />.'>
		<h5 class="text-center">Date Approved</h5>
		<p class='text-center'><small><dspace:date date="${itemRetriever.dateApproved}" clientLocalTime="true" /></small></p>
	</div>
</c:if>
<c:if test='${!empty itemRetriever.dateSubmitted}'>
	<h5 class="text-center">Access</h5>
	<p class='text-center'>
		<small>
			<c:choose>
				<c:when test="${itemRetriever.isRestricted}">
					<i class="glyphicon glyphicon-lock restrictionIconColorInstructorOnly"></i> Instructor Only
				</c:when>
				<c:otherwise>
					<i class="glyphicon glyphicon-globe restrictionIconColorEveryone"></i> Everyone
				</c:otherwise>
			</c:choose>
		</small>
	</p>
</c:if>