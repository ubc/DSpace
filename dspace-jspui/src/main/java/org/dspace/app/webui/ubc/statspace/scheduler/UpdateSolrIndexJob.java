/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.statspace.scheduler;

import java.io.IOException;
import java.sql.SQLException;
import java.util.logging.Level;
import org.apache.log4j.Logger;
import org.dspace.discovery.IndexingService;
import org.dspace.utils.DSpace;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 *
 */
public class UpdateSolrIndexJob implements Job {

	private final static Logger log = Logger.getLogger(GenerateThumbnailJob.class);

	/**
	 * Rebuild the Solr index from scratch.
	 * @param jec
	 * @throws JobExecutionException 
	 */
	@Override
	public void execute(JobExecutionContext jec) throws JobExecutionException {
		log.info("(Re)building index from scratch.");
        DSpace dspace = new DSpace();
        IndexingService indexer = dspace.getServiceManager().getServiceByName(IndexingService.class.getName(),IndexingService.class);
		try {
			org.dspace.core.Context dspaceContext = new org.dspace.core.Context();
			indexer.createIndex(dspaceContext);
		} catch (SQLException ex) {
			log.error(ex);
		} catch (IOException ex) {
			log.error(ex);
		}
	}
	
}
