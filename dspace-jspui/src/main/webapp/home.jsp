<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
  -    recent.submissions - RecetSubmissions
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout locbar="nolink" titlekey="jsp.home.title">

	<div class='row'>
		<div class='col-sm-6'>
			<h1 class='text-center'>Welcome to BioSpace</h1>
			<p>BioSpace is a shared space for archiving and sharing teaching and learning resources related to Biology courses at UBC.</p>
			<p>Resources are organized according to biological disciplines and learning goals. These tried-and-tested resources undergo an internal peer-review and feedback process before posting.</p>
			<p>If you are interested in posting resources, we encourage you to use our template! Although no template is ever going to meet everyone's needs, we hope that this will provide helpful guidelines and standards, ultimately making BioSpace easier to use for both posters and downloaders. If you have any feedback (regarding the template, the site, the resources, or otherwise), please let us know! We would love to hear from you.</p>
		</div>
		<div class='col-sm-6'>
			<h2 class='text-center'>Explore</h2>
			<div class='row'>
				<c:forEach items="${subjects}" var="subject" varStatus="loopStatus">
					<div class='col-lg-4 col-md-6 col-sm-6 homePageSubject'>
						<a href='<c:url value='${subject.searchURL}'/>'>
							<div class='media'>
								<div class='media-left'>
									<img src='<c:url value="${subject.icon}" />' />
								</div>
								<div class='media-body' style='vertical-align:middle;'>
									<p class='media-heading text-center'>${subject.name}</p>
								</div>
							</div>
						</a>
					</div>
				</c:forEach>
			</div>
		</div>
	</div>

	<h2 class='text-center'>Featured Articles</h2>
	<div class="row">
		<div class="col-xs-offset-1 col-xs-10">
			<div class="featured-articles">
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="media">
							<div class="media-left">
								<img class="media-object" src="http://placekitten.com/80/70">
							</div>
							<div class="media-body">
								<h4 class="media-heading">Feature Number 1</h4>
								<p style='display: inline'>Consectetur purus ut faucibus pulvinar elementum integer enim neque volutpat. Tellus cras adipiscing enim eu. Tortor aliquam nulla facilisi cras fermentum odio eu feugiat pretium. Massa sed elementum tempus egestas sed sed risus pretium. At augue eget arcu dictum varius. Maecenas accumsan lacus vel facilisis volutpat est velit. Lacus vel facilisis volutpat est velit.</p>
							</div>
						</div>
					</div>
				</div>
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="media">
							<div class="media-left">
								<img class="media-object" src="http://placekitten.com/80/80">
							</div>
							<div class="media-body">
								<h4 class="media-heading">Feature Number 2</h4>
								<p style='display: inline'>Porta lorem mollis aliquam ut porttitor leo a diam sollicitudin. Hendrerit dolor magna eget est lorem ipsum dolor sit. Tortor aliquam nulla facilisi cras fermentum odio eu feugiat pretium. Massa sed elementum tempus egestas sed sed risus pretium. At augue eget arcu dictum varius.</p>
							</div>
						</div>
					</div>
				</div>
				<div class="panel panel-default">
					<div class="panel-body">
						<div class="media">
							<div class="media-left">
								<img class="media-object" src="http://placekitten.com/90/80">
							</div>
							<div class="media-body">
								<h4 class="media-heading">Feature Number 3</h4>
								<p style='display: inline'>Maecenas accumsan lacus vel facilisis volutpat est velit. Lacus vel facilisis volutpat est velit.</p>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<%-- Only using carousel on this page, so including the library here from cdn --%>
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
</dspace:layout>
