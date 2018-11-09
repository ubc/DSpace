<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout locbar="nolink" title="Contact Us">

	<ol class="breadcrumb">
		<li><a href='<c:url value="/"/>'>Home</a></li>
		<li class="active">Contact Us</li>
	</ol>

	${content}
	
</dspace:layout>