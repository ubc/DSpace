package org.dspace.app.webui.ubc.scheduler;

import java.sql.SQLException;
import java.util.logging.Level;
import org.apache.log4j.Logger;
import org.dspace.app.mediafilter.MediaFilterManager;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

public class GenerateThumbnailJob implements Job {
	
	private final static Logger log = Logger.getLogger(GenerateThumbnailJob.class);
	
	@Override
	public void execute(JobExecutionContext context) throws JobExecutionException {
		try {
			org.dspace.core.Context dspaceContext = new org.dspace.core.Context();
			String[] argv = {};
			MediaFilterManager.runFilter(argv);
		} catch (SQLException ex) {
			log.error(ex);
		} catch (Exception ex) {
			log.error(ex);
		}
	}

}