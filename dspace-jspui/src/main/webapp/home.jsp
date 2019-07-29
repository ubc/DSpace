<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - Home page JSP
  -
  - Attributes:
  -    communities - Community[] all communities in DSpace
  -    recent.submissions - RecetSubmissions
  --%>

<%@page import="org.dspace.core.Utils"%>
<%@page import="org.dspace.content.Bitstream"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.core.Context" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.NewsManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Metadatum" %>
<%@ page import="org.dspace.content.Item" %>
<%@ page import="org.apache.commons.lang.StringUtils"%>
<%@ page import="org.dspace.app.webui.servlet.MyDSpaceServlet" %>

<%
    Community[] communities = (Community[]) request.getAttribute("communities");

    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
    String topNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));
    String sideNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-side.html"));

	/*
    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }
	*/
    
	Context context = UIUtil.obtainContext(request);
	request.setAttribute("context", context);
    ItemCounter ic = new ItemCounter(context);

    RecentSubmissions submissions = (RecentSubmissions) request.getAttribute("recent.submissions");
%>

<dspace:layout locbar="nolink" titlekey="jsp.home.title">
<%-- <dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData %>"> --%>

	<div class='flex mb2'>
		<!-- blurbs sidebar -->
		<div class='flex-none pr2 xs-hide'>
			<ul class="nav nav-pills nav-stacked">
				<li>
					<a href="<c:url value='/blurb?blurb=About' />">About</a>
				</li>
				<li>
					<a href="<c:url value='/blurb?blurb=Access' />">Access</a>
				</li>
				<li>
					<a href="<c:url value='/blurb?blurb=Contact Us' />">Contact Us</a>
				</li>
				<li>
					<a href="<c:url value='/blurb?blurb=Copyright and Licensing' />">Copyright and Licensing</a>
				</li>
				<li>
					<a href="<c:url value='/blurb?blurb=Information for Contributors' />">Information for Contributors</a>
				</li>
				<li>
					<a href="<c:url value='/blurb?blurb=Resources' />">Resources</a>
				</li>
				<li>
					<a href="<c:url value='/blurb?blurb=Terms of Use' />">Terms of Use</a>
				</li>
			</ul>
		</div>
		<!-- main content -->
		<div class='flex-auto'>
			<div class='mb3 clearfix'>
				<div class='sm-col sm-col-9'>
				${homeBlurb}
				</div>
				<div class='sm-col sm-col-3 center'>
					<%-- show sign in or submit button depending on if the user is logged in --%>
					<c:if test='${!empty context.currentUser}'>
						<form action="<c:url value='/mydspace'/>" method="post">
							<input type="hidden" name="step" value="<%= MyDSpaceServlet.MAIN_PAGE %>" />
							<button class="btn btn-primary" type="submit" name="submit_new" value="<fmt:message key="jsp.mydspace.main.start.button"/>">Start Submission</button>
						</form>
					</c:if>
					<c:if test='${empty context.currentUser}'>
						<a href="<c:url value='/mydspace'/>" class='btn btn-primary'>Sign in</a>
					</c:if>
				</div>
			</div>
			<!-- Communities Listing -->
			<div class='sm-flex flex-wrap content-stretch'>
				<c:forEach items='${communities}' var='community'>
					<a class='xs-col-12 sm-col-6 md-col-4 lg-col-3 p2 mb3 flex flex-column homeCommunityBox'
					   href="<c:url value='/handle/${community.handle}'/>">
						<div class="center">
							<c:if test='${empty community.logo}'>
								<img alt="${community.name} logo" class="img-responsive homeCommunityBoxLogo" 
									 style='opacity: 0.3'
									 src="<c:url value='/static/ubc/images/ubc-crest.png' />" /> 
							</c:if>
							<c:if test='${!empty community.logo}'>
								<img alt="${community.name} logo" class="img-responsive img-rounded border border-silver homeCommunityBoxLogo" 
									 src="<c:url value='/retrieve/${community.logo.ID}' />" /> 
							</c:if>
						</div>
						<div class=''>
							<h4 class='center'>${community.name}</h4>
						</div>
					</a>
				</c:forEach>
			</div>
		</div>
	</div>

	<!-- Recent Submissions -->
	<%-- 
	<c:set var='submissions' value="${requestScope['recent.submissions']}" />
	<c:if test="${submissions != null && submissions.count() > 0}">
		<div class="clearfix">
			<h4 class="center"><fmt:message key="jsp.collection-home.recentsub"/></h4>
			<div id="recent-submissions-carousel" class="carousel slide border border-silver sm-col-12 md-col-10 lg-col-8 mx-auto">
				<!-- Wrapper for slides -->
				<div class="carousel-inner">
					<c:forEach items='${submissions.recentSubmissions}' var='submission' varStatus='status'>
						<div style="padding-bottom: 50px; height: 125px;" class="item ${status.first?'active':''} center">
							<div style='padding-left: 80px; padding-right: 80px; display: inline-block;'>
								<h4><a href="<c:url value='/handle/${submission.handle}'/>">${submission.name}</a></h4>
								<div class='recentSubmissionOverflow'>${submission.getMetadata('dc.description')}</div>
							</div>
						</div>
					</c:forEach>
				</div>
					
				<!-- Controls -->
				<a class="left carousel-control" href="#recent-submissions-carousel" data-slide="prev" style="background: transparent; color: black">
					<span class="icon-prev"></span>
				</a>
				<a class="right carousel-control" href="#recent-submissions-carousel" data-slide="next" style="background: transparent; color: black">
					<span class="icon-next"></span>
				</a>
					
				<ol class="carousel-indicators">
					<li data-target="#recent-submissions-carousel" data-slide-to="0" class="active"></li>
					<c:forEach var='i' begin='1' end='${submissions.count()-1}'>
						<li data-target="#recent-submissions-carousel" data-slide-to="${i}"></li>
					</c:forEach>
				</ol>
			</div>
		</div>
	</c:if>
	--%>

