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

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
    

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.app.webui.components.RecentSubmissions" %>
<%@ page import="org.dspace.content.Community" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.core.NewsManager" %>
<%@ page import="org.dspace.browse.ItemCounter" %>
<%@ page import="org.dspace.content.Metadatum" %>
<%@ page import="org.dspace.content.Item" %>

<%
    // Is anyone logged in?
    EPerson user = (EPerson) request.getAttribute("dspace.current.user");

    // Is the logged in user an admin
    Boolean admin = (Boolean)request.getAttribute("is.admin");
    boolean isAdmin = (admin == null ? false : admin.booleanValue());

    Community[] communities = (Community[]) request.getAttribute("communities");

    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);
    String topNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-top.html"));
    String sideNews = NewsManager.readNewsFile(LocaleSupport.getLocalizedMessage(pageContext, "news-side.html"));

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }
    
    ItemCounter ic = new ItemCounter(UIUtil.obtainContext(request));

    RecentSubmissions submissions = (RecentSubmissions) request.getAttribute("recent.submissions");
%>

<dspace:layout locbar="nolink" titlekey="jsp.home.title" feedData="<%= feedData %>">
    <% if (user == null) { %>

        <div class="row landing-page">  
            <div class="col-md-8">
		
                <div class="jumbotron">
                    <h1><i class="glyphicon glyphicon-stats"></i> StatSpace</h1>
                    <h2>Find and share vetted learning materials for teaching introductory statistics in any discipline</h2>
		    
                    <p>StatSpace brings together high-quality open education materials vetted by instructors from UBC and around the world, with the goal of supporting cooperation among statistics instruction experts and sharing resources that address common cross-disciplinary challenges of teaching in this area.</p>
                </div>
		
                <div class="row after-jumbotron">
                    <div class="col-md-6">
                        <h4>About Us</h4>
                        <p>Learn about StatSpace and how open education resouces help teaching and learning. <a href="<c:url value='/demo/about.jsp' />">More &raquo;</a></p>
                    </div>    
                    <div class="col-md-6">
                        <h4>Copyright</h4>
                        <p>Understand how content copyright works for the materials available in StatSpace. <a href="<c:url value='/demo/copyright.jsp' />">More &raquo;</a></p>                        
                    </div>
                </div>
		
            </div>
	    
            <div class="col-md-4 intro-sidebar">
	    
                <div class="panel panel-info">
                    <div class="panel-heading">
                        <h3 class="panel-title">
                            <i class="glyphicon glyphicon-search"></i>Search for Materials
                        </h3>
                    </div>
                    <div class="panel-body">
						<%-- Search Box --%>
						<form method="get" action="<%= request.getContextPath() %>/simple-search">
							<div class="input-group">
								<input type="text" class="form-control" placeholder="Enter keywords" name="query" id="tequery"/>
								<span class="input-group-btn">
									<button type="submit" class="btn btn-primary">
										<span class="glyphicon glyphicon-search"></span>
									</button>
								</span>
							</div>
						</form>
					</div>
				</div>


		<div class="panel panel-info" >
		    <div class="panel-heading">
                <h3 class="panel-title"><i class="glyphicon glyphicon-open"></i> Contribute Materials</h3>
		    </div>
		    <div class="panel-body">
			 <p>Easily share introductory statistics material&mdash;including <strong>copyright-cleared simulations, video, data sets</strong>, and more&mdash;with other educators and get meaningful feedback.</p>
			 <p>Contributing material requires StatSpace registration and signing in.  In this current pilot stage, contributing also requires approval from <a href='mailto:statspace@stat.ubc.ca'>statspace@stat.ubc.ca</a>.</p>
		    </div>
		</div>
        
        <div class="panel panel-info" >
                <div class="panel-heading">
                    <h3 class="panel-title"><a href="https://ubc.ca1.qualtrics.com/jfe/form/SV_6J4ans7VBN2hpt3"><i class="glyphicon glyphicon-info-sign"></i>&nbsp;Survey</a></h3>
                </div>
                <div class="panel-body">
                    <p>When you have explored StatSpace, we would appreciate your opinion, via a brief <a href="https://ubc.ca1.qualtrics.com/jfe/form/SV_6J4ans7VBN2hpt3">survey</a>.<span class="glyphicon glyphicon-new-window"></span></p>
                </div>
		</div>
	   <!--Will be using at a later date
            <div class="panel panel-info">
		      <div class="panel-heading">
                <h3 class="panel-title"><a href="/register"><i class="glyphicon glyphicon-comment"></i> &nbsp;Evaluate what you use</a></h3>
		      </div>
		      <div class="panel-body">
			     <p>Evaluate the introductory statistics material in StatSpace by giving <strong>detailed private feedback</strong> for any resources you use, to help other educators improve their designs.</p>
		      </div>
            </div>
	    -->
                </div>
            </div>
	
            <div class="row">
                <div class="col-md-12">
                    <h3 class="featured-heading">Featured StatSpace materials</h3>
                </div>
            </div>
	
            <div class="row featured-items">
                <div class="col-md-4 text-center">
                    <h4>Simulation</h4>
                    <div class="thumbnail">
                        <img src="http://www.zoology.ubc.ca/~whitlock/kingfisher/Common/Images/fish.svg" class="sim-image" width="250">
                        <div class="caption">
                            <h5>Web Visualization: Sampling from a Normal distribution</h5>
                            <p class="text-left"><strong>About:</strong> This web visualization demonstrates the concept of a sampling distribution of an estimate, using the example of a mean of a Normally distributed variable. It also reinforces the idea of a histogram.</p>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Sampling distributions - Sample mean <br>&bull; Exploratory data analysis/Classifying data - Graphical representations - Histograms</p> 
                            <p class="see-more"><a href="<c:url value='/demo/sim-example.jsp' />" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>
                    </div>
                </div>
	    
                <div class="col-md-4 text-center">
                    <h4>Video</h4>
                    <div class="thumbnail video-iframe">
                        <iframe src="https://player.vimeo.com/video/196027417?byline=0&portrait=0" width="300" height="169" frameborder="0" ></iframe>
                        <div class="caption">
                            <h5>Video: Sampling distribution of the mean</h5>
                            <p class="text-left"><strong>About:</strong> This video explores the concept of a sampling distribution of the mean. It highlights how we can draw conclusions about a population mean based on a sample mean by understanding how sample means behave when we know the true values of the population.</p>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Sampling distribution -  Sample mean</p>
                            <br>
                            <p class="see-more"><a href="<c:url value='/demo/video-example.jsp' />" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>     
                    </div>
                </div>
                <div class="col-md-4 text-center">
                    <h4>WeBWorK Questions</h4>
                    <div class="thumbnail">
                            <img src="image/webwork_homepage.JPG"  class="sim-image-large">
                        <div class="caption">
                            <br>
                            <h5>WeBWorK Web Application</h5>
                            <p class="text-left"><strong>About:</strong> WeBWorK is a free on-line individualized assessment tool that provides students with automatic feedback on their work and is used at over 700 institutions globally. </p>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Normal distribution, Histograms, Sampling variability, Sampling from a Normal distribution</p><br><br>
                            <p class="see-more"><a href="<c:url value='/demo/WebWork_Questions.jsp' />" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>
                    </div>
                </div>
            </div>
        
            <div class="row featured-items">
                <div class="col-md-4 text-center">
                    <h4>iClicker</h4>
                    <div class="thumbnail">
                        <img src="image/iClicker_home_image.JPG" class="sim-image-large" width="220">
                        <div class="caption">
                            <h5>Interactive engagement (clicker) questions: Sampling distributions of means</h5>
                            <p class="text-left"><strong>About:</strong> With a personal response system, students can answer questions and instructors can monitor understanding in real time. Turn the classroom into a conversation and allow students to participate with smartphones, laptops, tablets, or clickers.</p>
                            <p class="text-left"><strong>Topics:</strong> <br>&bull; Probability -- Laws, theory -- Central Limit Theorem <br>&bull; Sampling distributions -- Sample mean</p> 
                            <p class="see-more"><a href="<c:url value='/demo/iClicker-example.jsp' />" class="btn btn-primary">Read more &raquo;</a></p>
                        </div>
                    </div>
                </div>
            </div>
    <% } %>

    <% if (user != null) { %>
	<%-- Search Box --%>
	<form method="get" action="<%= request.getContextPath() %>/simple-search">

        <div class="form-group col-md-8 col-md-offset-2" style="padding: 3em 0;">
            <div class="input-group">
                <input type="text" class="form-control input-lg" placeholder="<fmt:message key="jsp.layout.navbar-default.search"/>" name="query" id="tequery"/>
                <span class="input-group-btn">
                    <button type="submit" class="btn btn-primary input-lg">
                        <span class="glyphicon glyphicon-search"></span>
                    </button>
                </span>
            </div>
        </div>
        <%--               <br/><a href="<%= request.getContextPath() %>/advanced-search"><fmt:message key="jsp.layout.navbar-default.advanced"/></a>
        <%
		if (ConfigurationManager.getBooleanProperty("webui.controlledvocabulary.enable"))
		{
        %>
        <br/><a href="<%= request.getContextPath() %>/subject-search"><fmt:message key="jsp.layout.navbar-default.subjectsearch"/></a>
        <%
        }
        %> --%>

	</form>

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
<div class="col-md-4">
    <%= sideNews %>
</div>
</div>
<% } %>

