<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="itemRetriever" value="${requestScope[param.retrieverVar]}"></c:set>

<div class="row">
<c:forEach items="${itemRetriever.files}" var="result">
	<div class="col-md-3 col-sm-4 fileTile">
		<div class="panel panel-default">
			<!-- File Name -->
			<div class="panel-heading">
				<a href="${result.link}">
					<h3 class="panel-title fileTileTitle" title="${result.name}">
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
							${result.name}
					</h3>
				</a>
			</div>
			<!-- Thumbnail/Media player -->
			<div class="fileTileMedia" title="${result.description}">
			<c:choose>
				<c:when test="${result.isPlayableAudio}">
					<audio id="stream-${result.id}" class="video-js vjs-fluid vjs-audio" controls preload="none"
							data-setup='{"aspectRatio": "1:0", "controlBar": {"fullscreenToggle": false}}'>
						<source src="${result.link}" type="${result.mimeType}" />
						<p class="vjs-no-js">
							To view this video please enable JavaScript, and consider upgrading to a web browser that
							<a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 media playback</a>
						</p>
					</audio>
				</c:when>
				<c:when test="${result.isPlayableVideo}">
					<video style="vertical-align: middle;" id="stream-${result.id}" class="video-js vjs-fluid vjs-big-play-centered vjs-16-9" controls preload="metadata"
							data-setup='{}'>
						<source src="${result.link}" type="${result.mimeType}" />
						<p class="vjs-no-js">
							To view this video please enable JavaScript, and consider upgrading to a web browser that
							<a href="http://videojs.com/html5-video-support/" target="_blank">supports HTML5 video</a>
						</p>
					</video>
				</c:when>
				<c:when test="${!empty result.thumbnail}">
					<a href="${result.link}" <c:if test="${!empty result.description}">- ${result.description}</c:if>">
						<img src="${result.thumbnail}" class="center-block thumbnail">
					</a>
				</c:when>
				<c:otherwise>
					<a href="${result.link}" <c:if test="${!empty result.description}">- ${result.description}</c:if>">
						<div class="fileTilePlaceholder">
							<i class="glyphicon glyphicon-file"></i>
						</div>
					</a>
				</c:otherwise>
			</c:choose>
			</div>
			<!-- Download button -->
			<div class="panel-footer">
				<a class="btn btn-primary" href="${result.link}?forcedownload" title="Download"><i class="glyphicon glyphicon-save"></i> Download</a>
				<span class="label label-info">${result.size}</span>
				<span class="fileTileRestriction">
				<c:choose>
					<c:when test="${result.instructorOnly}">
						<i class="glyphicon glyphicon-lock restrictionIconColorInstructorOnly" title='<fmt:message key="jsp.submit.upload-file-list.tooltip.instructor-only"/>'></i>
					</c:when>
					<c:otherwise>
						<i class="glyphicon glyphicon-globe restrictionIconColorEveryone" title='This file is accessible to everyone.'></i>
					</c:otherwise>
				</c:choose>
				</span>
			</div>
		</div>
	</div>
</c:forEach>
</div>