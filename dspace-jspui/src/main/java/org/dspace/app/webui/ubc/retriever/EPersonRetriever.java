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

	public final static String ROLE_QUALIFIER = "role";
	public final static String UNIT_QUALIFIER = "unit";
	public final static String INSTITUTION_QUALIFIER = "institution";

	public EPerson user;

	public EPersonRetriever(EPerson user) {
		this.user = user;
	}

	public int getID() {
		return user.getID();
	}

	public String getEmail() {
		return user.getEmail();
	}

	public String getName() {
		return user.getFullName();
	}

	public String getPhone() {
		String phone = user.getMetadata("phone");
		if (phone == null) phone = "";
		return phone;
	}

	public String getRole() {
		return getMetadataWithQualifier(ROLE_QUALIFIER);
	}

	public String getUnit() {
		return getMetadataWithQualifier(UNIT_QUALIFIER);
	}

	public String getInstitution() {
		return getMetadataWithQualifier(INSTITUTION_QUALIFIER);
	}

	private String getMetadataWithQualifier(String qualifier) {
		String value = "";
		Metadatum[] values = user.getMetadata("eperson", qualifier, null, "*");
		if (values.length > 0) {
			value = values[0].value;
		}
		return value;
	}

}
