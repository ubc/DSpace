package org.dspace.app.webui.ubc.fileupload;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.RandomAccessFile;
import javax.servlet.http.HttpServletRequest;
import org.apache.commons.fileupload.FileUploadBase.FileSizeLimitExceededException;
import org.apache.log4j.Logger;

import org.dspace.core.ConfigurationManager;

/**
 * Handles chunked uploads from flow.js. Flow.JS is the successor to
 * resumable.js used in the submission file uploader.
 */
public class FlowJSHandler
{
    private static Logger log = Logger.getLogger(FlowJSHandler.class);

	private static long MAX_FILE_SIZE = ConfigurationManager.getLongProperty("upload.max");

	public static String TMP_DIR =
		(ConfigurationManager.getProperty("upload.temp.dir") != null) ?
			ConfigurationManager.getProperty("upload.temp.dir") :
			System.getProperty("java.io.tmpdir"); 

	private HttpServletRequest request;
	private boolean isFlowJSRequest = false;
	private boolean isComplete = false;

	private int flowChunkNumber;
	private int flowChunkSize;
	private int flowTotalChunks;
	private long flowTotalSize;
	private String flowFilename;
	private String flowIdentifier;

	public FlowJSHandler(HttpServletRequest request) throws FileSizeLimitExceededException
	{
		this.request = request;
		log.debug("FlowJS Constructor flowId: " + request.getParameter("flowIdentifier"));
		if (request.getParameter("flowIdentifier") != null)
			isFlowJSRequest = true;
		if (isFlowJSRequest())
		{
			getResumableInfo();
			if (flowTotalSize > MAX_FILE_SIZE)
				throw new FileSizeLimitExceededException("File too large.",flowTotalSize, MAX_FILE_SIZE);
		}
	}

	public void processChunk() throws FileNotFoundException, IOException
	{
		if (!isFlowJSRequest()) return;
		
		String filePath = getFilePath();
		log.debug("FlowJS Process Chunk File Path: " + filePath);
		RandomAccessFile raf = new RandomAccessFile(filePath, "rw");
		//Seek to position
		raf.seek((flowChunkNumber - 1) * flowChunkSize);
		
		//Save to file
		InputStream is = request.getInputStream();
		long readed = 0;
		long content_length = request.getContentLength();
		byte[] bytes = new byte[1024 * 100];
		while(readed < content_length) {
			int r = is.read(bytes);
			if (r < 0)  {
				break;
			}
			raf.write(bytes, 0, r);
			readed += r;
		}
		raf.close();

		if (flowChunkNumber >= flowTotalChunks) isComplete = true;
	}

	public static boolean isFlowJSRequest(HttpServletRequest request)
	{
		if (request.getParameter("flowIdentifier") != null)
			return true;
		return false;
	}

	public boolean isFlowJSRequest()
	{
		return isFlowJSRequest;
	}
	
	public boolean isComplete()
	{
		return isComplete;
	}
	
	public File getFile()
	{
		File file = new File(getFilePath());
		return file;
	}

	public String getFilename()
	{
		return flowFilename;
	}

	private String getFilePath()
	{
		return TMP_DIR + File.separator + flowIdentifier;
	}

	private void getResumableInfo()
	{
		this.flowChunkNumber = Integer.parseInt(request.getParameter("flowChunkNumber"));
		this.flowChunkSize   = Integer.parseInt(request.getParameter("flowChunkSize"));
		this.flowTotalChunks = Integer.parseInt(request.getParameter("flowTotalChunks"));
		this.flowTotalSize   = Long.parseLong(request.getParameter("flowTotalSize"));
		this.flowFilename    = request.getParameter("flowFilename");
		this.flowIdentifier  = request.getParameter("flowIdentifier");
	}
	
	
}
