-- ********************************
--  DROP VIEW vw_dashboard;
CREATE VIEW vw_dashboard AS	
    SELECT ATV.*, SP.nome AS SPORT, EV.nome AS EVENTO, US.nome AS ATLETA,US.nick AS nick, QD.lat, QD.lng , QD.nome AS QUADRA, PC.SETS_P1, PC.SETS_P2,
    (SELECT COUNT(*) FROM tb_kudos WHERE id_atividade = ATV.id) AS KUDOS,
    (SELECT COUNT(*) FROM tb_message WHERE id_atividade = ATV.id) AS MESSAGES
            FROM tb_atividades AS ATV 
            INNER JOIN tb_sport AS SP
            INNER JOIN tb_evento AS EV
            INNER JOIN tb_usuario AS US
            INNER JOIN tb_quadra AS QD
            INNER JOIN vw_placar AS PC            
            ON SP.id = ATV.id_sport
            AND PC.id = ATV.id          
            AND EV.id = ATV.id_evento
            AND US.id = ATV.id_usuario
            AND QD.id = ATV.id_quadra    
            ORDER BY ATV.dia DESC;

SELECT * FROM vw_dashboard LIMIT 0,10;
    
-- ********************************

CREATE VIEW vw_minhasQuadras AS    
SELECT AQ.*, MQ.id_usuario 
	FROM tb_quadra AS AQ
	INNER JOIN tb_minhasquadras AS MQ
	ON AQ.id = MQ.id_quadra;    
    
SELECT * FROM vw_minhasQuadras WHERE id_usuario = 2;

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
    
SELECT * FROM vw_friends WHERE nome LIKE "%A%" ;

-- *********************************

-- DROP VIEW vw_perfil;
CREATE VIEW vw_perfil AS    
SELECT US.id, US.nome,
	(SELECT COUNT(*) FROM vw_friends WHERE hostID = US.id ) AS SEGUINDO, 
    (SELECT COUNT(*) FROM vw_friends WHERE guestID = US.id ) AS SEGUIDORES,
    (SELECT COUNT(*) FROM tb_atividades WHERE id_usuario = US.id) AS ATIVIDADES
    FROM tb_usuario AS US;
    
SELECT * FROM vw_perfil ;

-- *********************************

SELECT * FROM vw_placarAtiv;
SELECT * FROM vw_dashboard;
SELECT * FROM vw_placarAtiv;
SELECT * FROM vw_noSets;
SELECT * FROM vw_placar;
SELECT * FROM vw_friends;
SELECT * FROM vw_perfil;

-- ****************************************
SELECT * FROM vw_placarAtiv UNION ALL SELECT * FROM vw_noSets ORDER BY id ASC;

SELECT * from vw_message WHERE id_atividade = 22;

SELECT US.nome, US.lat, US.lng, (SELECT fn_calcDist(-23,-45,US.lat,US.lng)) AS DISTANCE 
FROM tb_usuario AS US;

SELECT fn_calcDist(-23,-45,-23.5,-45.5);
       