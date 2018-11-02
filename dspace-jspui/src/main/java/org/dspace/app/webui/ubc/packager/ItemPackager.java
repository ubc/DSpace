package org.dspace.app.webui.ubc.packager;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.FileSystemException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;
import org.apache.commons.lang.StringUtils;
import org.dspace.content.Bundle;
import org.apache.log4j.Logger;
import org.dspace.app.webui.ubc.retriever.ItemMetadataRetriever;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Bitstream;
import org.dspace.content.Collection;
import org.dspace.content.DCDate;
import org.dspace.content.Item;
import org.dspace.content.ItemIterator;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Context;
import org.dspace.core.Utils;
import org.dspace.ubc.UBCAccessChecker;

/**
 * Package all files in a resource item into a zip file for easy download.
 * Each resource item can have multiple files, instead of having the users click
 * on download for each file, it'd be nice if they can download all the files
 * together in a zip package in one go. It looks like there's an "Export Item"
 * feature in DSpace already, however, that feature is only enabled for admins.
 * It also looks like the stock export is user specific, you can only download
 * items you've exported yourself. Also, a new export zip is generated each time
 * you click on the export for some reason.
 *
 * Started out trying use the original ItemExport where possible, but quickly
 * encountered undesired behaviour, so I've just brought in customized versions
 * of the code in ItemExport. E.g.: Original ItemExport will also export
 * thumbnails, but we're only interested in the original files.
 *
 * The goal is to run the package generation as a Quartz job, periodically
 * generating/updating packages for items when necessary. The generated zip
 * packages will be accessible by all users.
 *
 * File names presented to the user will have the item title. For internal use,
 * the package name must also have the item id. We can check file modified date
 * and compare it to the date that the item was last updated to see if we need
 * to update a package.
 * 
 * Each item will have 2 packages. One with restricted files included and one 
 * without. The package with restricted files will have an "r" suffix. The
 * package with only unrestricted files will have an "u" suffix.
 *
 */
public class ItemPackager
{
	private static Logger log = Logger.getLogger(ItemPackager.class);
	
	public static final String CONTENT_FILENAME = "contents.txt";
	public static final String DOWNLOAD_DIR = ConfigurationManager
			.getProperty("org.dspace.app.itemexport.download.dir") +
			File.separator + "all" + File.separator;
	
	private Context context;
	
	public ItemPackager() throws SQLException
	{
		// create a new dspace context
		Context context = new Context();
		// ignore auths as we need access to all files
		context.turnOffAuthorisationSystem();
		this.context = context;
	}

	public void close()
	{
		try {
			context.complete();
		} catch (SQLException ex) {
			log.error(ex);
		}
	}

	/**
	 * Returns the full path to the item's zip package on the filesystem,
	 * you should make sure the user can access restricted files before offering
	 * them this package.
	 * @param item
	 * @return
	 */
	public static String getRestrictedPackageFilePath(Item item)
	{
		return DOWNLOAD_DIR + getRestrictedPackageFileName(item);
	}
	
	/**
	 * Returns the full path to the item's zip package on the filesystem,
	 * this package only contains files open to everyone.
	 * @param item
	 * @return
	 */
	public static String getUnrestrictedPackageFilePath(Item item)
	{
		return DOWNLOAD_DIR + getUnrestrictedPackageFileName(item);
	}
	/**
	 * Given an item, return the filename of the generated package file, this
	 * package will contain files that requires restricted access permissions.
	 * The filename consists of the item title and the item id. This will
	 * sanitize the title to remove illegal file name characters (windows).
	 * @param item
	 * @return
	 */
	public static String getRestrictedPackageFileName(Item item)
	{
		String name = item.getName() + " - " + item.getHandle() + "r" + ".zip";
		return sanitizeFileName(name);
	}
	
	/**
	 * Given an item, return the filename of the generated package file, this
	 * package will only contain files that is open to everyone.
	 * The filename consists of the item title and the item id. This will
	 * sanitize the title to remove illegal file name characters (windows).
	 * @param item
	 * @return
	 */
	public static String getUnrestrictedPackageFileName(Item item)
	{
		String name = item.getName() + " - " + item.getHandle() + "u" + ".zip";
		return sanitizeFileName(name);
	}
	
	/**
	 * Go through all items in the repo and generate packages for them if necessary.
	 * @param item
	 */
	public void packageAllItems() throws SQLException, IOException, AuthorizeException
	{
		Collection[] collections = Collection.findAll(context);
		for (Collection collection : collections)
		{
			ItemIterator items = collection.getItems();
			while (items.hasNext())
			{
				Item item = items.next();
				packageItem(item);
			}
		}
	}
	
