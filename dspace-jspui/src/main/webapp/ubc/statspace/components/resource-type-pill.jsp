<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:url value="/simple-search" var="url">
	<c:param name="filtername" value="resourceType" />
	<c:param name="filterquery" value="${param.resource}" />
	<c:param name="filtertype" value="equals" />
</c:url>

<a class="resourceLink" href="${url}" target="_blank" title="${param.resource}">
	<span class="label label-default labelResource">
		${param.resource}
	</span>
</a>