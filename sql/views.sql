-- ********************************
--  DROP VIEW vw_dashboard;

CREATE VIEW vw_dashboard AS	
    SELECT ATV.*, SP.nome AS SPORT, EV.nome AS EVENTO, US.nick AS NOME_ATLETA,US.nick AS nick,
    QD.lat, QD.lng , QD.nome AS QUADRA, PC.SETS_P1, PC.SETS_P2, PC.P1_SCORE, PC.P2_SCORE,
    ATL.ID_ATLETAS,ATL.ATLETAS,ATL.LADO,ATL.ASK,ATL.CONFIRM,ATL.PESO AS NIVEL,
    (SELECT COUNT(*) FROM tb_kudos WHERE id_atividade = ATV.id) AS KUDOS,
    (SELECT COUNT(*) FROM tb_message WHERE id_atividade = ATV.id) AS MESSAGES,
    (SELECT IF(ATV.ranking=1,"RANQUEADO","AMISTOSO")) AS STATUS
	FROM tb_atividades AS ATV
	INNER JOIN tb_sport AS SP
	INNER JOIN tb_evento AS EV
	INNER JOIN tb_usuario AS US
	INNER JOIN tb_quadra AS QD
	INNER JOIN vw_placar AS PC
    INNER JOIN vw_atvAtl AS ATL
	ON SP.id = ATV.id_sport
	AND PC.id = ATV.id    
	AND EV.id = ATV.id_evento
	AND US.id = ATV.id_usuario
	AND QD.id = ATV.id_quadra  
	AND ATL.id_ativ = ATV.id          
	ORDER BY ATV.dia DESC;

SELECT * FROM vw_dashboard;    
    
-- ********************************
--  DROP VIEW vw_atvAtl;
CREATE VIEW vw_atvAtl AS
    SELECT ATL.id_ativ, 
		GROUP_CONCAT(US.nick SEPARATOR ',') AS ATLETAS,        
		GROUP_CONCAT(ATL.id_atleta SEPARATOR ',') AS ID_ATLETAS,
        GROUP_CONCAT(ATL.team SEPARATOR ',') AS LADO,
        GROUP_CONCAT(ATL.confirm SEPARATOR ',') AS CONFIRM,
        GROUP_CONCAT(ATL.ask SEPARATOR ',') AS ASK,
        ROUND(SUM(US.nivel),2) AS PESO
		FROM tb_ativ_atleta AS ATL
        INNER JOIN tb_usuario AS US
        ON US.id = ATL.id_atleta
		GROUP BY ATL.id_ativ;
    
SELECT * FROM vw_atvAtl;    
    
-- ********************************

CREATE VIEW vw_minhasQuadras AS    
SELECT AQ.*, MQ.id_usuario 
	FROM tb_quadra AS AQ
	INNER JOIN tb_minhasquadras AS MQ
	ON AQ.id = MQ.id_quadra;    
    
SELECT * FROM vw_minhasQuadras;

-- *********************************
-- DROP VIEW vw_placarAtiv;
/*CREATE VIEW vw_placarAtiv AS*/
	SELECT  AT.id,
		SUM( IF(ST.p1_score > ST.p2_score,1,0))AS SETS_P1,
		SUM( IF(ST.p1_score < ST.p2_score,1,0))AS SETS_P2,
		GROUP_CONCAT(ST.p1_score SEPARATOR ',') AS P1_SCORE,
		GROUP_CONCAT(ST.p2_score SEPARATOR ',') AS P2_SCORE,
        (SELECT GROUP_CONCAT( id_atleta SEPARATOR ',') AS TEAM_A FROM tb_ativ_atleta WHERE id_ativ=AT.id AND team="A") AS TEAM_A,
        (SELECT GROUP_CONCAT( id_atleta SEPARATOR ',') AS TEAM_A FROM tb_ativ_atleta WHERE id_ativ=AT.id AND team="B") AS TEAM_B
		FROM tb_atividades AS AT
		INNER JOIN (SELECT * FROM tb_sets ORDER BY id_atividade, id ASC) AS ST
		ON ST.id_atividade = AT.id
		GROUP BY AT.id
        ORDER BY  AT.id;

SELECT * FROM vw_placarAtiv;

-- DROP VIEW vw_noSets;
CREATE VIEW vw_noSets AS	
	SELECT id AS id_atividade, 0 AS SETS_P1, 0 as SETS_P2, 0 as P1_SCORE, 0 as P2_SCORE, NULL AS TEAM_A, NULL AS TEAM_B
	FROM tb_atividades 
	WHERE id NOT IN (SELECT id_atividade FROM tb_sets)
ORDER BY id;

SELECT * FROM vw_noSets;

-- DROP VIEW vw_winners;
CREATE VIEW vw_winners AS	
	SELECT 	id AS id_ativ,
		IF(SETS_P1>SETS_P2,TEAM_A, IF(SETS_P2>SETS_P1,TEAM_B,0)) AS WINNER,
		IF(SETS_P1<SETS_P2,TEAM_A, IF(SETS_P2<SETS_P1,TEAM_B,0)) AS LOSER
        FROM vw_placarAtiv;