	/**
	 * Given an item, package up all uploaded files in that item together into
	 * a zip file.
	 * @param item
	 * @throws IOException
	 * @throws SQLException
	 * @throws AuthorizeException
	 */
	public void packageItem(Item item)
			throws IOException, SQLException, AuthorizeException
	{
		// temporary directory to hold all the files for zipping
		File workDir = new File(DOWNLOAD_DIR + File.separator + item.getID());
		// the actual zip file we'll keep
		File restrictedPackageFile = new File(DOWNLOAD_DIR, getRestrictedPackageFileName(item));
		File unrestrictedPackageFile = new File(DOWNLOAD_DIR, getUnrestrictedPackageFileName(item));
		// remove existing working dir holding the tmp files for zipping
		if (workDir.exists())
		{
			deleteDirectory(workDir);
		}
		// check if existing package zip file needs to be updated
		if (restrictedPackageFile.exists() && unrestrictedPackageFile.exists());
		{
			if (!needsUpdate(item, restrictedPackageFile)) return;
		}
		// create the working directory
		workDir.mkdirs();
		// sort files into restricted and unrestricted
		List<Bitstream> restrictedBitstreams = new ArrayList<Bitstream>();
		List<Bitstream> unrestrictedBitstreams = new ArrayList<Bitstream>();
		
		Bundle[] bundles = item.getBundles("ORIGINAL"); // don't want thumbnails and other crap
		for (Bundle bundle : bundles)
		{
			Bitstream[] bitstreams = bundle.getBitstreams();
			for (Bitstream bitstream : bitstreams)
			{
				if (UBCAccessChecker.isRestricted(item, bitstream))
					restrictedBitstreams.add(bitstream);
				else
					unrestrictedBitstreams.add(bitstream);
			}
		}
		// copy unrestricted files in item into working directory
		writeBitstreams(item, unrestrictedBitstreams, workDir);
		// zip up files in the working directory
		try {
			zip(workDir.getAbsolutePath(), unrestrictedPackageFile.getAbsolutePath());
			// now also copy the restricted files into the working directory
			writeBitstreams(item, restrictedBitstreams, workDir);
			zip(workDir.getAbsolutePath(), restrictedPackageFile.getAbsolutePath());
			deleteDirectory(workDir);
		} catch (Exception ex) {
			log.error(ex);
			throw new FileSystemException("Cannot create package in " + restrictedPackageFile.getAbsolutePath());
		}
	}
	
	/**
	 * Check if we need to update packages because the submission has been updated.
	 * @param item
	 * @param file
	 * @return
	 */
	private boolean needsUpdate(Item item, File file)
	{
		ItemMetadataRetriever itemMetadataRetriever = new ItemMetadataRetriever(item);
		String submittedTimeStr =  itemMetadataRetriever.getField("dc.date.submitted").getValue();
		long submittedTime = (new Date()).getTime();
		if (submittedTimeStr.isEmpty())
		{ // no submitted time means this was submitted before that feature was added
			// so we can assume there's been no changes, otherwise it'd have an submitted time
			return false;
		}
		else
		{
			DCDate dcDate = new DCDate(submittedTimeStr);
			submittedTime = dcDate.toDate().getTime();
		}
		if (file.lastModified() > submittedTime)
		{ // no need to update, package file created after the submit time
			return false;
		}
		return true;
	}
	
	/**
	 * Copy the given bitstreams to the given destination directory.
	 */
	private static void writeBitstreams(Item item, List<Bitstream> bitstreams, File destDir)
			throws IOException, SQLException, AuthorizeException
	{
		File outFile = new File(destDir, CONTENT_FILENAME);
		
		if (!outFile.exists() && !outFile.createNewFile())
		{
			throw new FileSystemException("Cannot create contents in " + destDir);
		}
		PrintWriter out = new PrintWriter(new FileWriter(outFile));
		out.println(item.getName() + " -- List of Files");
		out.println();
		
		for (Bitstream bitstream : bitstreams)
		{
			String myName = bitstream.getName();
			String oldName = myName;
			
			InputStream is;
			try
			{
				is = bitstream.retrieve();
			} catch (FileNotFoundException ex)
			{
				log.debug("Somebody deleted an uploaded file?!");
				log.error(ex);
				continue;
			}
			
			if (myName.contains(File.separator))
			{
				String dirs = myName.substring(0, myName
						.lastIndexOf(File.separator));
				File fdirs = new File(destDir + File.separator
						+ dirs);
				if (!fdirs.exists() && !fdirs.mkdirs())
				{
					log.error("Unable to create destination directory");
					throw new FileSystemException("Cannot create directory " + fdirs.getAbsolutePath());
				}
			}
			
			// if there's already an existing file with the name name,
			// disambiguate them by numbering with a prefix
			int myPrefix = 1; // only used with name conflict
			File fout = new File(destDir, myName);
			while (fout.exists())
			{
				myName = myPrefix + "_" + oldName;
				myPrefix++;
				fout = new File(destDir, myName);
			}
			
			if (!fout.createNewFile())
			{
				throw new FileSystemException("Cannot create file " + fout.getAbsolutePath());
			}
			
			// make a copy of the file to the given destDir
			FileOutputStream fos = new FileOutputStream(fout);
			Utils.bufferedCopy(is, fos);
			// close streams
			is.close();
			fos.close();
			
			// write file name and description to contents.txt
			out.println(myName);
			if (!StringUtils.isEmpty(bitstream.getDescription()))
			{
				out.println(bitstream.getDescription());
			}
			out.println();
		}
		// close the contents file
		out.close();
	}
	
