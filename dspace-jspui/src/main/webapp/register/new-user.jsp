<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Register with DSpace form
  -
  - Form where new users enter their email address to get a token to access
  - the personal info page.
  -
  - Attributes to pass in:
  -     retry  - if set, this is a retry after the user entered an invalid email
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.app.webui.servlet.RegisterServlet" %>

<%
    boolean retry = (request.getAttribute("retry") != null);
%>

<dspace:layout style="submission" titlekey="jsp.register.new-user.title">
    <%-- <h1>User Registration</h1> --%>
	<h1><fmt:message key="jsp.register.new-user.title"/></h1>
<%
    if (retry)
    { %>
    <%-- <p><strong>The e-mail address you entered was invalid.</strong>  Please try again.</strong></p> --%>
	<p class="alert alert-warning"><fmt:message key="jsp.register.new-user.info1"/></p>
<%  } %>
<!--
    <p>If you've never logged on to DSpace before, please enter your e-mail address in the box below and click "Register". If you have, please proceed to the <a href="/password-login">sign in</a> page.</p>
	<p class="alert"><fmt:message key="jsp.register.new-user.info2"/></p>-->
    <p>This is the preliminary version of StatSpace, and not all functions have been implemented.  We are currently working on implementing registration plus the following StatSpace functionalities:  search, evaluate and, for those of you who have resources to share, upload.</p>
    <p>If you would like to be contacted when these functionalities are added, please enter your email address below.</p>
    
    <form class="form-horizontal" action="<%= request.getContextPath() %>/register" method="post">

        <input type="hidden" name="step" value="<%= RegisterServlet.ENTER_EMAIL_PAGE %>"/>


                            <%-- <td class="standard"><strong>E-mail Address:</strong></td> --%>
					    <div class="form-group">
            				<label class="col-md-offset-1 col-md-2 control-label" for="temail"><fmt:message key="jsp.register.new-user.email.field"/></label>
                            <div class="col-md-5"><input class="form-control" type="text" name="email" id="temail" /></div>
                            <%-- <input type="submit" name="submit" value="Register"> --%>
						    <input class="btn btn-default col-md-2" type="submit" name="submit" value="<fmt:message key="jsp.register.new-user.register.button"/>" />
                        </div>
    </form>
    <!--omitted by request from Melissa Lee
    <p>If you or your department are interested in registering with DSpace, please
    contact the DSpace site administrators.</p>
    <br/>
	<div class="alert alert-info"><fmt:message key="jsp.register.new-user.info3"/></div>

    <dspace:include page="/components/contact-info.jsp" />
    -->
</dspace:layout>
