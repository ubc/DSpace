<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Display item/collection/community workflow statistics
  -
  - Attributes:
  -    statsActions - bean containing name, data, column and row labels
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>

<dspace:layout titlekey="jsp.workflow-statistics.title">

<h1><fmt:message key="jsp.workflow-statistics.title"/></h1>
<table class="table table-striped">
<tr>
    <th><fmt:message key="jsp.workflow-statistics.heading.step"/></th>
    <th><fmt:message key="jsp.workflow-statistics.heading.performed"/></th>
</tr>
<c:forEach items="${statsActions.matrix}" var="row" varStatus="counter">
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



