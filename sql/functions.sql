
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

-- DROP FUNCTION fn_numJogosPC;
DELIMITER $$
	CREATE FUNCTION fn_numJogosPC(numPlayers INT)
    RETURNS INT 
    DETERMINISTIC
	BEGIN    
		SET @num_jogos = 0;
		SET @cont = 0;
		loop_PC:  LOOP
			SET @cont = @cont+1;
			SET @num_jogos = @num_jogos + @cont;                    
			IF  @cont >=numPlayers-1 THEN 
				LEAVE  loop_PC;
			END  IF;                
		END LOOP;  	
		RETURN (SELECT @num_jogos AS QTD_JOGOS);		
	END $$
DELIMITER ;

DROP FUNCTION fn_numJogosP_OFF;
DELIMITER $$
	CREATE FUNCTION fn_numJogosP_OFF(numPlayers INT,MATAMATA BOOLEAN)
    RETURNS INT 
    DETERMINISTIC
	BEGIN    

		SET @playOff = 0;
		IF numPlayers >= 2 THEN
			SET @playOff = 2;
		END IF;
		IF numPlayers >= 4 THEN
			SET @playOff = 4;
		END IF;
		IF numPlayers >= 8 THEN
			SET @playOff = 8;
		END IF;
		IF numPlayers >= 16 THEN
			SET @playOff = 16;
		END IF;
        IF(NOT MATAMATA) THEN		
			IF numPlayers >= 32 THEN
				SET @playOff = 32;
			END IF;
			IF numPlayers >= 64 THEN
				SET @playOff = 64;
			END IF;
			IF numPlayers >= 128 THEN
				SET @playOff = 128;
			END IF;
			IF numPlayers >= 256 THEN
				SET @playOff = 256;
			END IF;
        END IF;
		RETURN @playOff;
        
	END $$
DELIMITER ;

DROP FUNCTION fn_numJogos;
DELIMITER $$
	CREATE FUNCTION fn_numJogos(modelo INT, numPlayers INT, numGrupos INT, numPlayOff INT)
    RETURNS INT 
    DETERMINISTIC
	BEGIN
		SET @num_jogos = numPlayers;
		SET @nJogadorGrupo = 0;
		SET @nRestaJog = 0;
        
            IF  modelo=2 THEN 
				SET @nJogadorGrupo = numPlayers DIV numGrupos;
				SET @nRestaJog = numPlayers % numGrupos;
                SET @num_jogos = ((SELECT fn_numJogosPC(@nJogadorGrupo+1)) * @nRestaJog) +
								 ((SELECT fn_numJogosPC(@nJogadorGrupo)) * (numGrupos -@nRestaJog));
                
                SET @num_jogos = @num_jogos + numPlayOff;                
			END  IF;            
            IF  modelo=3 THEN 
              SET @num_jogos = fn_numJogosPC(numPlayers);
			END  IF;            

		RETURN (SELECT @num_jogos AS QTD_JOGOS);		
	END $$
DELIMITER ;

SELECT fn_calcDist(-23,-45,-23.5,-45.5);
SELECT fn_numJogosPC(11);
SELECT fn_numJogosP_OFF(33);

SELECT fn_numJogos(2,32,2,0);


