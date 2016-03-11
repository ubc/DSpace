CREATE SCHEMA StatSpace;

CREATE SEQUENCE StatSpace.evaluation_seq;

CREATE TABLE StatSpace.Evaluation
(
    evaluation_id INTEGER PRIMARY KEY,
    eperson_id    INTEGER REFERENCES EPerson(eperson_id),
    item_id       INTEGER REFERENCES Item(item_id),
    created       TIMESTAMP,
    text_value    TEXT
);

CREATE index evaluation_author on StatSpace.Evaluation(eperson_id);
CREATE index evaluation_item on StatSpace.Evaluation(item_id);
