<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:if test='${!empty featuredArticles}'>
	<h2 class='text-center'>Featured Resources</h2>
	<div class="row">
		<div class="col-xs-offset-1 col-xs-10">
			<div class="featured-articles">
				<c:forEach items="${featuredArticles}" var="featuredArticle">
					<div class="panel panel-default">
						<div class="panel-body">
							<div class="media">
								<div class="media-left ${featuredArticle.hasPlaceholderThumbnail?'fadedSection':''}">
									<a href="${featuredArticle.url}" title="${featuredArticle.title}">
										<img class="media-object" src="${featuredArticle.thumbnail}">
									</a>
								</div>
								<div class="media-body">
									<a href="${featuredArticle.url}" title="${featuredArticle.title}">
										<h4 class="media-heading">${featuredArticle.title}</h4>
									</a>
									<p>${featuredArticle.summary}</p>
								</div>
							</div>
						</div>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>
	<%-- Only using carousel on this page, so only including the library here --%>
	<link rel="stylesheet" type="text/css" href="<c:url value="/static/ubc/lib/slick/slick.css" />" />
	<link rel="stylesheet" type="text/css" href="<c:url value="/static/ubc/lib/slick/slick-theme.css" />"/>
	<script type="text/javascript" src="<c:url value="/static/ubc/lib/slick/slick.min.js" />"></script>
	<script>
		$(document).ready(function(){
			$('.featured-articles').slick({
				dots: true,
				autoplay: true,
				autoplaySpeed: 10000,
				speed: 1500
			});
		});
	</script>
</c:if>