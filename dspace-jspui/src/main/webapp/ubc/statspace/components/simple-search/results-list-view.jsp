<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="results" value="${requestScope[param.resultsVar]}"></c:set>

<c:forEach items="${results}" var="result" varStatus="resultStatus">
	<div class="media SimpleSearchResultListItem">
		<div class="media-left">
			<a href="${result.url}">
				<img class="media-object ${result.hasPlaceholderThumbnail ? "SimpleSearchPlaceholderThumbnail":""}" src="${result.thumbnail}" alt="Thumbnail for ${result.title}">
			</a>
		</div>
		<div class="media-body">
			<h4 class="media-heading">
				<a href="${result.url}">${result.title}</a>
			</h4>
			<!-- Information that is always visible -->
			<div>
				<small>
				<c:set var="result" value="${result}" scope="request"></c:set>
				<jsp:include page="/ubc/statspace/components/simple-search/subject-list.jsp">
					<jsp:param name="retrieverVar" value="result" />
				</jsp:include>
				<c:set var="resultItemCollapseID" value="result-item-collapse-${resultStatus.index}"></c:set>
				<!-- List Resource Types -->
					<ul class='list-inline'>
						<li><strong>Resource Type:</strong></li>
						<c:forEach items="${result.resourceTypes}" var="type">
							<jsp:include page="/ubc/statspace/components/simple-search/tag-list-item.jsp">
								<jsp:param name="listItem" value="${type}" />
								<jsp:param name="searchFilterName" value="resourceType" />
							</jsp:include>
						</c:forEach>
					</ul>
					<!-- List Keywords -->
					<c:if test="${!empty result.keywords}">	
						<ul class='list-inline'>
							<li><strong>Keywords:</strong></li>
							<c:forEach items="${result.keywords}" var="keyword">
								<jsp:include page="/ubc/statspace/components/simple-search/tag-list-item.jsp">
									<jsp:param name="listItem" value="${keyword}" />
									<jsp:param name="searchFilterName" value="keyword" />
								</jsp:include>
							</c:forEach>
						</ul>
					</c:if>
				</small>
			</div>
			<!-- Information hidden away until user expands it -->
			<c:set var="resultItemCollapseID" value="result-item-collapse-${resultStatus.index}"></c:set>
			<p>
				<button class="btn btn-default btn-xs" type="button" id="${resultItemCollapseID}-btn"
					data-toggle="collapse" data-target="#${resultItemCollapseID}" aria-expanded="false" aria-controls="collapseExample">
					<span class="glyphicon glyphicon-chevron-down"></span> Details
				</button>
			</p>
			<div id="${resultItemCollapseID}" class="collapse">
				<p>${result.summary}</p>
				<small>
					<ul class='list-inline'>
						<li><strong>Author:</strong></li>
						<c:forEach items="${result.authors}" var="author">
							<jsp:include page="/ubc/statspace/components/simple-search/tag-list-item.jsp">
								<jsp:param name="listItem" value="${author}" />
								<jsp:param name="searchFilterName" value="author" />
							</jsp:include>
						</c:forEach>
					</ul>
					<ul class='list-inline'>
						<li><strong>License:</strong></li>
						<li>${result.license}</li>
						<c:if test='${!empty result.dateCreated}'>
							<li><strong>Created:</strong></li>
							<li>${result.dateCreated}</li>
						</c:if>
					</ul>
				</small>
			</div>
			<script>
				// swap the + and - icon on the details button when showing and hiding content
				jQuery(function() {
					var buttonIcon = jQuery('#${resultItemCollapseID}-btn span');
					jQuery('#${resultItemCollapseID}').on('show.bs.collapse', function () {
						buttonIcon.switchClass('glyphicon-chevron-down', 'glyphicon-chevron-up')
					});
					jQuery('#${resultItemCollapseID}').on('hide.bs.collapse', function () {
						buttonIcon.switchClass('glyphicon-chevron-up', 'glyphicon-chevron-down')
					});
				});
			</script>
		</div>
	</div>
</c:forEach>