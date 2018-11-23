package org.dspace.app.webui.ubc.statspace.curation;

import com.google.gson.JsonObject;
import com.google.gson.JsonParser;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.apache.log4j.Logger;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Community;
import org.dspace.content.Item;
import org.dspace.content.Metadatum;
import org.dspace.core.Context;
import org.dspace.ubc.MetadataFieldSplitter;

/**
 * Helper class to load blurbs. Realized there was a lot of code duplication now
 * that we're using blurbs in more places.
 */
public class BlurbManager {
    private static Logger log = Logger.getLogger(FeaturedArticleManager.class);

	public static final String CONTACT_US = "Contact Us";
	public static final String HOME_PAGE = "Home Page";
	public static final String HOW_TO_SUBMIT = "How to Submit";
	public static final String INSTRUCTOR_ACCESS = "Instructor Access";
	public static final String COMMENTING_POLICY = "Commenting Policy";

	public static final List<String> BLURB_TYPES = new ArrayList<String>(Arrays.asList(CONTACT_US, HOME_PAGE, HOW_TO_SUBMIT, INSTRUCTOR_ACCESS, COMMENTING_POLICY));

	public static final String FIELD_BLURBS = "ubc.blurbs";
	
	private MetadataFieldSplitter field = new MetadataFieldSplitter(FIELD_BLURBS);
	private Context context;
	private Community community;

	public BlurbManager(Context context) throws SQLException
	{
		this.context = context;
		// Was going to store the blurbs in the Site DSpaceObject, but turns out Site is just a fake DSpaceObject with no
		// metadata associated with it, so now have to do a stupid workaround where we store the metadata in a community.
		// This'll work for now cause we have only 1 community at the moment.
		Community[] communities = Community.findAllTop(context);
		// FIXME: IF THERE ARE MULTIPLE COMMUNITIES, WE MIGHT NOT PICK THE RIGHT ONE
		community = communities[0];
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
		community.clearMetadata(field.schema, field.element, field.qualifier, Item.ANY);
		community.addMetadata(field.schema, field.element, field.qualifier, Item.ANY, blurbs.toString());
		community.update();
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

		Metadatum[] savedVals = community.getMetadataByMetadataString(FIELD_BLURBS);
		if (savedVals.length == 0) return blurbs;

		String savedBlurbs = savedVals[0].value;
		JsonParser parser = new JsonParser();
		blurbs = parser.parse(savedBlurbs).getAsJsonObject();
		return blurbs;
	}
}
