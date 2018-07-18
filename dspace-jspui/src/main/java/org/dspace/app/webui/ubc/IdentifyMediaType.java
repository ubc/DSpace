package org.dspace.app.webui.ubc;

import java.util.Arrays;
import java.util.Set;
import java.util.HashSet;
import org.dspace.content.Bitstream;
import org.dspace.content.BitstreamFormat;

public class IdentifyMediaType 
{
	// mimetypes set in bitstream-formats.xml
	public static final String STREAMABLE_AUDIO_MP3 = "audio/mpeg";
	public static final String STREAMABLE_AUDIO_FLAC = "audio/flac";
	public static final String STREAMABLE_AUDIO_WAV = "audio/wav";
	public static final String STREAMABLE_AUDIO_OGG = "audio/ogg";
	public static final String STREAMABLE_VIDEO_WEBM = "video/webm";
	public static final String STREAMABLE_VIDEO_MP4 = "video/mp4";
	public static final String STREAMABLE_VIDEO_OGG = "video/ogg";
	public static final String IMAGE_PNG = "image/png";
	public static final String IMAGE_GIF = "image/gif";
	public static final String IMAGE_JPEG = "image/jpeg";

	public static final Set<String> STREAMABLE_VIDEO_FORMATS = new HashSet<String>(
		Arrays.asList(
			STREAMABLE_VIDEO_WEBM,
			STREAMABLE_VIDEO_MP4,
			STREAMABLE_VIDEO_OGG
		)
	);
	public static final Set<String> STREAMABLE_AUDIO_FORMATS = new HashSet<String>(
		Arrays.asList(
			STREAMABLE_AUDIO_MP3,
			STREAMABLE_AUDIO_FLAC,
			STREAMABLE_AUDIO_WAV,
			STREAMABLE_AUDIO_OGG
		)
	);
	public static final Set<String> VIEWABLE_IMAGE_FORMATS = new HashSet<String>(
		Arrays.asList(
			IMAGE_PNG,
			IMAGE_GIF,
			IMAGE_JPEG
		)
	);

	/**
	 * Returns true if the given bitstream is a potentially HTML5 playable
	 * video file. Note the "potentially". As an example, since IE can't play
	 * webm files, but Chrome & Firefox can, this'll return true for webm files,
	 * even if the user is using IE.
	 * 
	 * There's no good browser capability checking libs on the Java side, so
	 * we're leaving that up to the Javascript side.
	 * 
	 * @param bitstream
	 * @return True if the given bitstream is in a format that one of the big
	 * browsers can play it as an HTML5 media stream
	 */
	public static boolean isStreamableVideo(Bitstream bitstream) 
	{
		BitstreamFormat format = bitstream.getFormat();
		String mime = format.getMIMEType();
		if (STREAMABLE_VIDEO_FORMATS.contains(mime))
		{
			if (mime.equals(STREAMABLE_VIDEO_MP4) &&
				!verifyStreamableMp4(bitstream))
			{
				return false;
			}
			return true;
		}
		return false;
	}

	/**
	 * Returns true if the given bitstream is a potentially HTML5 playable
	 * audio file. Note the "potentially". User browser checking too complicated
	 * on the Java side, so we're leaving it up to the Javascript side. As long
	 * as the file is in a format that's playable by one of the major browsers,
	 * this'll return true.
	 * 
	 * @param bitstream
	 * @return True if the given bitstream is in a format that one of the big
	 * browsers can play it as an HTML5 media stream.
	 */
	public static boolean isStreamableAudio(Bitstream bitstream)
	{
		BitstreamFormat format = bitstream.getFormat();
		String mime = format.getMIMEType();
		if (STREAMABLE_AUDIO_FORMATS.contains(mime))
		{
			return true;
		}
		return false;
	}

	/**
	 * Returns true if the bitstream contains an image file in a format
	 * that all major browsers can display directly.
	 * @param bitstream
	 * @return True if bitstream is an image that is viewable in a browser.
	 */
	public static boolean isViewableImage(Bitstream bitstream)
	{
		BitstreamFormat format = bitstream.getFormat();
		String mime = format.getMIMEType();
		if (VIEWABLE_IMAGE_FORMATS.contains(mime))
		{
			return true;
		}
		return false;
	}

	/**
	 * Returns true if the bitstream has been identified as an image.
	 * @param bitstream
	 * @return True if the bitstream is an image.
	 */
	public static boolean isImage(Bitstream bitstream)
	{
		BitstreamFormat format = bitstream.getFormat();
		String mime = format.getMIMEType();
		if (mime == null || mime.isEmpty()) return false;
		String header = mime.split("/")[0];
		if (header.equals("image")) return true;
		return false;
	}

	/**
	 * Returns true if the given MP4 bitstream is using codecs that are browser
	 * playable. Currently, only h264 for video and AAC for audio are 
	 * universally supported.
	 * 
	 * TODO: actually check codec support, currently just returns true for all
	 * files.
	 * 
	 * @param bitstream
	 * @return true if given MP4 is playable by browsers.
	 */
	private static boolean verifyStreamableMp4(Bitstream bitstream)
	{
		return true;
	}
}
