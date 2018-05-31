package org.dspace.app.webui.ubc.importer;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.sql.SQLException;
import java.text.ParseException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Level;
import org.apache.commons.csv.CSVFormat;
import org.apache.commons.csv.CSVRecord;
import org.apache.commons.lang.StringUtils;
import org.apache.log4j.Logger;
import org.dspace.app.itemupdate.MetadataUtilities;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Collection;
import org.dspace.content.Community;
import org.dspace.content.Item;
import org.dspace.core.Context;
import org.dspace.eperson.Group;

public class CommunityAndCollectionCSVImporter {
    private static Logger log = Logger.getLogger(CommunityAndCollectionCSVImporter.class);

	public static final String COMMUNITY_NAME_HEADER = "Community Name";
	public static final String COMMUNITY_DESC_HEADER = "Community Short Description";
	public static final String COMMUNITY_INTRO_HEADER = "Community Introductory Text";
	public static final String COMMUNITY_COPYRIGHT_HEADER = "Community Copyright Text";
	public static final String COMMUNITY_SIDEBAR_HEADER = "Community Side Bar Text";

	public static final String COLLECTION_NAME_HEADER = "Collection Name";
	public static final String COLLECTION_DESC_HEADER = "Collection Short Description";
	public static final String COLLECTION_INTRO_HEADER = "Collection Introductory Text";
	public static final String COLLECTION_COPYRIGHT_HEADER = "Collection Copyright Text";
	public static final String COLLECTION_SIDEBAR_HEADER = "Collection Side Bar Text";
	public static final String COLLECTION_LICENCE_HEADER = "Collection License";
	public static final String COLLECTION_PROVENANCE_HEADER = "Collection Provenance";

	public static final String COLLECTION_ENABLE_ACCEPT_REJECT_STEP_HEADER = "Enable Accept/Reject Step in Workflow";
	public static final String COLLECTION_ENABLE_ACCEPT_REJECT_EDIT_STEP_HEADER = "Enable Accept/Reject/Edit Step in Workflow";
	public static final String COLLECTION_ENABLE_EDIT_STEP_HEADER = "Enable Edit Step in Workflow";
	
	public static final String COLLECTION_GROUPS_AUTHORIZED_TO_SUBMIT_HEADER = "Collection Groups Authorized to Submit";
	public static final String COLLECTION_GROUPS_ADMIN_HEADER = "Collection Groups Admin";

	public static final String COLLECTION_DEFAULT_METADATA_HEADER_PREFIX = "Default Metadata";

	private Context context;
	private Map<String,Community> communitiesByName = new HashMap<String,Community>();
	
	public CommunityAndCollectionCSVImporter(Context context)
			throws SQLException
	{
		this.context = context;
		Community[] communities = Community.findAll(context);
		for (Community community : communities)
		{
			communitiesByName.put(community.getName(), community);
		}
	}

