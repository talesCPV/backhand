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
		IN Ihash varchar(77),
		IN Iid_quadra int(11)
    )
	BEGIN			            
		DECLARE Iid_usuario INT(11);
		SET Iid_usuario = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);

		INSERT INTO tb_minhasquadras (id_usuario,id_quadra)
        VALUES (Iid_usuario,Iid_quadra);
        
        SELECT TRUE AS MYCOURT;
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_delMinhasQuadras;
DELIMITER $$
	CREATE PROCEDURE sp_delMinhasQuadras(
		IN Ihash varchar(77),
		IN Iid_quadra int(11)
    )
	BEGIN			        
		DECLARE Iid_usuario INT(11);
		SET Iid_usuario = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);

		DELETE FROM tb_minhasquadras WHERE id_usuario=Iid_usuario AND id_quadra=Iid_quadra;
        
		SELECT FALSE AS MYCOURT;

	END $$
DELIMITER ;


-- DROP PROCEDURE sp_findQuadra;
DELIMITER $$
		CREATE PROCEDURE sp_findQuadra(
        IN Ihash varchar(77),
		IN Idistance int(11),
        IN Inome varchar(30)
    )
	BEGIN	      
		DECLARE Iid_host INT(11);
        DECLARE Ilat DOUBLE;
		DECLARE Ilng DOUBLE;
		SET Iid_host = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SET Ilat = (SELECT lat FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SET Ilng = (SELECT lng FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
         
		SELECT QD.*, 
			(SELECT COUNT(*) FROM tb_minhasquadras WHERE id_quadra = QD.id AND id_usuario = Iid_host) AS MYCOURT,
			(SELECT IFNULL((SELECT fn_calcDist(Ilat,Ilng,QD.lat,QD.lng)),0)) AS DISTANCE
			FROM tb_quadra AS QD
            WHERE (SELECT IFNULL((SELECT fn_calcDist(Ilat,Ilng,QD.lat,QD.lng)),0)) < Idistance
            AND QD.nome COLLATE utf8_general_ci LIKE CONCAT("%",Inome,"%")COLLATE utf8_general_ci
            ORDER BY DISTANCE,QD.nome
            LIMIT 30;
    		
	END $$
DELIMITER ;

CALL sp_findQuadra("f'lB9$rN`<'~l<$Z<9*~rBHT$rB3`0~N?l<-Z*xH9f6'T$rB3`0~N?l<-Z*xH9f6'T$rB3`0~N?l<",100,"mil");

SELECT QD.*, 
			(SELECT COUNT(*) FROM tb_minhasquadras WHERE id_quadra = 1 AND id_usuario = 1) AS MYCOURT,
			(SELECT IFNULL((SELECT fn_calcDist("","","","")),0)) AS DISTANCE
			FROM tb_quadra AS QD
            WHERE (SELECT IFNULL((SELECT fn_calcDist("","","","")),0)) < 100
            ORDER BY DISTANCE,QD.nome
            LIMIT 30;

/* ATIVIDADES */

-- DROP PROCEDURE sp_insertAtividades;
DELIMITER $$
	CREATE PROCEDURE sp_insertAtividades(
		IN Iid int(11),
		IN Iid_usuario int(11),
		IN Inome varchar(30),
		IN Iid_sport int(11),
		IN Iid_evento int(11),
		IN Idia datetime,
		IN Iduracao DOUBLE,
		IN Iid_quadra int(11)
    )
	BEGIN			       
    
		DECLARE lastID INT(11);
    
		INSERT INTO tb_atividades (id,id_usuario,nome,id_sport,id_evento,dia,duracao,id_quadra)
        VALUES (Iid,Iid_usuario,Inome,Iid_sport,Iid_evento,Idia,Iduracao,Iid_quadra)
		ON DUPLICATE KEY 
        UPDATE nome=Inome, id_sport=Iid_sport, id_evento=Iid_evento, dia=Idia, duracao=Iduracao, id_quadra=Iid_quadra;        
		
        SET lastID = (SELECT IF(Iid="DEFAULT",LAST_INSERT_ID(),Iid));
        
		INSERT INTO tb_ativ_atleta (id_ativ,id_atleta,ativ_owner,confirm,ask)
        VALUES (lastID,Iid_usuario,TRUE,TRUE, FALSE)
		ON DUPLICATE KEY 
        UPDATE id_ativ=id_ativ;
        
        SELECT * FROM tb_atividades WHERE id = lastID;
        
	END $$
DELIMITER ;

SELECT * FROM tb_atividades;

DROP PROCEDURE sp_ativ_weigth;
DELIMITER $$
	CREATE PROCEDURE sp_ativ_weigth(
		IN Iid int(11),
		IN Ipeso DOUBLE
    )
	BEGIN
		UPDATE tb_atividades SET peso=Ipeso WHERE id=Iid;
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_AtvAtl;
DELIMITER $$
CREATE PROCEDURE sp_AtvAtl(
		IN Ihash varchar(77),
		IN IidAtv int(11), 
		IN Ifields VARCHAR(3000),
		IN Ivalues VARCHAR(3000)
    )
BEGIN    
    
		SET @call_owner = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci);
		SET @atv_owner  = (SELECT id_usuario FROM tb_atividades WHERE id COLLATE utf8_general_ci = IidAtv COLLATE utf8_general_ci);
        	
		IF (@call_owner = @atv_owner) THEN
        
            CALL sp_clearAtvAtl(IidAtv);
			
			SET @query = CONCAT('INSERT INTO tb_ativ_atleta ', Ifields, ' VALUES ', Ivalues);

			PREPARE stmt1 FROM @query;
			EXECUTE stmt1;
			DEALLOCATE PREPARE stmt1;
        
		END IF; 
    
        
        SELECT * FROM tb_ativ_atleta WHERE id_ativ=IidAtv;
        
	END $$
DELIMITER ;

 DROP PROCEDURE sp_updatePlayer;
DELIMITER $$
CREATE PROCEDURE sp_updatePlayer(
		IN Ipeso VARCHAR(10),
		IN Iplayer VARCHAR(100)
    )
	BEGIN    
    
		SET @query = CONCAT('UPDATE tb_usuario SET nivel = ROUND(nivel+', Ipeso, ',2) WHERE id IN (', Iplayer,')');

		PREPARE stmt1 FROM @query;
		EXECUTE stmt1;
		DEALLOCATE PREPARE stmt1;

        SELECT * FROM tb_usuario WHERE id IN(Iplayer);
	END $$
DELIMITER ;

CALL sp_updatePlayer(-0.1,"1,2");

CALL sp_AtvAtl(1,1,"A",TRUE);
SELECT * FROM tb_ativ_atleta;

-- DROP PROCEDURE sp_editAtvAtl;
DELIMITER $$
	CREATE PROCEDURE sp_editAtvAtl(
		IN IidAtv int(11),
		IN Ihash varchar(77),
		IN Iconfirm BOOLEAN,
		IN Iask BOOLEAN        
    )
	BEGIN			   		
		SET @IidAtl = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci);        
        UPDATE tb_ativ_atleta SET confirm=Iconfirm, ask = Iask WHERE id_ativ=IidAtv AND id_atleta=@IidAtl;  
        SET @peso = (SELECT (SUM(USR.nivel* 0.05)) 
						FROM tb_ativ_atleta AS ATV
						INNER JOIN tb_usuario AS USR
						ON ATV.id_atleta = USR.id 
						WHERE ATV.id_ativ=IidAtv);
		SET @winner = (SELECT WINNER FROM vw_winners WHERE id_ativ=IidAtv);
        SET @loser = (SELECT LOSER FROM vw_winners WHERE id_ativ=IidAtv);
        
		IF ((SELECT COUNT(*) FROM tb_ativ_atleta WHERE id_ativ=IidAtv AND ativ_owner=0 AND confirm=0)=0) THEN        
			UPDATE tb_atividades SET ranking=1, peso=@peso WHERE id=IidAtv;
            
			CALL sp_updatePlayer(@peso,@winner);
			CALL sp_updatePlayer(-@peso,@loser);
            
		ELSE
			UPDATE tb_atividades SET ranking=0 WHERE id=IidAtv; 
		END IF; 
                
        SELECT * FROM tb_ativ_atleta WHERE id_ativ=IidAtv AND id_atleta=@IidAtl;
	END $$
