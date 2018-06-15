/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.List;
import java.util.ArrayList;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.dspace.ubc.UBCAccessChecker;
import org.dspace.app.webui.util.JSPManager;
import org.dspace.app.webui.util.UIUtil;
import org.dspace.authorize.AuthorizeException;
import org.dspace.content.Bitstream;
import org.dspace.content.Bundle;
import org.dspace.content.DSpaceObject;
import org.dspace.content.Item;
import org.dspace.core.ConfigurationManager;
import org.dspace.core.Constants;
import org.dspace.core.Context;
import org.dspace.core.LogManager;
import org.dspace.core.Utils;
import org.dspace.handle.HandleManager;
import org.dspace.usage.UsageEvent;
import org.dspace.utils.DSpace;

/**
 * Servlet for retrieving bitstreams. The bits are simply piped to the user. If
 * there is an <code>If-Modified-Since</code> header, only a 304 status code
 * is returned if the containing item has not been modified since that date.
 * <P>
 * <code>/bitstream/handle/sequence_id/filename</code>
 * 
 * @author Robert Tansley
 * @version $Revision$
 */
public class BitstreamServlet extends DSpaceServlet
{
    /** log4j category */
    private static Logger log = Logger.getLogger(BitstreamServlet.class);

    /**
     * Threshold on Bitstream size before content-disposition will be set.
     */
    private int threshold;
    
    @Override
	public void init(ServletConfig arg0) throws ServletException {

		super.init(arg0);
		threshold = ConfigurationManager
				.getIntProperty("webui.content_disposition_threshold");
	}

    @Override
	protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
    	Item item = null;
    	Bitstream bitstream = null;

        // Get the ID from the URL
        String idString = request.getPathInfo();
        String handle = "";
        String sequenceText = "";
        String filename = null;
        int sequenceID;

        if (idString == null)
        {
            idString = "";
        }

        // Parse 'handle' and 'sequence' (bitstream seq. number) out
        // of remaining URL path, which is typically of the format:
        // {handle}/{sequence}/{bitstream-name}
        // But since the bitstream name MAY have any number of "/"s in
        // it, and the handle is guaranteed to have one slash, we
        // scan from the start to pick out handle and sequence:

        // Remove leading slash if any:
        if (idString.startsWith("/"))
        {
            idString = idString.substring(1);
        }

        // skip first slash within handle
        int slashIndex = idString.indexOf('/');
        if (slashIndex != -1)
        {
            slashIndex = idString.indexOf('/', slashIndex + 1);
            if (slashIndex != -1)
            {
                handle = idString.substring(0, slashIndex);
                int slash2 = idString.indexOf('/', slashIndex + 1);
                if (slash2 != -1)
                {
                    sequenceText = idString.substring(slashIndex+1,slash2);
                    filename = idString.substring(slash2+1);
                }
            }
        }

        try
        {
            sequenceID = Integer.parseInt(sequenceText);
        }
        catch (NumberFormatException nfe)
        {
            sequenceID = -1;
        }
        
        // Now try and retrieve the item
        DSpaceObject dso = HandleManager.resolveToObject(context, handle);
        
        // Make sure we have valid item and sequence number
        if (dso != null && dso.getType() == Constants.ITEM && sequenceID >= 0)
        {
            item = (Item) dso;
        
            if (item.isWithdrawn())
            {
                log.info(LogManager.getHeader(context, "view_bitstream",
                        "handle=" + handle + ",withdrawn=true"));
                JSPManager.showJSP(request, response, "/tombstone.jsp");
                return;
            }

            boolean found = false;

            Bundle[] bundles = item.getBundles();

            for (int i = 0; (i < bundles.length) && !found; i++)
            {
                Bitstream[] bitstreams = bundles[i].getBitstreams();

                for (int k = 0; (k < bitstreams.length) && !found; k++)
                {
                    if (sequenceID == bitstreams[k].getSequenceID())
                    {
                        bitstream = bitstreams[k];
                        found = true;
                    }
                }
            }
        }

