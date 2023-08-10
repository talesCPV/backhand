
-- DROP FUNCTION fn_calcDist;
DELIMITER $$
	CREATE FUNCTION fn_calcDist(lat1 DOUBLE, lng1 DOUBLE, lat2 DOUBLE,lng2 DOUBLE)
    RETURNS DOUBLE 
    DETERMINISTIC
	BEGIN    
		RETURN ROUND(6371 *
        acos(
            cos(radians(lat1)) *
            cos(radians(lat2)) *
            cos(radians(lng1) - radians(lng2)) +
            sin(radians(lat1)) *
            sin(radians(lat2))
        ),3);        			
	END $$
DELIMITER ;

DROP FUNCTION fn_split;
DELIMITER $$
	CREATE FUNCTION fn_split(texto VARCHAR(255), i INT)
    RETURNS VARCHAR (30)
    DETERMINISTIC
	BEGIN
		RETURN (
			SELECT SUBSTRING_INDEX(
			SUBSTRING_INDEX(texto, ',', i)
			, ',', -1)
        );		
	END $$
DELIMITER ;

SELECT fn_split("A,B,C,TEXTO,TALES C. DANTAS,2,(9),ok",6);

SELECT fn_calcDist(-23,-45,-23.5,-45.5);
