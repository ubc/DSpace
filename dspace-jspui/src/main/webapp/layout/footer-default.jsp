<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Footer for home page
  --%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="java.net.URLEncoder" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>

<%
    String sidebar = (String) request.getAttribute("dspace.layout.sidebar");
%>

            <%-- Right-hand side bar if appropriate --%>
<%
    if (sidebar != null)
    {
%>
	</div>
	<div class="col-md-3">
                    <%= sidebar %>
    </div>
    </div>       
<%
    }
%>
</div>
</main>
		<%-- Page footer --%>
		<footer class="ubcFooter py4">
			<div class='container'>
				<div class='clearfix'>
					<div class='sm-col col-sm-6'>
						<p>
							<strong>SEI Materials Archive</strong>
						</p>
						<p>
							Skylight and CWSEI, Earth Sciences Building, 2178-2207 Main Mall <br/>
							Vancouver , British Columbia Canada V6T 1Z4
						</p>
						<p>Tel 604.822.4691</p>
						<p>
							Email <a style='color: white;' href='mailto:lt.support@science.ubc.ca'>lt.support@science.ubc.ca</a> for technical difficulties <br/>
							Email <a style='color: white;' href='mailto:warcode@science.ubc.ca'>warcode@science.ubc.ca</a> for SEI matters
						</p>
						<p>Web <a href="http://www.cwsei.ubc.ca/" style='color: white;'>http://www.cwsei.ubc.ca/</a></p>
					</div>
					<div class='sm-col col-sm-6 xs-hide'>
						<a href="http://www.ubc.ca/" title="The University of British Columbia">
							<img src="<c:url value='/static/ubc/images/ubc-signature-white.png' />" style='margin-top: -15px; height: 70px'/>
						</a>
					</div>
				</div>
			</div>
		</footer>
    </body>
</html>