DELIMITER ;

CALL sp_editAtvAtl("5","p#~[#/*~[*6p?#/?iM/pT#86/[TT#p?/[*wF6b1~M=i8(T#p?/[*wF6b1~M=i8(T#p?/[*wF6b1~M",1,0);

	UPDATE tb_ativ_atleta SET confirm=0, ask=1 WHERE id_ativ=5 AND id_atleta=2;
 
	SELECT * FROM tb_ativ_atleta WHERE id_ativ=5 AND id_atleta=2;



-- DROP PROCEDURE sp_delAtividades;
DELIMITER $$
	CREATE PROCEDURE sp_delAtividades(
		IN Iid int(11) 
    )
	BEGIN		
		CALL sp_clearAtvAtl(Iid);
		DELETE FROM tb_atividades WHERE id=Iid;                                    
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_clearAtvAtl;
DELIMITER $$
	CREATE PROCEDURE sp_clearAtvAtl(
		IN IidAtv int(11)
    )
	BEGIN			   		
		DELETE FROM tb_ativ_atleta WHERE id_ativ=IidAtv;									 
	END $$
DELIMITER ;

/* SETS */
DELIMITER $$
CREATE PROCEDURE sp_sets(
		IN Ihash varchar(77),
		IN IidAtv int(11), 
		IN Ifields VARCHAR(3000),
		IN Ivalues VARCHAR(3000)
    )
