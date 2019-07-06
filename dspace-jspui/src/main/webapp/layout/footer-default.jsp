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
				 <p>
					 <strong>Carl Wieman Science Education Initiative</strong>
				 </p>
				 <p>Web <a href="http://www.cwsei.ubc.ca/" style='color: white;'>http://www.cwsei.ubc.ca/</a></p>
				 <a href="http://www.ubc.ca/" title="The University of British Columbia">
					 <img src="<c:url value='/static/ubc/images/ubc-signature.png' />" style='margin-left: -20px; height: 100px'/>
				 </a>
			 </div>
		</footer>
    </body>
</html>