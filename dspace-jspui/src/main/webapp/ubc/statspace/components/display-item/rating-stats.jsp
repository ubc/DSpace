<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:set var="numStarArray" value="${[param.num5StarVar,param.num4StarVar,param.num3StarVar,param.num2StarVar,param.num1StarVar]}"></c:set>
<c:set var="totalRatingCount" value="${param.num5StarVar+param.num4StarVar+param.num3StarVar+param.num2StarVar+param.num1StarVar}" />
<c:set var="itemRetriever" value="${requestScope[param.retrieverVar]}"></c:set>
<c:set var="ratingDescriptionMap" value="${requestScope[param.ratingDescriptionMapVar]}"></c:set>

<div class="rating-stats">
    <div class="row rating-stats-header">
        <div class="col-xs-8 rating-stats-title">
            <h5>Ratings in detail
                <small>
                    <c:choose>
                        <c:when test="${totalRatingCount gt 1}">
                            (${totalRatingCount} ratings)
                        </c:when>
                        <c:otherwise>
                            (${totalRatingCount} rating)
                        </c:otherwise>
                    </c:choose>
                </small>
            </h5>
        </div>
        <div class="col-xs-4 rating-stats-avg-rating">
            <c:choose>
                <c:when test="${totalRatingCount gt 0}">
                    <fmt:formatNumber value="${itemRetriever.avgRating}" pattern="0.0"/>
                </c:when>
                <c:otherwise>
                    &nbsp;
                </c:otherwise>
            </c:choose>
        </div>
    </div>

    <div class="row rating-stats-header">
        <div class="col-xs-12">
            <small>Would you recommend this resource for teaching and learning?</small>
        </div>
    </div>

    <c:forEach items="${numStarArray}" var="starCount" varStatus="status">
        <c:set var="starValue" value="${(5-status.index)}"/>
        <div class="row rating-bar-row">
            <div class="col-xs-4 rating-bar-label">
                ${starValue}<span class="glyphicon glyphicon-star"></span>&nbsp;<c:out value="${ratingDescriptionMap[starValue]}"/>&nbsp;
            </div>
            <div class="col-xs-6 rating-bar-background">
                <div class="rating-bar" style="width:${totalRatingCount == 0? 0 : (starCount / totalRatingCount)*100}%;">
                </div>
            </div>
            <div class="col-xs-2 rating-bar-count">${starCount}</div>
        </div>
    </c:forEach>
</div>