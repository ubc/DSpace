<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="pagination" value="${requestScope[param.paginationVar]}"></c:set>

<div class='row text-center'>
	<nav aria-label="Search Result Pages" class='col-sm-12'>
		<ul class="pagination pagination SimpleSearchPagination">
			<li class="${pagination.pageCurrent == 1 ? 'disabled' : ''}">
				<a href="${pagination.firstPageURL}"><small><span class='glyphicon glyphicon-backward'></span></small></a>
			</li>
			<li class="${pagination.pageCurrent == 1 ? 'disabled' : ''}">
				<a href="${pagination.previousPageURL}"><small><span class='glyphicon glyphicon-triangle-left'></span></small></a>
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
			<li class="${pagination.pageRangeEnd == pagination.pageCurrent ? 'disabled' : ''}">
				<a href="${pagination.nextPageURL}"><small><span class="glyphicon glyphicon-triangle-right"></span></small></a>
			</li>
			<li class="${pagination.pageRangeEnd == pagination.pageCurrent ? 'disabled' : ''}">
				<a href="${pagination.lastPageURL}"><small><span class="glyphicon glyphicon-forward"></span></small></a>
			</li>
		</ul>
	</nav>
</div>