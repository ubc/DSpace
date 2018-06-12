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
			<c:set var='fieldNamePopup' value='${param.fieldName}_popup${fieldNameIndex}' />

			<div class='col-md-12 form-inline'>
				<!-- Input Elements -->
				<div class='input-group col-md-10'>
					<div>
						<input class='form-control' type='text' id='${fieldNamePopup}' />
						<script>
							jQuery(function() {
								jQuery('#${fieldNamePopup}').datepicker({
									changeMonth: true,
									changeYear: true,
									dateFormat: 'yy-mm-dd',
									maxDate: 0,
									yearRange: "c-50:c+50",
									onSelect: function(dateText, inst) { 
										var date = jQuery(this).datepicker('getDate'),
												day  = date.getDate(),  
												month = date.getMonth() + 1,              
												year =  date.getFullYear();
										console.log(day + '-' + month + '-' + year);
										jQuery('#${fieldNameYear}').val(year);
										jQuery('#${fieldNameMonth}').val(month);
										jQuery('#${fieldNameDay}').val(day);
									}
								});
								<c:if test='${param.curYear > 0}'>
								jQuery('#${fieldNamePopup}').datepicker("setDate", "${param.curYear}-${param.curMonth}-${param.curDay}");
								</c:if>
							});
						</script>
					</div>
					<div class='hidden'>
						<!-- Month -->
						<input type='text' id='${fieldNameMonth}' name='${fieldNameMonth}' value='<c:if test='${param.curMonth > 0}'>${param.curMonth}</c:if>' />
						<!-- Day -->
						<input type='text' id='${fieldNameDay}' name='${fieldNameDay}' value='<c:if test='${param.curDay > 0}'>${param.curDay}</c:if>' />
						<!-- Year -->
						<input type='text' id='${fieldNameYear}' name='${fieldNameYear}' value='<c:if test='${param.curYear > 0}'>${param.curYear}</c:if>' />
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