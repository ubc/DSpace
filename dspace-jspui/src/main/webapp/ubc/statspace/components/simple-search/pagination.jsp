<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pagination" value="${requestScope[param.paginationVar]}"></c:set>

<div class='row text-center'>
	<nav aria-label="Search Result Pages" class='col-sm-12'>
		<ul class="pagination pagination SimpleSearchPagination">
			<c:set var='isFirstPage' value="${pagination.pageCurrent == 1}" />
			<li class="${isFirstPage ? 'disabled' : ''}">
				<c:if test='${!isFirstPage}'><a href="${pagination.firstPageURL}"></c:if>
					<span><small><span class='glyphicon glyphicon-backward'></span></small></span>
				<c:if test='${!isFirstPage}'></a></c:if>
			</li>
			<li class="${isFirstPage ? 'disabled' : ''}">
				<c:if test='${!isFirstPage}'><a href="${pagination.previousPageURL}"></c:if>
					<span><small><span class='glyphicon glyphicon-triangle-left'></span></small></span>
				<c:if test='${!isFirstPage}'></a></c:if>
			</li>
			<c:if test="${pagination.pageRangeStart != 1}">
				<li><a href="${pagination.skipBackURL}"><small><span class="glyphicon glyphicon-option-horizontal"></span></small></a></li>
			</c:if>
			<c:forEach begin="${pagination.pageRangeStart}" end="${pagination.pageRangeEnd}" varStatus="loop">
				<li class="${loop.index == pagecurrent ? 'active' : ''}"><a href="${pagination.baseURL}${(loop.index-1)*pagination.multiplier}">${loop.index}</a></li>
			</c:forEach>
			<c:if test="${pagination.pageRangeEnd != pagination.pageTotal}">
				<li><a href="${pagination.skipForwardURL}"><small><span class="glyphicon glyphicon-option-horizontal"></span></small></a></li>
			</c:if>
			<c:set var='isLastPage' value="${pagination.pageRangeEnd == pagination.pageCurrent}" />
			<li class="${isLastPage ? 'disabled' : ''}">
				<c:if test='${!isLastPage}'><a href="${pagination.nextPageURL}"></c:if>
					<span><small><span class="glyphicon glyphicon-triangle-right"></span></small></span>
				<c:if test='${!isLastPage}'></a></c:if>
			</li>
			<li class="${pagination.pageRangeEnd == pagination.pageCurrent ? 'disabled' : ''}">
				<c:if test='${!isLastPage}'><a href="${pagination.lastPageURL}"></c:if>
					<span><small><span class="glyphicon glyphicon-forward"></span></small></span>
				<c:if test='${!isLastPage}'></a></c:if>
			</li>
		</ul>
	</nav>
</div>