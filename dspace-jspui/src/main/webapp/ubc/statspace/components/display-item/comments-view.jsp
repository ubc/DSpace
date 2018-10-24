<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<c:set var="item" value="${requestScope[param.itemVar]}"></c:set>
<c:set var="itemRetriever" value="${requestScope[param.retrieverVar]}"></c:set>
<c:set var="canLeaveComment" value="${requestScope[param.canLeaveCommentVar]}"></c:set>
<c:set var="canDeleteComment" value="${requestScope[param.canDeleteCommentVar]}"></c:set>
<c:set var="commentPerPage" value="${requestScope[param.commentPerPageVar]}"></c:set>
<c:set var="commentPage" value="${param.commentPageVar}"></c:set>
<c:set var="maxTitleLength" value="${requestScope[param.maxTitleLengthVar]}"></c:set>
<c:set var="maxDetailLength" value="${requestScope[param.maxDetailLengthVar]}"></c:set>
<c:set var="canCommentWithRealName" value="${requestScope[param.canCommentWithRealNameVar]}"></c:set>
<c:set var="commentingAnonymousDisplayName" value="${requestScope[param.commentingAnonymousDisplayNameVar]}"></c:set>
<c:set var="commentingRealDisplayName" value="${requestScope[param.commentingRealDisplayNameVar]}"></c:set>
<c:set var="ratingDescriptionMap" value="${requestScope[param.ratingDescriptionMapVar]}"></c:set>

<c:set var="newline" value="<%= \"\n\" %>" />

<c:if test="${empty commentPerPage or commentPerPage le 0}">
    <c:set var="commentPerPage" value="${5}"/>
</c:if>
<c:set var="commentNumPagesStr" value="${fn:substringBefore((fn:length(itemRetriever.comments) + commentPerPage - 1) / commentPerPage, '.')}"/>
<fmt:parseNumber var="commentNumPages" value="${commentNumPagesStr}" integerOnly="true"/>

<c:if test="${empty commentPage or commentPage lt 0 or commentPage ge commentNumPages}">
    <c:set var="commentPage" value="${0}"/>
</c:if>
<c:if test="${empty maxTitleLength or maxTitleLength le 0}">
    <c:set var="maxTitleLength" value="${120}"/>
</c:if>
<c:if test="${empty maxDetailLength or maxDetailLength le 0}">
    <c:set var="maxDetailLength" value="${10000}"/>
</c:if>

<script>
    function apiCreateNewComment(payload) {
        return $.ajax({
            url: '/itemcomment',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            type: 'POST',
            data: JSON.stringify({
                action: 'create',
                data: payload}),
        });
    }

    function apiDeleteComment(payload) {
        return $.ajax({
            url: '/itemcomment',
            contentType: "application/json; charset=utf-8",
            dataType: 'json',
            type: 'POST',
            data: JSON.stringify({
                action: 'delete',
                data: payload}),
        });
    }

    $(document).ready(function() {
        $('.check-length').on('keydown keyup change', function() {
            var charLength = $(this).val().length;
            var theMax = $(this).attr('maxlength');
            if (charLength >= theMax * 0.9) {
                $(this).siblings('.length-warning-msg').text((theMax - charLength) + ' character(s) left');
            } else {
                $(this).siblings('.length-warning-msg').empty();
            }
        });
    });
</script>

