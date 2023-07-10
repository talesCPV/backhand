-- ********************************
-- DROP VIEW vw_dashboard;
CREATE VIEW vw_dashboard AS	
    SELECT ATV.*, SP.nome AS SPORT, EV.nome AS EVENTO, US.nome AS ATLETA, QD.lat, QD.lng , QD.nome AS QUADRA, PC.SETS_P1, PC.SETS_P2
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

SELECT DB.*, (SELECT calcDist(DB.lat,DB.lng,-23.1112704,-45.71136)) AS distance 
	FROM vw_dashboard AS DB
    WHERE (SELECT calcDist(DB.lat,DB.lng,-23.1112704,-45.71136))<= 2
    LIMIT 0,10;
    
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
SELECT * FROM vw_placarAtiv;
SELECT * FROM vw_dashboard;
SELECT * FROM vw_placarAtiv;
SELECT * FROM vw_noSets;
SELECT * FROM vw_placar;
-- ****************************************
SELECT * FROM vw_placarAtiv UNION ALL SELECT * FROM vw_noSets ORDER BY id ASC;