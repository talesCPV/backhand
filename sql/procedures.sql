/**
DROP PROCEDURE distance;
DELIMITER $$

	CREATE PROCEDURE distance(IN lat1 DOUBLE, IN lng1 DOUBLE, IN lat2 DOUBLE,IN lng2 DOUBLE)
	BEGIN

		SELECT ROUND(6371 *
        acos(
            cos(radians(lat1)) *
            cos(radians(lat2)) *
            cos(radians(lng1) - radians(lng2)) +
            sin(radians(lat1)) *
            sin(radians(lat2))
        ),3) AS distance;
			
	END $$
DELIMITER ;

CALL distance(-23.01491109452432,-45.564878769127105,-23.5,-45.5);
*/

/*  USUARIO  */

-- DROP PROCEDURE sp_insertUsuario;
DELIMITER $$
	CREATE PROCEDURE sp_insertUsuario(
		IN Iid int(11) ,
		IN Iemail varchar(70),
		IN Ihash varchar(77),
		IN Inome varchar(60),
		IN Inick varchar(15),
		IN Icel varchar(14),
		IN Iclass int(11),
		IN Ilat double,
		IN Ilng double
    )
	BEGIN			            
		INSERT INTO tb_usuario (id,email,hash,nome,nick,cel,class,lat,lng) 
		VALUES (Iid,Iemail,Ihash,Inome,Inick,Icel,Iclass,Ilat,Ilng)
		ON DUPLICATE KEY 
        UPDATE email=Iemail, hash=Ihash, nome=Inome, nick=Inick, cel=Icel, class=Iclass, lat=Ilat, lng=Ilng ;                                    
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_delUsuario;
DELIMITER $$
	CREATE PROCEDURE sp_delUsuario(
		IN Iid int(11) 
    )
	BEGIN			            
		DELETE FROM tb_usuario WHERE id=Iid;                                    
	END $$
DELIMITER ;


/* QUADRA */


-- DROP PROCEDURE sp_insertQuadra;
DELIMITER $$
	CREATE PROCEDURE sp_insertQuadra(
		IN Iid int(11),
		IN Inome varchar(30),
		IN Ilat double,
		IN Ilng double,
		IN Itipo varchar(10) 
    )
	BEGIN			            
		INSERT INTO tb_quadra (id,nome,lat,lng,tipo)
        VALUES (Iid,Inome,Ilat,Ilng,Itipo)
        ON DUPLICATE KEY 
        UPDATE nome=Inome, lat=Ilat, lng=Ilng, tipo=Itipo;        
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_delQuadra;
DELIMITER $$
	CREATE PROCEDURE sp_delQuadra(
		IN Iid int(11) 
    )
	BEGIN			            
		DELETE FROM tb_quadra WHERE id=Iid;                                    
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_insertMinhasQuadras;
DELIMITER $$
	CREATE PROCEDURE sp_insertMinhasQuadras(
		IN Iid_usuario int(11),
		IN Iid_quadra int(11)
    )
	BEGIN			            
		INSERT INTO tb_minhasquadras (id_usuario,id_quadra)
        VALUES (Iid_usuario,Iid_quadra);
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_delMinhasQuadras;
DELIMITER $$
	CREATE PROCEDURE sp_delMinhasQuadras(
		IN Iid_usuario int(11),
		IN Iid_quadra int(11)
    )
	BEGIN			            
		DELETE FROM tb_minhasquadras WHERE id_usuario=Iid_usuario AND id_quadra=Iid_quadra;
	END $$
DELIMITER ;

/* ATIVIDADES */

-- DROP PROCEDURE sp_insertAtividades;
DELIMITER $$
	CREATE PROCEDURE sp_insertAtividades(
		IN Iid int(11),
		IN Iid_usuario int(11),
		IN Inome varchar(30),
		IN Iid_sport int(11),
		IN Iid_evento int(11),
		IN Iparceiro varchar(30),
		IN Idia datetime,
		IN Iduracao DOUBLE,
		IN Iid_quadra int(11)
    )
	BEGIN			            
		INSERT INTO tb_atividades (id,id_usuario,nome,id_sport,id_evento,parceiro,dia,duracao,id_quadra)
        VALUES (Iid,Iid_usuario,Inome,Iid_sport,Iid_evento,Iparceiro,Idia,Iduracao,Iid_quadra)
		ON DUPLICATE KEY 
        UPDATE nome="x02", id_sport="x03", id_evento="x04", parceiro="x05", dia="x06", duracao="x07", id_quadra="x08";	END $$
DELIMITER ;

-- DROP PROCEDURE sp_delAtividades;
DELIMITER $$
	CREATE PROCEDURE sp_delAtividades(
		IN Iid int(11) 
    )
	BEGIN			            
		DELETE FROM tb_atividades WHERE id=Iid;                                    
	END $$
DELIMITER ;