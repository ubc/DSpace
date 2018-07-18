<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="itemRetriever" value="${requestScope[param.retrieverVar]}"></c:set>

<ul class="list-inline listResourceType">
	<li>
		<span class="label label-success labelLarge"><i class="glyphicon glyphicon-bookmark"></i> Resource Types</span>
	</li>
	<c:forEach items="${itemRetriever.resourceTypes}" var="type" varStatus="loopStatus">
		<c:if test="${loopStatus.index > 0}">
			<li>-</li>
		</c:if>
		<li>
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