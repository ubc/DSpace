<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout style="submission" titlekey="jsp.dspace-admin.import-communities-collections.title"
               navbar="admin"
               locbar="link"
               parenttitlekey="jsp.administer"
               parentlink="/dspace-admin" 
               nocache="true">
	<h1>
		<fmt:message key="jsp.dspace-admin.import-communities-collections.title"/>
	</h1>
	<h2>Upload CSV</h2>
	<!-- File Selection Area -->
	<div id='dropTarget' class='text-center well well-lg'>
		<h3>
			<span class='btn btn-primary' id='browseButton'>Browse</span> or drag &amp; drop CSV here.
		</h3>
	</div>
	<!-- Import Type Selection Area -->
	<div class="form-group">
		<label>What are you importing:
			<label class="radio-inline">
				<input type="radio" name="${TOGGLE_COMMUNITIES_COLLECTIONS}" value="${IMPORT_COMMUNITIES}" />
				Communities
			</label>
			<label class="radio-inline">
				<input type="radio" name="${TOGGLE_COMMUNITIES_COLLECTIONS}" value="${IMPORT_COLLECTIONS}" checked />
				Collections
			</label>
		</label>
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
	<script src='<c:url value="/static/ubc/lib/flow.min.js" />' type="text/javascript"></script>
	<script>
		jQuery(function() {	
			var updateProgress = function (percent) {
				var percentage = Math.round(100 * percent);
				progressBarElem.css('width', percentage + '%')
				progressBarElem.text(percentage + '%')
			};
			var flow = new Flow({
				target: '<c:url value="/dspace-admin/import-communities-collections" />',
				singleFile: true,
				forceChunkSize: true,
				chunkSize: 1024*1000,
				testChunks: false,
				method: "octet",
				query: function(file, chunk, isTest) {
					return {
						"${TOGGLE_COMMUNITIES_COLLECTIONS}": jQuery("input:radio[name='${TOGGLE_COMMUNITIES_COLLECTIONS}']:checked").val()
					};
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
			flow.assignDrop(document.getElementById('dropTarget'));
			flow.on('fileAdded', function(file, event){
				filenameElem.text(file.name);
				progressTextElem.text('Uploading')
				updateProgress(0);
				jQuery('#fileStatus').removeClass('hidden');
				statusSuccessElem.addClass('hidden');
				statusErrorElem.addClass('hidden');
			});
			flow.on('filesSubmitted', function(array, event){
				flow.upload();
			});
			flow.on('fileProgress', function(file, chunk){
				updateProgress(flow.progress());
			});
			flow.on('fileSuccess', function(file,message){
				statusSuccessElem.removeClass('hidden');
			});
			flow.on('fileError', function(file, message){
				var retObj = JSON.parse(message);
				statusErrorMsg.text(retObj.error);
				statusErrorElem.removeClass('hidden');
			});
		});
	</script>
	<h2>Preparing the CSV File</h2>
	<p>
		The import CSV file should follow RFC4180. In short: use double quotes
		<strong><mark>&quot;</mark></strong> to escape strings and use comma
		<strong><mark>,</mark></strong> as the delimiter. The first row is
		treated as headers for the rest of the rows. Headers are case sensitive.
		Unknown headers will just be ignored. Headers marked 
		<span class="label label-danger">Required</span> must not have empty
		values. All headers are required to be present, even if they only hold
		empty values.
	</p>
	<h3>CSV Headers for Communities</h3>
	<dl>
		<dt>
			${COMMUNITY_NAME_HEADER}
			<span class="label label-danger">Required</span>
		</dt>
		<dd>
			The name for this new community.
		</dd>
		<dt>${COMMUNITY_DESC_HEADER}</dt>
		<dd>
			A short one sentence description of this community.
		</dd>
		<dt>${COMMUNITY_INTRO_HEADER}</dt>
		<dd>
			A longer introduction to this community. Please use HTML formatting.
		</dd>
		<dt>${COMMUNITY_COPYRIGHT_HEADER}</dt>
		<dd>
			Copyright text for this community. Plain text only.
		</dd>
		<dt>${COMMUNITY_SIDEBAR_HEADER}</dt>
		<dd>
			Side bar text for this community. Please use HTML formatting.
		</dd>
	</dl>
	<h4>Import Community Example CSV</h4>
	<pre class="pre-horiz-scroll">
${COMMUNITY_NAME_HEADER},${COMMUNITY_DESC_HEADER},${COMMUNITY_INTRO_HEADER},${COMMUNITY_COPYRIGHT_HEADER},${COMMUNITY_SIDEBAR_HEADER}
Statistics,,"Lecture slides, videos, photos, tutorials, syllabi, and other tools to assist with teaching and learning statistics.",Please review the license information provided for each item as usage rights vary.,
General & Integrated Sciences,,"Lecture slides, videos, photos, tutorials, syllabi, and other tools to assist with teaching and learning science.",Please review the license information provided for each item as usage rights vary.,</pre>
	
	<h3>CSV Headers for Collections</h3>

	<dt>
		${COMMUNITY_NAME_HEADER}
		<span class="label label-danger">Required</span>
	</dt>
	<dd>
		The name of the community that this collection should be in.
	</dd>
	<dt>
		${COLLECTION_NAME_HEADER}
		<span class="label label-danger">Required</span>
	</dt>
	<dd>
		The name of the collection.
	</dd>
	<dt>
		${COLLECTION_DESC_HEADER}
	</dt>
	<dd>
		A short one sentence description of this community.
	</dd>
	<dt>${COLLECTION_INTRO_HEADER}</dt>
	<dd>
		A longer introduction to this collection. Please use HTML formatting.
	</dd>
	<dt>${COLLECTION_COPYRIGHT_HEADER}</dt>
	<dd>
		Copyright text for this collection. Plain text only.
	</dd>
	<dt>${COLLECTION_SIDEBAR_HEADER}</dt>
	<dd>
		Side bar text for this collection. Please use HTML formatting.
	</dd>
	<dt>${COLLECTION_LICENCE_HEADER}</dt>
	<dd>
		License that submitters must grant. Leave this blank to use the default license. 
	</dd>
	<dt>${COLLECTION_PROVENANCE_HEADER}</dt>
	<dd>
		Plain text, any provenance information about this collection. Not shown on collection pages. 
	</dd>
	<dt>${COLLECTION_ENABLE_ACCEPT_REJECT_STEP_HEADER}</dt>
	<dd>
		Whether to require submissions to be approved before it's available for
		access.
		<ul>
			<li>To turn on, add in a list of groups responsible for this step,
				e.g.: <code>"Instructors, Curators"</code>.</li>
			<li>The groups must already exist in the system.</li>
			<li>To disable, just leave empty.</li>
		</ul>
	</dd>
	<dt>${COLLECTION_ENABLE_ACCEPT_REJECT_EDIT_STEP_HEADER}</dt>
	<dd>
		Whether to require submissions to be approved before it's available for
		access. Submissions can also be edited during this step. See additional
		instructions in the header above.
	</dd>
	<dt>${COLLECTION_ENABLE_EDIT_STEP_HEADER}</dt>
	<dd>
		Whether to require submissions to be edited by a reviewer before it's
		available for access. See additional instructions in the header above.
	</dd>
	<dt>${COLLECTION_GROUPS_AUTHORIZED_TO_SUBMIT_HEADER}</dt>
	<dd>
		List of groups that can make submissions to this collection. If empty,
		will remove all existing groups and users that are allowed to submit
		to this collection. If not empty, will not remove existing groups and
		users allowed to submit, but will add the groups given. E.g.: If group
		"Instructors" is already allowed to submit and this field is empty,
		"Instructors" will no longer be allowed to submit. If group
		"Instructors" is already allowed to submit and this field contains
		"Curators", both "Instructors" and "Curators" will be able to submit.
	</dd>
	<dt>${COLLECTION_GROUPS_ADMIN_HEADER}</dt>
	<dd>
		List of groups that'll be the administrators for this collection. If
		empty, will remove all existing groups and users that are allowed to
		submit to this collection. If not empty, will not remove existing groups
		and users allowed to submit, but will add the groups given.
	</dd>
	<dt>${COLLECTION_DEFAULT_METADATA_HEADER_PREFIX}</dt>
	<dd>
		Indicates the metadata field to set.
		"<em>${COLLECTION_DEFAULT_METADATA_HEADER_PREFIX}</em>" is the prefix.
		The metadata field should follow the prefix, e.g.:
		<code>${COLLECTION_DEFAULT_METADATA_HEADER_PREFIX}
			dcterms.accessRights</code>
	</dd>

	<h4>Import Collection Example CSV</h4>
	<pre class="pre-horiz-scroll">
Community Name,Collection Name,Collection Short Description,Collection Introductory Text,Collection Copyright Text,Collection Side Bar Text,Collection License,Collection Provenance,Enable Accept/Reject Step in Workflow,Enable Accept/Reject/Edit Step in Workflow,Enable Edit Step in Workflow,Collection Groups Authorized to Submit,Collection Groups Admin,Default Metadata dcterms.accrualMethod,Default Metadata dcterms.abstract
Statistics,Test,Short Desc,Intro Text,Copyright,Side bar,License,Provenance,"Vetted Instructor, UsersToBeVetted",UsersToBeVetted,Vetted Instructor,,,Accrual,abstract
Statistics,Test2,Short Desc,Intro Text,Copyright,Side bar,License,Provenance,,,,Vetted Instructor,"Vetted Instructor, UsersToBeVetted",Accrual,abstract</pre>

</dspace:layout>
