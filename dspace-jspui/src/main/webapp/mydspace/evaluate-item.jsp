<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%--
  - Item evaluation form
  -
  - Attributes to pass in:
  -
  -   eperson     - the EPerson who's editing their profile
  -   item        - the Item being evaluated
  --%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.content.Item" %>

<%
    Item item = (Item) request.getAttribute("item");
    
    Boolean attr = (Boolean) request.getAttribute("incomplete");
    boolean incomplete = (attr != null && attr.booleanValue());
%>

<dspace:layout style="submission" title="Evaluate Item" nocache="true">

    <h1>Pedagogical Evaluation for item <%= item.getName() %></h1>

<%
    if (incomplete) {
%>
    <p class="alert alert-info"><strong>Please fill out the evaluation.</strong></p>
<%
    }
%>

    <p>
        Please consider the following two goals when evaluating the item's
        pedagogical quality:
    </p>

    <ul>
      <li>Do the learning goals for this learning object align with its
          assessment activities?</li>
      <li>How would you judge the quality of the content of this learning
          object?</li>
    </ul>
    
    <form class="" action="<%= request.getContextPath() %>/evaluate" method="post">
        <input type="hidden" name="item_id" value="<%= item.getID() %>"/>

        <div class="form-group">
            <label for="item-evaluation">Evaluation</label>
            <textarea name="item-evaluation" rows=6 id="item-evaluation" class="form-control"></textarea>
            <p class="help-block">Please enter your pedagogical evaluation of the item.</p>
        </div>

 	<div class="col-md-offset-5">
	   <input class="btn btn-success col-md-4" type="submit" name="submit" value="Submit evaluation" />
	 </div>
   </form>
</dspace:layout>
