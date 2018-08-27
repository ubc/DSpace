<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:url value="/simple-search" var="url">
	<c:param name="filtername" value="${param.searchFilterName}" />
	<c:param name="filterquery" value="${param.listItem}" />
	<c:param name="filtertype" value="equals" />
</c:url>
<li>
	<a class="resourceLink" href="${url}" target="_blank" title="${param.listItem}">
		${param.listItem}
	</a>
</li>