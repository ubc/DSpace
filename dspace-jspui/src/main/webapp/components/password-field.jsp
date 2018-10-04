<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="form-group">
	<label class="col-md-offset-3 col-md-2 control-label" for="tpassword">
		<fmt:message key="jsp.register.edit-profile.pswd.field"/>${param.required?'*':''}</label>
	<div class="col-md-3">
		<div class="input-group">
			<input class="form-control" type="password" name="password"
				   id="tnewpassword" aria-describedby="passwordFeedback" pattern=".{0}|.{8,}" ${param.required?'required':''} title="Passwords must be at least 8 characters long."/>
			<a id="showHidePassword" class="input-group-addon">
				<i class="glyphicon glyphicon-eye-open"></i>
			</a>
		</div>
	</div>
	<div id="passwordFeedback" class="col-md-offset-5 col-md-4 help-block">
		<span id="passwordFeedbackStrength" class="password-strength">Strength:
			<span></span></span>
		<p id="passwordFeedbackText"></p>
	</div>
</div>
<script type="text/javascript" src='<c:url value="/static/ubc/lib/zxcvbn.js"/>'>
	</script>
<script>
	jQuery(function() {
		var scoreMap = {
			0: "None",
			1: "Bad",
			2: "Weak",
			3: "Good",
			4: "Strong",
		}
		var pwField = jQuery("#tnewpassword");
		var showHidePasswordBtn = jQuery("#showHidePassword");
		var showHidePasswordBtnStatus = jQuery("#showHidePassword i");
		jQuery("#passwordFeedback").hide();
		// gives feedback to the user on password strength
		pwField.on("input", function() {
			jQuery("#passwordFeedback").show();
			var ret = zxcvbn(pwField.val());
			if (ret.feedback.warning)
				jQuery("#passwordFeedbackText").text(ret.feedback.warning);
			else
				jQuery("#passwordFeedbackText").text(ret.feedback.suggestions);
			jQuery("#passwordFeedbackStrength span").text(scoreMap[ret.score]);
		});
		// controls the icon for hiding or showing passwords
		showHidePasswordBtn.click(function() {
			if (pwField.attr("type") == "text") {
				pwField.attr("type", "password");
				showHidePasswordBtnStatus.removeClass("glyphicon-eye-close");
				showHidePasswordBtnStatus.addClass("glyphicon-eye-open");
			}
			else {
				pwField.attr("type", "text");
				showHidePasswordBtnStatus.removeClass("glyphicon-eye-open");
				showHidePasswordBtnStatus.addClass("glyphicon-eye-close");
			}
		});
	});
</script>