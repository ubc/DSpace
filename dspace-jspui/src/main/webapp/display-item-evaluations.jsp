<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%--
  - Renders a whole HTML page for displaying item metadata.  Simply includes
  - the relevant item display component in a standard HTML page.
  -
  - Attributes:
  -    display.all - Boolean - if true, display full metadata record
  -    item        - the Item to display
  -    collections - Array of Collections this item appears in.  This must be
  -                  passed in for two reasons: 1) item.getCollections() could
  -                  fail, and we're already committed to JSP display, and
  -                  2) the item might be in the process of being submitted and
  -                  a mapping between the item and collection might not
  -                  appear yet.  If this is omitted, the item display won't
  -                  display any collections.
  -    admin_button - Boolean, show admin 'edit' button
  --%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Metadatum" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.content.Evaluation" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.handle.HandleManager" %>
<%@page import="javax.servlet.jsp.jstl.fmt.LocaleSupport"%>
<%@page import="org.dspace.versioning.Version"%>
<%@page import="org.dspace.core.Context"%>
<%@page import="java.util.List"%>
<%@page import="org.dspace.core.Constants"%>
<%@page import="org.dspace.eperson.EPerson"%>
<%@page import="org.dspace.versioning.VersionHistory"%>
<%
    // Attributes
    Item item = (Item) request.getAttribute("item");

    // get the handle if the item has one yet
    String handle = item.getHandle();

    // Full title needs to be put into a string to use as tag argument
    String title = item.getName();
    if (title == null || title.equals("")) {
        title = "Item " + handle;
    }

    Boolean newversionavailableBool = (Boolean)request.getAttribute("versioning.newversionavailable");
    boolean newVersionAvailable = (newversionavailableBool!=null && newversionavailableBool.booleanValue());
    String latestVersionHandle = (String)request.getAttribute("versioning.latestversionhandle");
String latestVersionURL = (String)request.getAttribute("versioning.latestversionurl");

    List<Evaluation> evaluations = (List<Evaluation>) request.getAttribute("evaluations");
%>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>
<dspace:layout title="<%= title %>">

<%
    if (newVersionAvailable) {
%>
        <div class="alert alert-warning"><b><fmt:message key="jsp.version.notice.new_version_head"/></b>
        <fmt:message key="jsp.version.notice.new_version_help"/><a href="<%=latestVersionURL %>"><%= latestVersionHandle %></a>
        </div>
<%
    }
%>

<%
if (evaluations.size() > 0) {
%>
    <h1>Evaluations for item <em><%= title %></em></h1>
    <table class="table" align="center" summary="Item evaluations">
        <tr>
            <th id="t10">Author</th>
            <th id="t11">Date</th>
            <th id="t12">&nbsp;</th>
        </tr>
<%
    
    for (Evaluation evaluation : evaluations) {
        Date submitted = evaluation.getSubmitted();
        EPerson submitter = evaluation.getSubmitter();
%>
    <tr>
        <td headers="t10">
            <a href="mailto:<%= submitter.getEmail() %>"><%= Utils.addEntities(submitter.getFullName()) %></a>
        </td>
        <td headers="t11"><%= DateFormat.getDateTimeInstance().format(submitted) %></td>
        <td headers="t12">
            <form action="<%= request.getContextPath() %>/evaluate" method="post">
                <input type="hidden" name="evaluation_id" value="<%= evaluation.getId() %>"/>
                <input class="btn btn-default" type="submit" name="submit_view" value="View" />
            </form>
        </td>
    </tr>
<%
    }
%>
    </table>
<%
} 
else {
%>
    <p>There are no pedagogical evaluations for item <em><%= title %></em></p>
<%
}
%>
</dspace:layout>
