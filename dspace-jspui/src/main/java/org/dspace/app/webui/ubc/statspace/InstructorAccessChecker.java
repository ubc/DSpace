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
public class InstructorAccessChecker {
	
    /** log4j logger */
    private static Logger log = Logger.getLogger(InstructorAccessChecker.class);

	public static String ACCESS_EVERYONE = "Everyone";
	public static String ACCESS_INSTRUCTOR_ONLY = "Instructor Only";

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
	public static boolean hasInstructorAccess(Context context) throws SQLException {
		// Access isn't for everyone, so check if user is logged in
		EPerson user = context.getCurrentUser();
		if (user == null) return false; // user isn't logged in, so reject access

		if (AuthorizeManager.isAdmin(context)) {
			return true;
		}
		Pattern instructorRegex = Pattern.compile("instructor", Pattern.CASE_INSENSITIVE);
		Pattern curatorRegex = Pattern.compile("curator", Pattern.CASE_INSENSITIVE);
		Group[] groups = Group.allMemberGroups(context, user);
		for (Group g : groups) {
			String groupName = g.getName();
			if (instructorRegex.matcher(groupName).find()) {
				return true;
			}
			else if (curatorRegex.matcher(groupName).find()) {
				return true;
			}
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
	public static boolean hasItemAccess(Context context, Item item) {
		// We only need to go further if there's an instructor only restriction
		if (!isInstructorOnly(item)) {
			log.debug("Everyone can access this item");
			return true;
		}

		try {
			return hasInstructorAccess(context);
		} catch (SQLException ex) {
			log.error(ex);
		}
		return false;
	}

}
