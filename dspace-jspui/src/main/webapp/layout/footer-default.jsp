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
        <footer id="ubc7-footer" class="expand" role="contentinfo">
            <div class="row-fluid expand" id="ubc7-unit-footer">
                <div class="container">
                	<div class="col-md-8" id="ubc7-unit-address">
                        <div class="ubc7-address-unit-name">
                            <strong>UBC StatSpace</strong>
                        </div>
                	    <div class="ubc7-address-street">Department of Statistics<br>3178 Earth Sciences Building
                            <br>2207 Main Mall</div>
                        <div class="ubc7-address-location">
                            <span class="ubc7-address-city">Vancouver</span>, <span class="ubc7-address-province" title="British Columbia">British Columbia</span> <span class="ubc7-address-country">Canada</span> <span class="ubc7-address-postal">V6T 1Z4</span>
                        </div>
						<div id="ubc7-address-web">Web <a href="https://www.stat.ubc.ca/">https://www.stat.ubc.ca/</a></div>
                	    <div id="ubc7-address-email">E-mail lt.support@science.ubc.ca</div>
                	</div>
                    <div class="col-md-4">
                        <div id="ubc7-signature">
                            <a href="http://www.ubc.ca/">The University of British Columbia</a>
                        </div>
                    </div>
                </div>
                
            </div>
        </footer>
    </body>
</html>
