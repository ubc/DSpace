<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="FacetResultURL" 
	   value="${param.baseURL}0&amp;filtername=${param.filterName}&amp;filterquery=${param.filterQuery}&amp;filtertype=${param.filterType}"/>

<tr>
	<td>
		<a href='${FacetResultURL}'
		   title='<fmt:message key="jsp.search.facet.narrow"><fmt:param>${param.label}</fmt:param></fmt:message>'>
			${param.label}
		</a>
	</td>
	<td class='text-right'>${param.count}</td>
</tr>