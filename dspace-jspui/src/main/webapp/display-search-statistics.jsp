<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Display item/collection/community search statistics
  -
  - Attributes:
  -    statsTerms - bean containing name, data, column and row labels
  -    statsTotal - bean containing name, data, column and row labels
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>

<dspace:layout titlekey="jsp.search-statistics.title">

<h1><fmt:message key="jsp.search-statistics.title"/></h1>
<h2><fmt:message key="jsp.search-statistics.heading.top"/></h2>
<table class="table table-striped">
<tr>
    <th><fmt:message key="jsp.search-statistics.heading.term"/></th>
    <th><fmt:message key="jsp.search-statistics.heading.searches"/></th>
    <th><fmt:message key="jsp.search-statistics.heading.pct-total"/></th>
    <th><fmt:message key="jsp.search-statistics.heading.views-search"/></th>
</tr>
<c:forEach items="${statsTerms.matrix}" var="row" varStatus="counter">
    <tr>
        <c:forEach items="${row}" var="cell" varStatus="rowcounter">
            <td>
                <c:out value="${cell}"/>
            </td>
        </c:forEach>
    </tr>
</c:forEach>
</table>

</dspace:layout>
