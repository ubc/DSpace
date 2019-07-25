package org.dspace.app.webui.ubc.license;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import org.apache.log4j.Logger;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Item;

/**
 * Build and provides information on all licenses. 
 */
public class UBCLicenseUtil {
    private static Logger log = Logger.getLogger(UBCLicenseUtil.class);

	public static String CCBY = "CC BY 4.0";
	public static String CCBYNC = "CC BY-NC 4.0";
	public static String CCBYSA = "CC BY-SA 4.0";
	public static String CCBYND = "CC BY-ND 4.0";
	public static String CCBYNCSA = "CC BY-NC-SA 4.0";
	public static String CCBYNCND = "CC BY-NC-ND 4.0";
	public static String CC0 = "CC0";
	public static String PUBLIC = "Public Domain";
	public static String POLICY81 = "UBC Policy 81";

	// radio button group name

	// preserves the order in which we should present the licenses to the user
	private static List<String> LICENSE_ORDER = Arrays.asList(
		CCBYNC, CCBY, CCBYSA, CCBYND, CCBYNCSA, CCBYNCND, CC0, POLICY81);
	private static List<String> LICENSE_ORDER_RESTRICTED = Arrays.asList(
		POLICY81);
	private static Map<String,String> FULLNAMES = initFullnames();
	private static Map<String,String> LICENSE_URLS = initLicenseUrls();
	private static Map<String,String> BADGE_URLS = initBadgeUrls();

	private List<UBCLicenseInfo> licenseList;
	private Map<String,UBCLicenseInfo> licenseByShortname;

	private boolean isRestricted;
 
	public UBCLicenseUtil(boolean isRestricted)
	{
		this.isRestricted = isRestricted;
		licenseList = initLicenseList();
		licenseByShortname = initLicenseMappedByShortName();
	}

	/**
	 * Get a map of the licenses where the keys are the license short names.
	 * Note that
	 * @return 
	 */
	public Map<String,UBCLicenseInfo> getLicenses()
	{
		return getLicenseByShortName();
	}

	/**
	 * Write the license metadata to the item.
	 * @param license - short name for the license
	 * @param item - the item to assign the license to
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	public static void assignLicense(String license, Item item)
			throws SQLException, AuthorizeException
	{
		item.clearMetadata("dc", "rights", Item.ANY, Item.ANY);
		item.addMetadata("dc", "rights", null, Item.ANY, license);
		item.addMetadata("dc", "rights", "uri", Item.ANY, getLicenseUrl(license));
		item.update();
	}

	/**
	 * The the license info object for the given license short name.
	 * @param license
	 * @return 
	 */
	public UBCLicenseInfo getLicense(String license)
	{
		if (isValidLicense(license))
			return licenseByShortname.get(license);
		return null;
	}

	/**
	 * Get a map of UBCLicenseInfo where the keys are the license short names.
	 * Note that this is backed by a LinkedHashMap which preserves the order
	 * given in LICENSE_ORDER.
	 * @return 
	 */
	public Map<String,UBCLicenseInfo> getLicenseByShortName()
	{
		return licenseByShortname;
	}

	/**
	 * Get the list of licenses that we know about.
	 * @return 
	 */
	public List<UBCLicenseInfo> getLicenseList()
	{
		return licenseList;
	}

	/**
	 * Check if the given license is a known license.
	 * @param license
	 * @return True if we have information on this license, false otherwise.
	 */
	public static boolean isValidLicense(String license)
	{
		if (FULLNAMES.get(license) == null) return false;
		return true;
	}

	/**
	 * Get the url to the badge image for this license.
	 * @param license the short name for this license
	 * @return the url to the badge or null if license is invalid
	 */
	public String getBadge(String license)
	{
		return BADGE_URLS.get(license);
	}

	/**
	 * Get the full name of the license.
	 * @param license the short name for this license
	 * @return the full name of this license
	 */
	public String getFullName(String license)
	{
		return FULLNAMES.get(license);
	}

	/**
	 * Get the url to the license page.
	 * @param license the short name for this license
	 * @return the url to the license page or null if license is invalid 
	 */
	public static String getLicenseUrl(String license)
	{
		return LICENSE_URLS.get(license);
	}

