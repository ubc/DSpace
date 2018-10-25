<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<tr <c:if test='${!empty param.rowID}'>id="${param.rowID}"</c:if> class="${param.isHidden?'hidden':''}">
	<%-- File Name --%>
	<td class="uploadFileName">${param.fileName}</td>
	<%-- File Size --%>
	<td class="uploadFileSize">${param.fileSize}</td>
	<%-- File Type --%>
	<%-- <td class="uploadFileType">Video OGG</td> --%>
	<%-- Restricted Access --%>
	<c:if test="${!disablePerFileRestriction}">
		<td class="uploadFileRestricted" title="<fmt:message key="jsp.submit.upload-file-list.tooltip.restricted"/>">
			<input type="checkbox" name="restricted${param.bitstreamID}" ${param.fileRestricted?'checked':''} />
		</td>
	</c:if>
	<%-- File Description --%>
	<td class="uploadFileDesc">
		<input name="description" class="form-control" value="${param.fileDesc}" />
		<input name="bitstreamID" class="bitstreamID" type="hidden" value="${param.bitstreamID}"/>
	</td>
	<%-- Delete File --%>
	<td class="uploadFileDelete">
		<button class="btn btn-danger" value="<fmt:message key="jsp.submit.upload-file-list.button2"/>" name="submit_remove_${param.bitstreamID}"
			title="<fmt:message key="jsp.submit.upload-file-list.button2"/>">
			<span class="glyphicon glyphicon-trash"></span>
		</button>
	</td>
	<%-- Upload Status --%>
	<td class="uploadStatus hidden" colspan="${disablePerFileRestriction?'3':'2'}">
		<div class="progress-bar uploadProgressBar" role="progressbar"
			aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"
			style="width: 60%; min-width: 2em">
			60%
		</div>
		<div class="alert alert-danger hidden uploadError" role="alert">
			<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
			<span class="sr-only">Error:</span>
			<span class='messageSpan'>Unknown error occurred while processing upload.</span>
		</div>
	</td>
</tr>