/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.scheduler;

import java.io.IOException;
import java.sql.SQLException;
import org.apache.log4j.Logger;
import org.dspace.discovery.IndexingService;
import org.dspace.storage.rdbms.DatabaseRegistryUpdater;
import org.dspace.utils.DSpace;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 * Update DSpace configuration changes, these tasks only has to run once on startup.
 * You'd usually run these using the dspace command line tool, but since we don't
 * have access to that, we're running them as a startup task using quartz. There's
 * currently two tasks:
 * 1. Update the registry entries from reading the registry xml config files.
 * 2. Update the solr index after discovery.xml changes.
 */
public class StartupJob implements Job {

	private final static Logger log = Logger.getLogger(GenerateThumbnailJob.class);

	/**
	 * Rebuild the Solr index from scratch.
	 * @param jec
	 * @throws JobExecutionException 
	 */
	@Override
	public void execute(JobExecutionContext jec) throws JobExecutionException {
		updateRegistry();
		updateSolrIndex();
	}

	private void updateSolrIndex() {
		log.info("Updating Solr index.");
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

	private void updateRegistry() {
		log.info("Updating registry database.");
		DatabaseRegistryUpdater registryUpdater = new DatabaseRegistryUpdater();
		registryUpdater.updateRegistries();
	}
	
}
