-- ********************************
--  DROP VIEW vw_dashboard;
CREATE VIEW vw_dashboard AS	
    SELECT ATV.*, SP.nome AS SPORT, EV.nome AS EVENTO, US.nome AS NOME_ATLETA,US.nick AS nick, QD.lat, QD.lng , QD.nome AS QUADRA, PC.SETS_P1, PC.SETS_P2,ATL.ATLETAS,ATL.LADO,
    (SELECT COUNT(*) FROM tb_kudos WHERE id_atividade = ATV.id) AS KUDOS,
    (SELECT COUNT(*) FROM tb_message WHERE id_atividade = ATV.id) AS MESSAGES    
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
		GROUP_CONCAT(US.nome SEPARATOR ', ') AS ATLETAS,
        GROUP_CONCAT(ATL.team SEPARATOR ', ') AS LADO
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
CREATE VIEW vw_placarAtiv AS    
	SELECT  AT.id,
	SUM( IF(ST.p1_score > ST.p2_score,1,0))AS SETS_P1,
	SUM( IF(ST.p1_score < ST.p2_score,1,0))AS SETS_P2
FROM tb_atividades AS AT
INNER JOIN tb_sets AS ST
ON ST.id_atividade = AT.id
GROUP BY AT.id;

-- DROP VIEW vw_noSets;
CREATE VIEW vw_noSets AS	
	SELECT id AS id_atividade, 0 AS SETS_P1, 0 as SETS_P2
	FROM tb_atividades 
	WHERE id NOT IN (SELECT id_atividade FROM tb_sets)
ORDER BY id;

-- DROP VIEW vw_placar;
CREATE VIEW vw_placar AS
	SELECT * FROM vw_placarAtiv 
    UNION ALL 
    SELECT * FROM vw_noSets 
    ORDER BY id ASC;

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
SELECT FW.id_host AS hostID,(SELECT nome FROM tb_usuario WHERE id=FW.id_host) AS hostname,US.id AS guestID, US.nome AS guestname 
	FROM tb_following AS FW
	INNER JOIN tb_usuario AS US
	ON US.id = FW.id_guest;
    
SELECT * FROM vw_friends;

-- *********************************

-- DROP VIEW vw_perfil;
CREATE VIEW vw_perfil AS
SELECT US.id, US.nome,
	(SELECT COUNT(*) FROM vw_friends WHERE hostID = US.id ) AS SEGUINDO, 
    (SELECT COUNT(*) FROM vw_friends WHERE guestID = US.id ) AS SEGUIDORES,
    (SELECT COUNT(*) FROM tb_atividades WHERE id_usuario = US.id) AS ATIVIDADES,
    (SELECT COUNT(*) FROM tb_atividades WHERE id_usuario = US.id AND dia>(NOW() - INTERVAL 28 DAY)) AS LAST_28,
    (SELECT ALERTAS FROM vw_alerta WHERE id_atleta = US.id) AS ALERTA_QTD,
    (SELECT NOME FROM vw_alerta WHERE id_atleta = US.id) AS ALERTA_NOME,
    (SELECT NOME_OWNER FROM vw_alerta WHERE id_atleta = US.id) AS ALERTA_OWNER,
    (SELECT ATV FROM vw_alerta WHERE id_atleta = US.id) AS ALERTA_ATV,
    (SELECT GROUP_CONCAT(SUBSTRING(dia,1,10) SEPARATOR ', ')
		FROM tb_atividades 
        WHERE dia>(NOW() - INTERVAL 28 DAY) 
        AND id_usuario = US.id) AS TREINOS,
    (SELECT GROUP_CONCAT(id SEPARATOR ', ')
		FROM tb_atividades 
        WHERE dia>(NOW() - INTERVAL 28 DAY) 
        AND id_usuario = US.id) AS TREINO_ID            
    FROM tb_usuario AS US;
    
SELECT * FROM vw_perfil ;

-- SELECT * FROM vw_alerta WHERE id_atleta = 2;

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
CREATE VIEW vw_alerta AS    
	SELECT AAT.id_atleta, COUNT(AAT.id_ativ)AS ALERTAS,
		GROUP_CONCAT(AAT.id_ativ SEPARATOR ',') AS ATV,
		GROUP_CONCAT(ATV.nome SEPARATOR ',') AS NOME,
		GROUP_CONCAT(USR.nome SEPARATOR ',') AS NOME_OWNER
		FROM tb_ativ_atleta AS AAT
		INNER JOIN tb_atividades AS ATV
		INNER JOIN tb_usuario AS USR
		ON ATV.id = AAT.id_ativ
		AND USR.id = ATV.id_usuario
		AND confirm=0 
		AND ask=1 
		GROUP BY id_atleta;
    
SELECT * FROM vw_alerta;

SELECT AAT.id_atleta, COUNT(AAT.id_ativ)AS ALERTAS,
	GROUP_CONCAT(AAT.id_ativ SEPARATOR ', ') AS ATV,
	GROUP_CONCAT(ATV.nome SEPARATOR ', ') AS NOME,
	GROUP_CONCAT(USR.nome SEPARATOR ', ') AS NOME_OWNER
	FROM tb_ativ_atleta AS AAT
    INNER JOIN tb_atividades AS ATV
    INNER JOIN tb_usuario AS USR
    ON ATV.id = AAT.id_ativ
    AND USR.id = ATV.id_usuario
    AND confirm=0 
    AND ask=1 
    GROUP BY id_atleta;

SELECT id_ativ from tb_ativ_atleta WHERE id_atleta = 2;


-- *********************************

SELECT * FROM vw_placarAtiv;
SELECT * FROM vw_dashboard;
SELECT * FROM vw_placarAtiv;
SELECT * FROM vw_noSets;
SELECT * FROM vw_placar;
SELECT * FROM vw_friends;
SELECT * FROM vw_perfil;
SELECT * FROM vw_alerta;

-- ****************************************
SELECT * FROM vw_placarAtiv UNION ALL SELECT * FROM vw_noSets ORDER BY id ASC;

SELECT * from vw_message WHERE id_atividade = 22;

SELECT US.nome, US.lat, US.lng, (SELECT fn_calcDist(-23,-45,US.lat,US.lng)) AS DISTANCE 
FROM tb_usuario AS US;

SELECT fn_calcDist(-23,-45,-23.5,-45.5);
       
