<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Perform task page
  -
  - Attributes:
  -    workflow.item: The workflow item for the task being performed
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.app.webui.servlet.MyDSpaceServlet" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.workflow.WorkflowItem" %>
<%@ page import="org.dspace.workflow.WorkflowManager" %>

<%
    WorkflowItem workflowItem =
        (WorkflowItem) request.getAttribute("workflow.item");

    Collection collection = workflowItem.getCollection();
    Item item = workflowItem.getItem();
%>

<dspace:layout style="submission" locbar="link"
               parentlink="/mydspace"
               parenttitlekey="jsp.mydspace"
               titlekey="jsp.mydspace.perform-task.title"
               nocache="true">

    <%-- <h1>Perform Task</h1> --%>
    <h1><fmt:message key="jsp.mydspace.perform-task.title"/></h1>
    
<%
    if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP1)
    {
%>
	<p><fmt:message key="jsp.mydspace.perform-task.text1">
        <fmt:param><%= collection.getMetadata("name") %></fmt:param>
         </fmt:message></p>
<%
    }
    else if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP2)
    {
%>
	<p><fmt:message key="jsp.mydspace.perform-task.text3">
        <fmt:param><%= collection.getMetadata("name") %></fmt:param>
	</fmt:message></p>
<%
    }
    else if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP3)
    {
%>
	<p><fmt:message key="jsp.mydspace.perform-task.text4">
        <fmt:param><%= collection.getMetadata("name") %></fmt:param>
    </fmt:message></p>
<%
    }
%>
    
    <dspace:item item="<%= item %>" />

    <p>&nbsp;</p>

    <form action="<%= request.getContextPath() %>/mydspace" method="post">
        <input type="hidden" name="workflow_id" value="<%= workflowItem.getID() %>"/>
        <input type="hidden" name="step" value="<%= MyDSpaceServlet.PERFORM_TASK_PAGE %>"/>
		<table class="table bg-warning table-bordered">
<%
    
    if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP1 ||
        workflowItem.getState() == WorkflowManager.WFSTATE_STEP2)
    {
%>
			<tr>
				<td>
					<input class="btn btn-success btn-block" type="submit" name="submit_approve" value="<fmt:message key="jsp.mydspace.general.approve"/>" />
				</td>
				<td>
					<p><fmt:message key="jsp.mydspace.perform-task.instruct1"/></p>
				</td>
			</tr>
<%
    }
    else
    {
        // Must be an editor (step 3)
%>
			<tr>
				<td>
					<input class="btn btn-success btn-block" type="submit" name="submit_approve" value="<fmt:message key="jsp.mydspace.perform-task.commit.button"/>" />
				</td>
				<td>					
					<fmt:message key="jsp.mydspace.perform-task.instruct2"/>
				</td>
			</tr>
<%
    }

    if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP1 ||
        workflowItem.getState() == WorkflowManager.WFSTATE_STEP2)
    {
%>
			<tr>
				<td>
					<input class="btn btn-danger btn-block" type="submit" name="submit_reject" value="<fmt:message key="jsp.mydspace.general.reject"/>"/>
				</td>
				<td>
					<fmt:message key="jsp.mydspace.perform-task.instruct3"/>
				</td>
			</tr>	
<%
    }

    if (workflowItem.getState() == WorkflowManager.WFSTATE_STEP2 ||
        workflowItem.getState() == WorkflowManager.WFSTATE_STEP3)
    {
%>
			<tr>
				<td>
					<input class="btn btn-primary btn-block" type="submit" name="submit_edit" value="<fmt:message key="jsp.mydspace.perform-task.edit.button"/>" />
				</td>
				<td>
					<fmt:message key="jsp.mydspace.perform-task.instruct4"/>
				</td>
			</tr>	
<%
    }
%>
			<tr>
				<td>
					<input class="btn btn-default btn-block" type="submit" name="submit_cancel" value="<fmt:message key="jsp.mydspace.perform-task.later.button"/>" />
				</td>
				<td>
					<fmt:message key="jsp.mydspace.perform-task.instruct5"/>
				</td>
			</tr>
			<tr>
				<td>
					<input class="btn btn-default btn-block" type="submit" name="submit_pool" value="<fmt:message key="jsp.mydspace.perform-task.return.button"/>" />
				</td>
				<td>
					<fmt:message key="jsp.mydspace.perform-task.instruct6"/>
				</td>
			</tr>
		</table>
    </form>
</dspace:layout>
