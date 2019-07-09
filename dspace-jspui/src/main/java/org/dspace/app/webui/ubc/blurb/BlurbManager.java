package org.dspace.app.webui.ubc.blurb;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.apache.log4j.Logger;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Item;
import org.dspace.content.Metadatum;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.ubc.MetadataFieldSplitter;

/**
 * Helper class to load blurbs. Realized there was a lot of code duplication now
 * that we're using blurbs in more places.
 */
public class BlurbManager {
    private static Logger log = Logger.getLogger(BlurbManager.class);

	public static final String BLURB_STORAGE_EMAIL = "Blurb_Storage_Do_Not_Delete@example.com";

	public static final String ABOUT = "About";
	public static final String ACCESS = "Access";
	public static final String CONTACT_US = "Contact Us";
	public static final String COPYRIGHT = "Copyright and Licensing";
	public static final String HOME_PAGE = "Home Page";
	public static final String CONTRIBUTORS = "Information for Contributors";
	public static final String RESOURCES = "Resources";
	public static final String TERMS_OF_USE = "Terms of Use";

	public static final List<String> BLURB_TYPES = new ArrayList<String>(Arrays.asList(ABOUT, ACCESS, CONTACT_US, COPYRIGHT, HOME_PAGE, CONTRIBUTORS, RESOURCES, TERMS_OF_USE));

	public static final String FIELD_BLURBS = "ubc.blurbs";
	
	private MetadataFieldSplitter field = new MetadataFieldSplitter(FIELD_BLURBS);

	private Context context = null;
	private EPerson storage = null;

	public BlurbManager(Context context) throws SQLException, AuthorizeException
	{
		this.context = context;
		// Was going to store the blurbs in the Site DSpaceObject, but turns out Site is just a fake DSpaceObject with no
		// metadata associated with it, so now have to do a stupid workaround where we store the metadata in a user.
		context.turnOffAuthorisationSystem();
		EPerson user = EPerson.findByEmail(context, BLURB_STORAGE_EMAIL);
		if (user == null)
		{ // need to create the user
			user = EPerson.create(context);
			user.setEmail(BLURB_STORAGE_EMAIL);
			user.update();
		}
		storage = user;
		context.restoreAuthSystemState();
	}

	public List<String> getBlurbTypes()
	{
		return BLURB_TYPES;
	}

	public String getBlurb(String blurbType)
	{
		JsonObject blurbs = getSavedBlurbs();
		if (blurbs.has(blurbType))
		{
			return blurbs.getAsJsonPrimitive(blurbType).getAsString();
		}
		return "";
	}

	public void saveBlurb(String blurbType, String blurb) throws SQLException, AuthorizeException
	{
		JsonObject blurbs = getSavedBlurbs();
		blurbs.addProperty(blurbType, blurb);
		context.turnOffAuthorisationSystem();
		storage.clearMetadata(field.schema, field.element, field.qualifier, Item.ANY);
		storage.addMetadata(field.schema, field.element, field.qualifier, Item.ANY, blurbs.toString());
		storage.update();
		context.commit();
		context.restoreAuthSystemState();
	}

	/**
	 * Read metadata for blurbs, if none were found, return an empty json object.
	 * @return 
	 */
	private JsonObject getSavedBlurbs()
	{
		JsonObject blurbs = new JsonObject();

		Metadatum[] savedVals = storage.getMetadataByMetadataString(FIELD_BLURBS);
		if (savedVals.length == 0) return blurbs;

		String savedBlurbs = savedVals[0].value;
		JsonParser parser = new JsonParser();
		blurbs = parser.parse(savedBlurbs).getAsJsonObject();
		return blurbs;
	}
}
