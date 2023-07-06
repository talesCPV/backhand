
DELIMITER $$
DROP TRIGGER tb_sets.addParent $$
CREATE
    TRIGGER tb_sets.addParent BEFORE INSERT
    ON `database_name `.`child_table`
    FOR EACH ROW BEGIN
    DECLARE last_id int;
    INSERT INTO  `database_name`.`parent_table`(id) VALUES (0);

    SET NEW.parent_id = LAST_INSERT_ID();
END $$
DELIMITER;