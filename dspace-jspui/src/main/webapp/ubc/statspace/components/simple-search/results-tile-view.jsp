<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="results" value="${requestScope[param.resultsVar]}"></c:set>

<div class="row discovery-result-results">
	<div class="col-md-12 searchResultsWrap">
	<c:forEach items="${results}" var="result">
		<div class="col-md-4 col-sm-6 col-xs-12 searchResultBox">
			<a class="center-block searchResultThumbnail img-rounded" href="${result.url}" 
			   style='background: center / contain no-repeat url(${result.thumbnail});'>
				<div class="text-center searchResultThumbnailPlaceholder">
					<c:if test="${empty result.thumbnail}">
					<%-- table is a simple but stupid workaround for vertical centering placeholder image --%>
					<table>
						<tr>
							<td>
								<span class="glyphicon glyphicon-file"></span>
							</td>
						</tr>
					</table>
					</c:if>
				</div>
			</a>

			<div class="caption">
				<h4 class="text-center">
					<a href="${result.url}">${result.title}</a>
				</h4>
				<p>
					${result.summary}
				</p>
				<div>
					<!-- List Resource Types -->
					<small>
						<strong>Resource Type:</strong>
						<ul class='list-inline'>
							<c:forEach items="${result.resourceTypes}" var="type">
								<jsp:include page="/ubc/statspace/components/simple-search/tag-list-item.jsp">
									<jsp:param name="listItem" value="${type}" />
									<jsp:param name="searchFilterName" value="resourceType" />
								</jsp:include>
							</c:forEach>
						</ul>
					</small>
				</div>
			</div>
		</div>
	</c:forEach>
	</div>
</div>