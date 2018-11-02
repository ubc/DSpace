<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>


<div id="${param.wrapperID}" class='editMetadataRemovableField row ${param.isHidden ? 'hidden':''}'>
	<div class='col-xs-11'>
		<input type="text" class="form-control ${param.hasEditor ? 'tinyMCEInput':''}" value="${param.inputVal}" name="${param.inputName}"
			   <c:if test='${param.isReadOnly}'>readonly</c:if> >
	</div>
	<c:if test="${param.hasRemoveBtn}">
		<jsp:include page="/ubc/submit/components/remove-entry-button.jsp" />
	</c:if>
</div>