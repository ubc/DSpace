package org.dspace.app.webui.ubc.packager;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.apache.log4j.Logger;
import org.dspace.app.itemexport.ItemExport;
import org.dspace.app.webui.servlet.DSpaceServlet;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Item;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.core.Utils;
import org.dspace.ubc.UBCAccessChecker;
/**
 * Serves zip package files for download to users.
 * Depending on the user permission, the servlet will serve either restricted or
 * unrestricted packages. Restricted packages includes files that were marked
 * as instructor-only.
 */
public class ItemZipPackageServlet extends DSpaceServlet {
	/** log4j category */
	private static Logger log = Logger.getLogger(ItemZipPackageServlet.class);

	@Override
	protected void doDSGet(Context context, HttpServletRequest request,
			HttpServletResponse response) throws ServletException, IOException,
			SQLException, AuthorizeException 
	{
		String itemIDStr = request.getPathInfo().substring(
				request.getPathInfo().lastIndexOf('/')+1);
		int itemID;
		try 
		{
			itemID = Integer.parseInt(itemIDStr);
		} catch (NumberFormatException ex) 
		{ // couldn't parse the ID string as an int
			JSPManager.showInvalidIDError(request, response, itemIDStr,
					Constants.ITEM);
			return;
		}

		Item item = Item.find(context, itemID);
		if (item == null)
		{ // couldn't find the item with the id given
			JSPManager.showInvalidIDError(request, response, itemIDStr,
					Constants.ITEM);
			return;
		}

		// only give the user access to restricted files if they have permission
		UBCAccessChecker accessChecker = new UBCAccessChecker(context);
		File zipPackage = new File(ItemPackager.getUnrestrictedPackageFilePath(item));
		if (accessChecker.hasRestrictedAccess())
			zipPackage = new File(ItemPackager.getRestrictedPackageFilePath(item));

		if (!zipPackage.exists())
		{
			log.error("User requested a zip package that hasn't been generated yet: " + zipPackage.getAbsolutePath());
			JSPManager.showJSP(request, response, "/ubc/error/package-not-generated.jsp");
			return;
		}

		InputStream exportStream = new FileInputStream(zipPackage);

		long lastModified = zipPackage.lastModified();
		response.setDateHeader("Last-Modified", lastModified);
		// Check for if-modified-since header
		long modSince = request.getDateHeader("If-Modified-Since");
		if (modSince != -1 && lastModified < modSince)
		{
			// Item has not been modified since requested date,
			// hence bitstream has not; return 304
			response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
			return;
		}

		// Set the response MIME type
		response.setContentType(ItemExport.COMPRESSED_EXPORT_MIME_TYPE);
		// Response length
		long size = zipPackage.length();
		response.setHeader("Content-Length", String.valueOf(size));
		// Properly specify the filename to browsers
		UIUtil.setBitstreamDisposition(zipPackage.getName(), request, response); 
		// Actually send the file
		Utils.bufferedCopy(exportStream, response.getOutputStream());
		// Cleanup
		exportStream.close();
		response.getOutputStream().flush();
	}
}
