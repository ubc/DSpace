<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<div class='editMetadataRemovableField row ${param.isHidden ? 'hidden':''}' <c:if test="${!empty param.wrapperID}">id='${param.wrapperID}'</c:if> >
	<div class='col-xs-3 col-sm-2 col-md-1 checkbox'>
		<input type="hidden" name="${param.selectName}_link" value="unidirectional" ${param.isHidden ? 'disabled':''}/>
		<label title='By checking this box, a change will be made to each resource page: a link to each will appear at the bottom of the resource page for the other.'>
			<span class='glyphicon glyphicon-retweet'></span>
			<input type="checkbox" name="${param.selectName}_link" value="bidirectional" ${param.isHidden ? 'disabled':''}
				<c:if test='${stepInfo.bidirectionalLinksMap[param.selectedVal]}'>checked</c:if> />
		</label>
	</div>
	<div class="col-xs-8 col-sm-9 col-md-10">
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