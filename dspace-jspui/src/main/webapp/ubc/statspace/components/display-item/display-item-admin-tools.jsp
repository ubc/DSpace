<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:url value="/tools/edit-item" var="urlEdit">
	<c:param name="item_id" value="${param.itemID}" />
</c:url>
<c:url value="/mydspace" var="urlExport"></c:url>
<c:url value="/dspace-admin/metadataexport" var="urlMetadataExport"></c:url>
<c:url value="/tools/version" var="urlVersion">
	<c:param name="itemID" value="${param.itemID}" />
</c:url>
<c:url value="/tools/history" var="urlVersionHistory">
	<c:param name="itemID" value="${param.itemID}" />
	<c:param name="versionID" value="${param.versionID}" />
</c:url>

<div class="alert alert-warning alert-dismissable adminToolsAlert" role="alert">
	<button type="button" class="close" data-dismiss="alert" aria-label="Close">
		<span aria-hidden="true">&times;</span>
	</button>
	<ul class="list-inline">
		<li><strong><fmt:message key="jsp.admintools"/></strong></li>
		<li><a href="${urlEdit}" class="btn btn-default btn-sm"><fmt:message key="jsp.general.edit.button"/></a></li>
		<li>
			<form method="post" action="${urlExport}">
				<input type="hidden" name="item_id" value="${param.itemID}" />
				<input type="hidden" name="step" value="${param.stepExportArchive}" />
				<input class="btn btn-default btn-sm" type="submit" name="submit" value="<fmt:message key="jsp.mydspace.request.export.item"/>" />
			</form>	
		</li>
		<li>
			<form method="post" action="${urlExport}">
				<input type="hidden" name="item_id" value="${param.itemID}" />
				<input type="hidden" name="step" value="${param.stepMigrateArchive}" />
				<input class="btn btn-default btn-sm" type="submit" name="submit" value="<fmt:message key="jsp.mydspace.request.export.migrateitem"/>" />
			</form>
		</li>
		<li>
			<form method="post" action="${urlMetadataExport}">
				<input type="hidden" name="handle" value="${param.handle}" />
				<input class="btn btn-default btn-sm" type="submit" name="submit" value="<fmt:message key="jsp.general.metadataexport.button"/>" />
			</form>
		</li>
		<c:if test="${hasVersionButton}">
			<li><a href="${urlVersion}" class="btn btn-default btn-sm"><fmt:message key="jsp.general.version.button"/></a></li>
		</c:if>
		<c:if test="${hasVersionHistory}">
			<li><a href="${urlVersionHistory}" class="btn btn-default btn-sm"><fmt:message key="jsp.general.version.history.button"/></a></li>
		</c:if>
	</ul>
</div>