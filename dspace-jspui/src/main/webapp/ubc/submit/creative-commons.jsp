<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Show the user the Creative Commons license which they may grant or reject
  -
  - Attributes to pass in:
  -    cclicense.exists   - boolean to indicate CC license already exists
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%--
These imports used to generate hidden fields for the SubmissionController to
know what step the submission is on.
--%>
<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%-- Used to generate Prev,Cancel,Next,etc buttons --%>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout style="submission"
			   locbar="off"
               navbar="off"
               titlekey="jsp.submit.creative-commons.title"
               nocache="true">

    <form name="foo" id="license_form" action="<c:url value='/submit' />"
		  class="form-horizontal"
		  method="post" onkeydown="return disableEnterKey(event);">
		<%-- Progress Bar has to be in the form since it does a submit on the form --%>
		<jsp:include page="/submit/progressbar.jsp"/>
		<%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
		<% Context context = UIUtil.obtainContext(request); %>
		<%= SubmissionController.getSubmissionParameters(context, request) %>

        <%-- <h1>Submit: Use a Creative Commons License</h1> --%>
		<h1><fmt:message key="jsp.submit.creative-commons.heading"/></h1>

		<p class="help-block"><fmt:message key="jsp.submit.creative-commons.info1"/></p>

		<!-- License options to choose from -->
		<div class="form-group">
			<label class="col-sm-2 control-label"><fmt:message key="jsp.submit.creative-commons.license"/></label>
			<div class="col-sm-10">
				<c:forEach items='${licenseUtil.licenses}' var='license' varStatus='status'>
					<div class='radio'>
						<label>
							<input type='radio' name='licenseclass_chooser' required value="${license.value.shortName}" 
								   <c:if test="${existingLicense.shortName == license.value.shortName}">checked</c:if> />
							${status.first ? '<em>(Recommended)</em>' : ''} ${license.value.fullName}
							<a href='${license.value.licenseUrl}' target='_blank'>(${license.value.shortName})</a>
						</label>
					</div>
				</c:forEach>
			</div>
		</div>

		<!-- Blurb used for Creative Commons licenses -->
		<div id='blurbCCLicense'>
			<div class="panel panel-default">
				<div class="panel-body">
					<h4 class="text-center ccLicenseName">Creative Commons License</h4>
					<p>In selecting and assigning this <em class='ccLicenseName'></em> license, you agree that the submitted material is either already licensed under or should be made available according to the terms of the license, as described in detail at <a target='_blank' id='ccLicenseLink' href=''></a>.</p>
					<p>You represent that (i) the submission is your original work, and that you have the right to grant the rights contained in this license, (ii) (where applicable) all co-authors have approved the submission and have agreed to the terms of this license, (iii) your submission does not, to the best of your knowledge, infringe upon anyone's copyright, (iv) the submission, to the best of your knowledge, does not contain any confidential information or violate anyone’s right to privacy, and (v) for material contained within for which you do not hold copyright, you have obtained the unrestricted permission of the copyright owner to grant the rights required by this license and that such third-party owned material is clearly identified and acknowledged within the text or content of the submission.</p>
					<p>If at any time after submitting this work you learn that any of the above statements are inaccurate, you agree to inform BioSpace of any inaccuracies as soon as possible.</p>
					<p>BioSpace will clearly identify your name(s) as the author(s) or owner(s) of the submission as required by the license you have chosen (if applicable).  Agreeing to this statement does not affect ownership of copyright.</p>
				</div>
			</div>
			<!-- Checkboxes explicitly asking the user to agree to the copyright chosen -->
			<div class="form-group">
				<label class="col-sm-12">
					<input type="checkbox" required />
					I have read and understood the terms for submission to this repository as outlined above. 
				</label>
			</div>
			<div class="form-group">
				<label class="col-sm-12">
					<input type="checkbox" required />
					I have read and understood the terms and legal code for the license I have selected. I hereby elect to apply this license to this work.
				</label>
			</div>
		</div>

		<!-- Blurb used for other types of licenses -->
		<div id="blurbOtherLicense">
			<div class="panel panel-default">
				<div class="panel-body">
					<h4 class="text-center">Public Domain</h4>
					<p>In selecting the Public Domain Mark, you agree that this material(s) is free of known copyright restrictions, as described in detail at <a href='https://creativecommons.org/share-your-work/public-domain/'>https://creativecommons.org/share-your-work/public-domain/</a>.</p>
					<p>If at any time after submitting this work you learn that the above statement is inaccurate, you agree to inform BioSpace of any inaccuracies as soon as possible.</p>
				</div>
			</div>
			<!-- Checkboxes explicitly asking the user to agree to the copyright chosen -->
			<div class="form-group">
				<label class="col-sm-12">
					<input type="checkbox" required />
					I have read and understood the terms for submission to this repository as outlined above. 
				</label>
			</div>
			<div class="form-group">
				<label class="col-sm-12">
					<input type="checkbox" required />
					I have read and understood the terms and legal code for the Public Domain Mark. I hereby elect to apply this mark to this work.
				</label>
			</div>
		</div>

		<div class="btn-group col-sm-offset-4 col-sm-8 col-md-offset-6 col-md-6">
			<input class="btn btn-default col-md-offset-3 col-md-3 col-sm-4" type="submit" name="<%=AbstractProcessingStep.PREVIOUS_BUTTON%>" value="<fmt:message key="jsp.submit.general.previous"/>" formnovalidate />
			<input class="btn btn-default col-md-3 col-sm-4" type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" value="<fmt:message key="jsp.submit.general.cancel-or-save.button"/>" formnovalidate />
			<input class="btn btn-primary col-md-3 col-sm-4" id="nextStepButton" type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" value="<fmt:message key="jsp.submit.general.next"/>" />
		</div>
    </form>

    <script type="text/javascript">
		jQuery(function() {
			// stores which licenses are creative common ones
			var licenses = {
				<c:forEach items='${licenseUtil.licenses}' var='license' varStatus='status'>
					"${license.value.shortName}": {
						"isCreativeCommons": ${license.value.isCreativeCommons},
						"fullName": "${license.value.fullName}",
						"url": "${license.value.licenseUrl}"
					}${status.last ? "":","}
				</c:forEach>
			};
			// hides or shows license blurbs as appropriate depending on which
			// license is selected
			function toggleLicenseBlurb() {
				function hideBlurb(blurbId) {
					// have to remove the required attr on inputs when hiding them
					// cause otherwise, the form won't submit
					jQuery(blurbId + " input").removeAttr('required');
					jQuery(blurbId).hide();
				}
				function showBlurb(blurbId) {
					jQuery(blurbId + " input").attr('required', true);
					jQuery(blurbId).show();
				}
				var selected = jQuery('input[name=licenseclass_chooser]:checked').val();
				var license = licenses[selected];
				if (license['isCreativeCommons']) {
					jQuery(".ccLicenseName").text(license['fullName']+" ("+selected+")");
					jQuery("#ccLicenseLink").prop("href", license['url']);
					jQuery("#ccLicenseLink").text(license['url']);
					showBlurb("#blurbCCLicense");
					hideBlurb("#blurbOtherLicense");
				}
				else {
					hideBlurb("#blurbCCLicense");
					showBlurb("#blurbOtherLicense");
				}
			}
			// initial page load, show the appropriate blurb
			toggleLicenseBlurb();
			// update the appropriate blurb when the user changes it
			jQuery('input[name=licenseclass_chooser]').change(function() {
				toggleLicenseBlurb();
			});
		});
	</script>

</dspace:layout>
