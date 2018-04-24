package org.dspace.app.webui.ubc.statspace;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.apache.log4j.Logger;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;
import org.dspace.eperson.EPerson;
import org.dspace.eperson.Group;

/**
 * Manages a list of users who are waiting for confirmation on whether they
 * should be granted instructor access.
 * 
 * For the Statspace workflow, they want to be able to vet all incoming new
 * users manually. Once a user has been confirmed, they'll be permitted
 * instructor access.
 */
public class ApproveUserUtil {

    private static final Logger log = Logger.getLogger(ApproveUserUtil.class);

	public static final String ACTION_GRANT = "grant";
	public static final String ACTION_DENY = "deny";
	public static final String GROUP_NAME_TO_BE_VETTED = "UsersToBeVetted";
	public static final String GROUP_NAME_INSTRUCTOR_PERMISSION = "Vetted " +
			UBCAccessChecker.GROUP_NAME_INSTRUCTOR;

	public Context context;

	public ApproveUserUtil() throws SQLException {
		this.context = new Context();
	}

	/**
	 * Returns a list of users that are still waiting on approval.
	 * 
	 * @return
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	public List<EPerson> getUsersForApproval() throws SQLException, AuthorizeException {
		Group group = getToBeVettedGroup();
		ArrayList<EPerson> users = new ArrayList<>(Arrays.asList(group.getMembers()));
		return users;
	}

	/**
	 * Add the given user to the list of people waiting for approval.
	 * 
	 * @param person
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	public void addUserForApproval(EPerson person) throws SQLException, AuthorizeException {
		Group group = getToBeVettedGroup();
		addUserToGroup(person, group);
	}

	/** 
	 * Add the given user to the first instructor group found.
	 * 
	 * @param person 
	 */
	public void grantUserInstructorPermission(EPerson person) throws SQLException, AuthorizeException {
		Group group = getInstructorPermissionGroup();
		addUserToGroup(person, group);
	}

	/**
	 * Remove the given user from the list of people waiting for approval.
	 * 
	 * @param person
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	public void removeUserForApproval(EPerson person) throws SQLException, AuthorizeException {
		Group group = getToBeVettedGroup();
		group.removeMember(person);
		group.update();
		context.commit(); // flush to database or it'll be aborted
	}

	/**
	 * Get the group used to store the list of users that have yet to be vetted.
	 * 
	 * @return
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	public Group getToBeVettedGroup() throws SQLException, AuthorizeException {
		return getGroup(GROUP_NAME_TO_BE_VETTED);
	}

	/**
	 * Get the group used to store the list of users that have been vetted and 
	 * granted instructor permission.
	 * 
	 * @return
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	public Group getInstructorPermissionGroup() throws SQLException, AuthorizeException {
		return getGroup(GROUP_NAME_INSTRUCTOR_PERMISSION);
	}

	/**
	 * Add the given user to the given group.
	 * 
	 * @param user
	 * @param group
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	private void addUserToGroup(EPerson user, Group group) throws SQLException, AuthorizeException {
		group.addMember(user);
		group.update();
		context.commit(); // flush to database or it'll be aborted
	}

	/**
	 * Search by group name and return the first matching group found.
	 * 
	 * @param groupName
	 * @return
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	private Group getGroup(String groupName) throws SQLException, AuthorizeException {
		Group group;
		Group[] existingGroup = Group.search(context, groupName);
		if (existingGroup.length > 0) {
			group = existingGroup[0];
		}
		else {
			// have to create a group since it doesn't exist
            context.turnOffAuthorisationSystem();
			group = Group.create(context);
			group.setName(groupName);
			group.update();
            context.restoreAuthSystemState();
			context.commit();
		}
		return group;
	}
	
}
