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
                	<div class="col-md-10" id="ubc7-unit-address">
                        <div class="ubc7-address-unit-name">
                            <strong>UBC StatSpace</strong>
                        </div>
                	    <div class="ubc7-address-street">UBC Department of Statistics Earth Sciences Building, 3178-2207 Main Mall</div>
                        <div class="ubc7-address-location">
                            <span class="ubc7-address-city">Vancouver</span>, <span class="ubc7-address-province" title="British Columbia">British Columbia</span> <span class="ubc7-address-country">Canada</span> <span class="ubc7-address-postal">V6T 1Z4</span>
                        </div>
                	    <div id="ubc7-address-phone">Tel 604.827.1546</div>
                	    <div id="ubc7-address-email">E-mail statspace@stat.ubc.ca</div>
                	</div>
                	<div class="col-md-2">
                	    <strong>Find us on</strong>
                	    <div id="ubc7-unit-social-icons">
                	        <a href="http://www.ubc.ca/"><i class="icon-facebook-sign"></i></a>&nbsp;
                	        <a href="http://www.ubc.ca/"><i class="icon-twitter-sign"></i></a>
                	    </div>
                	</div>
                </div>
            </div>
            <div class="row-fluid expand ubc7-back-to-top">
                <div class="container">
                	<div class="col-md-2">
                	    <a href="#">Back to top <div class="ubc7-arrow up-arrow grey"></div></a>
                	</div>
                </div>
            </div>
            <div class="row-fluid expand" id="ubc7-global-footer">
                <div class="container">
                	<div class="col-md-12">
                        <div id="ubc7-signature">
                            <a href="http://www.ubc.ca/">The University of British Columbia</a>
                        </div>
                	</div>
                </div>
            </div>
            <div class="row-fluid expand" id="ubc7-minimal-footer">
                <div class="container">
                	<div class="col-md-12">
                	    <ul>
                	        <li><a href="//cdn.ubc.ca/clf/ref/emergency">Emergency Procedures</a> <span class="divider">|</span></li>
                	        <li><a href="//cdn.ubc.ca/clf/ref/terms">Terms of Use</a> <span class="divider">|</span></li>
                	        <li><a href="//cdn.ubc.ca/clf/ref/copyright">Copyright</a> <span class="divider">|</span></li>
                	        <li><a href="//cdn.ubc.ca/clf/ref/accessibility">Accessibility</a></li>
                	    </ul>
                	</div>
                </div>
            </div>
        </footer>
    </body>
</html>
