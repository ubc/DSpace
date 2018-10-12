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
<div class="row SimpleSearchBigSearchRow">
	<div class="col-sm-12 SimpleSearchBigSearchBox">
		<!-- Main Search Box -->
		<c:set var="SearchFormID" value="SearchForm" />
		<c:set var="SearchFormResultsPerPageID" value="SearchFormResultsPerPage" />
		<c:set var="SearchFormSortedByID" value="SearchFormSortedBy" />
		<c:set var="SearchFormSortOrderID" value="SearchFormSortOrder" />
		<c:set var="SearchFormViewTypeID" value="SearchFormViewType" />
		<c:set var="VIEW_TYPE_TILE" value="tile" />
		<c:set var="VIEW_TYPE_LIST" value="list" />
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
					<c:set var='ClearAllFiltersButtonID' value='ClearAllFilters'/>
					<c:set var='DidYouMeanButtonID' value='DidYouMean' />
					<div class='SimpleSearchAddFilterToggle'>
						<button type='button' class='pull-right btn btn-link' id='${AddFilterToggleID}'>
							<small>Advanced Search</small>
						</button>
						<!-- "Did You Mean", DSpace will suggest search terms when it thinks you've made a typo -->
						<c:if test='${!empty spellcheck}'>
							<p class='h4 SimpleSearchDidYouMean'>
								<em>
								<fmt:message key="jsp.search.didyoumean">
									<fmt:param><a id="${DidYouMeanButtonID}" role='button'>${spellcheck}</a></fmt:param>
								</fmt:message>
								</em>
							</p>
						</c:if>
						<!-- "Clear All Filters" button -->
						<c:if test='${!empty appliedFilters}'>
							<button id='${ClearAllFiltersButtonID}' type='button' class='pull-left btn btn-default btn-xs' style=''>
								<span class='glyphicon glyphicon-remove'></span> Clear All Filters
							</button>
						</c:if>
					</div>
					<div id='${AddFilterSectionID}' class='SimpleSearchAddFilter hidden'>
						<div class='form-inline'>
							<label>Filter</label>
							<select class='form-control input-sm' id='filtername' name='filtername' disabled required>
								<option class='hidden' selected disabled>- Select Field -</option>
								<c:forEach items='${filterNameOptions}' var='filterNameOption'>
									<option value="${filterNameOption}"><fmt:message key="jsp.search.filter.${filterNameOption}"/></option>
								</c:forEach>
							</select>
							<select class='form-control input-sm' id='filtertype' name='filtertype' disabled required>
								<%-- Defaulting to 'Select Operation' increases the size of the field to the point that it forces the following form inputs to wrap around on sm sizes,
									 if we default to the first option, this wraparound deson't happen. Not sure what's a good way to solve this. --%>
								<!--<option class='hidden' selected disabled>- Select Operation -</option>-->
								<c:forEach items='${filterTypeOptions}' var='filterTypeOption'>
									<option value="${filterTypeOption}"><fmt:message key="jsp.search.filter.op.${filterTypeOption}"/></option>
								</c:forEach>
							</select>
							<input class='form-control input-sm' type="text" id="filterquery" name="filterquery" placeholder='Filter Term' disabled required />
							<button class='btn btn-default btn-sm'><span class='glyphicon glyphicon-plus'></span> <fmt:message key="jsp.search.filter.add"/></button>
						</div>
						<!-- Autocomplete for filters -->
						<script>
							jQuery(function() {
								function autocomplete(queryElem, nameElem, typeElem) {
									queryElem.autocomplete({
										source: function( request, response ) {
											jQuery.ajax({
												url: "<c:url value='${autocompleteURL}' />",
												dataType: "json",
												cache: false,
												data: {
													auto_idx: nameElem.val(),
													auto_query: request.term,
													auto_sort: 'count',
													auto_type: typeElem.val(),
													location: "${searchScope}"
												},
												success: function( data ) {
													response( jQuery.map( data.autocomplete, function( item ) {
														var tmp_val = item.authorityKey;
														if (tmp_val == null || tmp_val == '')
														{
															tmp_val = item.displayedValue;
														}
														return {
															label: item.displayedValue + " (" + item.count + ")",
															value: tmp_val
														};
													}));			
												}
											});
										}
									});
								}
								autocomplete(jQuery('#filterquery'), jQuery("#filtername"), jQuery("#filtertype"));
								<c:forEach items='${appliedFilters}' var='filter' varStatus='loop'>
									var test=jQuery('#filterquery_${loop.index+1}');
									console.log(test.val());
									autocomplete(jQuery('#filterquery_${loop.index+1}'), jQuery("#filtername_${loop.index+1}"), jQuery("#filtertype_${loop.index+1}"));
								</c:forEach>
							});
						</script>
					</div>
					<!-- JS for: Show/Hide Advanced Search, Did You Mean -->
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
							// if the advanced search section is open but values weren't entered, DSpace will error out,
							// so we should hide the advanced search section when the user hasn't completed anything
							var searchForm = jQuery('#${SearchFormID}');
							searchForm.submit(function() {
								section.find('select, input').each(function() {
									if (!jQuery(this).val()) hideSection();
								});
							});
						});
						// replace search term with the suggested fix and resubmit form
						jQuery(function() {
							var didYouMeanButton = jQuery('#${DidYouMeanButtonID}');
							didYouMeanButton.click(function() {
								var searchForm = jQuery('#${SearchFormID}');
								searchForm.find('#query').val("${spellcheck}");
								searchForm.submit();
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
						<select class='form-control' name='filter_field_${filterLoop.index+1}' id="filtername_${filterLoop.index+1}">
							<c:forEach items='${filterNameOptions}' var='filterNameOption'>
								<option value="${filterNameOption}" ${filter[0] == filterNameOption?'selected':''}>
									<fmt:message key="jsp.search.filter.${filterNameOption}"/>
								</option>
							</c:forEach>
						</select>
						<select class='form-control' name='filter_type_${filterLoop.index+1}' id="filtertype_${filterLoop.index+1}">
							<c:forEach items='${filterTypeOptions}' var='filterTypeOption'>
								<option value="${filterTypeOption}" ${filter[1] == filterTypeOption?'selected':''}>
									<fmt:message key="jsp.search.filter.op.${filterTypeOption}"/>
								</option>
							</c:forEach>
						</select>
						<input class='form-control' size='35' style='max-width: 100%;' type='text' id="filterquery_${filterLoop.index+1}" name='filter_value_${filterLoop.index+1}'
							   value='${filter[2]}' required />
						<button id="filter_remove_${filterLoop.index+1}" type="button" class="close editMetadataRemoveEntryButton" aria-label="Remove">
							<span class="glyphicon">&times;</span>
						</button>
					</div>
				</div>
			</c:forEach>
			<script>
				jQuery(function() {
					var searchForm = jQuery('#${SearchFormID}');
					// Because of the way DSpace rely on sequentially numbering repeated fields, if you have
					// say fields 1,2,3,4, and you remove field 2, it'll also remove fields 3 and 4 cause
					// it stops after seeing that 2 is gone. The proper way to fix this is to use form arrays,
					// but I don't have the time required to fix the api, so this is a workaround to renumber 
					// the fields to make sure they're sequential. UPDATE: This behaviour was fixed in
					// edit-metadata.jsp but hasn't been patched in search yet.
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
					var canSubmit = true;
					removeButtons.click(function() {
						var elemToRemove = jQuery(this).parent().parent();
						var elemToRemoveID = elemToRemove.prop('id');
						elemToRemove.remove();
						renumberFields(elemToRemoveID);
						if (canSubmit) searchForm.submit();
					});
					var clearAllFiltersButton = jQuery('#${ClearAllFiltersButtonID}');
					clearAllFiltersButton.click(function() {
						jQuery('.${AppliedFilterClass}').remove();
						searchForm.submit();
					});
				});
			</script>
			<!-- Preserve existing search settings -->
			<div class='form-group hidden'>
				<input type="hidden" value="${resultsPerPage}" name="rpp" id='${SearchFormResultsPerPageID}' />
				<input type="hidden" value="${sortedBy}" name="sort_by" id='${SearchFormSortedByID}' />
				<input type="hidden" value="${sortOrder}" name="order" id='${SearchFormSortOrderID}' />
				<input type="hidden" value="${viewType}" name="viewType" id='${SearchFormViewTypeID}' />
			</div>
		</form>
	</div>
</div>

<!-- Everything Below The Search Box -->
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
				<c:set var='FacetCollapseToggleID' value='${facet.key}_facet_collapse_toggle_id' />	
				<c:set var='FacetCollapseHeadingID' value='${facet.key}_facet_collapse_heading_id' />	
				<div class='panel panel-default'>
					<a role="button" id='${FacetCollapseToggleID}' class='FilterResultsHeadingLink'>
						<div class='panel-heading FilterResultsHeading' id='${FacetCollapseHeadingID}'>
							<small><span class='glyphicon glyphicon-chevron-down'></span></small>
							<fmt:message key="jsp.search.facet.refine.${facet.key}" />
						</div>
					</a>
					<table id='${FacetCollapseID}' class='table table-condensed table-hover hidden'>
						<tbody>
							<c:forEach items='${facet.value}' var='facetResult'>
								<jsp:include page="/ubc/statspace/components/simple-search/filter-results-tr.jsp">
									<jsp:param name="baseURL" value="${pagination.baseURL}" />
									<jsp:param name="filterName" value="${facet.key}" />
									<jsp:param name="filterQuery" value="${facetResult.asFilterQuery}" />
									<jsp:param name="filterType" value="${facetResult.filterType}" />
									<jsp:param name="label" value="${facetResult.displayedValue}" />
									<jsp:param name="count" value="${facetResult.count}" />
								</jsp:include>
							</c:forEach>
						</tbody>
					</table>
				</div>	
				<script>
					// swap the indicator icon when showing and hiding content
					jQuery(function() {
						var buttonIcon = jQuery('#${FacetCollapseHeadingID} span');
						jQuery('#${FacetCollapseToggleID}').click(function () {
							var facet = jQuery('#${FacetCollapseID}');
							if (facet.is(':visible'))
								buttonIcon.switchClass('glyphicon-chevron-up', 'glyphicon-chevron-down');
							else {
								buttonIcon.switchClass('glyphicon-chevron-down', 'glyphicon-chevron-up');
								if (facet.hasClass('hidden')) {
									facet.hide();
									facet.removeClass('hidden');
								}
							}
							facet.toggle({ effect: 'blind', duration: 'fast' });
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
				<c:set var="ResultsControlSort" value="ResultsControlSort" />
				<c:set var="SearchSortAscending" value="asc" />
				<c:set var="SearchSortDescending" value="desc" />
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
						<div class="clearfix visible-sm-block SimpleSearchResultControlsSeparator"></div>
						<div class='form-group'>
							<label>Order</label>
							<button id='${ResultsControlSort}' type="button" class="btn btn-default" title='Swap Sort Order'>
								<span class='glyphicon glyphicon-sort'></span>
							</button>
						</div>
						<!-- List vs Thumbnail view -->
						<div class="form-group">
							<c:set var='ListViewButtonID' value='ListViewButton' />
							<c:set var='TileViewButtonID' value='TileViewButton' />
							<label>View</label>
							<div class="btn-group">
								<button id='${ListViewButtonID}' class='btn btn-default ${viewType!=VIEW_TYPE_TILE?'active':''}' type='button' title="List View">
									<i class="glyphicon glyphicon-th-list"></i>
								</button>
								<button id='${TileViewButtonID}' class='btn btn-default ${viewType==VIEW_TYPE_TILE?'active':''}' type='button' title="Tile View">
									<i class="glyphicon glyphicon-th-large"></i>
								</button>
							</div>
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
						var searchViewType = jQuery('#${SearchFormViewTypeID}');
						var resultsPerPage = jQuery('#${ResultsControlResultsPerPageID}');
						var sortedBy = jQuery('#${ResultsControlSortedByID}');
						var sort = jQuery('#${ResultsControlSort}');
						var listViewButton = jQuery('#${ListViewButtonID}');
						var tileViewButton = jQuery('#${TileViewButtonID}');
						// copy changes over to the main search form and then do a submit in order to preserve search settings
						resultsPerPage.change(function() {
							searchResultsPerPage.val(resultsPerPage.val());
							searchForm.submit();
						});
						sortedBy.change(function() {
							searchSortedBy.val(sortedBy.val());
							searchForm.submit();
						});
						sort.click(function(e) {
							console.log(searchSortOrder.val());
							if (searchSortOrder.val() == "${SearchSortAscending}") {
								searchSortOrder.val('${SearchSortDescending}');
							}
							else {
								searchSortOrder.val('${SearchSortAscending}');
							}
							searchForm.submit();
						});
						listViewButton.click(function(e){
							searchViewType.val("${VIEW_TYPE_LIST}");
							searchForm.submit();
						});
						tileViewButton.click(function(e){
							searchViewType.val("${VIEW_TYPE_TILE}");
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
		<div class="tab-content SimpleSearchResults">
			<div role="tabpanel" class="tab-pane ${viewType!=VIEW_TYPE_TILE?'active':''}" id="ResultsListView">
				<jsp:include page="/ubc/statspace/components/simple-search/results-list-view.jsp">
					<jsp:param name="resultsVar" value="results" />
				</jsp:include>
			</div>
			<div role="tabpanel" class="tab-pane ${viewType==VIEW_TYPE_TILE?'active':''}" id="ResultsTileView">
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
