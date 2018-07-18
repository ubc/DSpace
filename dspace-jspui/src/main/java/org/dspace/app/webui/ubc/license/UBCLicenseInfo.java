package org.dspace.app.webui.ubc.license;

import org.dspace.app.webui.ubc.license.UBCLicenseUtil;

/**
 * Combines license information together into one class for easier use in JSPs.
 * Each object is one license.
 */
public class UBCLicenseInfo {

	private String shortName;
	private String fullName;
	private String badgeUrl;
	private String licenseUrl;

	public UBCLicenseInfo(String shortName, String fullName, String licenseUrl, String badgeUrl)
	{
		this.shortName = shortName;
		this.fullName = fullName;
		this.badgeUrl = badgeUrl;
		this.licenseUrl = licenseUrl;
	}

	public String getShortName()
	{
		return this.shortName;
	}

	public String getFullName()
	{
		return this.fullName;
	}

	public String getLicenseUrl()
	{
		return this.licenseUrl;
	}

	public String getBadgeUrl()
	{
		return this.badgeUrl;
	}

	public boolean getIsCreativeCommons()
	{
		if (shortName.substring(0,2).equalsIgnoreCase("CC"))
			return true;
		return false;
	}

	public boolean getIsPublicDomain()
	{
		if (shortName.equals(UBCLicenseUtil.PUBLIC))
			return true;
		return false;
	}
	
}
