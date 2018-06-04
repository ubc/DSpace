<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<div class="form-group">
	<label class="col-md-offset-3 col-md-2 control-label" for="tpassword">
		<fmt:message key="jsp.register.edit-profile.pswd.field"/></label>
	<div class="col-md-3">
		<div class="input-group">
			<input class="form-control" type="password" name="password"
				   id="tnewpassword" aria-describedby="passwordFeedback" />
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
			0: {
				text: "None",
				css: "password-strength-0"
			},
			1: {
				text: "Bad",
				css: "password-strength-1"
			},
			2: {
				text: "Weak",
				css: "password-strength-2"
			},
			3: {
				text: "Good",
				css: "password-strength-3"
			},
			4: {
				text: "Strong",
				css: "password-strength-4"
			}
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
			// change the strength text color
			jQuery("#passwordFeedbackStrength").removeClass(function(index, names) {
				// remove the old color
				var classNames = names.split(" ");
				for (var i in scoreMap) {
					for (var j in classNames) {
						if (classNames[j] == scoreMap[i].css) return classNames[j];
					}
				}
			});
			jQuery("#passwordFeedbackStrength").addClass(scoreMap[ret.score].css);
			jQuery("#passwordFeedbackStrength span").text(scoreMap[ret.score].text);
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