        if (bitstream == null || filename == null
                || !filename.equals(bitstream.getName()))
        {
            // No bitstream found or filename was wrong -- ID invalid
            log.info(LogManager.getHeader(context, "invalid_id", "path="
                    + idString));
            JSPManager.showInvalidIDError(request, response, idString,
                    Constants.BITSTREAM);

            return;
        }

        log.info(LogManager.getHeader(context, "view_bitstream",
                "bitstream_id=" + bitstream.getID()));

		// check if the logged in user should have access to this file
		UBCAccessChecker accessChecker = new UBCAccessChecker(context);
		if (!accessChecker.hasFileAccess(item, bitstream)) {
            log.info(LogManager.getHeader(context, "unauthorized_access", "path="
                    + idString));
			// pretend the file doesn't exist
            JSPManager.showInvalidIDError(request, response, idString,
                    Constants.BITSTREAM);
            return;
		}
        
        //new UsageEvent().fire(request, context, AbstractUsageEvent.VIEW,
		//		Constants.BITSTREAM, bitstream.getID());

        new DSpace().getEventService().fireEvent(
        		new UsageEvent(
        				UsageEvent.Action.VIEW, 
        				request, 
        				context, 
        				bitstream));
        
		String forcedownload = request.getParameter("forcedownload");
		if (forcedownload != null)
		{
			response.setHeader ("Content-Disposition", "attachment");
		}

        
        // Modification date
        // Only use last-modified if this is an anonymous access
        // - caching content that may be generated under authorisation
        //   is a security problem
        if (context.getCurrentUser() == null)
        {
            // TODO: Currently the date of the item, since we don't have dates
            // for files
            response.setDateHeader("Last-Modified", item.getLastModified()
                    .getTime());

            // Check for if-modified-since header
            long modSince = request.getDateHeader("If-Modified-Since");

            if (modSince != -1 && item.getLastModified().getTime() < modSince)
            {
                // Item has not been modified since requested date,
                // hence bitstream has not; return 304
                response.setStatus(HttpServletResponse.SC_NOT_MODIFIED);
                return;
            }
        }
        
        // Pipe the bits
        InputStream is = bitstream.retrieve();
     
		// Set the response MIME type
        response.setContentType(bitstream.getFormat().getMIMEType());

		if(threshold != -1 && bitstream.getSize() >= threshold)
		{
			UIUtil.setBitstreamDisposition(bitstream.getName(), request, response);
		}

        //DO NOT REMOVE IT - WE NEED TO FREE DB CONNECTION TO AVOID CONNECTION POOL EXHAUSTION FOR BIG FILES AND SLOW DOWNLOADS
        context.complete();

        // Prepare some variables. The full Range represents the complete file.
        long length = bitstream.getSize();
        Range full = new Range(0, length - 1, length);
        List<Range> ranges = new ArrayList<Range>();

        // Validate and process Range and If-Range headers.
        String range = request.getHeader("Range");
        if (range != null) {

            // Range header should match format "bytes=n-n,n-n,n-n...". If not, then return 416.
            if (!range.matches("^bytes=\\d*-\\d*(,\\d*-\\d*)*$")) {
                response.setHeader("Content-Range", "bytes */" + length); // Required in 416.
                response.sendError(HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);
                return;
            }

            // If any valid If-Range header, then process each part of byte range.
            if (ranges.isEmpty()) {
                for (String part : range.substring(6).split(",")) {
                    // Assuming a file with length of 100, the following examples returns bytes at:
                    // 50-80 (50 to 80), 40- (40 to length=100), -20 (length-20=80 to length=100).
                    long start = sublong(part, 0, part.indexOf("-"));
                    long end = sublong(part, part.indexOf("-") + 1, part.length());

                    if (start == -1) {
                        start = length - end;
                        end = length - 1;
                    } else if (end == -1 || end > length - 1) {
                        end = length - 1;
                    }

                    // Check if Range is syntactically valid. If not, then return 416.
                    if (start > end) {
                        response.setHeader("Content-Range", "bytes */" + length); // Required in 416.
                        response.sendError(HttpServletResponse.SC_REQUESTED_RANGE_NOT_SATISFIABLE);
                        return;
                    }

                    // Add range.
                    ranges.add(new Range(start, end, length));
                }
            }
        }
        response.setHeader("Accept-Ranges", "bytes");

