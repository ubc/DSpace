<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
    
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.servlet.SubmissionController" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.submit.AbstractProcessingStep" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>

<dspace:layout style="submission"
			   locbar="off"
               navbar="off"
               titlekey="jsp.submit.choose-file.title"
               nocache="true">

    <form id="uploadForm" method="post" 
    	action="<%= request.getContextPath() %>/submit"
    	onkeydown="return disableEnterKey(event);">

		<jsp:include page="/submit/progressbar.jsp"/>
		
		<!-- Submit page title -->
		<h1>
            <fmt:message key="jsp.submit.choose-file.heading"/>
        </h1>
		<!-- General instructions -->
		<div>
            <fmt:message key="jsp.submit.choose-file.info1"/>
        </div>
		<c:if test='${!empty error}'>
			<div class="alert alert-danger" role="alert">
				<strong><span class="glyphicon glyphicon-warning-sign"></span> Error</strong>
				<p>${error}</p>
			</div>
		</c:if>

		<div>
			<!-- Nav tabs -->
			<ul class="nav nav-tabs" role="tablist">
				<li role="presentation" class="active"><a href="#uploadFiles" aria-controls="home" role="tab" data-toggle="tab">Files</a></li>
				<li role="presentation"><a href="#uploadURL" aria-controls="profile" role="tab" data-toggle="tab">URL</a></li>
			</ul>
			  
			<!-- Tab panes -->
			<div class="tab-content displayItemTabsContent" style="padding: 0.5em; border: 1px solid #ddd; border-top: none;">
				<!-- File Upload Area -->
				<div role="tabpanel" class="tab-pane active" id="uploadFiles">
					<!-- File Selection Area -->
					<div id='dropTarget' class='text-center well well-lg'>
						<h3>
							<span class='btn btn-primary' id='browseButton'>Browse</span> or drag &amp; drop at least one file here. <br />
							The first file that you upload will serve as the thumbnail image.
						</h3>
					</div>
					<!-- File Upload Status Display Area -->
					<table id="uploadTable" class="table">
						<thead>
							<tr>
								<th><fmt:message key="jsp.submit.upload-file-list.filename"/></th>
								<th><fmt:message key="jsp.submit.upload-file-list.filesize"/></th>
								<%-- <th><fmt:message key="jsp.submit.upload-file-list.filetype"/></th> --%>
								<c:if test="${!disablePerFileRestriction}">
									<th title="<fmt:message key="jsp.submit.upload-file-list.tooltip.restricted"/>">
										<i class="glyphicon glyphicon-lock"></i> Instructor Only</th>
								</c:if>
								<th><fmt:message key="jsp.submit.upload-file-list.filedesc"/></th>
								<th><!-- Delete --></th>
							</tr>
						</thead>
						<tbody>
							<jsp:include page="/ubc/submit/components/file-upload-tr.jsp">
								<jsp:param name="rowID" value="uploadRowTemplate" />
								<jsp:param name="isHidden" value="true" />
							</jsp:include>
							<c:forEach items="${files}" var="file">
								<jsp:include page="/ubc/submit/components/file-upload-tr.jsp">
									<jsp:param name="fileName" value="${file.name}" />
									<jsp:param name="fileSize" value="${file.size}" />
									<jsp:param name="fileDesc" value="${file.description}" />
									<jsp:param name="fileRestricted" value="${file.isRestricted}" />
									<jsp:param name="bitstreamID" value="${file.id}" />
								</jsp:include>
							</c:forEach>
						</tbody>
					</table>
				</div>
				<!-- URL "Upload" Area -->
				<div role="tabpanel" class="tab-pane" id="uploadURL">
					<input type="url" name="url" id="url" class="form-control" value="${url}"
						   title="Please enter a full URL that starts with http, e.g.: https://www.google.com"
						   oninput="setCustomValidity('')"
						   oninvalid="setCustomValidity('Please enter a full URL that starts with http, e.g.: https://www.google.com')"
						   placeholder="https://example.com" pattern="https?://.*" size="20" />	
				</div>
			</div>
		</div>
		
		<script src='<c:url value="/static/ubc/lib/flow.min.js" />' type="text/javascript"></script>
		<script>
			jQuery(function() {	
				function updateProgressBar(percent, progressBarElem) {
					var percentage = Math.round(100 * percent);
					progressBarElem.css('width', percentage + '%')
					progressBarElem.text(percentage + '%')
				}
				function showStatus(fileRow) {
					fileRow.find('.uploadFileRestricted').addClass('hidden');
					fileRow.find('.uploadFileDesc').addClass('hidden');
					fileRow.find('.uploadFileDelete').addClass('hidden');
					fileRow.find('.uploadStatus').removeClass('hidden');
				}
				function hideStatus(fileRow) {
					fileRow.find('.uploadFileRestricted').removeClass('hidden');
					fileRow.find('.uploadFileDesc').removeClass('hidden');
					fileRow.find('.uploadFileDelete').removeClass('hidden');
					fileRow.find('.uploadStatus').addClass('hidden');
				}
				function humanFileSize(bytes, si) {
					var thresh = si ? 1000 : 1024;
					if(Math.abs(bytes) < thresh) {
						return bytes + ' B';
					}
					var units = si
					? ['kB','MB','GB','TB','PB','EB','ZB','YB']
					: ['KiB','MiB','GiB','TiB','PiB','EiB','ZiB','YiB'];
					var u = -1;
					do {
						bytes /= thresh;
						++u;
					} while(Math.abs(bytes) >= thresh && u < units.length - 1);
					return bytes.toFixed(1)+' '+units[u];
				}

				// FlowJS configuration & setup
				var flow = new Flow({
					target: 'submit',
					singleFile: true,
					forceChunkSize: true,
					chunkSize: 1024*1000,
					testChunks: false,
					method: "octet",
					query: {${isInWorkflow?'workflow_id':'workspace_item_id'}:${submissionItemID}}
				});
				flow.assignBrowse(document.getElementById('browseButton'), false, true);
				flow.assignDrop(document.getElementById('dropTarget'));

				var uploadTableElem = jQuery('#uploadTable');
				var uploadRowTemplateElem = jQuery('#uploadRowTemplate');
				var fileRows = {};
				flow.on('fileAdded', function(file, event) {
					var newFileRow = uploadRowTemplateElem.clone();
					fileRows[file.uniqueIdentifier] = newFileRow;
					newFileRow.attr('id', file.uniqueIdentifier);
					newFileRow.find('.uploadFileName').text(file.name);
					newFileRow.find('.uploadFileSize').text(humanFileSize(file.size, true));
					showStatus(newFileRow);
					updateProgressBar(0, newFileRow.find('.uploadProgressBar'));
					uploadTableElem.find('tbody:last').append(newFileRow);
					newFileRow.removeClass('hidden');
				});
				flow.on('filesSubmitted', function(array, event){
					flow.upload();
				});
				flow.on('fileProgress', function(file, chunk){
					var fileRow = fileRows[file.uniqueIdentifier];
					updateProgressBar(flow.progress(), fileRow.find('.uploadProgressBar'));
				});
				flow.on('fileSuccess', function(file,message){
					var fileRow = fileRows[file.uniqueIdentifier];
					var retObj = JSON.parse(message);
					fileRow.find('.uploadFileDelete .btn').attr("name", "submit_remove_"+retObj.bitstreamID);
					fileRow.find('.uploadFileDesc .bitstreamID').val(retObj.bitstreamID);
					fileRow.find('.uploadFileRestricted input').attr("name", "restricted"+retObj.bitstreamID);
					hideStatus(fileRow);
				});
				flow.on('fileError', function(file, message){
					var fileRow = fileRows[file.uniqueIdentifier];
					var retObj = JSON.parse(message);
					fileRow.find('.uploadProgressBar').addClass('hidden');
					var errorElem = fileRow.find('.uploadError');
					errorElem.find('.messageSpan').text(retObj.error);
					errorElem.removeClass('hidden');
				});
			});
		</script>


		
		<%-- Hidden fields needed for SubmissionController servlet to know which item to deal with --%>
		<% Context context = UIUtil.obtainContext(request); %>
		<%= SubmissionController.getSubmissionParameters(context, request) %>
		<div class="btn-group btn-group-justified" role="group" aria-label="form control buttons">
			<div class="btn-group" role="group">
				<button class="btn btn-default" type="submit" name="<%=AbstractProcessingStep.PREVIOUS_BUTTON%>" <c:if test='${stepInfo.isFirstStep && stepInfo.pageNum <= 1}'>disabled</c:if>>
					<fmt:message key="jsp.submit.edit-metadata.previous"/>
				</button>
			</div>
			<div class="btn-group" role="group">
				<button class="btn btn-default" type="submit" name="<%=AbstractProcessingStep.CANCEL_BUTTON%>">
					<fmt:message key="jsp.submit.edit-metadata.cancelsave"/>
				</button>
			</div>
			<div class="btn-group" role="group">
				<button class="btn btn-primary" type="submit" name="<%=AbstractProcessingStep.NEXT_BUTTON%>">
					<fmt:message key="jsp.submit.edit-metadata.next"/>
				</button>
			</div>
		</div>
        
    </form>
</dspace:layout>
