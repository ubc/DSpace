<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - News Edit Form JSP
  -
  - Attributes:
   --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout style="submission" titlekey="jsp.dspace-admin.news-edit.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin">

    <%-- <h1>News Editor</h1> --%>
    <h1>Edit Blurb: ${position}</h1>

	<form action="<%= request.getContextPath() %>/dspace-admin/news-edit" method="post">
		<div class="form-group">
			<%-- <label><fmt:message key="jsp.dspace-admin.news-edit.news"/></label> --%>
			<textarea class="form-control tinyMCETextArea" name="news" rows="10" cols="50">${news}</textarea>
		</div>

        <input type="hidden" name="position" value='${position}'/>
        <%-- <input type="submit" name="submit_save" value="Save"> --%>
        <input class="btn btn-primary" type="submit" name="submit_save" value="<fmt:message key="jsp.dspace-admin.general.save"/>" />
        <%-- <input type="submit" name="cancel" value="Cancel"> --%>
		<input class="btn btn-default" type="submit" name="cancel" value="<fmt:message key="jsp.dspace-admin.general.cancel"/>" />

    </form>
</dspace:layout>
