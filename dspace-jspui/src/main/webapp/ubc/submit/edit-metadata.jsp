<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Edit metadata form
  -
  - Attributes to pass in to this page:
  -    submission.info   - the SubmissionInfo object
  -    submission.inputs - the DCInputSet
  -    submission.page   - the step in submission
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>


<dspace:layout style="submission" locbar="off" navbar="off" titlekey="jsp.submit.edit-metadata.title">
<form class="form-horizontal" action="<c:url value="/submit" />" method="post" name="edit_metadata" id="edit_metadata" onkeydown="return disableEnterKey(event);">
	<jsp:include page="/submit/progressbar.jsp"></jsp:include>
	<h1><fmt:message key="jsp.submit.edit-metadata.heading"/></h1>
	<c:choose>
		<c:when test="${stepInfo.pageNum <= 1}">
			<p><fmt:message key="jsp.submit.edit-metadata.info1"/></p>
		</c:when>
		<c:otherwise>
			<p><fmt:message key="jsp.submit.edit-metadata.info2"/></p>
		</c:otherwise>
	</c:choose>
	<c:if test='${stepInfo.hasValidationErrors}'>
		<div class="alert alert-danger text-center h4" role="alert">
			<span class='glyphicon glyphicon-warning-sign'></span> Please correct the errors below.
		</div>
	</c:if>

	<c:forEach items="${stepInfo.fields}" var="field">
		<c:if test='${field.isVisible}'>
			<div class="form-group <c:if test ='${field.hasValidationError}'>has-error</c:if>">
				<c:if test='${field.hasValidationError}'>
					<div class="alert alert-danger text-center" role="alert">${field.validationErrorMsg}</div>
				</c:if>
				<label for="${field.inputID}" class="col-sm-2 control-label">
					${field.label}
					<c:if test="${field.isRequired}">*</c:if>
				</label>
				<div class="col-sm-10">
					<c:if test="${field.hasAddMore && !field.isReadOnly}">
						<button id="${field.inputAddMoreButtonID}" class="btn btn-default" type="button">
							<span class="glyphicon glyphicon-plus"></span> Add More
						</button>
					</c:if>
					<%--
					TODO:
					2. Form validation
					--%>
					<c:choose>
						<%-- NAME input type --%>
						<c:when test="${field.inputType == field.INPUT_TYPE_NAME}">
							<c:forEach items="${field.names}" var="name" varStatus="nameStatus">
								<c:set var="fieldWrapperID" value="${field.inputWrapperID}_${nameStatus.index}" />
								<div id="${fieldWrapperID}" class='form-inline editMetadataRemovableField'>
									<div class="input-group">
										<div>
											<c:set var="firstNameID" value="${field.inputID}_first${!nameStatus.first && field.hasAddMore ? '_'.concat(nameStatus.index) : ''}" />
											<c:set var="lastNameID" value="${field.inputID}_last${!nameStatus.first && field.hasAddMore ? '_'.concat(nameStatus.index) : ''}" />
											<input type='text' class='form-control' id='${firstNameID}' name='${firstNameID}' placeholder='Last Name' value='${name.firstNames}'
												   <c:if test='${field.isReadOnly}'>readonly</c:if>>
											<input type='text' class='form-control' id='${lastNameID}' name='${lastNameID}' placeholder='First Name' value='${name.lastName}'
												   <c:if test='${field.isReadOnly}'>readonly</c:if>>
										</div>
									</div>
									<c:if test="${field.hasAddMore}">
										<jsp:include page="/ubc/submit/components/remove-entry-button.jsp">
											<jsp:param name="buttonID" value="${fieldWrapperID}_remove" />
											<jsp:param name="hide" value="${nameStatus.first}" />
										</jsp:include>
									</c:if>
								</div> 
							</c:forEach>
						</c:when>
						<%-- ONEBOX input type --%>
						<c:when test="${field.inputType == field.INPUT_TYPE_ONEBOX}">
							<c:forEach items="${field.values}" var="value" varStatus="valueStatus">
								<c:set var="fieldWrapperID" value="${field.inputWrapperID}_${valueStatus.index}" />
								<div id="${fieldWrapperID}" class='editMetadataRemovableField'>
									<c:set var="fieldID" value="${field.inputID}${!valueStatus.first && field.hasAddMore ? '_'.concat(valueStatus.index) : ''}" />
									<input type="text" class="form-control" value="${value}" id="${fieldID}" name="${fieldID}" <c:if test='${field.isReadOnly}'>readonly</c:if>>
									<c:if test="${field.hasAddMore}">
										<jsp:include page="/ubc/submit/components/remove-entry-button.jsp">
											<jsp:param name="buttonID" value="${fieldWrapperID}_remove" />
											<jsp:param name="hide" value="${valueStatus.first}" />
										</jsp:include>
									</c:if>
								</div>
							</c:forEach>
						</c:when>
						<%-- TEXTAREA input type --%>
						<c:when test="${field.inputType == field.INPUT_TYPE_TEXTAREA}">
							<div>
								<textarea class="form-control" id="${field.inputID}_id" name="${field.inputID}" <c:if test='${field.isReadOnly}'>readonly</c:if>>${field.value}</textarea>
							</div>
							<%-- Don't bother implementing repeatable support, as we're not using it --%>
							<c:if test="${field.isRepeatable}">
								<jsp:include page="/ubc/submit/components/not-implemented.jsp">
									<jsp:param name="fieldType" value="repeatable ${field.inputType}" />
								</jsp:include>
							</c:if>
						</c:when>
						<%-- DROPDOWN input type --%>
						<c:when test="${field.inputType == field.INPUT_TYPE_DROPDOWN}">
							<div>
								<select class="form-control" name="${field.inputID}" <c:if test='${field.isRepeatable}'>multiple</c:if> <c:if test='${field.isReadOnly}'>disabled</c:if>>
									<c:forEach items="${field.options}" var="option">
										<option value="${option.value}" <c:if test='${field.values.contains(option.value)}'>selected</c:if>>${option.key}</option>
									</c:forEach>
								</select>
							</div>
						</c:when>
						<%-- DATE input type --%>
						<c:when test="${field.inputType == field.INPUT_TYPE_DATE}">
							<c:set var='fieldNameMonth' value='${field.inputID}_month' />
							<c:set var='fieldNameDay' value='${field.inputID}_day' />
							<c:set var='fieldNameYear' value='${field.inputID}_year' />
							<c:set var='fieldNameDatepicker' value='${field.inputID}_datepicker' />
							<c:set var='fieldNameBtn' value='${field.inputID}_btn' />
							<div class="form-inline">
								<div class='input-group'>
									<div>
										<!-- These are the actual fields read & stored on form submit -->
										<!-- Year -->
										<input type='text' pattern="[1-2]\d\d\d" maxlength="4" size="8" id='${fieldNameYear}' name='${fieldNameYear}' 
											   <c:if test='${field.isReadOnly}'>readonly</c:if>
											   value='<c:if test='${field.date.year > 0}'>${field.date.year}</c:if>' class="text-center form-control" placeholder="Year" />
										<!-- Month -->
										<input type='text' pattern="[1-9]|[0][1-9]|[1][0-2]" maxlength="2" size="5" id='${fieldNameMonth}' name='${fieldNameMonth}'
											   <c:if test='${field.isReadOnly}'>readonly</c:if>
											   value='<c:if test='${field.date.month > 0}'>${field.date.month}</c:if>' class="text-center form-control" placeholder="Month" />
										<!-- Day -->
										<input type='text' pattern="[1-9]|[0][1-9]|[1-2]\d|[3][0-1]" maxlength="2" size="5" id='${fieldNameDay}' name='${fieldNameDay}' 
											   <c:if test='${field.isReadOnly}'>readonly</c:if>
											   value='<c:if test='${field.date.day > 0}'>${field.date.day}</c:if>' class="text-center form-control" placeholder="Day" />
									</div>
								</div>
							</div>
							<%-- Don't bother implementing repeatable support, as we're not using it --%>
							<c:if test="${field.isRepeatable}">
								<jsp:include page="/ubc/submit/components/not-implemented.jsp">
									<jsp:param name="fieldType" value="repeatable ${field.inputType}" />
								</jsp:include>
							</c:if>
							<script>
								// Date field scripting
								jQuery(function() {
									var latestDate = new Date();
									// The problem with instantiating a datepicker for each
									// year/month/date fields is that we have to sync the
									// underlying Date object for all 3 fields together.
									// This issue is exacerbated by the fact that we need to
									// allow users to only partially enter data, e.g. only
									// year or year & month. And the Date object underlying
									// bootstrap-datepicker requires all time information to
									// be present. Working around this by not instantiating
									// the datepicker for fields that have no data.
									var yearField = {
										'jq': jQuery('#${fieldNameYear}'),
										'params': {
											startView: 2,
											minViewMode: 2,
											format: "yyyy",
											autoclose: true,
											clearBtn: true
										}
									};
									var monthField = {
										'jq': jQuery('#${fieldNameMonth}'),
										'params': {
											startView: 1,
											minViewMode: 1,
											format: "m",
											autoclose: true,
											clearBtn: true
										}
									};
									var dayField = {
										'jq': jQuery('#${fieldNameDay}'),
										'params': {
											startView: 0,
											minViewMode: 0,
											format: "dd",
											autoclose: true,
											clearBtn: true
										}
									};
									// true if the given field has a datepicker instance
									function hasDatepicker(field) {
										if (field.jq.data('datepicker'))
											return true;
										return false;
									}
									// change the date for each datepicker depending on what
									// is entered in the fields
									function updateDateFromFields() {
										function getFieldValue(field, fallbackVal) {
											// make sure the field is validated (html5's pattern attribute) before accepting value
											if (field.val() && field.is(":valid"))
												return field.val();
											return fallbackVal;
										}
										function shouldUpdateField(field) {
											if (!hasDatepicker(field)) return false;
											var oldDate = field.jq.datepicker('getDate');
											if (!oldDate) return false;
											if (oldDate.getFullYear() == latestDate.getFullYear() &&
												oldDate.getMonth() == latestDate.getMonth() &&
												oldDate.getDate() == latestDate.getDate())
												return false;
											return true;
										}
										var year = getFieldValue(yearField.jq, latestDate.getFullYear());
										// month is special cause it's zero indexed in the Date object while the field isn't
										var month = getFieldValue(monthField.jq, (latestDate.getMonth() + 1)) -1;
										var day = getFieldValue(dayField.jq, latestDate.getDate());
										latestDate.setFullYear(year);
										latestDate.setMonth(month);
										latestDate.setDate(day);
										if (shouldUpdateField(yearField))
											yearField.jq.datepicker('update', latestDate);
										if (shouldUpdateField(monthField))
											monthField.jq.datepicker('update', latestDate);
										if (shouldUpdateField(dayField))
											dayField.jq.datepicker('update', latestDate);
									}
									// Disable or enable fields based on whether their 
									// prereq field has been filled in yet. i.e.: month
									// needs year, day needs month. Also instantiates or
									// destroys the datepicker on those fields as necessary.
									function enableOrDisableFields() {
										function toggleField(field, prereqField) {
											if (prereqField.jq.val()) { // enable field
												field.jq.prop('disabled', false);
												if (!hasDatepicker(field))
													field.jq.datepicker(field.params);
											}
											else { // disable field
												field.jq.prop('disabled', true);
												if (hasDatepicker(field)) {
													field.jq.datepicker('destroy');
													field.jq.val("");
												}
											}
										}
										toggleField(monthField, yearField);
										toggleField(dayField, monthField);
									}
									// INITIALIZATION
									// Year field should always have a datepicker on it
									yearField.jq.datepicker(yearField.params);
									enableOrDisableFields();
									updateDateFromFields();
									// make sure all 3 datepickers get updated on changes
									yearField.jq.change(function() {
										enableOrDisableFields();
										updateDateFromFields();
									});
									monthField.jq.change(function() {
										enableOrDisableFields();
										updateDateFromFields();
									});
									dayField.jq.change(function() {
										enableOrDisableFields();
										updateDateFromFields();
									});
								});
							</script>
						</c:when>
						<%-- Unimplemented field types, since we're not using 
							them, save some time by not implementing them for 
							the rewrite. This should be qualdrop, series, twobox
							list. --%>
						<c:otherwise>
							<jsp:include page="/ubc/submit/components/not-implemented.jsp">
								<jsp:param name="fieldType" value="${field.inputType}" />
							</jsp:include>
						</c:otherwise>
					</c:choose>
					<div class="help-block">
						<p>${field.hint}</p>
					</div>
					<c:if test="${field.hasAddMore}">
						<script>
							// Add More & Remove scripting
							jQuery(function() {
								// Because of the way DSpace rely on sequentially numbering repeated fields, if you have
								// say fields 1,2,3,4, and you remove field 2, it'll also remove fields 3 and 4 cause
								// it stops after seeing that 2 is gone. The proper way to fix this is to use form arrays,
								// but I don't have the time required to fix the api, so this is a workaround to renumber 
								// the fields to make sure they're sequential. 
								function getIndex(elementID) {
									var index = elementID.match(/\d+/g);
									// dspace cannot handle elements numbered with 0, it expects the first element
									// to not be numbered, so have to compensate here. Assume that if we didn't
									// find a number, it's the first element.
									if (index === null) index = 0;
									index = parseInt(index, 10);
									return index;
								}
								function incrementFieldID(fieldID) {
									var prevIndex = getIndex(fieldID);
									if (fieldID.match("_"+prevIndex))
										return fieldID.replace("_"+prevIndex, "_"+(prevIndex+1));
									// special case if starting from element 0, since it isn't numbered
									return fieldID+"_"+(prevIndex+1);
								}
								function decrementFieldID(fieldID) {
									var fieldIndex = getIndex(fieldID);
									// strip off numbering if we want element 0
									if (fieldIndex == 1) return fieldID.replace("_"+fieldIndex,"");
									// normal case, just decrement the index
									else if (fieldIndex > 1) return fieldID.replace("_"+fieldIndex,"_"+(fieldIndex-1));
									// something messed up if we reach this case, don't do anything
									else return fieldID;
								}
								// update the index on the wrapper, input, buttons, etc fields as appropriate
								function updateFieldIDs(field, isIncrement = true) {
									var operation = function(i, fieldID) {
										if (isIncrement) return incrementFieldID(fieldID);
										return decrementFieldID(fieldID);
									};
									field.prop("id", operation);
									field.find("input").prop("id", operation);
									field.find("input").prop("name", operation);
									field.find("button").prop("id", operation);
								}
								function incrementFieldIDs(field) {
									updateFieldIDs(field, true);
								}
								function decrementFieldIDs(field) {
									updateFieldIDs(field, false);
								}
								function renumberFields(removedElementID) {
									var nextElementID = incrementFieldID(removedElementID);
									var nextElement = jQuery("#"+nextElementID);
									while (nextElement.length) {
										decrementFieldIDs(nextElement);
										nextElementID = incrementFieldID(nextElementID);
										nextElement = jQuery("#"+nextElementID);
									}
								}
								// remove a repeated element
								function removeElement(element) {
									var removedElementID = element.prop("id");
									element.remove();
									renumberFields(removedElementID);
								}
								// make the jsp generated pre-existing remove buttons functional
								jQuery("div[id^='${field.inputWrapperID}']").find("button").click(function() {
									removeElement(jQuery(this).parent());
								}); 
								jQuery("#${field.inputAddMoreButtonID}").click(function() {
									var lastFieldWrapperID = "div[id^='${field.inputWrapperID}']:last"; 
									var clone = jQuery(lastFieldWrapperID).clone();

									incrementFieldIDs(clone);
									clone.find("input").prop("value", "");
									clone.find("button").removeClass("hidden");
									jQuery(lastFieldWrapperID).after(clone);
									// make the newly added remove button functional
									clone.find("button").click(function() {
										removeElement(clone);
									});
								});
							});
						</script>
					</c:if>
				</div>
			</div>
		</c:if>
	</c:forEach>

	<%-- Hidden fields needed for SubmissionController servlet to know which item to deal with --%>
	<% Context context = UIUtil.obtainContext(request); %>
	<%= SubmissionController.getSubmissionParameters(context, request) %>
	<div class="btn-group btn-group-justified" role="group" aria-label="form control buttons">
		<div class="btn-group" role="group">
			<button class="btn btn-default" type="submit" name="<%=AbstractProcessingStep.PREVIOUS_BUTTON%>" <c:if test='${stepInfo.isFirstStep && stepInfo.pageNum <= 1}'>disabled</c:if>>
				<fmt:message key="jsp.submit.edit-metadata.previous"/>
			</button>
		</div>
		<div class="btn-group" role="group">
			<button class="btn btn-default" type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>">
				<fmt:message key="jsp.submit.edit-metadata.cancelsave"/>
			</button>
		</div>
		<div class="btn-group" role="group">
			<button class="btn btn-primary" type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>">
				<fmt:message key="jsp.submit.edit-metadata.next"/>
			</button>
		</div>
	</div>
</form>


</dspace:layout>