BEGIN                
		SET @call_owner = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci);
		SET @atv_owner  = (SELECT id_usuario FROM tb_atividades WHERE id COLLATE utf8_general_ci = IidAtv COLLATE utf8_general_ci);
        	
		IF (@call_owner = @atv_owner) THEN
        
			DELETE FROM tb_sets WHERE id_atividade=IidAtv;
			
			SET @query = CONCAT('INSERT INTO tb_sets ', Ifields, ' VALUES ', Ivalues);

			PREPARE stmt1 FROM @query;
			EXECUTE stmt1;
			DEALLOCATE PREPARE stmt1;
			
		END IF; 

        SELECT * FROM tb_sets WHERE id_atividade=IidAtv;
        
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_insertSets;
DELIMITER $$
	CREATE PROCEDURE sp_insertSets(
		IN Iid int(11),
		IN Iid_atividade int(11), 
		IN Ip1_score int(11),
		IN Ip2_score int(11),
		IN Iobs varchar(255)
    )
	BEGIN			            
		INSERT INTO tb_sets (id,id_atividade,p1_score,p2_score,obs)
        VALUES (Iid,Iid_atividade,Ip1_score,Ip2_score,Iobs)
        ON DUPLICATE KEY
        UPDATE p1_score=Ip1_score, p2_score=Ip2_score, obs=Iobs;
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_delSets;
DELIMITER $$
	CREATE PROCEDURE sp_delSets(
		IN Iid int(11), 
        IN Iid_atividade int(11) 
    )
	BEGIN			            
		DELETE FROM tb_sets WHERE id=Iid AND id_atividade = Iid_atividade;
        CALL sp_orderSet(Iid,Iid_atividade);
	END $$
DELIMITER ;

DROP PROCEDURE sp_orderSet;

DELIMITER $$
	CREATE PROCEDURE sp_orderSet (	
		IN Iid int(11), 
        IN Iid_atividade int(11) 
		)
	BEGIN
		UPDATE tb_sets SET id = id - 1 WHERE id>Iid AND id_atividade = Iid_atividade;
	END$$
DELIMITER ;

-- CALL sp_orderSet(2);
CALL sp_insertSets("0","18","1","1","1");

/* KUDOS */

-- DROP PROCEDURE sp_kudos;
DELIMITER $$
	CREATE PROCEDURE sp_kudos(
		IN Ihash varchar(77),
		IN Iid_atividade int(11)
    )
	BEGIN	
		DECLARE Iid_usuario INT(11);
		SET Iid_usuario = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
        
		IF ((SELECT COUNT(*) FROM tb_kudos WHERE id_usuario = Iid_usuario AND id_atividade = Iid_atividade)>0) THEN
		   DELETE FROM tb_kudos WHERE id_usuario = Iid_usuario AND id_atividade = Iid_atividade ;           
		ELSE
		   INSERT INTO tb_kudos (id_usuario,id_atividade) VALUES (Iid_usuario,Iid_atividade);
		END IF;    	
        SELECT COUNT(*) AS KUDOS FROM tb_kudos WHERE id_atividade = Iid_atividade;

	END $$
DELIMITER ;


SELECT * FROM tb_kudos;
CALL sp_kudos("f'lB9$rN`<'~l<$Z<9*~rBHT$rB3`0~N?l<-Z*xH9f6'T$rB3`0~N?l<-Z*xH9f6'T$rB3`0~N?l<",22);

/* MESSAGE */

