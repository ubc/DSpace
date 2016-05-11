<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="java.util.Arrays"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.List"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.Context"%>
<%@ page import="org.dspace.core.Utils" %>
<%@ page import="org.dspace.content.Collection" %>
<%@ page import="org.dspace.content.DSpaceObject"%>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.dspace.content.ItemIterator"%>
<%@ page import="org.dspace.content.Metadatum" %>
<%@ page import="org.dspace.handle.HandleManager"%>

<%
    Context context = UIUtil.obtainContext(request);
    String showcaseCollectionHandle = ConfigurationManager.getProperty("statspace.showcase.handle");
    if (StringUtils.isEmpty(showcaseCollectionHandle)) throw new IllegalArgumentException("Showcase collection handle is not configured");
    DSpaceObject dso = HandleManager.resolveToObject(context, showcaseCollectionHandle);
    if (dso == null || !(dso instanceof Collection)) {
        throw new IllegalArgumentException("Showcase collection handle does not resolve to a Collection: " + showcaseCollectionHandle + 
                " (" + dso.getTypeText() + ")");
    }

    Collection collection = (Collection) dso;
    ItemIterator itemsIterator = collection.getAllItems();
    ArrayList<Item> items = new ArrayList<>();
    while (itemsIterator.hasNext()) {
        items.add(itemsIterator.next());
    }
    itemsIterator.close();
%>
<div id="showcase">
<%
    if (items.size() > 0) {
%>
<table class="table" align="center" summary="Downloaded items">
    <tr>
        <th id="t10">Title</th>
        <th id="t11">Author(s)</th>
        <th id="t12">Subject(s)</th>
        <th id="t13">Description</th>
    </tr>
    <% 
        for (Item item : items) {
            String title = item.getName();
            List<Metadatum> authorMetadata = Arrays.asList(item.getMetadata("dc", "creator", null, Item.ANY));
            if (authorMetadata.size() == 0) {
                authorMetadata = Arrays.asList(item.getMetadata("dc", "author", null, Item.ANY));
            }
            StringBuffer authors = new StringBuffer();
            if (authorMetadata.size() > 0) {
                authors.append(authorMetadata.get(0).value);
                for (Metadatum author : authorMetadata.subList(1, authorMetadata.size())) {
                    authors.append("; ").append(author.value);
                }
            } else {
                authors.append("-");
            }
            List<Metadatum> subjectMetadata = Arrays.asList(item.getMetadata("dc", "subject", null, Item.ANY));
            StringBuffer subjects = new StringBuffer();
            if (subjectMetadata.size() > 0) {
                subjects.append(subjectMetadata.get(0).value);
                for (Metadatum subject : subjectMetadata.subList(1, subjectMetadata.size())) {
                    subjects.append("; ").append(subject.value);
                }
            } else {
                subjects.append("-");
            }
            Metadatum[] descriptionMetadata = item.getMetadata("dc", "description", "abstract", Item.ANY);
            String description = descriptionMetadata.length > 0 ? descriptionMetadata[0].value : "-";
    %>
    <tr>
        <td><a href="<%= request.getContextPath() + "/handle/"
                            + item.getHandle() %>"><%= Utils.addEntities(title) %></a></td>
        <td><%= authors %></td>
        <td><%= subjects %></td>
        <td><%= description %></td>
    </tr>
    <% } %>
</table>
<%
    }
    else {
%>
    <p>Showcase collection empty</p>
<% } %>
</div>
