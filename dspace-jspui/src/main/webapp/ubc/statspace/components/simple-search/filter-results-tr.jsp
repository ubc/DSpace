<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="FacetResultURL" 
	   value="${param.baseURL}0&amp;filtername=${param.filterName}&amp;filterquery=${param.filterQuery}&amp;filtertype=${param.filterType}"/>
<tr>
	<td>
		<a href='${FacetResultURL}'
		   title='<fmt:message key="jsp.search.facet.narrow"><fmt:param>${param.label}</fmt:param></fmt:message>'>
			<c:if test='${!empty param.level}'>
				<small>
					<c:if test='${param.level > 0}'>
						<span class='glyphicon glyphicon-chevron-right'></span>
					</c:if>
					<c:if test='${param.level > 1}'>
						<span class='glyphicon glyphicon-chevron-right'></span>
					</c:if>
				</small>
			</c:if>
			${param.label}
		</a>
	</td>
	<td class='text-info'>${param.count}</td>
</tr>