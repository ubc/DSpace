<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Form to upload a metadata files
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.List"            %>
<%@ page import="java.util.ArrayList"            %>
<%@ page import="org.dspace.content.Collection"            %>

<%

	List<String> inputTypes = (List<String>)request.getAttribute("input-types");
	List<Collection> collections = (List<Collection>)request.getAttribute("collections");
	String hasErrorS = (String)request.getAttribute("has-error");
	boolean hasError = (hasErrorS==null) ? false : (Boolean.parseBoolean((String)request.getAttribute("has-error")));
	
	String uploadId = (String)request.getAttribute("uploadId");
	
    String message = (String)request.getAttribute("message");
    
	List<String> otherCollections = new ArrayList<String>();
	if (request.getAttribute("otherCollections")!=null) {
		otherCollections = (List<String>)request.getAttribute("otherCollections");
	}
		
	Integer owningCollectionID = null;
	if (request.getAttribute("owningCollection")!=null){
		owningCollectionID = (Integer)request.getAttribute("owningCollection");
	}
	
	String selectedInputType = null;
	if (request.getAttribute("inputType")!=null){
		selectedInputType = (String)request.getAttribute("inputType");
	}
%>

<dspace:layout style="submission" titlekey="jsp.dspace-admin.batchimport.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin" 
               nocache="true">

    <h1><fmt:message key="jsp.dspace-admin.batchimport.title"/></h1>

	<% if (uploadId != null) { %>
		<div style="color:red">-- <fmt:message key="jsp.dspace-admin.batchimport.resume.info"/> --</div>
		<br/>
	<% } %>
			
<%
	if (hasErrorS == null){
	
	}
	else if (hasError && message!=null){
%>
	<div class="alert alert-warning"><%= message %></div>
<%  
    }
	else if (hasError && message==null){
%>
		<div class="alert alert-warning"><fmt:message key="jsp.dspace-admin.batchmetadataimport.genericerror"/></div>
<%  
	}
	else {
%>
		<div class="batchimport-info alert alert-info">
			<fmt:message key="jsp.dspace-admin.batchimport.info.success">
				<fmt:param><%= request.getContextPath() %>/mydspace</fmt:param>
			</fmt:message>
		</div>
<%  
	}
