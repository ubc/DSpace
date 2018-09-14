<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display the form to refine the simple-search and dispaly the results of the search
--%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout titlekey="jsp.search.title">

<!-- Big Search Box -->
<%--
TODO:
2. Autocomplete for search
3. Persist list/tile view selection
4. Higher resolution UBC logo placeholder
--%>
<div class="row SimpleSearchBigSearchRow">
	<div class="col-sm-12 SimpleSearchBigSearchBox">
		<!-- Main Search Box -->
		<c:set var="SearchFormID" value="SearchForm" />
		<c:set var="SearchFormResultsPerPageID" value="SearchFormResultsPerPage" />
		<c:set var="SearchFormSortedByID" value="SearchFormSortedBy" />
		<c:set var="SearchFormSortOrderID" value="SearchFormSortOrder" />
		<form id='${SearchFormID}' action="simple-search" method="get" class='form-horizontal'>
			<div class="form-group">
				<label for="query" class="col-sm-2 SimpleSearchBigLabel control-label">
					<h1><fmt:message key="jsp.search.title"/></h1>
				</label>
				<div class="col-sm-10 col-md-9 col-lg-8">
					<div class="input-group">
						<input class="form-control input-lg" type="text" id="query" name="query" value="${queryStr}"/>
						<span class="input-group-btn">
							<input class="btn btn-primary btn-lg" type="submit" id="main-query-submit" value="<fmt:message key="jsp.general.go"/>" />
						</span>
					</div>
					<!-- Advanced Filters -->
					<c:set var='AddFilterToggleID' value='AddFilterToggle'/>
					<c:set var='AddFilterSectionID' value='AddFilterSection'/>
					<div class='SimpleSearchAddFilterToggle'>
						<button type='button' class='pull-right btn btn-link' id='${AddFilterToggleID}'>
							<small>Advanced Search</small>
						</button>
					</div>
					<div id='${AddFilterSectionID}' class='SimpleSearchAddFilter hidden'>
						<div class='form-inline'>
							<label>Add Filter</label>
							<select class='form-control' name='filtername' disabled required>
								<option class='hidden' selected disabled>- Select Field -</option>
								<c:forEach items='${filterNameOptions}' var='filterNameOption'>
									<option value="${filterNameOption}"><fmt:message key="jsp.search.filter.${filterNameOption}"/></option>
								</c:forEach>
							</select>
							<select class='form-control' name='filtertype' disabled required>
								<option class='hidden' selected disabled>- Select Operation -</option>
								<c:forEach items='${filterTypeOptions}' var='filterTypeOption'>
									<option value="${filterTypeOption}"><fmt:message key="jsp.search.filter.op.${filterTypeOption}"/></option>
								</c:forEach>
							</select>
							<input class='form-control' type="text" id="filterquery" name="filterquery" placeholder='Filter Term' disabled required />
							<button class='btn btn-default'><span class='glyphicon glyphicon-plus'></span> <fmt:message key="jsp.search.filter.add"/></button>
						</div>
					</div>
					<!-- Show/Hide Advanced Search -->
					<script>
						// need to disable inputs so they don't get submitted, otherwise,
						// dspace API gets confused by the empty fields
						jQuery(function() {
							var toggle = jQuery('#${AddFilterToggleID}');
							var section = jQuery('#${AddFilterSectionID}');
							function hideSection() {
								section.find('select').prop('disabled', true);
								section.find('input').prop('disabled', true);
								section.addClass('hidden');
							};
							function showSection() {
								section.find('select').prop('disabled', false);
								section.find('input').prop('disabled', false);
								section.removeClass('hidden');
							}
							toggle.click(function() {
								if (section.hasClass('hidden')) showSection();
								else hideSection();
							});
						});
					</script>
				</div>
			</div>
			<!-- List Applied Filters -->
			<c:set var='AppliedFilterClass' value='AppliedFilterFormGroup' />
			<c:forEach items='${appliedFilters}' var='filter' varStatus='filterLoop'>
				<div class='form-group form-group-sm ${AppliedFilterClass}' id='${AppliedFilterClass}_${filterLoop.index}'>
					<div class='form-inline col-sm-10 col-sm-offset-2'>
						<label>Filter</label>
						<select class='form-control' name='filter_field_${filterLoop.index+1}'>
							<c:forEach items='${filterNameOptions}' var='filterNameOption'>
								<option value="${filterNameOption}" ${filter[0] == filterNameOption?'selected':''}>
									<fmt:message key="jsp.search.filter.${filterNameOption}"/>
								</option>
							</c:forEach>
						</select>
						<select class='form-control' name='filter_type_${filterLoop.index+1}'>
							<c:forEach items='${filterTypeOptions}' var='filterTypeOption'>
								<option value="${filterTypeOption}" ${filter[1] == filterTypeOption?'selected':''}>
									<fmt:message key="jsp.search.filter.op.${filterTypeOption}"/>
								</option>
							</c:forEach>
						</select>
						<input class='form-control' size='35' style='max-width: 100%;' type='text' name='filter_value_${filterLoop.index+1}' value='${filter[2]}' required />
						<button id="filter_remove_${filterLoop.index+1}" type="button" class="close editMetadataRemoveEntryButton" aria-label="Remove">
							<span class="glyphicon">&times;</span>
						</button>
					</div>
				</div>
			</c:forEach>
			<script>
				// TODO: This is almost identical to edit-metadata.jsp's renumbering script, should merge them together into one
				jQuery(function() {
						// Because of the way DSpace rely on sequentially numbering repeated fields, if you have
						// say fields 1,2,3,4, and you remove field 2, it'll also remove fields 3 and 4 cause
						// it stops after seeing that 2 is gone. The proper way to fix this is to use form arrays,
						// but I don't have the time required to fix the api, so this is a workaround to renumber 
						// the fields to make sure they're sequential. 
						function getIndex(elementID) {
							var index = elementID.match(/\d+/g);
							// dspace cannot handle elements numbered with 0, it expects the first element
							// to not be numbered, so have to compensate here. Assume that if we didn't
							// find a number, it's the first element.
							if (index === null) index = 0;
							index = parseInt(index, 10);
							return index;
						}
						function incrementFieldID(fieldID) {
							var prevIndex = getIndex(fieldID);
							if (fieldID.match("_"+prevIndex))
								return fieldID.replace("_"+prevIndex, "_"+(prevIndex+1));
							// special case if starting from element 0, since it isn't numbered
							return fieldID+"_"+(prevIndex+1);
						}
						function decrementFieldID(fieldID) {
							var fieldIndex = getIndex(fieldID);
							// normal case, just decrement the index
							if (fieldIndex > 0) return fieldID.replace("_"+fieldIndex,"_"+(fieldIndex-1));
							// something messed up if we reach this case, don't do anything
							else return fieldID;
						}
						// update the index on the wrapper, input, buttons, etc fields as appropriate
						function updateFieldIDs(field, isIncrement) {
							var operation = function(i, fieldID) {
								if (isIncrement) return incrementFieldID(fieldID);
								return decrementFieldID(fieldID);
							};
							field.prop("id", operation);
							field.find("select").prop("name", operation);
							field.find("input").prop("name", operation);
							field.find("button").prop("id", operation);
						}
						function incrementFieldIDs(field) {
							updateFieldIDs(field, true);
						}
						function decrementFieldIDs(field) {
							updateFieldIDs(field, false);
						}
						function renumberFields(removedElementID) {
							var nextElementID = incrementFieldID(removedElementID);
							var nextElement = jQuery("#"+nextElementID);
							while (nextElement.length) {
								decrementFieldIDs(nextElement);
								nextElementID = incrementFieldID(nextElementID);
								nextElement = jQuery("#"+nextElementID);
							}
						}
					var removeButtons = jQuery('.${AppliedFilterClass} button');
					removeButtons.click(function() {
						var elemToRemove = jQuery(this).parent().parent();
						var elemToRemoveID = elemToRemove.prop('id');
						elemToRemove.remove();
						renumberFields(elemToRemoveID);
					});
				});
			</script>
			<!-- Preserve existing search settings -->
			<div class='form-group hidden'>
				<input type="text" value="${resultsPerPage}" name="rpp" id='${SearchFormResultsPerPageID}' />
				<input type="text" value="${sortedBy}" name="sort_by" id='${SearchFormSortedByID}' />
				<input type="text" value="${sortOrder}" name="order" id='${SearchFormSortOrderID}' />
			</div>
		</form>
	</div>
