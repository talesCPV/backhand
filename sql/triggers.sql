
/* DELETE ATIVIDADES/SETS */

-- DROP TRIGGER tr_delAllSets;
DELIMITER $$

	CREATE TRIGGER tr_delAllSets AFTER DELETE 
    ON tb_atividades
    FOR EACH ROW 
	BEGIN
        DELETE FROM tb_sets WHERE id_atividade = OLD.id;
        DELETE FROM tb_ativ_atleta WHERE id_ativ = OLD.id;
    END$$;
        
DELIMITER ;    