-- DROP PROCEDURE sp_message;
DELIMITER $$
	CREATE PROCEDURE sp_message (	
		IN Iid int(11), 
		IN Ihash varchar(77),
        IN Iid_atividade int(11),
        IN Iscrap varchar(600)
		)
	BEGIN
		DECLARE Iid_usuario INT(11);
		SET Iid_usuario = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);

		INSERT INTO tb_message (id,id_usuario,id_atividade,scrap)
        VALUES (Iid,Iid_usuario,Iid_atividade,Iscrap)
        ON DUPLICATE KEY UPDATE scrap=Iscrap;
        
        SELECT * from vw_message WHERE id_atividade = Iid_atividade ORDER BY id;
        
	END$$
DELIMITER ;

-- DROP PROCEDURE sp_delMessage;
DELIMITER $$
	CREATE PROCEDURE sp_delMessage(
		IN Ihash varchar(77),
		IN Iid int(11)
    )
	BEGIN			 
		DECLARE Iid_usuario INT(11);
		SET Iid_usuario = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
      
		DELETE FROM tb_message WHERE id=Iid AND id_usuario = Iid_usuario;
        
	END $$
DELIMITER ;

CALL sp_delMessage("¨hL¨h1¨hL¨h=,<L-=,<L¨l|/?.>N^n~1A0@P`p#3­2BRbr%5$4DTdt'7&6FVfv)9(8HXhx+;*:JZj",16);

00:46:25	CALL sp_delMessage("¨hL¨h1¨hL¨h=,<L-=,<L¨l|/?.>N^n~1A0@P`p#3­2BRbr%5$4DTdt'7&6FVfv)9(8HXhx+;*:JZj",16)	Error Code: 1305. PROCEDURE d2soft98_backhand.sp_delMessage does not exist	0,135 sec


/* FOLLOW */

-- DROP PROCEDURE sp_follow;
DELIMITER $$
	CREATE PROCEDURE sp_follow(
		IN Ihash varchar(77),
		IN Iid_guest int(11)
    )
	BEGIN	
		DECLARE Iid_host INT(11);
		SET Iid_host = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
        
		IF ((SELECT COUNT(*) FROM tb_following WHERE id_host = Iid_host AND id_guest = Iid_guest)>0) THEN
		   DELETE FROM tb_following WHERE id_host = Iid_host AND id_guest = Iid_guest ;           
		ELSE
		   INSERT INTO tb_following (id_host,id_guest) VALUES (Iid_host,Iid_guest);
		END IF;    	
        SELECT COUNT(*) AS FOLLOW FROM tb_following WHERE id_guest = Iid_guest;

	END $$
DELIMITER ;

-- DROP PROCEDURE sp_viewKudos;
DELIMITER $$
	CREATE PROCEDURE sp_viewKudos(
		IN Iid int(11),
		IN Iid_atividade int(11)
    )
	BEGIN	         
		SELECT KD.id_atividade, US.id AS userID, US.nome, US.nick,
        (SELECT COUNT(*) FROM tb_following WHERE id_host=Iid AND id_guest=US.id)AS FOLLOW
		FROM tb_kudos AS KD
		INNER JOIN tb_usuario AS US
		ON KD.id_usuario = US.id
        AND KD.id_atividade=Iid_atividade;
	END $$
DELIMITER ;

CALL sp_viewKudos(3,22);

/* USER BY DISTANCE */

