<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%@page import="java.text.DateFormat"%>
<%@page import="org.dspace.content.Evaluation"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@ page import="org.dspace.core.Utils" %>
<%--
  - Item evaluation form
  -
  - Attributes to pass in:
  -
  -   eperson     - the EPerson who's editing their profile
  -   evaluation  - the Evaluation being viewed
  --%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.core.Utils" %>

<%
    Evaluation evaluation = (Evaluation) request.getAttribute("evaluation");
    Item item = evaluation.getItem();
%>

<dspace:layout style="submission" title="Evaluate Item" nocache="true">

    <h1>Pedagogical Evaluation for item <a href="<%= request.getContextPath() + "/handle/"
                                                 + item.getHandle() %>"><%= Utils.addEntities(item.getName()) %></a></h1>
    
    <div>
        <div>
            <div>
                <strong>Submitted by:</strong>
                <span class="">
                    <%= Utils.addEntities(evaluation.getSubmitter().getFullName()) %>
                </span>
            </div>
            
            <div>
                <strong>Date:</strong>
                <span>
                    <%= DateFormat.getDateTimeInstance().format(evaluation.getSubmitted()) %>
                </span>
            </div>
        </div>
        
        <div>
            <strong>Evaluation:</strong>
            <div>
                <%= evaluation.getContent() %>
            </div>
        </div>
    </div>

    <p><a href="<%= request.getContextPath() + "/handle/" + item.getHandle() %>">Back to item</a></p>
</dspace:layout>
