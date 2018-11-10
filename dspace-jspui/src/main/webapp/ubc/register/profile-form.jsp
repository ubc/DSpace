<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - User profile editing form.
  -
  - This isn't a full page, just the fields for entering a user's profile.
  -
  - Attributes to pass in:
  -   eperson       - the EPerson to edit the profile for.  Can be null,
  -                   in which case blank fields are displayed.
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.Locale"%>

<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.content.Metadatum" %>
<%@ page import="org.dspace.core.Utils" %>

<div class="row"><h3 class='col-md-offset-2 col-md-6 text-center'>Personal Information</h3></div>
	<div class="form-group">
		<label class="col-md-offset-2 col-md-2 control-label" for="first_name"><fmt:message key="jsp.register.profile-form.fname.field"/></label>
        <div class="col-md-4"><input class="form-control" type="text" name="first_name" id="tfirst_name" size="40" value="${user.firstName}" required/></div>
	</div>
	<div class="form-group">
        <%-- <td align="right" class="standard"><label for="tlast_name"><strong>Last name*:</strong></label></td> --%>
		<label class="col-md-offset-2 col-md-2 control-label" for="tlast_name"><fmt:message key="jsp.register.profile-form.lname.field"/></label>
        <div class="col-md-4"><input class="form-control" type="text" name="last_name" id="tlast_name" size="40" value="${user.lastName}" required /></div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-2 col-md-2 control-label" for="trole"><fmt:message key="jsp.register.profile-form.role.field"/></label>
        <div class="col-md-4">
			<c:set var="roleFaculty" value="Instructor/Faculty" />
			<c:set var="roleStaff" value="Staff" />
			<c:set var="roleOther" value="Other" />
			<select class="form-control" name="role" id="trole" value="${user.role}">
				<option value="${roleFaculty}" ${user.role == roleFaculty ? "selected" : ""}>${roleFaculty}</option>
				<option value="${roleStaff}" ${user.role == roleStaff ? "selected" : ""}>${roleStaff}</option>
				<option value="${roleOther}" ${user.role == roleOther ? "selected" : ""}>${roleOther}</option>
			</select>
		</div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-2 col-md-2 control-label" for="tphone"><fmt:message key="jsp.register.profile-form.phone.field"/></label>
        <div class="col-md-4"><input class="form-control" type="text" name="phone" id="tphone" size="40" maxlength="32" value="${user.phone}"/></div>
    </div>

<div class="row">
	<div class="col-md-offset-2 col-md-6">
		${instructorAccessBlurb}
		<div>
			<label>
				<input type='checkbox' id="RequestInstructorAccessCheckbox" name='requestInstructorAccess' ${user.hasRequestedInstructorAccess ? "checked disabled" : ""}>
				If I am granted instructor-only access, I agree that I will not share instructor-only material or my username/password with others.
			</label>
		</div>
	</div>
	<script>
		jQuery(function(){
			var checkbox = jQuery('#RequestInstructorAccessCheckbox');
			var instructorFieldset = jQuery('#InstructorInformationFieldset');
			function toggleInstructorFieldset() {
				if (checkbox.prop('checked')) {
					console.log("checked");
					instructorFieldset.prop('disabled', false);
					instructorFieldset.removeClass("fadedSection");
				}
				else {
					console.log("not checked");
					instructorFieldset.prop('disabled', true);
					instructorFieldset.addClass("fadedSection");
				}
			}
			checkbox.change(function() {
				toggleInstructorFieldset();
			});
			toggleInstructorFieldset()
		});
	</script>
</div>

<fieldset id="InstructorInformationFieldset" disabled class="fadedSection">
	<div class="row"><h3 class=' col-md-offset-2 col-md-6 text-center'>Instructor Information</h3></div>
	<div class="form-group">
		<c:set var="institutionTypeUniversity" value="College or University" />
		<c:set var="institutionTypeSecondary" value="Secondary School" />
		<c:set var="institutionTypePrimary" value="Elementary/Primary School" />
		<c:set var="institutionTypeProfit" value="For Profit Institution" />
		<c:set var="institutionTypeOther" value="Other" />
		<label class="col-md-offset-2 col-md-2 control-label" for="tinstitution_type"><fmt:message key="jsp.register.profile-form.institutiontype.field"/></label>
        <div class="col-md-4">
			<select class="form-control" type="text" name="institution_type" id="tinstitution_type" maxlength="32" value="${user.institutionType}">
				<option value="${institutionTypeUniversity}" ${user.institutionType == institutionTypeUniversity ? "selected" : ""}>${institutionTypeUniversity}</option>
				<option value="${institutionTypeSecondary}" ${user.institutionType == institutionTypeSecondary ? "selected" : ""}>${institutionTypeSecondary}</option>
				<option value="${institutionTypePrimary}" ${user.institutionType == institutionTypePrimary ? "selected" : ""}>${institutionTypePrimary}</option>
				<option value="${institutionTypeProfit}" ${user.institutionType == institutionTypeProfit ? "selected" : ""}>${institutionTypeProfit}</option>
				<option value="${institutionTypeOther}" ${user.institutionType == institutionTypeOther ? "selected" : ""}>${institutionTypeOther}</option>
			</select>
		</div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-2 col-md-2 control-label" for="tinstitution"><fmt:message key="jsp.register.profile-form.institution.field"/></label>
        <div class="col-md-4"><input class="form-control" type="text" name="institution" id="tinstitution" maxlength="32" value="${user.institution}"/></div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-2 col-md-2 control-label" for="tunit"><fmt:message key="jsp.register.profile-form.unit.field"/></label>
        <div class="col-md-4"><input class="form-control" type="text" name="unit" id="tunit" size="40" value="${user.unit}"/></div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-2 col-md-2 control-label" for="tinstitution_address"><fmt:message key="jsp.register.profile-form.institutionaddress.field"/></label>
        <div class="col-md-4"><input class="form-control" type="text" name="institution_address" id="tinstitution_address" size="40" value="${user.institutionAddress}"/></div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-2 col-md-2 control-label" for="tinstitution_url"><fmt:message key="jsp.register.profile-form.institutionurl.field"/></label>
        <div class="col-md-4"><input class="form-control" type="text" name="institution_url" id="tinstitution_url" size="40" value="${user.institutionUrl}"/></div>
		<span class="help-block"><fmt:message key="jsp.register.profile-form.institutionurl.help"/></span>
    </div>
	<div class="form-group">
		<label class="col-md-offset-2 col-md-2 control-label" for="tinstitution_email"><fmt:message key="jsp.register.profile-form.institutionemail.field"/></label>
        <div class="col-md-4"><input class="form-control" type="text" name="institution_email" id="tinstitution_email" size="40" value="${user.institutionEmail}"/></div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-2 col-md-2 control-label" for="tsupervisor_contact"><fmt:message key="jsp.register.profile-form.supervisorcontact.field"/></label>
        <div class="col-md-4"><input class="form-control" type="text" name="supervisor_contact" id="tsupervisor_contact" size="40" value="${user.supervisorContact}"/></div>
		<span class="help-block"><fmt:message key="jsp.register.profile-form.supervisorcontact.help"/></span>
    </div>
	<div class="form-group">
		<label class="col-md-offset-2 col-md-2 control-label" for="tadditional"><fmt:message key="jsp.register.profile-form.additional.field"/></label>
        <div class="col-md-4"><textarea class="form-control" name="additional" id="tadditional">${user.additionalInfo}</textarea></div>
		<span class="help-block"><fmt:message key="jsp.register.profile-form.additional.help"/></span>
    </div>
</fieldset>