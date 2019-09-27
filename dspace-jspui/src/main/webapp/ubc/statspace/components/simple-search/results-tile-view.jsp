<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>  

<c:set var="results" value="${requestScope[param.resultsVar]}"></c:set>
<c:set var="commentingEnabled" value="${requestScope[param.commentingEnabledVar]}"></c:set>

<div class="row discovery-result-results">
	<div class="col-md-12 searchResultsWrap">
	<c:forEach items="${results}" var="result">
		<div class="col-md-4 col-sm-6 col-xs-12 searchResultBox">
			<a class="center-block searchResultThumbnail img-rounded ${result.hasPlaceholderThumbnail ? "SimpleSearchPlaceholderThumbnail":""}" href="${result.url}" 
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
                <c:if test="${commentingEnabled && result.activeRatingCount gt 0}">
                    <fmt:formatNumber value="${result.avgRating}" pattern="0.0" var="roundedAvgRating"/>
                    <span class="starRating">
                        <c:set var="starDisplayed" value="${0}" />
                        <c:forEach begin="1" end="${(roundedAvgRating - (roundedAvgRating mod 1))}">
                            <span class="glyphicon glyphicon-star"></span>
                            <c:set var="starDisplayed" value="${starDisplayed+1}" />
                        </c:forEach>
                        <c:choose>
                            <c:when test="${(roundedAvgRating * 10) mod 10 ge 5}">
                                <span class="glyphicon glyphicon-star glyphicon-half-star"></span>
                                <c:set var="starDisplayed" value="${starDisplayed+1}" />
                            </c:when>
                        </c:choose>
                        <c:forEach begin="1" end="${5 - starDisplayed}">
                            <span class="glyphicon glyphicon-star-empty"></span>
                        </c:forEach>
                    </span>
                    <small>(<c:out value="${result.activeRatingCount}"/>)</small>
                </c:if>
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
						<strong>Author:</strong>
						<ul class='list-inline'>
							<c:forEach items="${result.authors}" var="author">
								<jsp:include page="/ubc/statspace/components/simple-search/tag-list-item.jsp">
									<jsp:param name="listItem" value="${fn:escapeXml(author)}" />
									<jsp:param name="searchFilterName" value="author" />
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