SELECT * FROM vw_winners;

-- DROP VIEW vw_placar;
/*CREATE VIEW vw_placar AS*/
	SELECT * FROM vw_placarAtiv 
    UNION ALL 
    SELECT * FROM vw_noSets
    ORDER BY id ASC;

SELECT * FROM vw_placar;
-- ****************************************
-- DROP VIEW vw_kudos;

CREATE VIEW vw_kudos AS    
SELECT KD.id_atividade AS id, US.id AS userID, US.nome, US.nick 
	FROM tb_kudos AS KD
	INNER JOIN tb_usuario AS US
	ON KD.id_usuario = US.id;
    
SELECT * FROM vw_kudos WHERE id = 22;

-- *********************************
-- DROP VIEW vw_message;

CREATE VIEW vw_message AS    
SELECT MS.id, MS.id_atividade, US.id AS userID, US.nome, US.nick, MS.scrap 
	FROM tb_message AS MS
	INNER JOIN tb_usuario AS US
	ON MS.id_usuario = US.id;
    
SELECT * FROM vw_message WHERE id_atividade = 22;

-- *********************************
-- DROP VIEW vw_friends;

CREATE VIEW vw_friends AS
SELECT FW.id_host AS hostID,(SELECT nick FROM tb_usuario WHERE id=FW.id_host) AS hostname,US.id AS guestID, US.nick AS guestname,
	(SELECT COUNT(*) FROM tb_following WHERE id_host=FW.id_guest AND id_guest=FW.id_host) AS SEGUE_VOLTA
	FROM tb_following AS FW
	INNER JOIN tb_usuario AS US
	ON US.id = FW.id_guest;
    
SELECT * FROM vw_friends;

-- *********************************

-- DROP VIEW vw_perfil;
-- CREATE VIEW vw_perfil AS
SELECT US.id, US.nome,US.nivel,
	(SELECT COUNT(*) FROM vw_friends WHERE hostID = US.id ) AS SEGUINDO, 
    (SELECT COUNT(*) FROM vw_friends WHERE guestID = US.id ) AS SEGUIDORES,
    (SELECT COUNT(*) FROM vw_atv WHERE id_atleta = US.id) AS ATIVIDADES,
    (SELECT COUNT(*) FROM vw_atv WHERE id_atleta = US.id AND dia>(NOW() - INTERVAL 28 DAY)) AS LAST_28,
    (SELECT ALERTAS FROM vw_alerta WHERE id_atleta = US.id) AS ALERTA_QTD,
    (SELECT NOME FROM vw_alerta WHERE id_atleta = US.id) AS ALERTA_NOME,
    (SELECT NOME_OWNER FROM vw_alerta WHERE id_atleta = US.id) AS ALERTA_OWNER,
    (SELECT ATV FROM vw_alerta WHERE id_atleta = US.id) AS ALERTA_ATV,
    (SELECT ALERTA_TORN FROM vw_alerta_torn WHERE id_atleta = US.id) AS ALERTA_TORN,
    (SELECT QTD_TORN FROM vw_alerta_torn WHERE id_atleta = US.id) AS QTD_TORN,
    (SELECT GROUP_CONCAT(SUBSTRING(dia,1,10) SEPARATOR ', ')
		FROM vw_atv 
        WHERE dia>(NOW() - INTERVAL 28 DAY) 
        AND id_atleta = US.id) AS TREINOS,
    (SELECT GROUP_CONCAT(id_atv SEPARATOR ', ')
		FROM vw_atv 
        WHERE dia>(NOW() - INTERVAL 28 DAY) 
        AND id_atleta = US.id) AS TREINO_ID            
	FROM tb_usuario AS US;
    
SELECT * FROM vw_perfil;    

-- DROP VIEW vw_dashboard_atleta;
CREATE VIEW vw_dashboard_atleta AS
SELECT ATV.id_atleta, DSB.* 
	FROM tb_ativ_atleta AS ATV
	INNER JOIN vw_dashboard AS DSB
	ON ATV.id_ativ = DSB.id
	AND DSB.dia>(NOW() - INTERVAL 28 DAY)
	AND (ATV.confirm=1 OR ATV.ativ_owner);

SELECT * FROM vw_dashboard_atleta WHERE id_atleta = 1;

-- SELECT * FROM vw_alerta WHERE id_atleta = 2;
-- *********************************
-- DROP VIEW vw_atv;

CREATE VIEW vw_atv AS
	SELECT ATV.id AS id_atv, ATL.id_atleta, ATV.id_quadra, ATV.id_sport, ATV.id_evento, ATV.nome, ATV.dia, ATV.duracao, ATV.ranking
	FROM tb_ativ_atleta AS ATL
	INNER JOIN tb_atividades AS ATV
	ON ATV.id = ATL.id_ativ
    AND (ATL.confirm = 1 OR ATL.ativ_owner = 1);