%>

    <form method="post" action="<%= request.getContextPath() %>/dspace-admin/batchimport" enctype="multipart/form-data">
	
		<div class="form-group">
			<label for="inputType"><fmt:message key="jsp.dspace-admin.batchmetadataimport.selectinputfile"/></label>
	        <select class="form-control" name="inputType" id="import-type">
			<%
				String safuploadSelected = ("safupload".equals(selectedInputType)) ? "selected" : "";
				String safSelected = ("saf".equals(selectedInputType)) ? "selected" : "";
			%>
	        	<option <%= safuploadSelected %> value="safupload"><fmt:message key="jsp.dspace-admin.batchimport.saf.upload"/></option>
				<option <%= safSelected %> value="saf"><fmt:message key="jsp.dspace-admin.batchimport.saf.remote"/></option>
	<% 
	 		for (String inputType : inputTypes){
				String selected = (inputType.equals(selectedInputType)) ? "selected" : "";
	%> 			
	 			<option <%= selected %> value="<%= inputType %>"><%= inputType %></option>	
	<%
	 		}
	%>      </select>
 		</div>
 		
		<% if (uploadId != null) { %>
			<input type="hidden" name=uploadId value="<%= uploadId %>"/>
		<% } %>
		
		<div class="form-group" id="input-url" style="display:none">
			<label for="collection"><fmt:message key="jsp.dspace-admin.batchmetadataimport.selecturl"/></label><br/>
			<input type="text" name="zipurl" class="form-control"/>
        </div>
        
		<!-- File Selection Area -->
		<label><fmt:message key="jsp.dspace-admin.batchmetadataimport.selectfile"/></label>
		<div id='input-file' class='text-center well well-lg'>
			<h3>
				<span class='btn btn-primary' id='browseButton'>Browse</span> or drag &amp; drop file here.
			</h3>
		</div>
		<!-- File Upload Status Display Area -->
		<div id='fileStatus' class='row hidden'>
			<div class='col-sm-4 text-center' id='statusFilename'>Some File Name</div>
			<div class='col-sm-2 text-center' id='statusProgressText'>
				Status
			</div>
			<div class='col-sm-6'>
				<div class="progress">
					<div id='statusProgress' class="progress-bar" role="progressbar"
						aria-valuenow="60" aria-valuemin="0" aria-valuemax="100"
						style="width: 60%; min-width: 2em">
						60%
					</div>
				</div>
			</div>
		</div>
		<div id='fileStatusError' class="alert alert-danger hidden" role="alert">
			<span class="glyphicon glyphicon-exclamation-sign" aria-hidden="true"></span>
			<span class="sr-only">Error:</span>
			<span class='messageSpan'>Unknown error occurred while processing upload.</span>
		</div>
		<div id='fileStatusSuccess' class="alert alert-success hidden" role="alert">
			<span class="glyphicon glyphicon-ok-sign" aria-hidden="true"></span>
			<span class="sr-only">Success:</span>
			<span class='messageSpan'>Import was successful!</span>
		</div>
		<%-- simple file uploader
        <div class="form-group" id="input-file">
			<label for="file"><fmt:message key="jsp.dspace-admin.batchmetadataimport.selectfile"/></label>
            <input class="form-control" type="file" size="40" name="file"/>
        </div>
		--%>
 
        <div class="form-group">
			<label for="collection">
				<fmt:message key="jsp.dspace-admin.batchmetadataimport.selectowningcollection"/>
				<span id="owning-collection-optional">&nbsp;<fmt:message key="jsp.dspace-admin.batchmetadataimport.selectowningcollection.optional"/></span>
			</label>
			<div id="owning-collection-info"><i for="collection"><fmt:message key="jsp.dspace-admin.batchmetadataimport.selectowningcollection.info"/></i></div>
            <select class="form-control" name="collection" id="owning-collection-select">
				<option value="-1"><fmt:message key="jsp.dspace-admin.batchmetadataimport.select"/></option>
 <% 
 		for (Collection collection : collections){
				String selected = ((owningCollectionID != null) && (owningCollectionID == collection.getID())) ? "selected" : "";
%> 			
 				<option <%= selected %> value="<%= collection.getID() %>"><%= collection.getName() %></option>	
 <%
 		}
 %>           	
            </select>
        </div>
        
		<% String displayValue = owningCollectionID != null ? "display:block" : "display:none"; %>
        <div class="form-group" id="other-collections-div" style="<%= displayValue %>">
			<label for="collection"><fmt:message key="jsp.dspace-admin.batchmetadataimport.selectothercollections"/></label>
            <select class="form-control" name="collections" multiple style="height:150px" id="other-collections-select">
 <% 
 		for (Collection collection : collections){
			String selected = ((otherCollections != null) && (otherCollections.contains(""+collection.getID()))) ? "selected" : "";
%> 				
 			<option <%= selected %> value="<%= collection.getID() %>"><%= collection.getName() %></option>	
 <%
 		}
 %>           	
            </select>
        </div>
        
        <input class="btn btn-success" type="submit" name="submit" value="<fmt:message key="jsp.dspace-admin.general.upload"/>" />

    </form>
    
    <script>
	    $( "#import-type" ).change(function() {
	    	var index = $("#import-type").prop("selectedIndex");
	    	if (index == 1){
	    		$( "#input-file" ).hide();
	    		$( "#input-url" ).show();
	    		$( "#owning-collection-info" ).show();
	    		$( "#owning-collection-optional" ).show();
	    	}
	    	else {
	    		$( "#input-file" ).show();
	    		$( "#input-url" ).hide();
	    		$( "#owning-collection-info" ).hide();
	    		$( "#owning-collection-optional" ).hide();
	    	}
	    });
		
		$( "#owning-collection-select" ).change(function() {
	    	var index = $("#owning-collection-select").prop("selectedIndex");
	    	if (index == 0){
	    		$( "#other-collections-div" ).hide();
				$( "#other-collections-select > option" ).attr("selected",false);
	    	}
	    	else {
	    		$( "#other-collections-div" ).show();
	    	}
	    });
    </script>
    
	<script src='<c:url value="/static/ubc/lib/flow.min.js" />' type="text/javascript"></script>
	<script>
		jQuery(function() {	
			var updateProgress = function (percent) {
				var percentage = Math.round(100 * percent);
				progressBarElem.css('width', percentage + '%')
				progressBarElem.text(percentage + '%')
			};
			var flow = new Flow({
				target: '<c:url value="/dspace-admin/batchimport" />',
				singleFile: true,
				forceChunkSize: true,
				chunkSize: 1024*1000,
				testChunks: false,
				method: "octet",
				query: function(file, chunk, isTest) {
					var formArray = jQuery("form").serializeArray();
					var returnArray = {};
					for (var i = 0; i < formArray.length; i++){
						returnArray[formArray[i]['name']] = formArray[i]['value'];
					}
					return returnArray;
				}
			});
			var filenameElem = jQuery('#statusFilename')
			var progressBarElem = jQuery('#statusProgress');
			var progressTextElem = jQuery('#statusProgressText');
			var statusSuccessElem = jQuery('#fileStatusSuccess')
			var statusErrorElem = jQuery('#fileStatusError')
			var statusSuccessMsg = jQuery('#fileStatusSuccess .messageSpan')
			var statusErrorMsg = jQuery('#fileStatusError .messageSpan')
			flow.assignBrowse(document.getElementById('browseButton'), false, true);
			flow.assignDrop(document.getElementById('input-file'));
			flow.on('fileAdded', function(file, event){
				filenameElem.text(file.name);
				progressTextElem.text('Selected')
				updateProgress(0);
				jQuery('#fileStatus').removeClass('hidden');
				statusSuccessElem.addClass('hidden');
				statusErrorElem.addClass('hidden');
			});
			flow.on('filesSubmitted', function(array, event){
				//flow.upload();
			});
			flow.on('fileProgress', function(file, chunk){
				updateProgress(flow.progress());
			});
			flow.on('fileSuccess', function(file,message){
				progressTextElem.text('Done')
				statusSuccessElem.removeClass('hidden');
			});
			flow.on('fileError', function(file, message){
				var retObj = JSON.parse(message);
				statusErrorMsg.text(retObj.error);
				statusErrorElem.removeClass('hidden');
			});
			// handles form submit
			jQuery("form").submit(function(e) {
				// make sure we don't get in the way if we're submitting an url
				if (jQuery('#input-file').is(":visible")) {
					e.preventDefault();
					flow.upload();
					progressTextElem.text('Uploading')
				}
			});
		});
	</script>

</dspace:layout>