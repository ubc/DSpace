<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Display item/collection/community statistics
  -
  - Attributes:
  -    statsVisits - bean containing name, data, column and row labels
  -    statsMonthlyVisits - bean containing name, data, column and row labels
  -    statsFileDownloads - bean containing name, data, column and row labels
  -    statsCountryVisits - bean containing name, data, column and row labels
  -    statsCityVisits - bean containing name, data, column and row labels
  -    isItem - boolean variable, returns true if the DSO is an Item 
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@page import="org.dspace.app.webui.servlet.MyDSpaceServlet"%>

<% Boolean isItem = (Boolean)request.getAttribute("isItem"); %>


<dspace:layout titlekey="jsp.statistics.title">
<h1><fmt:message key="jsp.statistics.title"/></h1>
<h2><fmt:message key="jsp.statistics.heading.visits"/></h2>
<table class="table table-striped">
<tr>
<th><!-- spacer cell --></th>
<th><fmt:message key="jsp.statistics.heading.views"/></th>
</tr>
<c:forEach items="${statsVisits.matrix}" var="row" varStatus="counter">
<c:forEach items="${row}" var="cell" varStatus="rowcounter">
<tr>
<td id="Item_Name">
<c:out value="${statsVisits.colLabels[rowcounter.index]}"/>
<td>
<c:out value="${cell}"/>
</td>
</c:forEach>
</tr>
</c:forEach>
</table>

<% if (request.getAttribute("statsMonthlyVisits") != null) { %>
<h2><fmt:message key="jsp.statistics.heading.monthlyvisits"/></h2>
<table class="table table-striped">
<tr>
<th><!-- spacer cell --></th>
<c:forEach items="${statsMonthlyVisits.colLabels}" var="headerlabel" varStatus="counter">
<th>
<c:out value="${headerlabel}"/>
</th>
</c:forEach>
</tr>
<c:forEach items="${statsMonthlyVisits.matrix}" var="row" varStatus="counter">
<tr>
<td>
<c:out value="${statsMonthlyVisits.rowLabels[counter.index]}"/>
</td>
<c:forEach items="${row}" var="cell">
<td>
<c:out value="${cell}"/>
</td>
</c:forEach>
</tr>
</c:forEach>
</table>
<% } %>

<% if(isItem) { %>

<h2><fmt:message key="jsp.statistics.heading.filedownloads"/></h2>
<table class="table table-striped">
<tr>
<th><!-- spacer cell --></th>
<th><fmt:message key="jsp.statistics.heading.views"/></th>
</tr>
<c:forEach items="${statsFileDownloads.matrix}" var="row" varStatus="counter">
<c:forEach items="${row}" var="cell" varStatus="rowcounter">
<tr>
<td>
<c:out value="${statsFileDownloads.colLabels[rowcounter.index]}"/>
<td>
<c:out value="${cell}"/>
</td>
</c:forEach>
</tr>
</c:forEach>
</table>

<% } %>

<% if (request.getAttribute("statsCountryVisits") != null) { %>
<h2><fmt:message key="jsp.statistics.heading.countryvisits"/></h2>
<table class="table table-striped">
<tr>
<th><!-- spacer cell --></th>
<th><fmt:message key="jsp.statistics.heading.views"/></th>
</tr>
<c:forEach items="${statsCountryVisits.matrix}" var="row" varStatus="counter">
<c:forEach items="${row}" var="cell" varStatus="rowcounter">
<tr>
<td>
<c:out value="${statsCountryVisits.colLabels[rowcounter.index]}"/>
<td>
<c:out value="${cell}"/>
</tr>
</td>
</c:forEach>
</c:forEach>
</table>
<% } %>

<% if (request.getAttribute("statsCityVisits") != null) { %>
<h2><fmt:message key="jsp.statistics.heading.cityvisits"/></h2>
<table class="table table-striped">
<tr>
<th><!-- spacer cell --></th>
<th><fmt:message key="jsp.statistics.heading.views"/></th>
</tr>
<c:forEach items="${statsCityVisits.matrix}" var="row" varStatus="counter">
<c:forEach items="${row}" var="cell" varStatus="rowcounter">
<tr>
<td>
<c:out value="${statsCityVisits.colLabels[rowcounter.index]}"/>
<td>
<c:out value="${cell}"/>
</td>
</tr>
</c:forEach>
</c:forEach>
</table>


<% } %>


<button class="btn btn-default" onclick=print_item()>Download</button>


<script type="text/javascript">

  function print_item() {
  var today = new Date();
	var name = (jQuery( "#Item_Name").text().trim());
	var dd = today.getDate();
	var mm = today.getMonth()+1; //January is 0!
	var yyyy = today.getFullYear();
	item = "";
	var tables = document.getElementsByTagName("table");
  Headers = document.getElementsByTagName("h2");
	 for (l = 0; l < (tables.length); l++) {
		var row = tables[l].rows;
    if (l != 0){
		item += "\n"; // Additional Table Separator
		item += "\n" + Headers[l].innerHTML;
      }
    else
		item += Headers[l].innerHTML;
		for (i = 0; i < (row.length); i++) {
			item += "\n"; // Row Delimiter
			var cell = row[i].cells;
			for( k=0; k<(cell.length); k++){
      cell[k].innerHTML = cell[k].innerHTML.replace(/(\r\n\t|\n|\r\t)/gm,"");
        if (cell[k].innerHTML.includes("<!--")){
          k = k++;
          item += ",";
        }
        else
			item += cell[k].innerHTML + ",";
					}
			}
		}
	exportToCsv( name + " " + yyyy + "-" + mm + "-" + dd + ".csv", item);
  }


  
function exportToCsv(filename, rows) {
        var csvFile = '';
        for (var i = 0; i < rows.length; i++) {
            csvFile += processRow(rows[i]);
        }

        var blob = new Blob([csvFile], { type: 'text/csv;charset=utf-8;' });
        if (navigator.msSaveBlob) { // IE 10+
            navigator.msSaveBlob(blob, filename);
        } else {
            var link = document.createElement("a");
            if (link.download !== undefined) { // feature detection
                // Browsers that support HTML5 download attribute
                var url = URL.createObjectURL(blob);
                link.setAttribute("href", url);
                link.setAttribute("download", filename);
                link.style.visibility = 'hidden';
                document.body.appendChild(link);
                link.click();
                document.body.removeChild(link);
            }
        }
   }

function processRow(row) {
            var finalVal = '';
            for (var j = 0; j < row.length; j++) {
                var innerValue = row[j] === null ? '' : row[j].toString();
                if (row[j] instanceof Date) {
                    innerValue = row[j].toLocaleString();
                };
                var result = innerValue.replace(/"/g, '""');
                if (j > 0)
                    finalVal += ',';
                finalVal += result;
            }
            return finalVal;
        }
</script>
</dspace:layout>