<%-- Submit comment modal --%>
<div class="modal fade" id="leaveCommentModal" tabindex="-1" role="dialog" aria-labelledby="leaveCommentModalTitle">
    <div class="modal-dialog modal-dialog-centered modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                  <span aria-hidden="true">&times;</span>
                </button>
                <h3 class="modal-title" id="leaveCommentModalTitle">
                    <span class="glyphicon glyphicon-pencil" aria-hidden="true"></span>
                    Leave a comment
                </h3>
            </div>
            <div class="modal-body">
                <c:if test="${canCommentWithRealName}">
                    <div class="row">
                        <div class="col-sm-4">
                            <label for="annonymousCommentYes" class="radio-inline">
                                <input type="radio" id="annonymousCommentYes" name="annonymousComment" value="1" checked="checked"/> Display my comment anonymously
                            </label>
                        </div>
                        <div class="col-sm-8">
                            <label for="annonymousCommentNo" class="radio-inline">
                                <input type="radio" id="annonymousCommentNo" name="annonymousComment" value="0"/> Display my comment with real name
                            </label>
                            <div>
                                <small>By selecting this option, you agree that your real name will be visible to anyone who accesses this page</small>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-sm-12">
                            <hr/>
                        </div>
                    </div>
                </c:if>
                <div class="row">
                    <div class="col-sm-12">
                        <span class="glyphicon glyphicon-user"></span>
                        <span class="commentDisplayName" id="commentDisplayName">${commentingAnonymousDisplayName}</span>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        <h4>Rating:</h4>
                    </div>
                    <div class="col-sm-5">
                        <div>
                            <small>Would you recommend this resource for teaching and learning?</small>
                        </div>
                        <div class="starRatingSelect">
                            <span class="glyphicon glyphicon-star-empty starRatingClickable" data-rating="1"></span>
                            <span class="glyphicon glyphicon-star-empty starRatingClickable" data-rating="2"></span>
                            <span class="glyphicon glyphicon-star-empty starRatingClickable" data-rating="3"></span>
                            <span class="glyphicon glyphicon-star-empty starRatingClickable" data-rating="4"></span>
                            <span class="glyphicon glyphicon-star-empty starRatingClickable" data-rating="5"></span>
                            &nbsp;&nbsp;<span id="ratingDescription"></span>
                            <input type="hidden" id="commentRating" class="rating-value" value="5">
                        </div>
                    </div>
                    <div class="col-sm-5">
                        <label for="optOutRating" class="checkbox-inline">
                            <input type="checkbox" name="optOutRating" id="optOutRating"> Leave a comment without rating
                        </label>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        <h4>Title:</h4>
                    </div>
                    <div class="col-sm-10">
                        <input size="40" id="inputCommentTitle" placeholder="(Optional) A brief description of your comment" maxlength="${maxTitleLength}" class="check-length"></input>
                        <div class="length-warning-msg" aria-hidden="true"></div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-2">
                        <h4>Details:</h4>
                    </div>
                    <div class="col-sm-10">
                        <textarea rows="10" cols="50" id="inputCommentDetail" placeholder="(Optional) Please provide details here" maxlength="${maxDetailLength}" class="check-length"></textarea>
                        <div class="length-warning-msg" aria-hidden="true"></div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-sm-12 text-right small">
                    <a href="/demo/commenting-policy.jsp" target="_blank">Commenting policy&nbsp;<span class="glyphicon glyphicon-new-window"></span></a>&nbsp;&nbsp;
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-dismiss="modal" id="btnCloseCommentsDialog">Close</button>
                <button type="button" class="btn btn-primary" id="btnSubmitComments">Submit comments</button>
            </div>
        </div>
    </div>
    <script>
    $(document).ready(function() {
        // anonymous comments
        $('#leaveCommentModal').find('input[name="annonymousComment"]').click(function() {
            if ($(this).attr("id") && $(this).attr("id") == "annonymousCommentYes") {
                $("#commentDisplayName").html("${fn:escapeXml(commentingAnonymousDisplayName)}");
            } else {
                $("#commentDisplayName").html("${fn:escapeXml(commentingRealDisplayName)}");
            }
        });

        var $star_rating = $('.starRatingSelect .glyphicon');
        function setRatingStar() {
            $star_rating.each(function() {
                // no action if opt-out from rating
                if ($('#optOutRating').is(':checked')) {
                    return;
                }

                if (parseInt($star_rating.siblings('input.rating-value').val()) >= parseInt($(this).data('rating'))) {
                    $(this).removeClass('glyphicon-star-empty').addClass('glyphicon-star');
                } else {
                    $(this).removeClass('glyphicon-star').addClass('glyphicon-star-empty');
                }
            });
            if ($star_rating.siblings('input.rating-value').val() == '1') {
                $star_rating.siblings('#ratingDescription').html("(${fn:escapeXml(ratingDescriptionMap[1])})");
            } else if ($star_rating.siblings('input.rating-value').val() == '2') {
                $star_rating.siblings('#ratingDescription').html("(${fn:escapeXml(ratingDescriptionMap[2])})");
            } else if ($star_rating.siblings('input.rating-value').val() == '3') {
                $star_rating.siblings('#ratingDescription').html("(${fn:escapeXml(ratingDescriptionMap[3])})");
            } else if ($star_rating.siblings('input.rating-value').val() == '4') {
                $star_rating.siblings('#ratingDescription').html("(${fn:escapeXml(ratingDescriptionMap[4])})");
            } else if ($star_rating.siblings('input.rating-value').val() == '5') {
                $star_rating.siblings('#ratingDescription').html("(${fn:escapeXml(ratingDescriptionMap[5])})");
            } else {
                $star_rating.siblings('#ratingDescription').html("&nbsp;");
            }
        };
        $star_rating.click(function() {
            if (! $(this).hasClass('starRatingClickable')) {
                return;
            }
            $star_rating.siblings('input#commentRating').val($(this).data('rating'));
            return setRatingStar();
        });
        setRatingStar();
        // opt-out from rating
        $('#leaveCommentModal').find('#optOutRating').click(function() {
            if ($(this).is(':checked')) {
                $star_rating.siblings('input.rating-value').val('0');
                setRatingStar();
                $('#inputCommentDetail').attr('placeholder', 'Please provide details here');
                $star_rating.each(function() {
                    $(this)
                        .removeClass('glyphicon-star').removeClass('starRatingClickable')
                        .addClass('glyphicon-star-empty').addClass('text-muted');
                });
            } else {
                $star_rating.siblings('input.rating-value').val('5');
                $('#inputCommentDetail').attr('placeholder', '(Optional) Please provide details here');
                $star_rating.each(function() {
                    $(this)
                        .removeClass('glyphicon-star-empty').removeClass('text-muted')
                        .addClass('starRatingClickable').addClass('glyphicon-star');
                });
                setRatingStar();
            }
        });

        function getRatingStar() {
            return $('#leaveCommentModal').find('input#commentRating').val();
        }
        function getCommentTitle() {
            return $('#leaveCommentModal').find('input#inputCommentTitle').val();
        }
        function getCommentDetail() {
            return $('#leaveCommentModal').find('textarea#inputCommentDetail').val();
        }
        function isAnonymousComment() {
            <c:if test="${!canCommentWithRealName}">
                return true;
            </c:if>
            <c:if test="${canCommentWithRealName}">
                return $('#leaveCommentModal').find('input#annonymousCommentYes').prop('checked') ? true : false;
            </c:if>
        }
        function gatherCommentPayLoad() {
            var payload = {};
            payload['item_id'] = '<c:out value="${item.ID}"/>';
            payload['rating'] = getRatingStar();
            payload['title'] = getCommentTitle();
            payload['detail'] = getCommentDetail();
            payload['isAnnonymousComment'] = isAnonymousComment();
            return payload;
        }

        // check and validate required fields
        function validateFields() {
            var valid = true;
            if ($('#optOutRating').is(':checked')) {
                if ($.trim(getCommentDetail()).length == 0) {
                    valid = false;
                }
            } else {
                if (parseInt(getRatingStar()) == 0) {
                    valid = false;
                }
            }
            return valid;
        }
        $('#leaveCommentModal').find('textarea#inputCommentDetail').on('input', function() {
            $('#leaveCommentModal').find('button#btnSubmitComments').attr('disabled', !validateFields());
        });
        $('#leaveCommentModal').find('#optOutRating').on('click', function() {
            $('#leaveCommentModal').find('button#btnSubmitComments').attr('disabled', !validateFields());
        });

        $('#leaveCommentModal').find('button#btnSubmitComments').click(function() {
            $('#leaveCommentModal').modal('hide');
            $('#submitCommentMessage').find('#submitCommentMessage-Msg').html('Submitting...');
            $('#submitResultModal').modal('toggle');
            $('#submitCommentMessage-Spinner').removeAttr('class').attr('class', 'glyphicon glyphicon-refresh glyphicon-refresh-animate');
            apiCreateNewComment(gatherCommentPayLoad())
                .done(function(data, status) {
                    $('#submitCommentMessage-Spinner').removeClass('glyphicon-refresh').removeClass('glyphicon-refresh-animate').addClass('glyphicon-ok');
                    $('#submitCommentMessage').find('#submitCommentMessage-Msg').html('Comments submitted successfully');
                })
                .fail(function(xhr, status) {
                    $('#submitCommentMessage-Spinner').removeClass('glyphicon-refresh').removeClass('glyphicon-refresh-animate').addClass('glyphicon-exclamation-sign');
                    $('#submitCommentMessage').find('#submitCommentMessage-Msg').html('Encountered problems when submitting your comments.  Please retry later.');
                })
                .always(function(data, status) {
                });
        });
    });
    </script>
