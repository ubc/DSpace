<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - User profile editing form.
  -
  - This isn't a full page, just the fields for entering a user's profile.
  -
  - Attributes to pass in:
  -   eperson       - the EPerson to edit the profile for.  Can be null,
  -                   in which case blank fields are displayed.
  --%>

<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>

<%@ page import="java.util.Locale"%>

<%@ page import="org.dspace.core.I18nUtil" %>
<%@ page import="org.dspace.app.webui.util.UIUtil" %>
<%@ page import="org.dspace.eperson.EPerson" %>
<%@ page import="org.dspace.content.Metadatum" %>
<%@ page import="org.dspace.core.Utils" %>

<%
    Locale[] supportedLocales = I18nUtil.getSupportedLocales();
    EPerson epersonForm = (EPerson) request.getAttribute("eperson");

    String lastName = "";
    String firstName = "";
    String phone = "";
    String role = "";
    String unit = "";
    String institution = "";
    String language = "";

    if (epersonForm != null)
    {
        // Get non-null values
        lastName = epersonForm.getLastName();
        if (lastName == null) lastName = "";

        firstName = epersonForm.getFirstName();
        if (firstName == null) firstName = "";

        phone = epersonForm.getMetadata("phone");
        if (phone == null) phone = "";

        Metadatum[] roles = epersonForm.getMetadata("eperson", "role", null, "*");
        if (roles.length > 0) {
            role = roles[0].value;
        }
        else {
            role = "";
        }

        Metadatum[] units = epersonForm.getMetadata("eperson", "unit", null, "*");
        if (units.length > 0) {
            unit = units[0].value;
        }
        else {
            unit = "";
        }

        Metadatum[] institutions = epersonForm.getMetadata("eperson", "institution", null, "*");
        if (institutions.length > 0) {
            institution = institutions[0].value;
        }
        else {
            institution = "";
        }

        language = epersonForm.getMetadata("language");
        if (language == null) language = "";
    }
%>
	<div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="first_name"><fmt:message key="jsp.register.profile-form.fname.field"/></label>
        <div class="col-md-3"><input class="form-control" type="text" name="first_name" id="tfirst_name" size="40" value="<%= Utils.addEntities(firstName) %>" required/></div>
	</div>
	<div class="form-group">
        <%-- <td align="right" class="standard"><label for="tlast_name"><strong>Last name*:</strong></label></td> --%>
		<label class="col-md-offset-3 col-md-2 control-label" for="tlast_name"><fmt:message key="jsp.register.profile-form.lname.field"/></label>
        <div class="col-md-3"><input class="form-control" type="text" name="last_name" id="tlast_name" size="40" value="<%= Utils.addEntities(lastName) %>" required/></div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tphone"><fmt:message key="jsp.register.profile-form.phone.field"/></label>
        <div class="col-md-3"><input class="form-control" type="text" name="phone" id="tphone" size="40" maxlength="32" value="<%= Utils.addEntities(phone) %>"/></div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="trole"><fmt:message key="jsp.register.profile-form.role.field"/></label>
        <div class="col-md-3"><input class="form-control" type="text" name="role" id="trole" size="40" value="<%= Utils.addEntities(role) %>"/></div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tunit"><fmt:message key="jsp.register.profile-form.unit.field"/></label>
        <div class="col-md-3"><input class="form-control" type="text" name="unit" id="tunit" size="40" value="<%= Utils.addEntities(unit) %>"/></div>
    </div>
	<div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tinstitution"><fmt:message key="jsp.register.profile-form.institution.field"/></label>
        <div class="col-md-3"><input class="form-control" type="text" name="institution" id="tinstitution" maxlength="32" value="<%= Utils.addEntities(institution) %>"/></div>
    </div>
    <div class="form-group">
		<label class="col-md-offset-3 col-md-2 control-label" for="tlanguage"><strong><fmt:message key="jsp.register.profile-form.language.field"/></strong></label>
 		<div class="col-md-3">
        <select class="form-control" name="language" id="tlanguage">
<%
        for (int i = supportedLocales.length-1; i >= 0; i--)
        {
        	String lang = supportedLocales[i].toString();
        	String selected = "";
        	
        	if (language.equals(""))
        	{ if(lang.equals(I18nUtil.getSupportedLocale(request.getLocale()).getLanguage()))
        		{
        			selected = "selected=\"selected\"";
        		}
        	}
        	else if (lang.equals(language))
        	{ selected = "selected=\"selected\"";}
%>
           <option <%= selected %>
                value="<%= lang %>"><%= supportedLocales[i].getDisplayName(UIUtil.getSessionLocale(request)) %></option>
<%
        }
%>
        </select>
        </div>
     </div>
