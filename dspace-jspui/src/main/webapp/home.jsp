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
	<h1 class='text-center'>Welcome to BioSpace</h1>
	<p class='text-center'>BioSpace is a space for storing stuff related to biology education. Morbi tincidunt augue interdum velit euismod in. Mi sit amet mauris commodo quis imperdiet massa. Massa placerat duis ultricies lacus sed. Ultrices vitae auctor eu augue ut lectus arcu bibendum at.</p>

	<h2 class='text-center'>Explore</h2>
	<div class='row'>
		<c:forEach items="${subjects}" var="subject" varStatus="loopStatus">
			<div class='col-md-4'>
				<div class='media'>
					<div class='media-left'>
						<img src='http://placecorgi.com/80/80?no_track=${loopStatus.count}' />
					</div>
					<div class='media-body'>
						<h4 class='media-heading text-center'>${subject}</h4>
						<p>Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur.</p>
					</div>
				</div>
			</div>
		</c:forEach>
	</div>

	<h2 class='text-center'>Featured Articles</h2>
	<c:forEach var='i' begin='1' end='3' step='1'>
		<div class='col-md-4'>
			<h4 class='media-heading text-center'>Feature Number ${i}</h4>
			<img src='http://placekitten.com/10${i}/10${i}' class='pull-left' style='margin-right: 0.5em' /> <p style='display:inline'>Porta lorem mollis aliquam ut porttitor leo a diam sollicitudin. Hendrerit dolor magna eget est lorem ipsum dolor sit. Consectetur purus ut faucibus pulvinar elementum integer enim neque volutpat. Tellus cras adipiscing enim eu. Tortor aliquam nulla facilisi cras fermentum odio eu feugiat pretium. Massa sed elementum tempus egestas sed sed risus pretium. At augue eget arcu dictum varius. Maecenas accumsan lacus vel facilisis volutpat est velit. Lacus vel facilisis volutpat est velit.</p>
		</div>
	</c:forEach>
</dspace:layout>
