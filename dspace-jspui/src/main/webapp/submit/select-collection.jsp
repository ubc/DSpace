<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - UI page for selection of collection.
  -
  - Required attributes:
  -    collections - Array of collection objects to show in the drop-down.
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.content.Collection" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
	
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%
    request.setAttribute("LanguageSwitch", "hide");

    //get collections to choose from
    Collection[] collections =
        (Collection[]) request.getAttribute("collections");

	//check if we need to display the "no collection selected" error
    Boolean noCollection = (Boolean) request.getAttribute("no.collection");

    // Obtain DSpace context
    Context context = UIUtil.obtainContext(request);
%>

<dspace:layout style="submission" locbar="off"
               navbar="off"
               titlekey="jsp.submit.select-collection.title"
               nocache="true">

    <h1><fmt:message key="jsp.submit.select-collection.heading"/>
    <dspace:popup page="<%= LocaleSupport.getLocalizedMessage(pageContext, \"help.index\") + \"#choosecollection\"%>"><fmt:message key="jsp.morehelp"/> </dspace:popup></h1>

	
<%  if (collections.length > 0)
    {
%>
	<p><fmt:message key="jsp.submit.select-collection.info1"/></p>

    <form action="<%= request.getContextPath() %>/submit" method="post" onkeydown="return disableEnterKey(event);">
<%
		//if no collection was selected, display an error
		if((noCollection != null) && (noCollection.booleanValue()==true))
		{
%>
					<div class="alert alert-warning"><fmt:message key="jsp.submit.select-collection.no-collection"/></div>
<%
		}
%>            
		
		<%-- Select Community First --%>
		<div class='input-group mb2'>
			<label for="selectCommunity" class="input-group-addon">
				Community
			</label>
			<select id='selectCommunity' class='form-control' required>
				<c:forEach var='entry' items='${communityCollections}'>
					<option value='${entry.key.ID}'>${entry.key.name}</option>
				</c:forEach>
			</select>
		</div>
		<%-- Select Collection --%>
		<c:forEach var='entry' items='${communityCollections}'>
			<div class='input-group collectionGroup' id='collectionGroup_${entry.key.ID}'>
				<label for="selectCollections_${entry.key.ID}" class="input-group-addon">
					Collection
				</label>
				<select id='selectCollections_${entry.key.ID}' name='collection' class='form-control' required disabled>
					<c:forEach var='collection' items='${entry.value}'>
						<option value='${collection.ID}'>${collection.name}</option>
					</c:forEach>
				</select>
			</div>
		</c:forEach>
		<%-- Show/Hide collection depending on community selected --%>
		<script>
			jQuery(function() {
				var collectionGroups = jQuery('.collectionGroup');
				var communityField = jQuery('#selectCommunity');
				function showCollection(commId) {
					var groupToShow = jQuery('#collectionGroup_' + commId);
					// hide and disable all the collections
					collectionGroups.hide();
					collectionGroups.find('select').prop('disabled', true)
					// show and enable the one we want
					groupToShow.show();
					groupToShow.find('select').removeAttr('disabled');
				}

				communityField.change(function() {
					showCollection(communityField.val());
				});
				// initialization
				showCollection(communityField.val());
			})
		</script>

		<%--
					<div class="input-group">
					<label for="tcollection" class="input-group-addon">
						<fmt:message key="jsp.submit.select-collection.collection"/>
					</label>
          <dspace:selectcollection klass="form-control" id="tcollection" collection="-1" name="collection"/>
					</div><br/>
		--%>
            <%-- Hidden fields needed for SubmissionController servlet to know which step is next--%>
            <%= SubmissionController.getSubmissionParameters(context, request) %>

				<div class="row mt3">
					<div class="col-md-4 pull-right btn-group">
						<input class="btn btn-default col-md-6" type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>" value="<fmt:message key="jsp.submit.select-collection.cancel"/>" />
						<input class="btn btn-primary col-md-6" type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>" value="<fmt:message key="jsp.submit.general.next"/>" />
					</div>
				</div>		
    </form>
<%  } else { %>
	<p class="alert alert-warning"><fmt:message key="jsp.submit.select-collection.none-authorized"/></p>
<%  } %>	
	   <p><fmt:message key="jsp.general.goto"/><br />
	   <a href="<%= request.getContextPath() %>"><fmt:message key="jsp.general.home"/></a><br />
	   <a href="<%= request.getContextPath() %>/mydspace"><fmt:message key="jsp.general.mydspace" /></a>
	   </p>	
</dspace:layout>