</div>

<%-- Confirm delete modal --%>
<div class="modal" id="confirmDeleteCommentModal" tabindex="-1" role="dialog">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
                <h4 class="modal-title">
                    <span class="glyphicon glyphicon-trash"></span>
                    Confirm to delete this comment
                </h4>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-3">
                        <h4>Reason for deletion:</h4>
                        <div>An email will be sent to the original commenter.</div>
                    </div>
                    <div class="col-sm-9">
                        <textarea rows="10" cols="50" id="inputDeleteReason" placeholder=""></textarea>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <input type="hidden" id="commentToDelete" name="commentToDelete" value="">
                <button type="button" class="btn btn-secondary" data-dismiss="modal">Cancel</button>
                <button type="button" class="btn btn-primary" id="btnDeleteComments">Delete</button>
            </div>
        </div>
    </div>

    <script>
    $(document).ready(function() {
        $(document).on("click", ".commentDeleteIcon", function() {
            var commentUuid = $(this).data('comment-uuid');
            $('#confirmDeleteCommentModal').find('input#commentToDelete').val(commentUuid);
        });

        function gatherDeleteCommentPayLoad() {
            var payload = {};
            payload['item_id'] = '<c:out value="${item.ID}"/>';
            payload['commentUuid'] = $('#confirmDeleteCommentModal').find('input#commentToDelete').val();
            payload['deleteReason'] = $('#confirmDeleteCommentModal').find('textarea#inputDeleteReason').val();
            return payload;
        }

        $('#btnDeleteComments').click(function() {
            $('#confirmDeleteCommentModal').modal('hide');
            $('#submitCommentMessage').find('#submitCommentMessage-Msg').html('Deleting...');
            $('#submitResultModal').modal('toggle');
            $("#submitCommentMessage-Spinner").removeAttr('class').attr('class', 'glyphicon glyphicon-refresh glyphicon-refresh-animate');
            apiDeleteComment(gatherDeleteCommentPayLoad())
                .done(function(data, status) {
                    $('#submitCommentMessage-Spinner').removeClass('glyphicon-refresh').removeClass('glyphicon-refresh-animate').addClass('glyphicon-ok');
                    $('#submitCommentMessage').find('#submitCommentMessage-Msg').html('Comments deleted successfully');
                })
                .fail(function(xhr, status) {
                    $('#submitCommentMessage-Spinner').removeClass('glyphicon-refresh').removeClass('glyphicon-refresh-animate').addClass('glyphicon-exclamation-sign');
                    $('#submitCommentMessage').find('#submitCommentMessage-Msg').html('Problem encountered when deleting comments.  Please retry later.');
                })
                .always(function(data, status) {
                });
        });
    });
    </script>