<%-- Stock Recent Submissions & Discovery section, not using
<div class="row">
<%
if (submissions != null && submissions.count() > 0)
{
%>
        <div class="col-md-8">
        <div class="panel panel-primary">        
        <div id="recent-submissions-carousel" class="panel-heading carousel slide">
          <h3><fmt:message key="jsp.collection-home.recentsub"/>
              <%
    if(feedEnabled)
    {
	    	String[] fmts = feedData.substring(feedData.indexOf(':')+1).split(",");
	    	String icon = null;
	    	int width = 0;
	    	for (int j = 0; j < fmts.length; j++)
	    	{
	    		if ("rss_1.0".equals(fmts[j]))
	    		{
	    		   icon = "rss1.gif";
	    		   width = 80;
	    		}
	    		else if ("rss_2.0".equals(fmts[j]))
	    		{
	    		   icon = "rss2.gif";
	    		   width = 80;
	    		}
	    		else
	    	    {
	    	       icon = "rss.gif";
	    	       width = 36;
	    	    }
	%>
	    <a href="<%= request.getContextPath() %>/feed/<%= fmts[j] %>/site"><img src="<%= request.getContextPath() %>/image/<%= icon %>" alt="RSS Feed" width="<%= width %>" height="15" style="margin: 3px 0 3px" /></a>
	<%
	    	}
	    }
	%>
          </h3>
          
		  <!-- Wrapper for slides -->
		  <div class="carousel-inner">
		    <%
		    boolean first = true;
		    for (Item item : submissions.getRecentSubmissions())
		    {
		        Metadatum[] dcv = item.getMetadata("dc", "title", null, Item.ANY);
		        String displayTitle = "Untitled";
		        if (dcv != null & dcv.length > 0)
		        {
		            displayTitle = Utils.addEntities(dcv[0].value);
		        }
		        dcv = item.getMetadata("dc", "description", "abstract", Item.ANY);
		        String displayAbstract = "";
		        if (dcv != null & dcv.length > 0)
		        {
		            displayAbstract = Utils.addEntities(dcv[0].value);
		        }
		%>
		    <div style="padding-bottom: 50px; min-height: 200px;" class="item <%= first?"active":""%>">
		      <div style="padding-left: 80px; padding-right: 80px; display: inline-block;"><%= StringUtils.abbreviate(displayTitle, 400) %> 
		      	<a href="<%= request.getContextPath() %>/handle/<%=item.getHandle() %>" class="btn btn-success">See</a>
                        <p><%= StringUtils.abbreviate(displayAbstract, 500) %></p>
		      </div>
		    </div>
		<%
				first = false;
		     }
		%>
		  </div>

		  <!-- Controls -->
		  <a class="left carousel-control" href="#recent-submissions-carousel" data-slide="prev">
		    <span class="icon-prev"></span>
		  </a>
		  <a class="right carousel-control" href="#recent-submissions-carousel" data-slide="next">
		    <span class="icon-next"></span>
		  </a>

          <ol class="carousel-indicators">
		    <li data-target="#recent-submissions-carousel" data-slide-to="0" class="active"></li>
		    <% for (int i = 1; i < submissions.count(); i++){ %>
		    <li data-target="#recent-submissions-carousel" data-slide-to="<%= i %>"></li>
		    <% } %>
	      </ol>
     </div></div></div>
<%
}
%>
</div>
<div class="container row">
	<%
    	int discovery_panel_cols = 8;
    	int discovery_facet_cols = 4;
    %>
	<%@ include file="discovery/static-sidebar-facet.jsp" %>
</div>

<div class="row">
	<%@ include file="discovery/static-tagcloud-facet.jsp" %>
</div>
--%>
	
</div>
</dspace:layout>
