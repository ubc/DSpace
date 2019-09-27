
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  


<c:set var="itemRetriever" value="${requestScope[param.retrieverVar]}"></c:set>

<ul class='list-inline'>
	<li><strong>Subject:</strong></li>
	<c:forEach items="${itemRetriever.subjects}" var="subject">
		<li>
			<c:url value="/simple-search" var="urlLevel1">
				<c:param name="filtername" value="subject" />
				<c:param name="filterquery" value="${subject.level1}" />
				<c:param name="filtertype" value="contains" />
			</c:url>
			<c:url value="/simple-search" var="urlLevel2">
				<c:param name="filtername" value="subject" />
				<c:param name="filterquery" value="${subject.level1} >>> ${subject.level2}" />
				<c:param name="filtertype" value="contains" />
			</c:url>
			<c:url value="/simple-search" var="urlLevel3">
				<c:param name="filtername" value="subject" />
				<c:param name="filterquery" value="${subject.subject}" />
				<c:param name="filtertype" value="equals" />
			</c:url>
						
			<a href="${urlLevel1}" target="_blank">
				${fn:escapeXml(subject.level1)}
			</a>
			<c:if test="${not empty subject.level2}">
				<i class="glyphicon glyphicon-chevron-right subjectsListArrow"></i>
				<a href="${urlLevel2}" target="_blank">
					${fn:escapeXml(subject.level2)}
				</a>
			</c:if>
			<c:if test="${not empty subject.level3}">
				<i class="glyphicon glyphicon-chevron-right subjectsListArrow"></i>
				<a href="${urlLevel3}" target="_blank">
					${fn:escapeXml(subject.level3)}
				</a>
			</c:if>
		</li>
	</c:forEach>
</ul>