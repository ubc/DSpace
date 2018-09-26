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
</dspace:layout>
