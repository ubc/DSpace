<%-- 
    Document   : ubc-banner
    Created on : 5-Jul-2019, 5:19:37 PM
    Author     : john
--%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<div class='container ubcBanner xs-hide'>
	<a href='<c:url value="/" />' style="background: url('<c:url value="/static/ubc/images/ubc-signature.png"/>') no-repeat; height:117px; display: block">
		<p style='position: relative; top: 54px; left: 97px; font-size: 2em; letter-spacing: 0.15em; font-weight: bold; font-family:"Whitney"'>SEI MATERIALS ARCHIVE</p>
	</a>
</div>
<!-- mobile banner -->
<div class="container ubcBanner sm-hide md-hide lg-hide pt2">
	<a href='<c:url value="/" />'>
		<div class='flex'>
			<div>
				<img src='<c:url value="/static/ubc/images/ubc-crest.png"/>'  class='mr2' style='height: 40px' />
			</div>
			<div>
				<span style='position: relative; top: -3px; font-size: 1em;font-family:"Whitney"'>The University of British Columbia</span>
				<p class="bold" style="font-family:'Whitney'; font-size: 1.1em;">SEI MATERIALS ARCHIVE</p>
			</div>
		</div>
	</a>
</div>