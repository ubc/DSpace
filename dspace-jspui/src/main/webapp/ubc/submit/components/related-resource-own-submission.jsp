<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<div class='editMetadataRemovableField row ${param.isHidden ? 'hidden':''}' <c:if test="${!empty param.wrapperID}">id='${param.wrapperID}'</c:if> >
	<div class='col-xs-4 col-sm-3 col-md-2 checkbox'>
		<input type="hidden" name="${param.selectName}_link" value="unidirectional" ${param.isHidden ? 'disabled':''}/>
        <div class="row">
            <label title='By checking this box, a change will be made to each resource page: a link to each will appear at the bottom of the resource page for the other.'>
            <div class="col-sm-9">
    			Link&nbsp;back&nbsp;<span class='glyphicon glyphicon-info-sign'></span>
            </div>
            <div class="col-sm-3">
    			<input type="checkbox" name="${param.selectName}_link" value="bidirectional" ${param.isHidden ? 'disabled':''}
    				<c:if test='${stepInfo.bidirectionalLinksMap[param.selectedVal]}'>checked</c:if> />
            </div>
            </label>
        </div>
	</div>
	<div class="col-xs-7 col-sm-8 col-md-9">
		<select <c:if test="${!empty param.selectID}">id='${param.selectID}'</c:if> name="${param.selectName}" class='form-control' ${param.isHidden ? 'disabled':''}>
			<option value=''>-- Select a Submission --</option>
			<c:forEach items='${stepInfo.submitterItems}' var='submitterItem'>
				<c:set var='optionVal' value='${stepInfo.RELATED_RESOURCE_HEADER}${submitterItem.ID}' />
				<option value='${optionVal}' ${param.selectedVal == optionVal ? 'selected':''} title='${submitterItem.summary}'>${submitterItem.title}</option>
			</c:forEach>
		</select>
	</div>
    <div class="col-xs-1 col-sm-1 col-md-1">
        &nbsp;
    	<c:if test="${param.hasRemoveBtn}">
    		<jsp:include page="/ubc/submit/components/remove-entry-button.jsp">
    			<jsp:param name="hide" value="false" />
    		</jsp:include>
    	</c:if>
    </div>
</div>