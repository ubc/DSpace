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
			${homeIntro}
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

	<jsp:include page="/ubc/statspace/components/home/featured-articles.jsp" />
</dspace:layout>
