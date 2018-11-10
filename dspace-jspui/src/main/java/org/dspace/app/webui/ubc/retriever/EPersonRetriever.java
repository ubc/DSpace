package org.dspace.app.webui.ubc.retriever;

import org.apache.log4j.Logger;
import org.dspace.content.Metadatum;
import org.dspace.eperson.EPerson;

/**
 * Easy way to get access to user data for JSPs.
 */
public class EPersonRetriever {
    /** log4j logger */
    private static Logger log = Logger.getLogger(EPersonRetriever.class);

	public final static String ROLE_ELEMENT = "role";
	public final static String UNIT_ELEMENT = "unit";
	public final static String INSTITUTION_ELEMENT = "institution";
	public final static String ADDITIONALINFO_ELEMENT = "additionalInfo";
	public final static String REQUEST_INSTRUCTOR_ACCESS_ELEMENT = "requestedInstructorAccess";
	public final static String SUPERVISOR_ELEMENT = "supervisor";
	public final static String ADDRESS_QUALIFIER = "address";
	public final static String TYPE_QUALIFIER = "type";
	public final static String URL_QUALIFIER = "url";
	public final static String EMAIL_QUALIFIER = "email";

	public EPerson user;

	public EPersonRetriever(EPerson user) {
		this.user = user;
	}

	public int getID() {
		if (user == null) return -1;
		return user.getID();
	}

	public String getEmail() {
		if (user == null) return "";
		return user.getEmail();
	}

	public String getLastName() {
		if (user == null) return "";
		return user.getLastName();
	}

	public String getFirstName() {
		if (user == null) return "";
		return user.getFirstName();
	}

	public String getName() {
		if (user == null) return "";
		return user.getFullName();
	}

	public String getPhone() {
		if (user == null) return "";
		String phone = user.getMetadata("phone");
		if (phone == null) phone = "";
		return phone;
	}

	public String getRole() {
		if (user == null) return "";
		return getMetadata(ROLE_ELEMENT);
	}

	public String getUnit() {
		if (user == null) return "";
		return getMetadata(UNIT_ELEMENT);
	}

	public String getInstitution() {
		if (user == null) return "";
		return getMetadata(INSTITUTION_ELEMENT);
	}

	public String getInstitutionType() {
		if (user == null) return "";
		return getMetadata(INSTITUTION_ELEMENT, TYPE_QUALIFIER);
	}

	public String getInstitutionAddress() {
		if (user == null) return "";
		return getMetadata(INSTITUTION_ELEMENT, ADDRESS_QUALIFIER);
	}

	public String getInstitutionUrl() {
		if (user == null) return "";
		return getMetadata(INSTITUTION_ELEMENT, URL_QUALIFIER);
	}

	public String getInstitutionEmail() {
		if (user == null) return "";
		return getMetadata(INSTITUTION_ELEMENT, EMAIL_QUALIFIER);
	}

	public String getSupervisorContact() {
		if (user == null) return "";
		return getMetadata(SUPERVISOR_ELEMENT);
	}

	public String getAdditionalInfo() {
		if (user == null) return "";
		return getMetadata(ADDITIONALINFO_ELEMENT);
	}

	public boolean getHasRequestedInstructorAccess() {
		if (user == null) return false;
		String data = getMetadata(REQUEST_INSTRUCTOR_ACCESS_ELEMENT);
		return !data.isEmpty();
	}

	private String getMetadata(String element) {
		return EPersonRetriever.this.getMetadata(element, null);
	}
	private String getMetadata(String element, String qualifier) {
		String value = "";
		Metadatum[] values = user.getMetadata("eperson", element, qualifier, "*");
		if (values.length > 0) {
			value = values[0].value;
			if (value == null) value = "";
		}
		return value;
	}

}
