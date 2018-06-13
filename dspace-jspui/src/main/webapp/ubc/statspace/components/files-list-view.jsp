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
					<jsp:include page="/ubc/statspace/components/media-tags/audio.jsp">
						<jsp:param name="id" value="${result.id}" />
						<jsp:param name="link" value="${result.link}" />
						<jsp:param name="mimeType" value="${result.mimeType}" />
					</jsp:include>
				</c:if>
				<c:if test="${result.isPlayableVideo}">
					<jsp:include page="/ubc/statspace/components/media-tags/video.jsp">
						<jsp:param name="id" value="${result.id}" />
						<jsp:param name="link" value="${result.link}" />
						<jsp:param name="mimeType" value="${result.mimeType}" />
					</jsp:include>
				</c:if>
			</div>
		</c:if>
		<div class="panel-footer">
			<a class="btn btn-primary" href="${result.link}?forcedownload"><i class="glyphicon glyphicon-download"></i> Download</a>
			<span class="label label-info">${result.size}</span>
		</div>
	</div>
</c:forEach>