SELECT * FROM vw_atv WHERE id_atleta = 2;
SELECT * FROM tb_ativ_atleta WHERE id_atleta = 2 AND (confirm = 1 OR ativ_owner = 1);


-- *********************************

-- DROP VIEW vw_atv_atleta;

CREATE VIEW vw_atv_atleta AS    
	SELECT AA.*, US.nome 
		FROM tb_ativ_atleta AS AA
		INNER JOIN tb_usuario AS US
		ON US.id = AA.id_atleta 
		ORDER BY AA.team ASC;
        
SELECT * FROM vw_atv_atleta;        

-- *********************************

-- DROP VIEW vw_alerta;
/*CREATE VIEW vw_alerta AS    */
	SELECT AAT.id_atleta, COUNT(AAT.id_ativ)AS ALERTAS,
		GROUP_CONCAT(AAT.id_ativ SEPARATOR ',') AS ATV,
		GROUP_CONCAT(ATV.nome SEPARATOR ',') AS NOME,
		GROUP_CONCAT(USR.nome SEPARATOR ',') AS NOME_OWNER,
		GROUP_CONCAT(USR.id SEPARATOR ',') AS ID_OWNER
		FROM tb_usuario AS USR
		INNER JOIN tb_atividades AS ATV
        INNER JOIN tb_ativ_atleta AS AAT
		ON ATV.id = AAT.id_ativ
		AND USR.id = ATV.id_usuario
		AND AAT.confirm=0        
        AND AAT.id_atleta != USR.id
		AND AAT.ask=1 
		GROUP BY AAT.id_atleta;
    
SELECT * FROM vw_alerta;


-- DROP VIEW vw_alerta_torn;
-- CREATE VIEW vw_alerta_torn AS 
	SELECT id_atleta, GROUP_CONCAT(id_torn SEPARATOR ',') AS ALERTA_TORN, COUNT(id_torn) AS QTD_TORN
		FROM tb_torn_invite 
		WHERE accept=0        
		AND ask=1 
        GROUP BY id_atleta;
    
SELECT * FROM vw_alerta_torn;


SELECT * FROM tb_torn_invite;
SELECT id_torn FROM tb_torn_invite WHERE id_player=3 AND ask=1;

-- *********************************

/* DROP VIEW vw_torn;*/
CREATE VIEW vw_torn AS
	SELECT TRN.*, USR.nome AS OWNER_NOME,
		(SELECT COUNT(*) FROM tb_torn_invite WHERE id_torn=TRN.id) AS CONVITES,
		(SELECT COUNT(*) FROM tb_torn_invite WHERE id_torn=TRN.id AND accept=1) AS ACEITOS
		FROM tb_torneio AS TRN
		INNER JOIN tb_usuario AS USR
		ON TRN.id_owner = USR.id;

SELECT * FROM vw_torn;

-- DROP VIEW vw_torn_invite;
-- CREATE VIEW vw_torn_invite AS
SELECT IVT.*,USR.nome AS nome_atleta, USR.nivel
	FROM tb_torn_invite AS IVT
	INNER JOIN tb_usuario AS USR
	ON IVT.id_atleta = USR.id
    ORDER BY id_torn,nivel DESC;

-- DROP VIEW vw_my_torn;
-- CREATE VIEW vw_my_torn AS
	SELECT INV.id_atleta ,TRN.*
	FROM tb_torneio AS TRN
	INNER JOIN vw_torn_invite AS INV
	ON TRN.id = INV.id_torn
    UNION
	SELECT id_owner AS id_atleta, id,id_owner,nome, modelo, num_players, num_grupos, playOff, regras, criado
	FROM tb_torneio 
    WHERE id NOT IN(SELECT id_torn FROM vw_torn_invite GROUP BY id_torn);
    
SELECT * FROM vw_my_torn ;

SELECT * FROM vw_torn_invite WHERE id_torn = 4;

SELECT * FROM vw_torn_invite;
SELECT * FROM vw_my_torn;
-- *********************************

SELECT * FROM vw_placarAtiv;
SELECT * FROM vw_dashboard;
SELECT * FROM vw_placarAtiv;
SELECT * FROM vw_noSets;
SELECT * FROM vw_placar;
SELECT * FROM vw_friends;
SELECT * FROM vw_perfil;
SELECT * FROM vw_alerta;
SELECT * FROM vw_torn;
SELECT * FROM vw_torn_invite;

-- ****************************************
SELECT * FROM vw_placarAtiv UNION ALL SELECT * FROM vw_noSets ORDER BY id ASC;

SELECT * from vw_message WHERE id_atividade = 22;

SELECT US.nome, US.lat, US.lng, (SELECT fn_calcDist(-23,-45,US.lat,US.lng)) AS DISTANCE 
FROM tb_usuario AS US;

SELECT fn_calcDist(-23,-45,-23.5,-45.5);
/*       
SELECT EQP.* 
FROM tb_equip AS EQP
INNER JOIN (SELECT * FROM ) AS MNT
*/
 UPDATE tb_torn_invite SET accept=1 WHERE id_torn=1 AND id_atleta=1;