<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout locbar="nolink" title="How to Submit">

	<ol class="breadcrumb">
		<li><a href='<c:url value="/"/>'>Home</a></li>
		<li class="active">How to Submit</li>
	</ol>

	${content}
	
</dspace:layout>