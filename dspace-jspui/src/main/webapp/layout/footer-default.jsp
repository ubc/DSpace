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
<%@ page import="org.dspace.core.ConfigurationManager" %>

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
                            <strong><%= ConfigurationManager.getProperty("dspace.name") %></strong>
                        </div>
                	    <div class="ubc7-address-street">
                            <%= ConfigurationManager.getProperty("dspace.contact.address.street") %>
                        </div>
                        <div class="ubc7-address-location">
                            <span class="ubc7-address-city">
                                <%= ConfigurationManager.getProperty("dspace.contact.address.city") %>
                            </span>,
                            <span class="ubc7-address-province">
                                <%= ConfigurationManager.getProperty("dspace.contact.address.province") %>
                            </span>
                            <span class="ubc7-address-country">
                                <%= ConfigurationManager.getProperty("dspace.contact.address.country") %>
                            </span>
                            <span class="ubc7-address-postal">
                                <%= ConfigurationManager.getProperty("dspace.contact.address.postal") %>
                            </span>
                        </div>
                	    <div id="ubc7-address-phone">
                            Tel <%= ConfigurationManager.getProperty("dspace.contact.phone") %>
                        </div>
                	    <div id="ubc7-address-email">
                            E-mail <%= ConfigurationManager.getProperty("dspace.contact.email") %>
                        </div>
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