</div>

<div class="row">
	<!-- Side Filters -->
	<div class="col-sm-3 SimpleSearchSidebar">
		<div class="SimpleSearchResultFilters" id='SimpleSearchResultFilters'>
			<h3><fmt:message key="jsp.search.facet.refine" /></h3>
			<c:if test='${empty facetNameToResults}'>
				<h5 class='text-info text-center'>No Filters Available</h4>
			</c:if>
			<c:forEach items='${facetNameToResults}' var='facet'>
				<c:set var='FacetCollapseID' value='${facet.key}_facet_collapse_id' />	
				<c:set var='FacetCollapseHeadingID' value='${facet.key}_facet_collapse_heading_id' />	
				<div class='panel panel-default'>
					<a role="button" data-toggle="collapse" data-parent="#SimpleSearchResultFilters" href="#${FacetCollapseID}" aria-expanded="true" aria-controls="${FacetCollapseID}">
						<div class='panel-heading' id='${FacetCollapseHeadingID}'>
							<span class='glyphicon glyphicon-chevron-down'></span>
							<fmt:message key="jsp.search.facet.refine.${facet.key}" />
						</div>
					</a>
					<div id='${FacetCollapseID}' class='panel-collapse collapse' role='tabpanel' aria-labelledby='${FacetCollapseHeadingID}'>
						<table class='table table-condensed table-hover'>
							<tbody>
								<c:forEach items='${facet.value}' var='facetResult'>
									<c:set var="FacetResultURL" 
									  value="${pagination.baseURL}0&amp;filtername=${facet.key}&amp;filterquery=${facetResult.asFilterQuery}&amp;filtertype=${facetResult.filterType}"/>
									<tr>
										<td>
											<a href='${FacetResultURL}'
											   title='<fmt:message key="jsp.search.facet.narrow"><fmt:param>${facetResult.displayedValue}</fmt:param></fmt:message>'>
												${facetResult.displayedValue}
											</a>
										</td>
										<td class='text-info'>${facetResult.count}</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
					</div>
				</div>	
				<script>
					// swap the indicator icon when showing and hiding content
					jQuery(function() {
						var buttonIcon = jQuery('#${FacetCollapseHeadingID} span');
						jQuery('#${FacetCollapseID}').on('show.bs.collapse', function () {
							buttonIcon.removeClass('glyphicon-chevron-down');
							buttonIcon.addClass('glyphicon-chevron-up');
						});
						jQuery('#${FacetCollapseID}').on('hide.bs.collapse', function () {
							buttonIcon.removeClass('glyphicon-chevron-up');
							buttonIcon.addClass('glyphicon-chevron-down');
						});
					});
				</script>
			</c:forEach>
		</div>
	</div>
	<!-- Results Display -->
	<div class="col-sm-9">
		<!-- Controls for Displaying Results -->
		<div class=''>
			<div class='row text-center'>
				<c:set var="ResultsControlResultsPerPageID" value="ResultsControlResultsPerPage" />
				<c:set var="ResultsControlSortedByID" value="ResultsControlSortedBy" />
				<c:set var="ResultsControlSortOrderID" value="ResultsControlSortOrder" />
				<c:set var="SearchSortAscending" value="ASC" />
				<c:set var="SearchSortDescending" value="DESC" />
				<form class='form-inline center-block col-sm-12'>
					<div class='SimpleSearchResultControls'>
					<!-- Results Count -->
					<span><strong>${numResults}</strong> Results</span>
					<!-- Results Per Page -->
					<div class='form-group'>
						<select id="${ResultsControlResultsPerPageID}" name="rpp" class='form-control'>
							<c:forEach items="${resultsPerPageOptions}" var="resultsPerPageOption">
								<option value='${resultsPerPageOption}' ${resultsPerPage == resultsPerPageOption? "selected":""}>${resultsPerPageOption} per page</option>
							</c:forEach>
						</select>
					</div>
					<!-- Sorting Controls -->
					<div class='form-group'>
						<c:if test='${!empty sortOptions}'>
							<select id="${ResultsControlSortedByID}" name="sort_by" class='form-control'>
							   <option value="score"><fmt:message key="search.results.sort-by"/> <fmt:message key="search.sort-by.relevance"/></option>
								<c:forEach items='${sortOptions}' var='sortOption'>
									<option value='${sortOption}' ${sortedBy == sortOption ? "selected" : ""}>
										<fmt:message key="search.results.sort-by"/>
										<fmt:message key="search.sort-by.${sortOption}"/>
									</option>
								</c:forEach>
							</select>
						</c:if>
					</div>
					<!-- Ascending vs Descending -->
					<div class='form-group'>
						<ul id='${ResultsControlSortOrderID}' class="nav nav-pills">
							<li role="presentation" class="${isSortedAscending ? 'active':''}">
								<a href="#SearchAscending" aria-controls="FilesTabTileView" role="tab" data-toggle="tab" title="Ascending">
									<span class='glyphicon glyphicon-sort-by-attributes'></span>
								</a>
							</li>
							<li role="presentation" class="${!isSortedAscending ? 'active':''}">
								<a href="#SearchDescending" aria-controls="FilesTabTileView" role="tab" data-toggle="tab" title="Descending">
									<span class='glyphicon glyphicon-sort-by-attributes-alt'></span>
								</a>
							</li>
						</ul>
					</div>
					<!-- List vs Thumbnail view -->
					<div class="form-group">
						<ul class="nav nav-pills">
							<li role="presentation" class="active">
								<a href="#SearchListView" aria-controls="SearchListView" role="tab" data-toggle="tab" title="List View">
									<i class="glyphicon glyphicon-th-list"></i>
								</a>
							</li>
							<li role="presentation">
								<a href="#SearchTileView" aria-controls="SearchTileView" role="tab" data-toggle="tab" title="Tile View">
									<i class="glyphicon glyphicon-th-large"></i>
								</a>
							</li>
						</ul>
					</div>
					</div>
				</form>
				<!-- Search Result Controls JS -->
				<script>
					jQuery(function() {
						var searchForm = jQuery('#${SearchFormID}');
						var searchResultsPerPage = jQuery('#${SearchFormResultsPerPageID}');
						var searchSortedBy = jQuery('#${SearchFormSortedByID}');
						var searchSortOrder = jQuery('#${SearchFormSortOrderID}');
						var resultsControlResultsPerPage = jQuery('#${ResultsControlResultsPerPageID}');
						var resultsControlSortedBy = jQuery('#${ResultsControlSortedByID}');
						var resultsControlSortOrderToggle = jQuery('#${ResultsControlSortOrderID} a[data-toggle="tab"]');
						// copy changes over to the main search form and then do a submit in order to preserve search settings
						resultsControlResultsPerPage.change(function() {
							searchResultsPerPage.val(resultsControlResultsPerPage.val());
							searchForm.submit();
						});
						resultsControlSortedBy.change(function() {
							searchSortedBy.val(resultsControlSortedBy.val());
							searchForm.submit();
						});
						resultsControlSortOrderToggle.on('shown.bs.tab', function(e) {
							if (jQuery(e.target).prop('title') == 'Ascending')
								searchSortOrder.val('${SearchSortAscending}');
							else
								searchSortOrder.val('${SearchSortDescending}');
							searchForm.submit();
						});
					});
				</script>
			</div>
			<!-- Pagination Controls -->
			<c:if test='${!empty results}'>
				<jsp:include page="/ubc/statspace/components/simple-search/pagination.jsp">
					<jsp:param name="paginationVar" value="pagination" />
				</jsp:include>
			</c:if>
			<!-- Warning for Empty Results -->
			<c:if test='${empty results}'>
				<div class="row">
					<div class='col-sm-12'>
						<div class="alert alert-info h4 text-center">
							<span class="glyphicon glyphicon-search"></span> <fmt:message key="jsp.search.general.noresults"/>
						</div>
					</div>
				</div>
			</c:if>
		</div>
		<!-- Display Results -->
		<div class="tab-content">
			<div role="tabpanel" class="tab-pane active" id="SearchListView">
				<jsp:include page="/ubc/statspace/components/simple-search/results-list-view.jsp">
					<jsp:param name="resultsVar" value="results" />
				</jsp:include>
			</div>
			<div role="tabpanel" class="tab-pane" id="SearchTileView">
				<jsp:include page="/ubc/statspace/components/simple-search/results-tile-view.jsp">
					<jsp:param name="resultsVar" value="results" />
				</jsp:include>
			</div>
		</div>
		<!-- Repeat Pagination Controls -->
		<c:if test='${!empty results}'>
			<jsp:include page="/ubc/statspace/components/simple-search/pagination.jsp">
				<jsp:param name="paginationVar" value="pagination" />
			</jsp:include>
		</c:if>
	</div>
</div>


</dspace:layout>
