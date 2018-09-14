/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace.search;

/**
 *
 * @author john
 */
public class PaginationInfo {

	private String baseURL = "";
	private String firstPageURL = "";
	private String lastPageURL = "";
	private String nextPageURL = "";
	private String previousPageURL = "";
	private String skipForwardURL = "";
	private String skipBackURL = "";
	private long multiplier = 1;
	private long pageCurrent = 1;
	private long pageTotal = 1;
	private long pageRangeStart = 1;
	private long pageRangeEnd = 1;

	public void setBaseURL(String baseURL) { this.baseURL = baseURL; }
	public void setFirstPageURL(String firstPageURL) { this.firstPageURL = firstPageURL; }
	public void setLastPageURL(String lastPageURL) { this.lastPageURL = lastPageURL; }
	public void setNextPageURL(String nextPageURL) { this.nextPageURL = nextPageURL; }
	public void setPreviousPageURL(String previousPageURL) { this.previousPageURL = previousPageURL; }
	public void setSkipForwardURL(String skipForwardURL) { this.skipForwardURL = skipForwardURL; }
	public void setSkipBackURL(String skipBackURL) { this.skipBackURL = skipBackURL; }
	public void setMultiplier(long multiplier) { this.multiplier = multiplier; }
	public void setPageCurrent(long pageCurrent) { this.pageCurrent = pageCurrent; }
	public void setPageTotal(long pageTotal) { this.pageTotal = pageTotal; }
	public void setPageRangeStart(long pageRangeStart) { this.pageRangeStart = pageRangeStart; }
	public void setPageRangeEnd(long pageRangeEnd) { this.pageRangeEnd = pageRangeEnd; }
	
	public String getBaseURL() { return baseURL; }
	public String getFirstPageURL() { return firstPageURL; }
	public String getLastPageURL() { return lastPageURL; }
	public String getNextPageURL() { return nextPageURL; }
	public String getPreviousPageURL() { return previousPageURL; }
	public String getSkipForwardURL() { return skipForwardURL; }
	public String getSkipBackURL() { return skipBackURL; }
	public long getMultiplier() { return multiplier; }
	public long getPageCurrent() { return pageCurrent; }
	public long getPageTotal() { return pageTotal; }
	public long getPageRangeStart() { return pageRangeStart; }
	public long getPageRangeEnd() { return pageRangeEnd; }

}
