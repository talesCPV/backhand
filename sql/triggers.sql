
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

-- DROP TRIGGER tr_delEquip;
DELIMITER $$
	CREATE TRIGGER tr_delEquip AFTER DELETE 
    ON tb_equip
    FOR EACH ROW 
	BEGIN
        DELETE FROM tb_equip_manut WHERE id_equip = OLD.id;
    END$$;        
DELIMITER ;    

-- DROP TRIGGER tr_delTorn;
DELIMITER $$
	CREATE TRIGGER tr_delTorn AFTER DELETE 
    ON tb_torneio
    FOR EACH ROW 
	BEGIN
        DELETE FROM tb_jogo WHERE id_torn = OLD.id;
    END$$;        
DELIMITER ;  
