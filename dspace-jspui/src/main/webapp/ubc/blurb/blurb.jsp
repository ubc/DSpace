<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout locbar="off" title="${blurbType}">

	<ol class="breadcrumb">
		<li><a href='<c:url value="/"/>'>CWSEISpace</a></li>
		<li class="active">${blurbType}</li>
	</ol>

	${blurb}
	
</dspace:layout>