	/**
	 * Create communities based on the given CSVfile.
	 * @param csvFile
	 * @throws FileNotFoundException
	 * @throws IOException
	 * @throws ImportCSVException
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	public void importCommunities(File csvFile) throws FileNotFoundException,
			IOException, ImportCSVException, SQLException, AuthorizeException
	{
		Reader csvFileReader = new FileReader(csvFile);
		List<CSVRecord> records = CSVFormat.DEFAULT.
				withFirstRecordAsHeader().parse(csvFileReader).getRecords();
		// validation pass, we don't want partial imports, so have to verify
		// all the information is valid before we try to do the actual imports
		int lineNum = 1; // assuming we're past first line, as that's header
		for (CSVRecord record : records)
		{
			lineNum++;
			verifyCommunityHeadersExists(record, lineNum);
			verifyCommunityRequiredFieldsNotEmpty(record, lineNum);
			if (!record.isConsistent())
			{
				throw new ImportCSVException("Unexpected data column found at "+
					"line " + lineNum + ". " +
					"Check if there are extra/missing headers or columns. " +
					"Additional Debug: " + record.toString());
			}
		}
		log.debug("trying actual community creation");
		for (CSVRecord record : records)
		{
			log.debug("done validation: " + record.get(COMMUNITY_NAME_HEADER));
			createCommunity(record.get(COMMUNITY_NAME_HEADER).trim(),
					record.get(COMMUNITY_DESC_HEADER),
					record.get(COMMUNITY_INTRO_HEADER),
					record.get(COMMUNITY_COPYRIGHT_HEADER),
					record.get(COMMUNITY_SIDEBAR_HEADER)
			);
		}
		// just calling update on community isn't enough, looks like
		// we need to explicitly commit to database.
		context.commit();
	}

	public void importCollections(File csvFile) throws FileNotFoundException,
			IOException, ImportCSVException, SQLException, AuthorizeException
	{
		Reader csvFileReader = new FileReader(csvFile);
		List<CSVRecord> records = CSVFormat.DEFAULT.
				withFirstRecordAsHeader().parse(csvFileReader).getRecords();
		// validation pass, we don't want partial imports, so have to verify
		// all the information is valid before we try to do the actual imports
		int lineNum = 1; // assuming we're past first line, as that's header
		for (CSVRecord record : records)
		{
			lineNum++;
			verifyCollectionHeadersExists(record, lineNum);
			if (!record.isConsistent())
			{
				throw new ImportCSVException("Unexpected data column found at "+
					"line " + lineNum + ". " +
					"Check if there are extra/missing headers or columns. " +
					"Additional Debug: " + record.toString());
			}
			verifyCollectionRequiredFieldsNotEmpty(record, lineNum);
			String communityName = record.get(COMMUNITY_NAME_HEADER);
			if (!communitiesByName.containsKey(communityName))
			{
				throw new ImportCSVException("Community '" + communityName +
						"' does not exist, line " + lineNum);
			}
			log.debug("done validation: " + record.get(COMMUNITY_NAME_HEADER));
			createCollection(record);
		}
		log.debug("trying actual collection creation");
		for (CSVRecord record : records)
		{
		}
		// just calling update on community isn't enough, looks like
		// we need to explicitly commit to database.
		context.commit();
	}

	private void createCollection(CSVRecord record)
			throws SQLException, AuthorizeException, ImportCSVException
	{
		String communityName = record.get(COMMUNITY_NAME_HEADER).trim();
		String collectionName = record.get(COLLECTION_NAME_HEADER).trim();
		Community community = communitiesByName.get(communityName);
		// don't create duplicate collections, modify existing collections if
		// they exist.
		Collection[] collections = community.getCollections();
		Collection collection = null;
		for (Collection c : collections)
		{
			if (c.getName().equals(collectionName))
			{
				log.debug("Existing Collection Found");
				collection = c;
			}
		}
		if (collection == null)
		{
			log.debug("Create new collection");
			collection = community.createCollection();
		}
		// configure the collection's basic metadata
		collection.setMetadata("name", collectionName);
		collection.setMetadata(Collection.SHORT_DESCRIPTION,
				record.get(COLLECTION_DESC_HEADER));
		collection.setMetadata(Collection.INTRODUCTORY_TEXT,
				record.get(COLLECTION_INTRO_HEADER));
		collection.setMetadata(Collection.SIDEBAR_TEXT,
				record.get(COLLECTION_SIDEBAR_HEADER));
		collection.setMetadata(Collection.COPYRIGHT_TEXT,
				record.get(COLLECTION_COPYRIGHT_HEADER));
		collection.setMetadata(Collection.PROVENANCE_TEXT,
				record.get(COLLECTION_PROVENANCE_HEADER));
		String license = record.get(COLLECTION_LICENCE_HEADER);
		if (!StringUtils.isEmpty(license))
		{
			collection.setLicense(license);
		}

		setCollectionSubmissionDefaultMetadata(record, collection);
		setWorkflowSteps(record, collection);
		// Configure groups allowed to submit and groups that are admin
		setGroupsCanSubmit(
			record.get(COLLECTION_GROUPS_AUTHORIZED_TO_SUBMIT_HEADER).trim(),
			collection);
		setGroupsCanAdmin(record.get(COLLECTION_GROUPS_ADMIN_HEADER).trim(),
			collection);

		collection.update();
	}

	/**
	 * Configure the given list of groups to be able to submit to this
	 * collection.
	 * @param groupsList
	 * @param collection
	 * @throws SQLException
	 * @throws AuthorizeException
	 * @throws ImportCSVException 
	 */
	private void setGroupsCanSubmit(String groupsList, Collection collection)
			throws SQLException, AuthorizeException, ImportCSVException
	{
		if (groupsList.isEmpty())
		{ // no groups that can submit, so remove existing groups if they exist
			Group group = collection.getSubmitters();
			if (group != null)
			{
				collection.removeSubmitters();
				collection.update();
				group.delete();
				group.update();
			}
		}
		else
		{
			addGroupNamesToGroup(groupsList,collection.createSubmitters());
		}
	}

	/**
	 * Configure the given list of groups to be able to admin this collection.
	 * This shares the exact same logic flow as setGroupsCanSubmit, but because
	 * it deals with admins, it has to call a different set of methods. Makes
	 * me wish Java has first class functions so I can dedup this.
	 * @param groupsList
	 * @param collection
	 * @throws SQLException
	 * @throws AuthorizeException
	 * @throws ImportCSVException 
	 */
	private void setGroupsCanAdmin(String groupsList, Collection collection)
			throws SQLException, AuthorizeException, ImportCSVException
	{
		if (groupsList.isEmpty())
		{
			Group group = collection.getAdministrators();
			if (group != null)
			{
				collection.removeAdministrators();
				collection.update();
				group.delete();
				group.update();
			}
		}
		else
		{
			addGroupNamesToGroup(groupsList,collection.createAdministrators());
		}
	}