</div>

<%-- Submit status modal --%>
<div class="modal fade" id="submitResultModal" tabindex="-1" role="dialog">
    <div class="modal-dialog modal-dialog-centered" role="document">
        <div class="modal-content">
            <div class="modal-body">
                <div class="row">
                    <div class="col-sm-9">
                        <div id="submitCommentMessage">
                            <span class="glyphicon glyphicon-refresh glyphicon-refresh-animate" id="submitCommentMessage-Spinner"></span>
                            <span id="submitCommentMessage-Msg"></span>
                        </div>
                    </div>
                    <div class="col-sm-3">
                        <button type="button" class="btn btn-primary" data-dismiss="modal">Close</button>
                    </div>
                </div>
            </div>

        </div>
    </div>
    <script>
    $(document).ready(function() {
        // $('#submitResultModal').on('shown.bs.modal', function() {
        //     $('#submitCommentMessage-Spinner').removeAttr('class').attr('class', 'glyphicon glyphicon-refresh glyphicon-refresh-animate');
        // })
        $('#submitResultModal').on('hidden.bs.modal', function () {
            location.reload();
        });
    });
    </script>
</div>

<!-- Comment block -->
<div class="well commentBlock" id="commentBlock">
    <div class="row commentBlockHeader">
        <div class="col-sm-12">
            <div class="col-md-4">
                <h3><span class="glyphicon glyphicon-comment" aria-hidden="true"></span>
                    Comments
                    <small>
                        <c:choose>
                            <c:when test="${canDeleteComment}">
                                (<c:out value="${itemRetriever.activeCommentCount}"/>&nbsp;/&nbsp;<c:out value="${fn:length(itemRetriever.comments)}"/>&nbsp;reviews)
                            </c:when>
                            <c:otherwise>
                                (<c:out value="${fn:length(itemRetriever.comments)}"/>&nbsp;reviews)
                            </c:otherwise>
                        </c:choose>
                    </small>
                </h3>
            </div>
            <div class="col-md-4">
                <c:set var="num5Star" value="${0}"/>
                <c:set var="num4Star" value="${0}"/>
                <c:set var="num3Star" value="${0}"/>
                <c:set var="num2Star" value="${0}"/>
                <c:set var="num1Star" value="${0}"/>
                <c:forEach items="${itemRetriever.comments}" var="theComment">
                    <c:if test="${theComment.rating gt 0 && theComment.status == 'ACTIVE'}">
                        <c:choose>
                            <c:when test="${theComment.rating eq 5}">
                                <c:set var="num5Star" value="${num5Star+1}" />
                            </c:when>
                            <c:when test="${theComment.rating eq 4}">
                                <c:set var="num4Star" value="${num4Star+1}" />
                            </c:when>
                            <c:when test="${theComment.rating eq 3}">
                                <c:set var="num3Star" value="${num3Star+1}" />
                            </c:when>
                            <c:when test="${theComment.rating eq 2}">
                                <c:set var="num2Star" value="${num2Star+1}" />
                            </c:when>
                            <c:when test="${theComment.rating eq 1}">
                                <c:set var="num1Star" value="${num1Star+1}" />
                            </c:when>
                        </c:choose>
                    </c:if>
                </c:forEach>
                <jsp:include page="/ubc/statspace/components/display-item/rating-stats.jsp">
                    <jsp:param name="num5StarVar" value="${num5Star}" />
                    <jsp:param name="num4StarVar" value="${num4Star}" />
                    <jsp:param name="num3StarVar" value="${num3Star}" />
                    <jsp:param name="num2StarVar" value="${num2Star}" />
                    <jsp:param name="num1StarVar" value="${num1Star}" />
                    <jsp:param name="retrieverVar" value="itemRetriever" />
                    <jsp:param name="ratingDescriptionMapVar" value="ratingDescriptionMap" />
                </jsp:include>
            </div>
            <div class="col-md-4 commentsActionButtons text-right">
                <c:if test="${canLeaveComment}">
                    <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#leaveCommentModal">
                        <span class="glyphicon glyphicon-pencil"></span>
                        Leave a comment
                    </button>
                </c:if>
                <c:if test="${!canLeaveComment}">
                    <small><a href="/password-login">To leave a comment, please log in</a></small>
                </c:if>
            </div>
        </div>
        <div class="col-sm-12">
            <div class="displayItemSectionHeader"></div>
        </div>
    </div>

    <c:if test="${fn:length(itemRetriever.comments) eq 0}">
        <div class="row commentRow">
            <div class="col-sm-12 commentEmptyBody">
                No comments
            </div>
        </div>
    </c:if>

    <c:forEach items="${itemRetriever.comments}" var="theComment" begin="${commentPage * commentPerPage}" end="${((commentPage+1) * commentPerPage) - 1}">

        <div class="row commentRow">
            <div class="col-sm-12">
                <div class="row">
                    <div class="col-sm-11">
                        <div class="commentUser">
                            <span class="glyphicon glyphicon-user"></span>
                            <span class="commentUserName"><c:out value="${theComment.commenterDisplayName}"/></span>
                        </div>
                    </div>
                    <div class="col-sm-1 commentActionPanel">
                        <c:if test="${canDeleteComment}">
                            <c:if test="${theComment.status == 'ACTIVE'}">
                                <span class="glyphicon glyphicon-trash commentDeleteIcon" data-comment-uuid="${theComment.uuid}" data-toggle="modal" data-target="#confirmDeleteCommentModal"></span>
                            </c:if>
                        </c:if>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12">
                        <c:if test="${theComment.rating gt 0}">
                            <span class="starRating">
                                <c:forEach begin="1" end="${theComment.rating}">
                                    <span class="glyphicon glyphicon-star"></span>
                                </c:forEach>
                                <c:forEach begin="1" end="${5 - theComment.rating}">
                                    <span class="glyphicon glyphicon-star-empty"></span>
                                </c:forEach>
                            </span>
                        </c:if>
                        <span class="commentTitle"><c:out value="${theComment.title}"/></span>
                        <span class="commentTimestamp"><script>document.write(new Date("${theComment.created}").toLocaleDateString('en-US', {month: "short", day: "2-digit", year: "numeric"}));</script></span>
                        <c:if test="${canDeleteComment}">
                            <c:if test="${theComment.status != 'ACTIVE'}">
                                <span class="commentBody">&nbsp;(deleted)</span>
                            </c:if>
                        </c:if>
                    </div>
                </div>
                <div class="row">
                    <div class="col-sm-12 commentBody">
                        <c:set var="escapedCommentDetail" value="${fn:escapeXml(theComment.detail)}" />
                        ${fn:replace(escapedCommentDetail, newline, "<br/>")}
                    </div>
                </div>

            </div>
        </div>

    </c:forEach>

    <c:if test="${commentNumPages gt 1}">
        <div class="row">
            <div class="col-sm-12 text-center">
                <nav aria-label="Comments navigation">
                    <ul class="pagination">
                        <c:choose>
                            <c:when test="${commentPage le 0}">
                                <li class="disabled">
                                    <span aria-hidden="true" class="glyphicon glyphicon-triangle-left"></span>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li>
                                    <a href="?commentPage=${commentPage-1}#commentBlock" aria-label="Previous">
                                        <span aria-hidden="true" class="glyphicon glyphicon-triangle-left"></span>
                                    </a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                        <c:forEach begin="0" end="${commentNumPages-1}" varStatus="loop">
                            <c:choose>
                                <c:when test="${loop.index - commentPage gt 3 or loop.index - commentPage lt -3}">
                                </c:when>
                                <c:when test="${loop.index - commentPage eq 3 or loop.index - commentPage eq -3}">
                                    <li><a>...</a></li>
                                </c:when>
                                <c:otherwise>
                                    <c:choose>
                                        <c:when test="${commentPage eq loop.index}">
                                            <li class="active">
                                                <a><c:out value="${loop.count}"/></a>
                                            </li>
                                        </c:when>
                                        <c:otherwise>
                                            <li>
                                                <a href="?commentPage=${loop.index}#commentBlock"><c:out value="${loop.count}"/></a>
                                            </li>
                                        </c:otherwise>
                                    </c:choose>
                                </c:otherwise>
                            </c:choose>
                        </c:forEach>
                        <c:choose>
                            <c:when test="${commentPage ge commentNumPages-1}">
                                <li class="disabled">
                                    <span aria-hidden="true" class="glyphicon glyphicon-triangle-right"></span>
                                </li>
                            </c:when>
                            <c:otherwise>
                                <li>
                                    <a href="?commentPage=${commentPage+1}#commentBlock" aria-label="Next">
                                        <span aria-hidden="true" class="glyphicon glyphicon-triangle-right"></span>
                                    </a>
                                </li>
                            </c:otherwise>
                        </c:choose>
                    </ul>
                </nav>
            </div>
        </div>
    </c:if>

</div> <!-- close commentBlock -->
