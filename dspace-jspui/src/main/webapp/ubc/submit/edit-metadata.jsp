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
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
			<div id="${field.formGroupID}" class="form-group <c:if test ='${field.hasValidationError}'>has-error</c:if>">
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
											<input type='text' class='form-control' name='${field.inputID}_last' placeholder='Last Name' value='${name.lastName}'
												   <c:if test='${field.isReadOnly}'>readonly</c:if>>
											<input type='text' class='form-control' name='${field.inputID}_first' placeholder='First Name' value='${name.firstNames}'
												   <c:if test='${field.isReadOnly}'>readonly</c:if>>
										</div>
									</div>
									<c:if test="${field.isRepeatable}">
										<jsp:include page="/ubc/submit/components/remove-entry-button.jsp">
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
									<input type="text" class="form-control" value="${value}" name="${field.inputID}" <c:if test='${field.isReadOnly}'>readonly</c:if>>
									<c:if test="${field.isRepeatable}">
										<jsp:include page="/ubc/submit/components/remove-entry-button.jsp">
											<jsp:param name="hide" value="${valueStatus.first}" />
										</jsp:include>
									</c:if>
								</div>
							</c:forEach>
						</c:when>
						<%-- RELATED RESOURCES input type --%>
						<c:when test="${field.inputType == field.INPUT_TYPE_RELATED_RESOURCES}">
							<c:set var="addMySubmissionsBtnID" value="${field.inputID}_addMySubmissionsBtn" />
							<c:set var="mySubmissionsSelectTplID" value="${field.inputID}_mySubmissionsSelectTplID" />
							<div id="tmpdropdownid" class="btn-group">
								<button type="button" class="btn btn-default dropdown-toggle" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
									<span class='glyphicon glyphicon-plus'></span> Add Resource <span class="caret"></span>
								</button>
								<ul class="dropdown-menu">
									<li  <c:if test='${empty stepInfo.submitterItems}'>title='No approved submissions found.'</c:if> >
										<a id="${addMySubmissionsBtnID}" href="#"
											<c:if test='${empty stepInfo.submitterItems}'>class='btn disabled'</c:if> >
											My Submissions</a>
									</li>
									<li><a id="${field.inputAddMoreButtonID}" href="#">Other</a></li>
								</ul>
							</div>
							<script>
								jQuery(function(){
									jQuery('#${field.inputAddMoreButtonID}').click(function(e){
										// bootstrap only lets us use links for dropdown menu items, so have to prevent the default link action on click
										e.preventDefault();
									})
									var mySubmissionsBtn = jQuery('#${addMySubmissionsBtnID}');
									mySubmissionsBtn.click(function(e) {
										e.preventDefault();
										var lastFieldWrapperID = "div[id^='${field.inputWrapperID}']:last"; 
										var clone = jQuery('#${mySubmissionsSelectTplID}').parent().parent().clone();

										// stupid way to maintain unique IDs, just append a 1 to the last id
										clone.prop('id', clone.prop('id') + '1');
										clone.removeClass("hidden");
										clone.find("select").attr("disabled", false);
										clone.find("input").attr("disabled", false);
										jQuery(lastFieldWrapperID).after(clone);
										// make the newly added remove button functional
										clone.find("button").click(function() {
											clone.remove();
										});
									});
								});
							</script>
							<!-- Template for selecting one of the user's own submissions-->
							<jsp:include page="/ubc/submit/components/related-resource-own-submission.jsp">
								<jsp:param name="isHidden" value="true" />
								<jsp:param name="selectID" value="${mySubmissionsSelectTplID}" />
								<jsp:param name="selectName" value="${field.inputID}" />
								<jsp:param name="hasRemoveBtn" value="${field.isRepeatable}" />
							</jsp:include>
							<!-- Template for a regular free form entry --> 
							<jsp:include page="/ubc/submit/components/related-material-other.jsp">
								<jsp:param name="isHidden" value="true" />
								<jsp:param name="hasEditor" value="false" />
								<jsp:param name="wrapperID" value="${field.inputWrapperID}_tmpl" />
								<jsp:param name="inputName" value="${field.inputID}" />
								<jsp:param name="isReadOnly" value="${field.isReadOnly}" />
								<jsp:param name="hasRemoveBtn" value="${field.isRepeatable}" />
							</jsp:include>
							<!-- Restore existing resources -->
							<c:forEach items="${field.values}" var="value" varStatus="valueStatus">
								<c:if test='${!empty value}'>
									<c:set var="hasResourceID" value="${fn:startsWith(value, stepInfo.RELATED_RESOURCE_HEADER)}" />
									<c:set var="fieldWrapperID" value="${field.inputWrapperID}_${valueStatus.index}" />
									<c:if test='${hasResourceID}'>
										<jsp:include page="/ubc/submit/components/related-resource-own-submission.jsp">
											<jsp:param name="isHidden" value="false" />
											<jsp:param name="wrapperID" value="${fieldWrapperID}" />
											<jsp:param name="selectName" value="${field.inputID}" />
											<jsp:param name="hasRemoveBtn" value="${field.isRepeatable}" />
											<jsp:param name="selectedVal" value="${value}" />
										</jsp:include>
									</c:if>
									<c:if test='${!hasResourceID}'>
										<jsp:include page="/ubc/submit/components/related-material-other.jsp">
											<jsp:param name="isHidden" value="false" />
											<jsp:param name="hasEditor" value="${field.hasEditor}" />
											<jsp:param name="wrapperID" value="${fieldWrapperID}" />
											<jsp:param name="inputName" value="${field.inputID}" />
											<jsp:param name="isReadOnly" value="${field.isReadOnly}" />
											<jsp:param name="hasRemoveBtn" value="${field.isRepeatable}" />
											<jsp:param name="inputVal" value="${value}" />
										</jsp:include>
									</c:if>
								</c:if>
							</c:forEach>
						</c:when>
						<%-- TEXTAREA input type --%>
						<c:when test="${field.inputType == field.INPUT_TYPE_TEXTAREA}">
							<div>
								<textarea class="form-control tinyMCETextArea" id="${field.inputID}_id" name="${field.inputID}"
									<c:if test='${field.isReadOnly}'>readonly</c:if>>${field.value}</textarea>
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
						<%-- TRIPLE LEVEL DROPDOWN for StatSpace's subjects tree --%>
						<c:when test="${field.inputType == field.INPUT_TYPE_TRIPLE_LEVEL_DROPDOWN}">
							<c:set var="subjectsLevel1ID" value="${field.inputID}_level_1"/>
							<c:set var="subjectsLevel2ID" value="${field.inputID}_level_2"/>
							<c:set var="subjectsLevel3ID" value="${field.inputID}_level_3"/>
							<c:set var="requiredHiddenOptionText" value="-- Select a sub-level topic (Required) --"/>
							<c:set var="optionalHiddenOptionText" value="-- Select a sub-level topic (Optional) --"/>
							<c:set var="noneHiddenOptionText" value="-- None --"/>
							<%--
							TODO:
							1. tell user to enter a custom subject in the Subject (Other) box when "Other" is selected as subject
							--%>
							<div class="editMetadataTripleLevelDropdown">
								<select class='form-control' id='${subjectsLevel1ID}'>
									<option selected value disabled hidden>-- Select a subject to see sub-level topics --</option>
								</select>
								<select class='form-control' id='${subjectsLevel2ID}' disabled>
									<option selected value disabled hidden>${requiredHiddenOptionText}</option>
								</select>
								<select class='form-control' id='${subjectsLevel3ID}' disabled>
									<option selected value>${noneHiddenOptionText}</option>
								</select>
								<select class="form-control hidden" id="${field.inputID}" name="${field.inputID}">
									<option value>-- None --</option>
									<c:forEach items="${field.options}" var="option">
										<option value="${option.value}" <c:if test='${field.values.contains(option.value)}'>selected</c:if>>${option.key}</option>
									</c:forEach>
								</select>
							</div>
							<%-- Statspace Subjects Selection JavaScript --%>
							<script>
								jQuery(document).ready(function() {
									var options = ${field.optionsJsonString};
									var level1Id = '#${subjectsLevel1ID}';
									var level2Id = '#${subjectsLevel2ID}';
									var level3Id = '#${subjectsLevel3ID}';
									var subjectsSelectId = '#${field.inputID}';
									var requiredHiddenOptionText = "${requiredHiddenOptionText}";
									var optionalHiddenOptionText = "${optionalHiddenOptionText}";
									var noneHiddenOptionText = "${noneHiddenOptionText}";

									// show/hide Subject (Other)
									var subjectOtherFormGroup = jQuery('#dc_subject_other_form_group');
									var subjectSelect = jQuery(subjectsSelectId);
									var showHideSubjectOther = function() {
										var selectedVals = subjectSelect.val();
										if (selectedVals && /Other$/.test(selectedVals)) {
											subjectOtherFormGroup.show("highlight", 1000);
										}
										else {
											subjectOtherFormGroup.hide("blind", "fast");
										}
									};
									showHideSubjectOther();
									subjectSelect.change(showHideSubjectOther);

									// Reset previous selections back to the default option
									function resetChildSelect(selectId) {
										jQuery(selectId + ' option:not(:first-child)').remove();
										jQuery(selectId).prop('disabled', true);
										jQuery(selectId + ' option:first').prop('selected', true);
									}
									function isLevel2(selectId) {
										if (selectId.indexOf("level_2") > 0) return true;
										return false;
									}
									function isLevel3(selectId) {
										if (selectId.indexOf("level_3") > 0) return true;
										return false;
									}
									
									// Populate level 2 and level 3 select boxes based on what was selected
									// in the parent level.
									function populateChildSelect(selectId, opts) {
										jQuery.each(opts, function(k,v) {
											var optionTag = jQuery("<option>").attr("value",k).text(k);
											if (typeof v == 'string')
												optionTag.attr("value", v);
											jQuery(selectId + ' option:last').after(optionTag);
										});
										// only enable the dropdown if there are options to select from
										var hiddenOptionElem = jQuery(selectId + ' option:first');
										if (jQuery.isEmptyObject(opts)) {
											hiddenOptionElem.text(noneHiddenOptionText);
										}
										else {
											jQuery(selectId).prop('disabled', false);
											if (isLevel2(selectId))
												hiddenOptionElem.text(requiredHiddenOptionText);
											else if (isLevel3(selectId))
												hiddenOptionElem.text(optionalHiddenOptionText);
										}
									}
									
									// Rebuild the Selected Subjects table based on existing selections.
									// This is needed for editing a saved item.
									function reloadSubjectsTable() {
										var existingVals = jQuery(subjectsSelectId).val();
										// no existing values selected
										if (!existingVals) return;
										var levels = existingVals.split(" >>> ");
										if (levels.length >= 1) {
											jQuery(level1Id).val(levels[0]).change();
										}
										if (levels.length >= 2) {
											jQuery(level2Id).val(levels[1]).change();
										}
										if (levels.length > 2) {
											jQuery(level3Id).val(existingVals).change();
										}
									}
									
									// There's a hidden select control that holds the actual values transmitted
									// to the server on form submit. This function updates that select when
									// called
									function updateSelectedSubjects() {
										var newVal = jQuery(level3Id).val();
										if (!newVal) { // no 3rd level value, try 2nd level
											newVal = jQuery(level2Id).val();
											if (newVal) // has 2nd level value
												newVal = jQuery(level1Id).val() + " >>> " + jQuery(level2Id).val();
											else // no 2nd level value, try 1st level value
												newVal = jQuery(level1Id).val();
										}
										// actually set the selected values
										if (newVal) jQuery(subjectsSelectId).val(newVal).change();
									}
									
									if (!options) return;
									
									// initial reset, prevent browser breaking when restoring prev session vals
									/*resetChildSelect(level1Id);
									jQuery(level1Id).prop('disabled', false); // undo disable from reset
									resetChildSelect(level2Id);
									resetChildSelect(level3Id);*/
									
									// update select options on selection events
									jQuery(level1Id).change(function() {
										// since the first level changed, all child selects needs to be
										// updated
										resetChildSelect(level2Id);
										resetChildSelect(level3Id);
										// can only populate the second level select at this level
										populateChildSelect(level2Id, options[jQuery(level1Id).val()]);
										updateSelectedSubjects();
									});
									jQuery(level2Id).change(function() {
										resetChildSelect(level3Id);
										populateChildSelect(level3Id, options[jQuery(level1Id).val()][jQuery(level2Id).val()]);
										updateSelectedSubjects();
									});
									jQuery(level3Id).change(function() {
										updateSelectedSubjects();
									});
									
									// initial populate
									populateChildSelect(level1Id, options);
									reloadSubjectsTable();
								});
							</script>
							<%-- Don't bother implementing repeatable support, as we're not using it --%>
							<c:if test="${field.isRepeatable}">
								<jsp:include page="/ubc/submit/components/not-implemented.jsp">
									<jsp:param name="fieldType" value="repeatable ${field.inputType}" />
								</jsp:include>
							</c:if>
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
					<c:if test="${field.isRepeatable}">
						<script>
							// "Add More" & "Remove" button scripting
							jQuery(function() {
								// remove a repeated element
								function removeElement(element) {
									element.remove();
								}
								// make the jsp generated pre-existing remove buttons functional
								jQuery("div[id^='${field.inputWrapperID}']").find("button").click(function() {
									removeElement(jQuery(this).parent());
								}); 
								jQuery("#${field.inputAddMoreButtonID}").click(function() {
									var firstFieldWrapper= jQuery("div[id^='${field.inputWrapperID}']:first"); 
									var lastFieldWrapper= jQuery("div[id^='${field.inputWrapperID}']:last"); 
									var clone = firstFieldWrapper.clone();

									// stupid way to maintain unique IDs, just append a 1 to the previous id
									clone.prop('id', lastFieldWrapper.prop('id') + '1');
									clone.find("input").prop("value", "");
									clone.find("button").removeClass("hidden");
									clone.removeClass('hidden');
									lastFieldWrapper.after(clone);
									<c:if test='${field.hasEditor}'>
									// initialize tinyMCE editor for the newly inserted input element
									tinymceConfigInput.selector = "#" + clone.prop('id') + ' input';
									tinymce.init(tinymceConfigInput);
									</c:if>
									// make the newly added remove button functional
									clone.find("button.close").click(function() {
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