	/**
	 * Configure all 3 of the workflow steps for a collection.
	 * 
	 * @param record - the CSVRecord of this collection
	 * @param collection - the collection being modified
	 * @throws SQLException
	 * @throws AuthorizeException
	 * @throws ImportCSVException 
	 */
	private void setWorkflowSteps(CSVRecord record, Collection collection)
			throws SQLException, AuthorizeException, ImportCSVException
	{
		setWorkflowStep(
			record.get(COLLECTION_ENABLE_ACCEPT_REJECT_STEP_HEADER).trim(),
			1, collection);
		setWorkflowStep(
			record.get(COLLECTION_ENABLE_ACCEPT_REJECT_EDIT_STEP_HEADER).trim(),
			2, collection);
		setWorkflowStep(
			record.get(COLLECTION_ENABLE_EDIT_STEP_HEADER).trim(),
			3, collection);
	}

	/**
	 * Turn a collection's workflow on or off, if on, also adds the groups 
	 * responsible for that particular workflow step.
	 * 
	 * @param workflowVal - the CSV value for this workflow field
	 * @param workflowType - a number 1-3 indicating which workflow type
	 * @param collection - the collection we're modifying
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	private void setWorkflowStep(String workflowVal, int workflowType,
			Collection collection)
			throws SQLException, AuthorizeException, ImportCSVException
	{
		if (workflowVal.isEmpty())
		{ // no groups set, so this step should be disabled
			log.debug("No groups set");
			Group group = collection.getWorkflowGroup(workflowType);
			if (group != null)
			{ // there is an existing group that should be deleted
				log.debug("Deleting existing group");
				collection.setWorkflowGroup(workflowType, null);
				collection.update();
				group.delete();
				group.update();
			}
			return;
		}
		// step is enabled, add the groups given to the workflow
		// first retrieve the workflow group
		Group workflowGroup = collection.getWorkflowGroup(workflowType);
		if (workflowGroup == null)
		{
			workflowGroup = collection.createWorkflowGroup(workflowType);
		}
		// then add the groups given to the workflow group
		addGroupNamesToGroup(workflowVal, workflowGroup);
	}

	/**
	 * Given a list of group names and a target group, add all the groups named
	 * into the target group.
	 * @param groupNames - a list of group names
	 * @param target - the group that'll be added to
	 * @throws SQLException
	 * @throws ImportCSVException
	 * @throws AuthorizeException 
	 */
	private void addGroupNamesToGroup(String groupsList, Group target)
			throws SQLException, ImportCSVException, AuthorizeException
	{
		List<String> groupNames = Arrays.asList(groupsList.split(","));
		for (String groupName : groupNames)
		{ // will error out if the group doesn't actually exist
			Group group = Group.findByName(context, groupName.trim());
			if (group == null)
			{
				throw new ImportCSVException("Couldn't find the group named: " +
						groupName);
			}
			target.addMember(group);
		}
		target.update();
	}

	/**
	 * Submissions made to this collection will have these metadata values by
	 * default.
	 * @param record
	 * @param collection
	 * @throws SQLException
	 * @throws AuthorizeException
	 * @throws ImportCSVException 
	 */
	private void setCollectionSubmissionDefaultMetadata(CSVRecord record,
			Collection collection)
			throws SQLException, AuthorizeException, ImportCSVException
	{
		Map<String, String> mappedRecord = record.toMap();
		Map<String, String> mappedMetadata = new HashMap<String, String>();
		for (Map.Entry<String, String> entry: mappedRecord.entrySet())
		{
			String key = entry.getKey();
			String registry = "";
			if (key.startsWith(COLLECTION_DEFAULT_METADATA_HEADER_PREFIX))
			{
				log.debug("FOUND Metadata Key! " + key);
				registry = key.replaceFirst(COLLECTION_DEFAULT_METADATA_HEADER_PREFIX, "");
				registry = registry.trim();
				mappedMetadata.put(registry, entry.getValue());
				log.debug("Metadata Registry: " + registry);
			}
		}
		if (mappedMetadata.isEmpty()) return;
		// create the metadata template
		collection.createTemplateItem();
		collection.update();
		Item templateItem = collection.getTemplateItem();
		// store the metadata, deleting the old values if they existed before
		for (Map.Entry<String, String> metadata : mappedMetadata.entrySet())
		{
			String registry = metadata.getKey();
			String value = metadata.getValue();
			String schema, element, qualifier = null;
			try {
				String[] registryParts = MetadataUtilities.
						parseCompoundForm(registry);
				schema = registryParts[0];
				element = registryParts[1];
				if (registryParts.length > 2) qualifier = registryParts[2];
			} catch (ParseException ex) {
				throw new ImportCSVException("Invalid metadata registry format:"
					+ " " + registry);
			}
			templateItem.clearMetadata(schema, element, qualifier, Item.ANY);
			templateItem.addMetadata(schema, element, qualifier, Item.ANY,
					value);
		}
		try
		{
			templateItem.update();
		} catch (SQLException ex) {
			if (ex.getMessage().startsWith("Invalid metadata field"))
				throw new ImportCSVException(ex.getMessage());
			throw ex;
		}
	}