	/**
	 * Remove file name characters that are illegal in windows.
	 * @param name
	 * @return
	 */
	private static String sanitizeFileName(String name)
	{
		name = name.replaceAll("[\\\\/:*?\"<>|]", "_");
		return name;
	}
	
	/** Copied from ItemExport, the only change being that it doesn't delete
	 * the source directory zipping the file.
	 *
	 * @param strSource
	 * @param target
	 * @throws Exception
	 */
	public static void zip(String strSource, String target) throws Exception
	{
		ZipOutputStream cpZipOutputStream = null;
		String tempFileName = target + "_tmp";
		try
		{
			File cpFile = new File(strSource);
			if (!cpFile.isFile() && !cpFile.isDirectory())
			{
				return;
			}
			File targetFile = new File(tempFileName);
			if (!targetFile.createNewFile())
			{
				log.warn("Target file already exists: " + targetFile.getName());
			}
			
			FileOutputStream fos = new FileOutputStream(tempFileName);
			cpZipOutputStream = new ZipOutputStream(fos);
			cpZipOutputStream.setLevel(9);
			zipFiles(cpFile, strSource, tempFileName, cpZipOutputStream);
			cpZipOutputStream.finish();
			cpZipOutputStream.close();
			cpZipOutputStream = null;
			
			// Fix issue on Windows with stale file handles open before trying to delete them
			System.gc();
			
			if (!targetFile.renameTo(new File(target)))
			{
				log.error("Unable to rename file");
			}
		}
		finally
		{
			if (cpZipOutputStream != null)
			{
				cpZipOutputStream.close();
			}
		}
	}
	
	/** Copied from ItemExport **/
	private static void zipFiles(File cpFile, String strSource,
			String strTarget, ZipOutputStream cpZipOutputStream)
			throws Exception
	{
		int byteCount;
		final int DATA_BLOCK_SIZE = 2048;
		FileInputStream cpFileInputStream = null;
		if (cpFile.isDirectory())
		{
			File[] fList = cpFile.listFiles();
			for (int i = 0; i < fList.length; i++)
			{
				zipFiles(fList[i], strSource, strTarget, cpZipOutputStream);
			}
		}
		else
		{
			try
			{
				if (cpFile.getAbsolutePath().equalsIgnoreCase(strTarget))
				{
					return;
				}
				String strAbsPath = cpFile.getPath();
				String strZipEntryName = strAbsPath.substring(strSource
						.length() + 1, strAbsPath.length());
				
				// byte[] b = new byte[ (int)(cpFile.length()) ];
				
				cpFileInputStream = new FileInputStream(cpFile);
				
				ZipEntry cpZipEntry = new ZipEntry(strZipEntryName);
				cpZipOutputStream.putNextEntry(cpZipEntry);
				
				byte[] b = new byte[DATA_BLOCK_SIZE];
				while ((byteCount = cpFileInputStream.read(b, 0,
						DATA_BLOCK_SIZE)) != -1)
				{
					cpZipOutputStream.write(b, 0, byteCount);
				}
				
				// cpZipOutputStream.write(b, 0, (int)cpFile.length());
			}
			finally
			{
				if (cpFileInputStream != null)
				{
					cpFileInputStream.close();
				}
				cpZipOutputStream.closeEntry();
			}
		}
	}
	
	/** Copied from ItemExport **/
	private static boolean deleteDirectory(File path)
	{
		if (path.exists())
		{
			File[] files = path.listFiles();
			for (int i = 0; i < files.length; i++)
			{
				if (files[i].isDirectory())
				{
					deleteDirectory(files[i]);
				}
				else
				{
					if (!files[i].delete())
					{
						log.error("Unable to delete file: " + files[i].getName());
					}
				}
			}
		}
		
		boolean pathDeleted = path.delete();
		return (pathDeleted);
	}
	
}