<!-- <div class="row">
    <div class="col-md-8">
        <h3>Copyright</h3>
        <ul>
            <li><a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Copyright_Permissions/Seeking_Permission">Seeking Permission for Copyrighted Content</a></li> 
            <li><a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Copyright_Permissions/Curated_Content">Copyright and Curated Content in Open Education Resource Repositories</a></li>
            <li><a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Copyright_Permissions/Self_Created_Content">Self-Created Content for Open Education Repositories</a></li>
        </ul>
    </div>
    <div class="col-md-4">
        <h3>Pedagogy</h3>
        <ul>
            <li>
                <a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Curating/Define">What are Open Education Resources?</a>
            </li>
            <li>
                <a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Curating/Finding">Finding Open Education Resources</a>
            </li>
            <li>
                <a href="http://wiki.ubc.ca/Library:OERR/User_Guides/Curating/Assessing">Assessing Open Education Resource</a>
            </li>
        </ul>
    </div>
</div> -->

<% if (user != null) { %>

<div class="container row">
<%
if (communities != null && communities.length != 0)
{
%>
	<div class="col-md-4">		
               <h3><fmt:message key="jsp.home.com1"/></h3>
                <p><fmt:message key="jsp.home.com2"/></p>
				<div class="list-group">
<%
	boolean showLogos = ConfigurationManager.getBooleanProperty("jspui.home-page.logos", true);
    for (int i = 0; i < communities.length; i++)
    {
%><div class="list-group-item row">
<%  
		Bitstream logo = communities[i].getLogo();
		if (showLogos && logo != null) { %>
	<div class="col-md-3">
        <img alt="Logo" class="img-responsive" src="<%= request.getContextPath() %>/retrieve/<%= logo.getID() %>" /> 
	</div>
	<div class="col-md-9">
<% } else { %>
	<div class="col-md-12">
<% }  %>		
		<h4 class="list-group-item-heading"><a href="<%= request.getContextPath() %>/handle/<%= communities[i].getHandle() %>"><%= communities[i].getMetadata("name") %></a>
<%
        if (ConfigurationManager.getBooleanProperty("webui.strengths.show"))
        {
%>
		<span class="badge pull-right"><%= ic.getCount(communities[i]) %></span>
<%
        }

%>
		</h4>
		<p><%= communities[i].getMetadata("short_description") %></p>
    </div>
</div>                            
<%
    }
%>
	</div>
	</div>
<%
}
%>
	<%
    	int discovery_panel_cols = 8;
    	int discovery_facet_cols = 4;
    %>
	<%@ include file="discovery/static-sidebar-facet.jsp" %>
</div>

<div class="row">
	<%@ include file="discovery/static-tagcloud-facet.jsp" %>
</div>

<%
} else if (!StringUtils.isEmpty(ConfigurationManager.getProperty("statspace.showcase.handle"))) {
%>
    <%@ include file="showcase.jsp" %>
<% } %>
</div>
</dspace:layout>
