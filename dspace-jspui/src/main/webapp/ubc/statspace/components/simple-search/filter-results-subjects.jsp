<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<c:set var="facet" value="${requestScope[param.facetVar]}" />

<ul class='list-unstyled FilterResultsSubjects hidden' id='${param.collapseID}'>
<c:set var="prevLevel" value="0" />
<c:forEach items="${filterResultsSubjects}" var="subject">
	<c:set var='facetResult' value="${filterResultsSubjectToFacetResults[subject.value]}" />
	<c:set var="FacetResultURL" 
		   value="${pagination.baseURL}0&amp;filtername=${facet.key}&amp;filterquery=${facetResult.asFilterQuery}&amp;filtertype=${facetResult.filterType}"/>
	<c:if test='${subject.level < prevLevel}'>
		<c:forEach begin='1' end='${prevLevel - subject.level}'>
			</ul></li>
		</c:forEach>
	</c:if>
	<li>
	<span class='pull-right'>
		<c:if test='${subject.hasSubjects}'>
			<button role='button' class='btn btn-default btn-xs ToggleCollapsibleButton' title='Show Subtopics'>
				<small><span class='glyphicon glyphicon-chevron-down'></span></small>
			</button>
		</c:if>
		${facetResult.count}
		<c:if test='${subject.hasSubjects}'></c:if>
	</span>
	<a href='${FacetResultURL}' title='<fmt:message key="jsp.search.facet.narrow"><fmt:param>${subject.label}</fmt:param></fmt:message>' class="SubjectLink">
		${subject.label}
	</a>
	<c:if test='${subject.hasSubjects}'><ul class='ToggleCollapsible list-unstyled hidden'></c:if>
	<c:if test='${!subject.hasSubjects}'></li></c:if>

	<c:set var="prevLevel" value="${subject.level}" />
</c:forEach>
</ul>
<script>
	jQuery(function() {
		var collapsibleElems = jQuery('.ToggleCollapsible');
		console.log(collapsibleElems);
		collapsibleElems.parent().children('span.pull-right').click(function() {
			var button = jQuery(this);
			var parent = button.parent();
			button.find('.ToggleCollapsibleButton span').toggleClass('glyphicon-chevron-down glyphicon-chevron-up');
			parent.children('ul.ToggleCollapsible').toggleClass('hidden');
			console.log(this);
			console.log("clicked");
		});
	});
</script>