        // Send requested file (part(s)) to client ------------------------------------------------

        // Prepare streams.
        OutputStream output = null;

		// Open streams.
		output = response.getOutputStream();

		if (ranges.size() == 1 && !ranges.get(0).equals(full)) {
			log.debug("Dealing with a partial content request.");
			// Deal with a partial content request
			Range r = ranges.get(0);
			response.setHeader("Content-Length", String.valueOf(r.length));
			response.setHeader("Content-Range", "bytes " + r.start + "-" + r.end + "/" + r.total);
			response.setStatus(HttpServletResponse.SC_PARTIAL_CONTENT); // 206.
			// Copy single part range.
			int bytesRead = partialContent(is, output, r.start, r.length);

		}
		else {
			// Response length
			response.setHeader("Content-Length", String
					.valueOf(bitstream.getSize()));
			Utils.bufferedCopy(is, response.getOutputStream());

		}
        is.close();
        response.getOutputStream().flush();
    }

	/**
	 * For dealing with partial content requests, sends only parts of input to the output.
	 * @param input the input stream to read from
	 * @param output the output stream to write the contents from input to
	 * @param start the byte to start reading input at
	 * @param length the amount of bytes to read
	 * @return
	 * @throws IOException 
	 */
    private static int partialContent(InputStream input, OutputStream output, long start, long length)
		throws IOException
    {
		int bufferSize = 1024*1024; // 1 MiB of buffer
		long remaining = length;
		int totalBytesRead = 0;
		// can't put everything into the buffer all at once cause we'll run out
		// of heap space on large files, so going to read the input in small chunks
		byte[] partialContentBuffer = new byte[bufferSize];

		input.skip((int)start);

		while (remaining > 0)
		{
			int bytesRead = input.read(partialContentBuffer, 0, bufferSize);
			if (bytesRead < 0)  {
				log.error("Partial Contest Request read error");
				break;
			}
			output.write(partialContentBuffer, 0, bytesRead);
			totalBytesRead += bytesRead;
			remaining -= bytesRead;
		}
		return totalBytesRead;
    }

    /**
     * Returns a substring of the given string value from the given begin index to the given end
     * index as a long. If the substring is empty, then -1 will be returned
     * @param value The string value to return a substring as long for.
     * @param beginIndex The begin index of the substring to be returned as long.
     * @param endIndex The end index of the substring to be returned as long.
     * @return A substring of the given string value as long or -1 if substring is empty.
     */
    private static long sublong(String value, int beginIndex, int endIndex) {
        String substring = value.substring(beginIndex, endIndex);
        return (substring.length() > 0) ? Long.parseLong(substring) : -1;
    }

    /**
     * This class represents a byte range.
     */
    protected class Range {
        public long start;
        public long end;
        public long length;
        public long total;

        /**
         * Construct a byte range.
         * @param start Start of the byte range.
         * @param end End of the byte range.
         * @param total Total length of the byte source.
         */
        public Range(long start, long end, long total) {
            this.start = start;
            this.end = end;
            this.length = end - start + 1;
            this.total = total;
        }

		@Override public boolean equals(Object obj) {
			if (obj == null) return false;
			if (!Range.class.isAssignableFrom(obj.getClass())) {
				return false;
			}
			final Range other = (Range) obj;
			
			if (other.start == start &&
				other.end == end &&
				other.length == length &&
				other.total == total) {
				return true;
			}

			return false;
		}

    }
}
