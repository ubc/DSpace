package org.dspace.ubc;

import java.sql.SQLException;
import java.util.regex.Pattern;
import org.apache.log4j.Logger;
import org.dspace.authorize.AuthorizeManager;
import org.dspace.content.Bitstream;
import org.dspace.content.Item;
import org.dspace.content.Metadatum;
import org.dspace.core.Context;
import org.dspace.core.I18nUtil;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Group;

/**
 * Performs permission checks for the instructor only access restriction.
 * 
 */
public class UBCAccessChecker {
	
    /** log4j logger */
    private static Logger log = Logger.getLogger(UBCAccessChecker.class);

	public final static String ACCESS_EVERYONE = I18nUtil.getMessage("ubc-access-checker.permission.everyone");
	public final static String ACCESS_RESTRICTED = I18nUtil.getMessage("ubc-access-checker.permission.restricted");
	public final static String GROUP_NAME_INSTRUCTOR = "Instructor";
	public final static String GROUP_NAME_CURATOR = "curator";

	private Context context;

	public UBCAccessChecker(Context context) {
		this.context = context;
	}

	/**
	 * Check if the given item is restricted access.
	 * @param item
	 * @return True if the item is restricted, false otherwise.
	 */
	public static boolean isRestricted(Item item) {
		// Check if item has access restrictions
		String restriction = getField(item, "dcterms.accessRights");
		// No restriction stored, so default to allow access
		if (restriction.isEmpty()) restriction = ACCESS_EVERYONE;
		log.debug("Item Restriction Is: " + restriction);

		if (restriction.equalsIgnoreCase(ACCESS_EVERYONE)) {
			return false;
		}
		return true;
	}

	/**
	 * Check if a bitstream attached to an item is restricted access.
	 * @param item - the item that the bitstream is attached to
	 * @param file - the bitstream we're checking permissions on
	 * @return True if the bitstream is restricted, false otherwise
	 */
	public static boolean isRestricted(Item item, Bitstream file) {
		if (UBCAccessChecker.isRestricted(item)) return true;
		String accessRight = file.getAccessRights();
		if (accessRight.equals(ACCESS_RESTRICTED)) {
			return true;
		}
		return false;
	}

	/**
	 * Check if the currently logged in user has access to instructor only items.
	 * 
	 * The logged in user has instructor access if one of the following is true:
	 * the user is a system admin, the user is in a group that has the word "instructor" in the name,
	 * the user is in a group that has the word "curator" in the name.
	 * 
	 * If user isn't logged in, this returns false.
	 * 
	 * One case that might be missed is users who aren't system admins but are
	 * collection/community admins. Not sure how to check that.
	 * 
	 * @param context the dspace context, need this to retrieve the currently logged in user.
	 * @return True if the currently logged in user has access to instructor only items, false otherwise.
	 * @throws SQLException 
	 */
	public boolean hasInstructorAccess() throws SQLException {
		if (hasCuratorAccess()) return true;
		if (isInGroup(GROUP_NAME_INSTRUCTOR)) return true;
		return false;
	}

	/**
	 * Check if the currently logged in user is in a curator group and hence
	 * has curator access.
	 * 
	 * @return True if the user has curator access.
	 * @throws SQLException 
	 */
	public boolean hasCuratorAccess() throws SQLException {
		// need user to be logged in if we want to check access
		if (!isLoggedIn()) return false;
		if (hasAdminAccess()) return true;
		if (isInGroup(GROUP_NAME_CURATOR)) return true;
		return false;
	}

	/**
	 * Check if the currently logged in user isn't just an anonymous user. All
	 * users are in the anonymous group. Users who are also in other groups
	 * have more than just anonymous access.
	 * @return True if the user has more than anonymous access.
	 */
	public boolean hasNonAnonymousAccess() throws SQLException {
		if (!isLoggedIn()) return false;
		EPerson user = context.getCurrentUser();
		Group[] groups = Group.allMemberGroups(context, user);
		if (groups.length > 1) return true;
		return false;
	}

	/**
	 * Check if the currently logged in user has access to restricted materials.
	 * This method will differ in different spaces.
	 * 
	 * @return True if the user can access restricted materials.
	 */
	public boolean hasRestrictedAccess() throws SQLException {
		if (hasNonAnonymousAccess()) return true;
		return false;
	}

	/**
	 * Returns true if the user is a system admin.
	 * 
	 * Note that this only checks for system admin access, it misses 
	 * collection/community admins. This is because to check for that access, we
	 * need to have a dspace object to check against. But this is used
	 * preemptively without an object to check against (for adding filters to
	 * search results).
	 * @return 
	 */
	public boolean hasAdminAccess() throws SQLException {
		if (AuthorizeManager.isAdmin(context)) {
			return true;
		}
		return false;
	}

	/**
	 * Check if the currently logged in user has access to the item given.
	 * 
	 * @param item the item being accessed
	 * @return True if the user has access, false otherwise.
	 */
	public boolean hasItemAccess(Item item) {
		if (!UBCAccessChecker.isRestricted(item)) {
			log.debug("Is not a restricted item");
			// everyone has access to this item
			return true;
		}
		log.debug("Is a restricted item");
		try {
			log.debug("Checking if has restricted access");
			return hasRestrictedAccess();
		} catch (SQLException ex) {
			log.error(ex);
		}
		return false;
	}

	/**
	 * Check if the currently logged in user has access to the given file.
	 * @param file the file that the user wants to access
	 * @return 
	 */
	public boolean hasFileAccess(Item item, Bitstream file) {
		if (!isRestricted(item, file)) {
			// everyone has access
			return true;
		}
		try {
			return hasRestrictedAccess();
		} catch (SQLException ex) {
			log.error(ex);
		}
		return false;
	}

	/**
	 * Check if the logged in user is in a group with a name that matches the given
	 * group name. Note that it's not an exact equal match, e.g.: if given
	 * "instructor" then "math instructor" will also match since it has "instructor"
	 * in it.
	 * 
	 * @param context
	 * @param user
	 * @param groupName
	 * @return
	 * @throws SQLException 
	 */
	private boolean isInGroup(String groupName) throws SQLException {
        return this.isInGroup(context.getCurrentUser(), groupName);
	}

    public boolean isInGroup(EPerson user, String groupName) throws SQLException {
        Pattern regex = Pattern.compile(groupName, Pattern.CASE_INSENSITIVE);
		Group[] groups = Group.allMemberGroups(context, user);
		for (Group g : groups) {
			String name = g.getName();
			log.debug("GROUP NAME: " + name);
			if (regex.matcher(name).find()) {
				return true;
			}
		}
		return false;
    }

	/**
	 * True if there's a user currently logged in, false otherwise.
	 * @return 
	 */
	public boolean isLoggedIn() {
		EPerson user = context.getCurrentUser();
		if (user == null) return false; // no user logged in
		return true;
	}


	/**
	 * Get a single value from a metadata field.
	 * @param item
	 * @param field
	 * @return 
	 */
	private static String getField(Item item, String field) {
		// Try to parse the field into its components.
		String[] eq = field.split("\\.");
		if (eq.length <= 1) {
			throw new IllegalArgumentException("Metadata field is not in a recognizable metadata registry entry string.");
		}
		String schema = eq[0];
		String element = eq[1];
		String qualifier = null;
		if (eq.length > 2)
		{
			qualifier = eq[2];
		}

		// Retrieve the metadata based on the field components.
		Metadatum[] values = item.getMetadata(schema, element, qualifier, Item.ANY);

		for (Metadatum value : values) {
			return value.value;
		}
		return "";
	}
}
