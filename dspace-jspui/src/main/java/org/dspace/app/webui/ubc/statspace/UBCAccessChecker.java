package org.dspace.app.webui.ubc.statspace;

import java.sql.SQLException;
import java.util.regex.Pattern;
import org.apache.log4j.Logger;
import org.dspace.app.webui.ubc.statspace.retriever.ItemMetadataRetriever;
import org.dspace.authorize.AuthorizeManager;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Group;

/**
 * Performs permission checks for the instructor only access restriction.
 * 
 */
public class UBCAccessChecker {
	
    /** log4j logger */
    private static Logger log = Logger.getLogger(UBCAccessChecker.class);

	public final static String ACCESS_EVERYONE = "Everyone";
	public final static String ACCESS_INSTRUCTOR_ONLY = "Instructor Only";
	public final static String GROUP_NAME_INSTRUCTOR = "Instructor";
	public final static String GROUP_NAME_CURATOR = "curator";

	private Context context;

	public UBCAccessChecker(Context context) {
		this.context = context;
	}

	/**
	 * Check if the given item is restricted to instructors only.
	 * @param item
	 * @return True if the item is restricted to instructors only, false otherwise.
	 */
	public static boolean isInstructorOnly(Item item) {
		// Check if item has access restrictions
		ItemMetadataRetriever retriever = new ItemMetadataRetriever(item);
		String restriction = retriever.getField("dcterms.accessRights").getValue();
		// No restriction stored, so default to allow access
		if (restriction.isEmpty()) restriction = ACCESS_EVERYONE;

		if (restriction.equalsIgnoreCase(ACCESS_EVERYONE)) {
			return false;
		}
		return true;
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

	public boolean hasCuratorAccess() throws SQLException {
		// need user to be logged in if we want to check access
		if (!isLoggedIn()) return false;
		if (hasAdminAccess()) return true;
		if (isInGroup(GROUP_NAME_CURATOR)) return true;
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
	 * @param context the dspace context
	 * @param item the item being accessed
	 * @return True if the user has access, false otherwise.
	 */
	public boolean hasItemAccess(Item item) {
		if (!isInstructorOnly(item)) {
			// everyone has access to this item
			return true;
		}
		try {
			return hasInstructorAccess();
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
		EPerson user = context.getCurrentUser();
		Pattern regex = Pattern.compile(groupName, Pattern.CASE_INSENSITIVE);
		Group[] groups = Group.allMemberGroups(context, user);
		for (Group g : groups) {
			String name = g.getName();
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
	private boolean isLoggedIn() {
		EPerson user = context.getCurrentUser();
		if (user == null) return false; // no user logged in
		return true;
	}
}
