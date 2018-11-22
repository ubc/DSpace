<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<h3>Featured Articles</h3>
<div class="panel panel-default">
	<div class="panel-body">
		<c:if test="${empty featuredArticleCollections}">
			<div class="alert alert-danger" role="alert">
				<span class="glyphicon glyphicon-alert"></span> There are no collections in this repository, please create them first to configure featured articles.
			</div>	
		</c:if>
		<c:set var='collectionID' value='featuredArticleCollectionID' />
		<c:set var='articleListID' value='featuredArticleListID' />
		<c:set var='articleURLID' value='featuredArticleURLID' />
		<c:set var='articleAddID' value='featuredArticleAddID' />
		<c:set var='articleAddSuccessID' value='featuredArticleAddSuccessID' />
		<c:set var='articleAddFailID' value='featuredArticleAddFailID' />
		<c:set var='articleTemplateID' value='featuredArticleTemplateID' />
		<div class="form-group ${fn:length(featuredArticleCollections) > 1 ? '' : 'hidden'}">
			<label class='control-label'>Select Collection</label>
			<select class='form-control' id="featuredArticleCollectionID">
				<c:forEach items="${featuredArticleCollections}" var="featuredArticleCollection">
					<option value="${featuredArticleCollection.ID}">${featuredArticleCollection.name}</option>
				</c:forEach>
			</select>
		</div>
		<div class='form-group'>
			<label class='control-label'>Article URL</label>
			<input class='form-control' id='${articleURLID}' placeholder='Copy and paste a url such as: https://statspace.elearning.ubc.ca/handle/123456789/3' />
		</div>
		<div class='form-group'>
			<button class="btn btn-primary" type="button" id='${articleAddID}'><span class='glyphicon glyphicon-plus'></span> Add Featured Article</button>
			<!-- inline style display none to work with jqueryui's hide -->
			<span class='label label-success' id='${articleAddSuccessID}' style='display: none;'>Added Successfully!</span>
			<span class='label label-danger' id='${articleAddFailID}' style='display: none;'>Add Failed!</span>
		</div>

		<table class='form-group table' id='${articleListID}'>
			<thead>
				<tr>
					<th>Article <span class="label label-info noArticles" style="display: none;">None Currently Featured</span></th>
					<th></th>
				</tr>
			</thead>
			<tbody>
				<tr id='${articleTemplateID}' style='display: none;'>
					<td>
						<a href='#'>test</strong></a><br>
						<p>blah</p>
					</td>
					<td>
						<button class='btn btn-danger' type='button'><span class='glyphicon glyphicon-trash'></span></button>
						<span class='label label-danger' id='${articleAddFailID}' style='display: none;'>Remove Failed!</span>
					</td>
				</tr>
			</tbody>
		</table>

		<script>
			jQuery(function() {
				var apiURL = "<c:url value='/featured-article' />";
				var collection = jQuery('#${collectionID}');
				var articleList = jQuery('#${articleListID}');
				var articleURL = jQuery('#${articleURLID}');
				var articleAdd = jQuery('#${articleAddID}');
				var articleAddSuccess = jQuery('#${articleAddSuccessID}');
				var articleAddFail = jQuery('#${articleAddFailID}');
				var articleTemplate = jQuery('#${articleTemplateID}');
				function removeArticle(event) {
					var article = jQuery(this).parent().parent();
					var actionData = {
						"${featuredArticleParamCollection}": collection.val(),
						"${featuredArticleParamRemove}": this.value
					};
					jQuery.ajax({url: apiURL +'?'+ jQuery.param(actionData), type: 'DELETE'})
						.done(function(resp){
							updateArticlesList();
						})
						.fail(function(resp){
							article.find('span.label-danger').text(resp.responseJSON.error);
							article.find('span.label-danger').show().delay(5000).fadeOut();
						});
				}
				function updateArticlesList() {
					var actionData = {
						"${featuredArticleParamCollection}": collection.val()
					};
					articleList.find("span.noArticles").hide();
					jQuery.get(apiURL, actionData)
						.done(function(articles) {
							if (articles.length == 0) articleList.find("span.noArticles").show();
							// remove all existing rows except for the template
							articleList.find("tbody tr:gt(0)").remove();
							// update with the new rows
							articles.forEach(function(article) {
								var clone = articleTemplate.clone();
								clone.removeAttr('id');
								clone.find('a').attr('href', article.URL)
								clone.find('a').text(article.title)
								clone.find('p').text(article.summary)
								clone.find('button').attr('value', article.ID);
								clone.find('button').click(removeArticle); // make the remove button functional
								articleList.find('tbody tr:last').after(clone);
								clone.toggle('highlight');
							});
						});
				}
				// initial article populate on page load
				updateArticlesList();
				// make the add button functional
				articleAdd.click(function() {
					articleAdd.attr('disabled', true);
					articleAddSuccess.hide();
					articleAddFail.hide();
					var actionData = {
						"${featuredArticleParamCollection}": collection.val(),
						"${featuredArticleParamAdd}": articleURL.val()
					};
					jQuery.post(apiURL, actionData)
						.done(function(data) {
							updateArticlesList();
							articleAdd.attr('disabled', false);
							articleAddSuccess.show().delay(5000).fadeOut();
						})
						.fail(function(data) {
							articleAdd.attr('disabled', false);
							articleAddFail.text(data.responseJSON.error);
							articleAddFail.show();
						});
				});
				// update the articles if the user changes the collection
				collection.change(function() {
					updateArticlesList();
				});
			});
		</script>
	</div>
</div>