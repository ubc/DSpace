<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - About page JSP
  -
  - Attributes:
  -    ?
  --%>

<%@page import="org.dspace.core.Utils"%>
<%@page import="org.dspace.content.Bitstream"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.io.File" %>
<%@ page import="java.util.Enumeration"%>
<%@ page import="java.util.Locale"%>
<%@ page import="javax.servlet.jsp.jstl.core.*" %>
<%@ page import="javax.servlet.jsp.jstl.fmt.LocaleSupport" %>
<%@ page import="org.apache.commons.lang.StringUtils" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.core.ConfigurationManager" %>
<%@ page import="org.dspace.app.webui.servlet.RegisterServlet" %>

<%
    boolean retry = (request.getAttribute("retry") != null);
%>

<%

    Locale sessionLocale = UIUtil.getSessionLocale(request);
    Config.set(request.getSession(), Config.FMT_LOCALE, sessionLocale);

    boolean feedEnabled = ConfigurationManager.getBooleanProperty("webui.feed.enable");
    String feedData = "NONE";
    if (feedEnabled)
    {
        feedData = "ALL:" + ConfigurationManager.getProperty("webui.feed.formats");
    }
%>

<dspace:layout locbar="nolink" titlekey="jsp.about.title" feedData="<%= feedData %>">

	<p><a href="/">Home</a> <span class="text-muted">&raquo; About</span></p>

	<h1>About StatSpace</h1>
	<p>This preliminary version of StatSpace allows you to explore and use resources through the featured StatSpace material, linked from the home page.   The current resources are web visualizations, videos, WebWorK questions and clicker questions.  We are currently working on implementing the following StatSpace functionalities:  search, evaluate and, for those of you who have resources to share, upload.</p>    
	<div class="panel panel-success" >
		<div class="panel-heading">
			<h3 class="panel-title"><i class="glyphicon glyphicon-send"></i> Contact us</h3>
		</div>
		<div class="panel-body">
			<ul>
				<li>
					Email <a href='mailto:lt.support@science.ubc.ca'>lt.support@science.ubc.ca</a> for technical difficulties.
				</li>
				<li>
					Email <a href='mailto:statspace@stat.ubc.ca'>statspace@stat.ubc.ca</a> for more information about the UBC Statistics Flexible Learning project or the StatSpace project.
				</li>
			</ul>
		</div>
	</div>

	<h2>Background</h2>
	<p>StatSpace brings together open, vetted and adaptable resources including animations, web visualizations, activities and questions, for teaching and learning introductory statistics.  StatSpace also provides suggestions for use including teaching pitfalls and how students use and misuse resources.</p>
	<p>StatSpace grew out of the University of British Columbia Statistics Department’s goal of improving cross-campus introductory statistics education.  At UBC, as in many universities, introductory statistics is taught not only in the Statistics Department but also in other units, as a complete course or as a component of a domain area course to provide in-context learning.  Some instructors are experts in statistics, in statistics education and in their domain area of application.  Other instructors are not.  And many instructors work alone in their units.  Several times  since the 1970’s, the university has tried to find some solution to this fragmented approach, but establishing a coherent plan has proved elusive.</p>
	<p>In 2008, the Statistics Department embarked on a path to build a cross-campus community for collaboration in teaching introductory statistics, for sharing teaching resources, experiences and best practices.  Such a collaboration would improve statistics instruction, reduce isolation and save instructors from re-inventing the wheel.   As a first step to building this community, the Department founded the cross-unit Introductory Statistics Discussion Group.  Through regular meetings, members not only shared resources, but gained an understanding of the approaches and challenges of teaching statistics in different contexts. Members of this group received UBC funding in 2014 and became the Flexible Learning Introductory Statistics (FLIS) project team.  The project not only received central UBC funding, but also direct funding from the deans of three faculties:  Medicine, Science and Arts.</p>
	<p>FLIS is led by a team of experienced statistics instructors, with homes in five different departments in three different faculties.   These instructors have student audiences ranging from second year statistics majors to third year political science majors to first year medical students.  The team has been challenged by the diversity of approaches and terminology.  But this diversity has enriched the project, forcing members to focus on the core statistical concepts that bridge all disciplines and to produce material that is truly cross-disciplinary and accessible to students of a variety of levels and interests.   The project team chose to focus on concepts rather than computations starting with the concept of sampling variability, which is fundamental to all of statistical inference.</p>
	<p>All materials were vetted through team discussion informed by our own experiences and by the education literature -  especially the statistics education literature (when it existed!).  Many of the resources were also vetted by students through interviews, through focus groups and through trialling in a range of courses.  With each resource on StatSpace we’ve included comments on what we’ve found out about how students learn.</p>
	<p>StatSpace will not only be a repository of resources developed by FLIS. It will also be a place and platform to contribute to open statistics pedagogies, and where other statistics educators can share and sustain their teaching resources, find those of their peers, as well as evaluate the teaching resources of their peers and get peer feedback on their own.  The development of contribution and comment functionality is currently underway.</p>

        <h2>Team</h2>
        <div class="row featured-items">
            <div class="col-md-4 text-center">
                <p class="text-left"><strong>Nancy Heckman, Project Lead:</strong> Nancy is a Professor in the UBC Statistics Department, where she also serves as Head.  She has taught a range of statistics courses within the Department, from introductory to graduate level.  Her work on the 1999 Report to the VP Academic and Provost on the Proliferation of Statistics Courses convinced her of the importance of an integrated campus approach to statistics education.   Given the absence of implementation of the report recommendations and with a continuation of problems that the report tried to address, Nancy feels the FLIS project provides a path towards a solution of this long-standing problem. Nancy was the project lead of the FLIS project.</p> 		
            </div>

            <div class="col-md-4 text-center">
                <p class="text-left"><strong>Michael Whitlock, web visualizations lead:</strong> Michael is a professor in the UBC Zoology Department and co-author of the widely used introductory statistics textbook The Analysis of Biological Data. Mike is noted for his excellent teaching of Biology’s required introductory statistics class and was honoured in 2011 with the UBC Science Undergraduate Society’s Teaching Excellence Award. </p> 		
            </div>

            <div class="col-md-4 text-center">
                <p class="text-left"><strong>Eugenia Yu, Senior Instructor:</strong> Eugenia is a Senior Instructor in the UBC Statistics Department, with experience in teaching an array of introductory statistics courses for various audiences.  Eugenia also led the UBC Intro Statistics Discussion Group, founded in 2008.  On the FLIS project, Eugenia was the resource lead for personal response system questions (aka Clickers). </p> 		
            </div>
        </div>    

        <div class="row featured-items">
            <div class="col-md-4 text-center">
                <p class="text-left"><strong>Andrew Owen, Instructor:</strong> Andrew is an Instructor in UBC’s Political Science Department, with a Ph.D. from Princeton University.   Andrew  teaches an introductory quantitative methods course for political science students and enjoys introducing statistical thinking to students with little to no background in this approach to knowledge. He brings his political science expertise into the classroom, using a range of real world examples including survey data from the most recent Canadian and American elections as well as a dataset that allows students to tackle questions about politics around the world including, for example, the relationship between democracy and economic growth. Andrew is an eager and reflective user of active in-class learning and the co-lead of activities on the FLIS project team. </p> 		
            </div>

            <div class="col-md-4 text-center">
                <p class="text-left"><strong>Bruce Dunham, Senior Instructor:</strong> Bruce is a Senior Instructor in the Department of Statistics at UBC and has taught a wide range of introductory statistics courses both at UBC and in the UK.  Currently he is the President-Elect of the Statistical Society of Canada’s Statistics Education Section and Chair of the Statistics Sub-committee of the British Columbia Committee on the Undergraduate Programs in Mathematics and Statistics.  In 2012 Bruce commenced a project developing statistics questions for the on-line homework system WeBWorK, and that work has continued during the FLIS project. Bruce has also assisted in testing and assessing many of the new resources created through the FLIS project, helping in facilitating interviews and focus groups during which student volunteers interacted with prototype resources.</p> 		
            </div>

            <div class="col-md-4 text-center">
                <p class="text-left"><strong>Melissa Lee, Lecturer:</strong> Melissa is a Lecturer in the UBC Statistics Department, with experience teaching introductory statistics courses for students from a range of academic backgrounds. Her teaching philosophy is strongly grounded in evidence-based pedagogical practices, with an emphasis on student-centered learning. She has been actively engaged with the Teaching and Learning Fellow community at UBC, which has helped inform her pedagogical approach. On the FLIS project, Melissa played a key role in resource assessment, working directly with students in order to gain feedback, and has been heavily involved in the development of StatSpace. </p> 		
            </div>
        </div>    

        <div class="row featured-items">
            <div class="col-md-4 text-center">
                <p class="text-left"><strong>Mike Marin, Video Resource Lead:</strong> Mike is a Senior Instructor in the UBC School of Population and Public Health (SPPH), and creator of over 60 highly successful educational statistics videos, hosted on his YouTube Channel.  Mike teaches the core statistical courses in SPPH to students spanning 7 different degree programs.  His students range from research-intensive PhD trainees to physicians in a Master of Health Sciences program who will be mainly consumers of statistics, and everything in between.  Mike has received numerous teaching awards over his tenure teaching, including a UBC Killam Teaching Prize in 2017. </p> 		
            </div>

            <div class="col-md-4 text-center">
                <p class="text-left"><strong>Noureddine Elouazizi:</strong>  Noureddine works for the Faculty of Science’s Dean office (<a href="https://skylight.science.ubc.ca/contact">Skylight</a>). He leads the Skylight-Learning Technology team (Skylight-LT) to provide Learning Technologies services, which include: (i) management of the LT-Ecosystem operations at the Faculty of Science, (ii) consulting faculty members and other stakeholders on the feasibility, integration, design and sustainability of LT-pedagogies and solutions, and (iii) collaborating and engaging with Science faculty in LT-mediated pedagogy’ s evaluation, innovation and research. On the FLIS project, Noureddine led the learning technologies collective efforts of Faculty of Science and UBC central (CTLT) to design and create the StatSpace platform and its underlying framework. </p> 		
            </div>

            <div class="col-md-4 text-center">
                <p class="text-left"><strong>Gillian Gerhard, Senior Educational Consultant:</strong> Gillian is a Senior Educational Consultant in the Centre for Teaching, Learning and Technology (CTLT), with a background in Mechanical Engineering and a PhD in Curriculum and Pedagogy.  During this project’s development, Gillian worked as a Strategist, Teaching and Learning Initiatives in Skylight at the Science Dean’s Office and as Science Faculty Liaison for CTLT.    She guided the development and implementation of FLIS, as well as other faculty-led strategic teaching and learning enhancement projects in Science. </p> 		
            </div>
        </div>
        <h4>CREDIT FUNDING</h4>

        <p>StatSpace was developed as part of the UBC Flexible Learning Introductory Statistics Project funded by The University of British Columbia’s Teaching and Learning Enhancement Fund, The Faculty of Medicine, The Faculty of Science, and The Faculty of Arts.</p>

</dspace:layout>
