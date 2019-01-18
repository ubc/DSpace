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

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<dspace:layout locbar="nolink" titlekey="jsp.home.title">
        <div class="row landing-page">  
            <div class="col-md-8">
		
                <div class="jumbotron">
                    <h1><i class="glyphicon glyphicon-stats"></i> StatSpace</h1>
                    <h2>Find and share vetted learning resources for teaching introductory statistics in any discipline</h2>
		    
                    <p>StatSpace brings together high-quality open education resources vetted by instructors from UBC and around the world, with the goal of supporting cooperation among statistics instruction experts and sharing resources that address common cross-disciplinary challenges of teaching in this area.</p>
                    <ul>
                        <li>Use the search feature and featured resources to explore
                        <li>Contribute open introductory statistics resources, including simulations, videos, data sets, and more&nbsp;<sup>*</sup>
                        <li>Comment on resources to share meaningful feedback with other educators
                        <li>Register and request instructor access, to view instructor-only resources
                    </ul>
                    <div class="text-left small">
                        <sup>*</sup>&nbsp;To contribute resources, please register and sign in.  In this current pilot stage, contributing also requires approval from <a href="mailto:statspace@stat.ubc.ca">statspace@stat.ubc.ca</a>.
                    </div>
                </div>
		
            </div>
	    
            <div class="col-md-4 intro-sidebar">
	    
		<div class="panel panel-info" >
		    <div class="panel-heading">
                <h3 class="panel-title">Copyright</h3>
		    </div>
		    <div class="panel-body">
			 <p>Understand how content copyright works for the resources available in StatSpace. <a href="<c:url value='/demo/copyright.jsp' />">More &raquo;</a></p>
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
			     <p>Evaluate the introductory statistics resource in StatSpace by giving <strong>detailed private feedback</strong> for any resources you use, to help other educators improve their designs.</p>
		      </div>
            </div>
	    -->
                </div>
            </div>
	

			<jsp:include page="/ubc/statspace/components/home/featured-articles.jsp" />
</dspace:layout>
