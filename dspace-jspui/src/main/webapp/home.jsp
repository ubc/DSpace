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
			<p>BioSpace is a space for archiving and disseminating teaching and learning resources related to Biology courses at UBC. We archive resources that are organized around courses in biological disciplines and aligned with learning goals established by the curriculum committees representing those disciplines. The tried-and-tested resources archived here are <em>peer-reviewed internally by Biology Instructors at UBC</em> and contain documentations for strategies for effective implementation. To allow for some uniformity in archiving resources in BioSpace, we have developed a template to guide your documentation process. We encourage you to use the template. We are aware that no template is ever going to meet everyone's needs, so we look forward to receiving feedback from you on making it better. We also welcome feedback on all of the archived resources – kudos, things that worked, things that could be changed to improve, things that did not work and why, etc.</p>
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
				autoplay: true
			});
		});
	</script>
</dspace:layout>
