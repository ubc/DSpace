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

    <div class="row ">  
	<div class="col-md-12">
		
	    <h1>About StatSpace</h1>
	    
	    <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Hic Speusippus, hic Xenocrates, hic eius auditor Polemo, cuius illa ipsa sessio fuit, quam videmus. An hoc usque quaque, aliter in vita? An, partus ancillae sitne in fructu habendus, disseretur inter principes civitatis, P. Quaesita enim virtus est, non quae relinqueret naturam, sed quae tueretur. Quae autem natura suae primae institutionis oblita est? Duo Reges: constructio interrete. Si stante, hoc natura videlicet vult, salvam esse se, quod concedimus; Quod autem satis est, eo quicquid accessit, nimium est; Sed tempus est, si videtur, et recta quidem ad me. </p>
	    
	    <p>Cyrenaici quidem non recusant; Nam memini etiam quae nolo, oblivisci non possum quae volo. Sed ne, dum huic obsequor, vobis molestus sim. At, si voluptas esset bonum, desideraret. Videamus animi partes, quarum est conspectus illustrior; </p>
	    
	    <h2>Verba tu fingas et ea dicas, quae non sentias?</h2>
	    
	    <p>Quid de Pythagora? Nam, ut sint illa vendibiliora, haec uberiora certe sunt. Apparet statim, quae sint officia, quae actiones. Itaque hic ipse iam pridem est reiectus; Primum in nostrane potestate est, quid meminerimus? Eiuro, inquit adridens, iniquum, hac quidem de re; Equidem etiam Epicurum, in physicis quidem, Democriteum puto. Non laboro, inquit, de nomine. </p>
	    
	    <dl>
		    <dt><dfn>Tenent mordicus.</dfn></dt>
		    <dd>Habent enim et bene longam et satis litigiosam disputationem.</dd>
		    <dt><dfn>Ita credo.</dfn></dt>
		    <dd>Et ego: Piso, inquam, si est quisquam, qui acute in causis videre soleat quae res agatur.</dd>
	    </dl>
	    
	    
	    <h2>Quo igitur, inquit, modo?</h2>
	    
	    <p>Ergo illi intellegunt quid Epicurus dicat, ego non intellego? Verum hoc idem saepe faciamus. Beatus sibi videtur esse moriens. Pudebit te, inquam, illius tabulae, quam Cleanthes sane commode verbis depingere solebat. Ego vero volo in virtute vim esse quam maximam; Qua tu etiam inprudens utebare non numquam. Quis istud possit, inquit, negare? </p>
	    
	    <ul>
		    <li>Non igitur potestis voluptate omnia dirigentes aut tueri aut retinere virtutem.</li>
		    <li>Hoc sic expositum dissimile est superiori.</li>
		    <li>Aliter homines, aliter philosophos loqui putas oportere?</li>
	    </ul>
	    
	    <h3>Sed quot homines, tot sententiae;</h3>
	    
	    <p>Facit enim ille duo seiuncta ultima bonorum, quae ut essent vera, coniungi debuerunt; In parvis enim saepe, qui nihil eorum cogitant, si quando iis ludentes minamur praecipitaturos alicunde, extimescunt. Atque haec coniunctio confusioque virtutum tamen a philosophis ratione quadam distinguitur. Hic nihil fuit, quod quaereremus. Sin kakan malitiam dixisses, ad aliud nos unum certum vitium consuetudo Latina traduceret. </p>
	
	</div>
    </div>

</dspace:layout>
