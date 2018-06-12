<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="monthNames" value="${requestScope[param.monthNamesVar]}"></c:set>

 <div class='row'>
	 <!-- Field Label -->
	<label class='col-md-2 <c:if test="${param.isRequired}">label-required</c:if>' >
		${param.fieldLabel}
	</label>
	<!-- Controls -->
	<div class='col-md-10'>
		<c:forEach begin='0' end='${param.fieldCount - 1}' varStatus='loop'>
			<%-- The API expects the date to be split up into month, day, and year fields.
   				Configure the expected field names here. --%>
			<c:choose>
				<c:when test='${param.isRepeatable && loop.index > 0}'>
					<c:set var='fieldNameIndex' value='_${loop.index}' />
				</c:when>
				<c:otherwise>
					<c:set var='fieldNameIndex' value='' />
				</c:otherwise>
			</c:choose>
			<c:set var='fieldNameMonth' value='${param.fieldName}_month${fieldNameIndex}' />
			<c:set var='fieldNameDay' value='${param.fieldName}_day${fieldNameIndex}' />
			<c:set var='fieldNameYear' value='${param.fieldName}_year${fieldNameIndex}' />
			<div class='col-md-12 form-inline'>
				<!-- Input Elements -->
				<div class='input-group col-md-10'>
					<div class='row'>
						<!-- Month -->
						<span class='input-group col-md-5'>
							<span class='input-group-addon'>
								<fmt:message key='jsp.submit.edit-metadata.month' />
            				</span>
							<select class='form-control' id='${fieldNameMonth}' name='${fieldNameMonth}'
									<c:if test='${param.isReadonly}'>disabled</c:if> >
								<option value='-1'><fmt:message key='jsp.submit.edit-metadata.no_month' /></option>
								<c:forEach items='${monthNames}' var='monthName' varStatus='monthLoop'>
									<option value='${monthLoop.index + 1}'
										<c:if test="${(monthLoop.index+1) == param.curMonth}">selected='selected'</c:if> >
										${monthName}
									</option>
								</c:forEach> 
							</select>
						</span>
						<!-- Day -->
						<span class='input-group col-md-2'>
							<span class='input-group-addon'>
								<fmt:message key='jsp.submit.edit-metadata.day' />
                			</span>
							<input class='form-control' type='text' id='${fieldNameDay}' name='${fieldNameDay}'
									<c:if test='${param.isReadonly}'>disabled</c:if> size='2' maxlength='2'
									value='<c:if test='${param.curDay > 0}'>${param.curDay}</c:if>' />
                		</span>
						<!-- Year -->
						<span class='input-group col-md-4'>
							<span class='input-group-addon'>
								<fmt:message key='jsp.submit.edit-metadata.year' />
                			</span>
							<input class='form-control' type='text' id='${fieldNameYear}' name='${fieldNameYear}'
									<c:if test='${param.isReadonly}'>disabled</c:if> size='4' maxlength='4'
									value='<c:if test='${param.curYear > 0}'>${param.curYear}</c:if>' />
            			</span>
					</div>
				</div>
				<!-- Remove Entry Button -->
				<c:if test='${isRepeatable && !isReadOnly}'>
					<button class='btn btn-danger col-md-2' name='submit_${fieldName}_remove_${loopStatus.indext}'
							value='<fmt:message key='jsp.submit.edit-metadata.button.remove' />' >
						<i class='glyphicon glyphicon-trash'></i> <fmt:message key='jsp.submit.edit-metadata.button.remove' />
					</button>
				</c:if>
			</div>
		</c:forEach>
		<!-- Add More Button -->
		<c:if test='${isRequired && !isReadOnly}'>
			<div class='col-md-10 addMoreButton'>
				<button class='btn btn-default col-md-2' name='submit_${fieldNamel}_add'
						value='<fmt:message key='jsp.submit.edit-metadata.button.add' />' >
					<i class='glyphicon glyphicon-plus'></i> <fmt:message key='jsp.submit.edit-metadata.button.add' />
				</button>
			</div>
		</c:if>
	</div>
 </div>