<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<div class='editMetadataRemovableField row ${param.isHidden ? 'hidden':''}' <c:if test="${!empty param.wrapperID}">id='${param.wrapperID}'</c:if> >
	<div class="col-xs-11">
		<select <c:if test="${!empty param.selectID}">id='${param.selectID}'</c:if> name="${param.selectName}" class='form-control' ${param.isHidden ? 'disabled':''}>
			<option value=''>-- Select a Submission --</option>
			<c:forEach items='${stepInfo.submitterItems}' var='submitterItem'>
				<c:set var='optionVal' value='${stepInfo.RELATED_RESOURCE_HEADER}${submitterItem.ID}' />
				<option value='${optionVal}' ${param.selectedVal == optionVal ? 'selected':''} title='${submitterItem.summary}'>${submitterItem.title}</option>
			</c:forEach>
		</select>
	</div>
	<c:if test="${param.hasRemoveBtn}">
		<jsp:include page="/ubc/submit/components/remove-entry-button.jsp">
			<jsp:param name="hide" value="false" />
		</jsp:include>
	</c:if>
</div>