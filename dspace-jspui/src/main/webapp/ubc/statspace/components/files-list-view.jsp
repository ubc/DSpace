<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="itemRetriever" value="${requestScope[param.retrieverVar]}"></c:set>

<c:forEach items="${itemRetriever.files}" var="result">
	<div class="panel panel-warning">
		<div class="panel-heading">
			<h3 class="panel-title file-title-overflow">
				<c:choose>
					<c:when test="${result.isPlayableVideo}">
						<span class="glyphicon glyphicon-film"></span>
					</c:when>
					<c:when test="${result.isPlayableAudio}">
						<span class="glyphicon glyphicon-volume-up"></span>
					</c:when>
					<c:when test="${result.isImage}">
						<span class="glyphicon glyphicon-picture"></span>
					</c:when>
					<c:otherwise>
						<span class="glyphicon glyphicon-file"></span>
					</c:otherwise>
				</c:choose>
				<a href="${result.link}">${result.name}</a>
				<c:choose>
					<c:when test="${result.instructorOnly}">
						<i class="glyphicon glyphicon-lock restrictionIconColorInstructorOnly pull-right" title='<fmt:message key="jsp.submit.upload-file-list.tooltip.instructor-only"/>'></i>
					</c:when>
					<c:otherwise>
						<i class="glyphicon glyphicon-globe restrictionIconColorEveryone pull-right" title='This file is accessible to everyone.'></i>
					</c:otherwise>
				</c:choose>
			</h3>
		</div>
		<c:if test="${!empty result.description ||
					  !empty result.thumbnail ||
					  result.isPlayableAudio ||
					  result.isPlayableVideo}">
			<div class="panel-body">
				<c:if test="${!empty result.description}">
					<p>${result.description}</p>
				</c:if>
				<c:if test="${!empty result.thumbnail}">
					<a href="${result.link}">
						<img class="img-thumbnail center-block" src="${result.thumbnail}" />
					</a>
				</c:if>
				<c:if test="${result.isPlayableAudio}">
					<audio id="stream-${result.id}" class="video-js vjs-fluid vjs-audio" controls preload="none"
							data-setup='{"aspectRatio": "1:0", "controlBar": {"fullscreenToggle": false}}'>
						<source src="${result.link}" type="${result.mimeType}" />
						<p class="vjs-no-js">
							To view this video please enable JavaScript, and consider upgrading to a web browser that
							<a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 media playback</a>
						</p>
					</audio>
				</c:if>
				<c:if test="${result.isPlayableVideo}">
					<video id="stream-${result.id}" class="video-js vjs-fluid vjs-big-play-centered" controls preload="metadata"
							data-setup="{}">
						<source src="${result.link}" type="${result.mimeType}" />
						<p class="vjs-no-js">
							To view this video please enable JavaScript, and consider upgrading to a web browser that
							<a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a>
						</p>
					</video>
				</c:if>
			</div>
		</c:if>
		<div class="panel-footer">
			<a class="btn btn-primary" href="${result.link}?forcedownload"><i class="glyphicon glyphicon-download"></i> Download</a>
			<span class="label label-info">${result.size}</span>
		</div>
	</div>
</c:forEach>