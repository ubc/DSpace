package org.dspace.content;

import java.sql.SQLException;
import java.util.ArrayList;
// import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.apache.log4j.Logger;
import org.dspace.core.Context;
import org.dspace.core.LogManager;

import org.dspace.eperson.EPerson;
import org.dspace.storage.rdbms.DatabaseManager;
import org.dspace.storage.rdbms.TableRow;

public class Evaluation
{
    private final Context context;
    
    private final int id;
    private final EPerson submitter;
    private final Item item;
    private final Date submitted;
    private final String content;

    /** log4j category */
    private static final Logger log = Logger.getLogger(Evaluation.class);

    /** The table row corresponding to this evaluation */
    private final TableRow evaluationRow;
    
    
    Evaluation(Context context, TableRow row) throws SQLException {
        this.context = context;
        
        // Ensure that my TableRow is typed.
        if (null == row.getTable())
            row.setTable("statspace.evaluation");

        evaluationRow = row;

        id = evaluationRow.getIntColumn("evaluation_id");
        submitter = EPerson.find(context,
                                 evaluationRow.getIntColumn("eperson_id"));
        item = Item.find(context,
                         evaluationRow.getIntColumn("item_id"));
        submitted = evaluationRow.getDateColumn("created");
        content = evaluationRow.getStringColumn("text_value");
        
        // Cache ourselves
        context.cache(this, evaluationRow.getIntColumn("evaluation_id"));
    }

    Evaluation(Context context, TableRow row,
               EPerson submitter, Item item,
               Date submitted, String content) {
        this.context = context;
        
        // Ensure that my TableRow is typed.
        if (null == row.getTable())
            row.setTable("statspace.evaluation");

        evaluationRow = row;

        this.id = evaluationRow.getIntColumn("evaluation_id");

        this.submitter = submitter;
        evaluationRow.setColumn("eperson_id", submitter.getID());
        
        this.item = item;
        evaluationRow.setColumn("item_id", item.getID());
        
        this.submitted = submitted;
        evaluationRow.setColumn("created", submitted);
        
        this.content = content;
        evaluationRow.setColumn("text_value", content);
        
        // Cache ourselves
        context.cache(this, evaluationRow.getIntColumn("evaluation_id"));
    }

    
    private void update() throws SQLException {
        DatabaseManager.update(context, evaluationRow);
    }

    
    public static Evaluation create(Context context,
                                    EPerson submitter,
                                    Item item,
                                    String content) throws SQLException {
        TableRow row = DatabaseManager.create(context, "statspace.evaluation");
        Evaluation e = new Evaluation(context, row,
                                      submitter, item,
                                      new Date(), content);

        e.update();
        
        log.info(LogManager.getHeader(context, "create_evaluation",
                                      "evaluation_id=" + row.getIntColumn("evaluation_id")));
        return e;
    }

    
    public static Evaluation find(Context context, int id) throws SQLException {
        // First check the cache
        Evaluation fromCache = (Evaluation) context.fromCache(Evaluation.class, id);

        if (fromCache != null) {
            return fromCache;
        }

        TableRow row = DatabaseManager.find(context, "statspace.evaluation", id);

        if (row == null) {
            if (log.isDebugEnabled()) {
                log.debug(LogManager.getHeader(context, "find_evaluation",
                        "not_found,evaluation_id=" + id));
            }

            return null;
        }

        // not null, return Evaluation
        if (log.isDebugEnabled()) {
            log.debug(LogManager.getHeader(context, "find_evaluation",
                    "evaluation_id=" + id));
        }
        
        return new Evaluation(context, row);
    }

    
    public static List<Evaluation> findBySubmitter(Context context, EPerson submitter) throws SQLException {
        throw new SQLException("Unimplemented");
    }

    
    public static List<Evaluation> findByItem(Context context, Item item) throws SQLException {
        String query = "SELECT * FROM statspace.evaluation WHERE item_id = ?";
        List<TableRow> rows = DatabaseManager.queryTable(context, "statspace.evaluation", query, item.getID()).toList();

        ArrayList<Evaluation> evaluations = new ArrayList(rows.size());
        for (TableRow row : rows) {
            evaluations.add(new Evaluation(context, row));
        }
        return evaluations;
    }

    
    public static List<Evaluation> findBySubmitterItem(Context context, EPerson submitter, Item item) throws SQLException {
        throw new SQLException("Unimplemented");
    }
    
    
    /**
     * @return the internal id of this evaluation
     */
    public int getId() {
        return id;
    }
    
    
    /**
     * @return the e-person that submitted this evaluation
     */
    public EPerson getSubmitter() {
        return submitter;
    }
    
    
    /**
     * @return the item that this evaluation refers to
     */
    public Item getItem() {
        return item;
    }
    
    
    /**
     * @return the time when the evaluation was submitted
     */
    public Date getSubmitted() {
        return submitted;
    }
    
    
    /**
     * @return the content of the evaluation
     */
    public String getContent() {
        return content;
    }
}
