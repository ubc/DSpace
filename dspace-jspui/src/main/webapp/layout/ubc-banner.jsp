<%-- 
    Document   : ubc-banner
    Created on : 5-Jul-2019, 5:19:37 PM
    Author     : john
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class='container ubcBanner py1'>
	<a href='<c:url value="/" />'>
		<%-- <img src='<c:url value="/static/ubc/images/ubc-crest.png"/>'  class='inline-block' style='height: 100px' /> --%>
		<img src='<c:url value="/static/ubc/images/cwsei-logo.jpg"/>' class='inline' />
	</a>
</div>