-- DROP PROCEDURE sp_searchFriends;
DELIMITER $$
	CREATE PROCEDURE sp_searchFriends(
        IN Ihash varchar(77),
		IN Idistance int(11)
    )
	BEGIN	      
		DECLARE Iid_host INT(11);
        DECLARE Ilat DOUBLE;
		DECLARE Ilng DOUBLE;
		SET Iid_host = (SELECT id FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SET Ilat = (SELECT lat FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);
		SET Ilng = (SELECT lng FROM tb_usuario WHERE hash COLLATE utf8_general_ci = Ihash COLLATE utf8_general_ci LIMIT 1);

		SELECT US.id AS userID, US.nick AS nome, US.lat, US.lng,Ilat,Ilng,
        (SELECT IFNULL((SELECT fn_calcDist(Ilat,Ilng,US.lat,US.lng)),0)) AS DISTANCE,
        (SELECT COUNT(*) FROM tb_following WHERE id_host=Iid_host AND id_guest=US.id)AS FOLLOW
		FROM tb_usuario AS US
        WHERE (SELECT IFNULL((SELECT fn_calcDist(Ilat,Ilng,US.lat,US.lng)),0)) < Idistance
        AND US.id != Iid_host
        ORDER BY FOLLOW DESC,DISTANCE,US.nome;
        
	END $$
DELIMITER ;

CALL sp_searchFriends("f'lB9$rN`<'~l<$Z<9*~rBHT$rB3`0~N?l<-Z*xH9f6'T$rB3`0~N?l<-Z*xH9f6'T$rB3`0~N?l<",100);

-- DROP PROCEDURE sp_usersByName;
DELIMITER $$
	CREATE PROCEDURE sp_usersByName(
		IN ImyId int(11),
		IN Inome varchar(60),
        IN Istart int(11),
        IN IshowLimit int(11)
    )
	BEGIN	         
		SELECT US.id AS userID, US.nome,
			(SELECT COUNT(*) FROM tb_following WHERE id_host = ImyId AND id_guest = US.id) AS FOLLOW
			FROM tb_usuario AS US
            WHERE US.NOME COLLATE utf8_general_ci LIKE Inome COLLATE utf8_general_ci
            LIMIT Istart,IshowLimit;
	END $$
DELIMITER ;

CALL sp_usersByName(4,"%%",0,10);


-- DROP PROCEDURE sp_addEquip;
DELIMITER $$
	CREATE PROCEDURE sp_addEquip(
		IN Iid int(11),
		IN Iid_owner int(11),
		IN Idescricao varchar(15),
		IN Imarca varchar(15),
		IN Iaquisicao date,
		IN Iobs varchar(255)
    )
	BEGIN			 

		INSERT INTO tb_equip (id,id_owner,descricao,marca,aquisicao,obs) 
        VALUES (Iid,Iid_owner,Idescricao,Imarca,Iaquisicao,Iobs)
        ON DUPLICATE KEY UPDATE
        descricao=Idescricao, marca=Imarca, aquisicao=Iaquisicao, obs=Iobs;
        
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_addEquipManut;
DELIMITER $$
	CREATE PROCEDURE sp_addEquipManut(
		IN Iid int(11),
		IN Iid_equip int(11),
		IN Iservico varchar(15),
		IN Idata date,
		IN Iobs varchar(255)
    )
	BEGIN			 

		INSERT INTO tb_equip_manut (id,id_equip,servico,data,obs) 
        VALUES (Iid,Iid_equip,Iservico,Idata,Iobs)
        ON DUPLICATE KEY UPDATE
        servico=Iservico, data=Idata, obs=Iobs;
        
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_delEquipManut;
DELIMITER $$
	CREATE PROCEDURE sp_delEquipManut(
		IN Iid int(11)
    )
	BEGIN			 
		DELETE FROM tb_equip_manut WHERE id=Iid;        
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_delEquip;
DELIMITER $$
	CREATE PROCEDURE sp_delEquip(
		IN Iid int(11)
    )
	BEGIN
		DELETE FROM tb_equip_manut WHERE id_equip=Iid;
		DELETE FROM tb_equip WHERE id=Iid;        
	END $$
DELIMITER ;

 DROP PROCEDURE sp_newTorn;
DELIMITER $$
	CREATE PROCEDURE sp_newTorn(
		IN Iid int(11) ,
		IN Iid_owner int(11), 
		IN Inome varchar(50),
		IN Imodelo varchar(15),    
		IN Inum_players int,
        IN Inum_grupos int,
        IN IplayOff int,
        IN Iregras varchar(1000)
    )
	BEGIN

		SET @edit = (SELECT COUNT(*) FROM tb_torneio WHERE id=Iid);
        
		INSERT INTO tb_torneio (id,id_owner,nome,modelo,num_players,num_grupos,playOff,regras)
        VALUES (Iid,Iid_owner,Inome,Imodelo,Inum_players,Inum_grupos,IplayOff,Iregras)
        ON DUPLICATE KEY UPDATE
        nome=Inome, regras=Iregras;
		
        SET @playOff = IplayOff DIV 2;        
        SET @id_torn =Iid;          
		IF (@edit=0) THEN			    
			SET @id_torn = (SELECT MAX(id) FROM tb_torneio);
            SET @num_jogos =  fn_numJogos(Imodelo,Inum_players,Inum_grupos,IplayOff);
			SET @nJogadorGrupo = (SELECT IFNULL((SELECT Inum_players DIV Inum_grupos),0)); 
			SET @nRestaJog = (SELECT IFNULL((SELECT Inum_players % Inum_grupos),0));
            
            SET @numJogo = 1;
            SET @numGrupo = 1;
            SET @numJogGrupo = 1;
            SET @numJogPorGrupo = fn_numJogosPC(@nJogadorGrupo + (SELECT IF(@nRestaJog>0,1,0)));
            loop_jogos:  LOOP
            
				INSERT INTO tb_jogo (id,id_torn,grupo)
				VALUES (@numJogo,@id_torn,@numGrupo);                   
                        
				SET @numJogGrupo = @numJogGrupo+1;
                IF @numGrupo <= Inum_grupos THEN                
					IF @numJogGrupo > @numJogPorGrupo THEN
						SET @numJogGrupo = 1;
						SET @numGrupo = @numGrupo+1;						
						SET @nRestaJog = @nRestaJog-1;
                        SET @numJogPorGrupo = fn_numJogosPC(@nJogadorGrupo + (SELECT IF(@nRestaJog>0,1,0)));
					END IF;
				ELSE 
					IF @numJogGrupo > @playOff THEN
						SET @numJogGrupo = 1;
						SET @numGrupo = @numGrupo+1;
                        IF @playOff > 2 THEN
							SET @playOff = @playOff DIV 2;
						END IF;
					END IF;                
                END IF;
            
				IF  @numJogo >= @num_jogos THEN
					LEAVE  loop_jogos;
				ELSE
					SET @numJogo = @numJogo+1;
				END  IF;
			END LOOP;
		END IF;
        
        SELECT * FROM tb_torneio WHERE id=@id_torn;
	END $$
DELIMITER ;

-- DROP PROCEDURE sp_delTorn;
DELIMITER $$
	CREATE PROCEDURE sp_delTorn(
		IN Iid int(11)
    )
	BEGIN
		DELETE FROM tb_jogo WHERE id_torn=Iid;
		DELETE FROM tb_torneio WHERE id=Iid;        
	END $$
DELIMITER ;

 DROP PROCEDURE sp_inviteTorn;
DELIMITER $$
	CREATE PROCEDURE sp_inviteTorn(
		IN Ihash varchar(77),
		IN Iid_torn int(11),
        IN Iid_atleta int(11)
    )
	BEGIN
		SET @OWNER_HASH = (SELECT US.hash FROM tb_usuario AS US INNER JOIN tb_torneio AS TN ON US.id=TN.id_owner AND TN.id=Iid_torn);
        SET @tot = (SELECT num_players FROM tb_torneio WHERE id=Iid_torn);
        SET @tot_invite = (SELECT COUNT(*) FROM tb_torn_invite WHERE id_torn=Iid_torn);
		SET @invite = 0;
        
		IF (Ihash COLLATE utf8_general_ci = @OWNER_HASH COLLATE utf8_general_ci)THEN
			IF ((SELECT COUNT(*) FROM tb_torn_invite WHERE id_torn = Iid_torn AND id_atleta = Iid_atleta)>0) THEN
			   DELETE FROM tb_torn_invite WHERE id_torn = Iid_torn AND id_atleta = Iid_atleta ;  
               SET @tot_invite = @tot_invite -1;
			ELSE
				IF(@tot_invite<@tot)THEN
					INSERT INTO tb_torn_invite (id_torn, id_atleta) VALUES (Iid_torn,Iid_atleta);
					SET @invite = 1;
				END IF;
			END IF;		
        END IF;
        
        SET @tot_invite = (SELECT COUNT(*) FROM tb_torn_invite WHERE id_torn=Iid_torn);
		SELECT @invite as OK, (@tot-@tot_invite) AS VAGAS;
	END $$
DELIMITER ;

CALL sp_inviteTorn("p#~[#/*~[*6p?#/?iM/pT#86/[TT#p?/[*wF6b1~M=i8(T#p?/[*wF6b1~M=i8(T#p?/[*wF6b1~M",1,1);
CALL sp_newTorn("1",1,"Torneio Teste editado",2,20,3,8);
CALL sp_delTorn(1);

SELECT fn_numJogos(2,20,3,8);

SELECT * FROM tb_torneio;
SELECT * FROM tb_jogo;
/* JOG por GRUPO */
SELECT IFNULL((SELECT 20 DIV 3),0);
/* RESTA JOG */
SELECT IFNULL((SELECT 20 % 3),0);
