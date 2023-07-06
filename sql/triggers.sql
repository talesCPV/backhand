
/* DELETE ATIVIDADES/SETS */

DELIMITER $$

	CREATE TRIGGER delAllSets AFTER DELETE 
    ON tb_atividades
    FOR EACH ROW 
	BEGIN
        DELETE FROM tb_sets WHERE id_atividade = OLD.id;
    END$$;
        
DELIMITER ;    