	private List<UBCLicenseInfo> initLicenseList()
	{
		List<UBCLicenseInfo> ret = new ArrayList<UBCLicenseInfo>();
		String fullName, licenseUrl, badgeUrl;
		List<String> licenseOrder = LICENSE_ORDER;
		if (isRestricted) licenseOrder = LICENSE_ORDER_RESTRICTED;
		for (String licenseName : licenseOrder)
		{
			log.debug(licenseName);
			fullName = getFullName(licenseName);
			licenseUrl = getLicenseUrl(licenseName);
			badgeUrl = getBadge(licenseName);
			UBCLicenseInfo info = new UBCLicenseInfo(
				licenseName, fullName, licenseUrl, badgeUrl);
			ret.add(info);
		}
		return ret;
	}

	/**
	 * Initialize the url for each creative commons license.
	 * @return 
	 */
	private static Map<String,String> initLicenseUrls()
	{
		Map<String,String> ret = new HashMap<String,String>();
		ret.put(CCBY, "https://creativecommons.org/licenses/by-sa/4.0/");
		ret.put(CCBYNC, "https://creativecommons.org/licenses/by-nc/4.0/");
		ret.put(CCBYSA, "https://creativecommons.org/licenses/by-sa/4.0/");
		ret.put(CCBYND, "https://creativecommons.org/licenses/by-nd/4.0/");
		ret.put(CCBYNCSA, "https://creativecommons.org/licenses/by-nc-sa/4.0/");
		ret.put(CCBYNCND, "https://creativecommons.org/licenses/by-nc-nd/4.0/");
		ret.put(CC0, "https://creativecommons.org/share-your-work/public-domain/");
		ret.put(PUBLIC, "https://creativecommons.org/share-your-work/public-domain/");
		ret.put(POLICY81, "https://universitycounsel.ubc.ca/files/2015/04/policy81.pdf");
		return ret;
	}

	/**
	 * Initialize the full creative common license names.
	 * @return 
	 */
	private static Map<String,String> initFullnames()
	{
		Map<String,String> ret = new HashMap<String,String>();
		ret.put(CCBY, "Creative Commons Attribution 4.0 International");
		ret.put(CCBYNC, "Creative Commons Attribution-NonCommercial 4.0 International");
		ret.put(CCBYSA, "Creative Commons Attribution-ShareAlike 4.0 International");
		ret.put(CCBYND, "Creative Commons Attribution-NoDerivatives 4.0 International");
		ret.put(CCBYNCSA, "Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International");
		ret.put(CCBYNCND, "Creative Commons Attribution-NonCommercial-NoDerivatives 4.0 International");
		ret.put(CC0, "Creative Commons Zero");
		ret.put(PUBLIC, "Public Domain");
		ret.put(POLICY81, "Non-Creative-Commons License");
		return ret;
	}

	/**
	 * Initialize the creative commons badge image URLs.
	 * @return 
	 */
	private static Map<String,String> initBadgeUrls()
	{
		Map<String,String> ret = new HashMap<String,String>();
		ret.put(CCBY,"https://i.creativecommons.org/l/by/4.0/88x31.png");
		ret.put(CCBYNC,"https://i.creativecommons.org/l/by-nc/4.0/88x31.png");
		ret.put(CCBYSA,"https://i.creativecommons.org/l/by-sa/4.0/88x31.png");
		ret.put(CCBYND,"https://i.creativecommons.org/l/by-nd/4.0/88x31.png");
		ret.put(CCBYNCSA,"https://i.creativecommons.org/l/by-nc-sa/4.0/88x31.png");
		ret.put(CCBYNCND,"https://i.creativecommons.org/l/by-nc-nd/4.0/88x31.png");
		ret.put(CC0,"https://licensebuttons.net/p/zero/1.0/88x31.png");
		ret.put(PUBLIC,"https://licensebuttons.net/p/mark/1.0/88x31.png");
		ret.put(POLICY81, "/image/ubc-logo-xs.png");
		return ret;
	}
	
	/**
	 * Initialize a map where the keys are the license short names and the vals
	 * are the UBCLicenseInfo.
	 * @return 
	 */
	private Map<String, UBCLicenseInfo> initLicenseMappedByShortName()
	{
		// using a LinkedHashMap to preserve the order that the licenses are 
		// supposed to be presented to the user.
		Map<String, UBCLicenseInfo> ret = new LinkedHashMap<String, UBCLicenseInfo>();
		for (UBCLicenseInfo info : licenseList)
		{
			ret.put(info.getShortName(), info);
		}
		return ret;
	}

}