	/**
	 * Make sure that there's data in the required fields.
	 * @param record
	 * @param lineNum
	 * @throws ImportCSVException - if the required field is empty.
	 */
	private void verifyCommunityRequiredFieldsNotEmpty(CSVRecord record,
			int lineNum) throws ImportCSVException
	{
		if (record.get(COMMUNITY_NAME_HEADER).trim().isEmpty())
		{
			throw new ImportCSVException("Line " + lineNum +
				", Missing Date in Required Field: " + COMMUNITY_NAME_HEADER);
		}
	}

	/**
	 * Make sure that the headers required for communities exist.
	 * @param record
	 * @param lineNum
	 * @throws ImportCSVException - if one of the required headers is missing.
	 */
	private void verifyCommunityHeadersExists(CSVRecord record, int lineNum)
			throws ImportCSVException 
	{
		String[] headers = {
			COMMUNITY_NAME_HEADER,
			COMMUNITY_DESC_HEADER,
			COMMUNITY_INTRO_HEADER,
			COMMUNITY_COPYRIGHT_HEADER,
			COMMUNITY_SIDEBAR_HEADER
		};
		for (String header : headers)
		{
			try
			{
				record.get(header);
			}
			catch(IllegalArgumentException ex)
			{
				throw new ImportCSVException("Line " + lineNum + ", " +
						"Missing Community Header: " + header);
			}
		}
	}

	/**
	 * Create a new community into the database.
	 * @param name
	 * @param desc
	 * @param intro
	 * @param copyright
	 * @param sidebar
	 * @throws SQLException
	 * @throws AuthorizeException 
	 */
	private void createCommunity(String name, String desc, String intro,
			String copyright, String sidebar)
			throws SQLException, AuthorizeException
	{
		log.debug("------------ nothing happened?");
		if (communitiesByName.containsKey(name))
		{
			log.warn("CSV community import, duplicate community name: " + name);
			return;
		}
		log.debug("Trying to create Community");
		Community community = Community.create(null, context);
        community.setMetadata("name", name);
		community.setMetadata(Community.SHORT_DESCRIPTION, desc);
		community.setMetadata(Community.INTRODUCTORY_TEXT, intro);
		community.setMetadata(Community.COPYRIGHT_TEXT, copyright);
		community.setMetadata(Community.SIDEBAR_TEXT, sidebar);
		community.update();
	}

	private void verifyCollectionHeadersExists(CSVRecord record, int lineNum)
			throws ImportCSVException 
	{
		String[] headers = {
			COMMUNITY_NAME_HEADER,
			COLLECTION_NAME_HEADER,
			COLLECTION_DESC_HEADER,
			COLLECTION_INTRO_HEADER,
			COLLECTION_COPYRIGHT_HEADER,
			COLLECTION_SIDEBAR_HEADER,
			COLLECTION_LICENCE_HEADER,
			COLLECTION_PROVENANCE_HEADER,
			COLLECTION_ENABLE_ACCEPT_REJECT_STEP_HEADER,
			COLLECTION_ENABLE_ACCEPT_REJECT_EDIT_STEP_HEADER,
			COLLECTION_ENABLE_EDIT_STEP_HEADER,
			COLLECTION_GROUPS_AUTHORIZED_TO_SUBMIT_HEADER,
			COLLECTION_GROUPS_ADMIN_HEADER
		};
		for (String header : headers)
		{
			try
			{
				record.get(header);
			}
			catch(IllegalArgumentException ex)
			{
				throw new ImportCSVException("Line " + lineNum + ", " +
						"Missing Collection Header: " + header);
			}
		}
	}

	private void verifyCollectionRequiredFieldsNotEmpty(CSVRecord record,
			int lineNum) throws ImportCSVException
	{
		if (record.get(COMMUNITY_NAME_HEADER).trim().isEmpty())
		{
			throw new ImportCSVException("Line " + lineNum +
					", Missing Date in Required Field: " + COMMUNITY_NAME_HEADER);
		}
		else if (record.get(COLLECTION_NAME_HEADER).trim().isEmpty())
		{
			throw new ImportCSVException("Line " + lineNum +
					", Missing Date in Required Field: " + COLLECTION_NAME_HEADER);
		}
	}


}
