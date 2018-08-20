/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package org.dspace.app.webui.ubc.scheduler;

import java.io.IOException;
import java.sql.SQLException;
import org.apache.log4j.Logger;
import org.dspace.app.webui.ubc.packager.ItemPackager;
import org.dspace.authorize.AuthorizeException;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

/**
 *
 * @author john
 */
public class GenerateItemPackagerJob implements Job
{
	
	private final static Logger log = Logger.getLogger(GenerateItemPackagerJob.class);

	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException 
	{
		log.debug("Scheduled Job: Generating Item Zip Packages");
		try {
			ItemPackager itemPackager = new ItemPackager();
			itemPackager.packageAllItems();
		} catch (SQLException | IOException | AuthorizeException ex) {
			log.error(ex);
		}
	}
}
