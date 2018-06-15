<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<audio id="${param.prefix}-stream-${param.id}" class="mejs__player"
		preload="none" controls width="100%"
		data-mejsoptions='{"pluginPath": "https://cdnjs.cloudflare.com/ajax/libs/mediaelement/4.2.9/", "shimScriptAccess":"always"}'>
	<source src="${param.link}" type="${param.mimeType}" />
	<p class="vjs-no-js">
		To view this video please enable JavaScript, and consider upgrading to a web browser that
		<a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 media playback</a>
	</p>
</audio>

<div id='stream-${param.id}-error' class='hidden mediaFormatError' title='Your browser indicated that it does not have support for this media file.'>
	<div class='alert alert-danger col-md-12 text-center' role='alert'>
		<i class='glyphicon glyphicon-remove-circle'></i> Unable to stream this media format. Please download it instead.
	</div>
</div>

<script>
	jQuery(function() {
		var v = document.createElement('audio');
		if (!v.canPlayType) return; // no video tag support
		if (!v.canPlayType('${param.mimeType}')) {
			// browser indicates that it can't play this mimetype
			jQuery('#stream-${param.id}').hide();
			jQuery('#stream-${param.id}-error').removeClass("hidden");
		}
	});
</script>
