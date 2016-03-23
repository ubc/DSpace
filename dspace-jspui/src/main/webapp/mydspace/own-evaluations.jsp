<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Show user's previous (accepted) submissions
  -
  - Attributes to pass in:
  -    user     - the e-person who's submissions these are (EPerson)
  -    items    - the submissions themselves (Item[])
  -    handles  - Corresponding Handles (String[])
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.eperson.EPerson" %>

<%
    EPerson eperson = (EPerson) request.getAttribute("user");
    Item[] items = (Item[]) request.getAttribute("items");
%>

<dspace:layout style="submission" locbar="link"
               parentlink="/mydspace"
               parenttitlekey="jsp.mydspace"
               titlekey="jsp.mydspace">

    <%-- <h2>Your Submissions</h2> --%>
    <h2>Your Downloads</h2>
    <!-- <h2><fmt:message key="jsp.mydspace.own-submissions.title"/></h2> -->
    
<%
    if (items.length == 0)
    {
%>
    <%-- <p>There are no items in the main archive that have been submitted by you.</p> --%>
	<!-- <p><fmt:message key="jsp.mydspace.own-submissions.text1"/></p> -->
    <p>There are no items in the main archive that you downloaded</p>
<%
    }
    else
    {
%>
    <%-- <p>Below are listed your previous submissions that have been accepted into
    the archive.</p> --%>
	<p><fmt:message key="jsp.mydspace.own-submissions.text2"/></p>
<%
        if (items.length == 1)
        {
%>
    <%-- <p>There is <strong>1</strong> item in the main archive that was submitted by you.</p> --%>
    <p>There is <strong>1</strong> item in the main archive that was downloaded by you.</p>
	<!-- <p><fmt:message key="jsp.mydspace.own-submissions.text3"/></p> -->
<%
        }
        else
        {
%>
    <%-- <p>There are <strong><%= items.length %></strong> items in the main archive that were submitted by you.</p> --%>
    <p>
        There are <strong><%= items.length %></strong> items in the
        main archive that were downloaded by you.
    </p>
	<!-- <p><fmt:message key="jsp.mydspace.own-submissions.text4">
         <fmt:param><%= items.length %></fmt:param>
         </fmt:message></p> -->
<%
        }
%>
<table class="table" align="center" summary="Downloaded items">
    <tr>
        <th id="t10"><fmt:message key="jsp.mydspace.main.subby"/></th>
        <th id="t11"><fmt:message key="jsp.mydspace.main.elem1"/></th>
        <th id="t12"><fmt:message key="jsp.mydspace.main.elem2"/></th>
        <th id="t13">&nbsp;</th>
    </tr>
<%
}

for (int i = 0; i < items.length; i++) {
    String title = items[i].getName();
    EPerson submitter = items[i].getSubmitter();
%>
    <tr>
        <td headers="t10">
            <a href="mailto:<%= submitter.getEmail() %>"><%= Utils.addEntities(submitter.getFullName()) %></a>
        </td>
        <td headers="t11"><%= Utils.addEntities(title) %></td>
        <td headers="t12"><%= items[i].getOwningCollection().getName() %></td>
        <td headers="t13">
            <form action="<%= request.getContextPath() %>/evaluate" method="post">
                <input type="hidden" name="item_id" value="<%= items[i].getID() %>"/>
                <input class="btn btn-default" type="submit" name="submit_evaluate" value="Evaluate" />
            </form>
        </td>
    </tr>
<%
    }
%>
    </table>
    <%-- <p align="center"><a href="<%= request.getContextPath() %>/mydspace">Back to My DSpace</a></p> --%>
	<p align="center"><a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="jsp.mydspace.general.backto-mydspace"/></a></p>
</dspace:layout>
