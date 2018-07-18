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
			<div class="fileTileMedia text-center" title="${result.description}">
			<c:choose>
				<c:when test="${result.isPlayableAudio}">
					<jsp:include page="/ubc/statspace/components/media-tags/audio.jsp">
						<jsp:param name="id" value="${result.id}" />
						<jsp:param name="prefix" value="tile" />
						<jsp:param name="link" value="${result.link}" />
						<jsp:param name="mimeType" value="${result.mimeType}" />
					</jsp:include>
				</c:when>
				<c:when test="${result.isPlayableVideo}">
					<jsp:include page="/ubc/statspace/components/media-tags/video.jsp">
						<jsp:param name="id" value="${result.id}" />
						<jsp:param name="prefix" value="tile" />
						<jsp:param name="link" value="${result.link}" />
						<jsp:param name="mimeType" value="${result.mimeType}" />
					</jsp:include>
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
				<a class="btn btn-primary" href="${result.link}?forcedownload" title="Download" download="${result.name}"><i class="glyphicon glyphicon-save"></i> Download</a>
				<span class="label label-info">${result.size}</span>
				<span class="fileTileRestriction">
				<c:choose>
					<c:when test="${result.isRestricted}">
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