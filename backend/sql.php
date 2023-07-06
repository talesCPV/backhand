<?php

    $query_db = array(
        "0" => 'SELECT * FROM tb_usuario WHERE email="x00" AND hash="x01";',
        "1" => 'CALL sp_insertUsuario("x00","x01","x02","x03","x04","x05","x06","x07","x08");',
        "2" => 'CALL sp_delUsuario("x00")',
        "3" => 'SELECT * FROM tb_quadra WHERE y00="x00" AND y01="x01";',
        "4" => 'CALL sp_insertQuadra("x00","x01","x02","x03","x04")',
        "5" => 'CALL sp_delQuadra("x00")',
        "6" => 'SELECT AQ.* FROM tb_quadra AS AQ
            INNER JOIN tb_minhasquadras AS MQ
            ON AQ.id = MQ.id_quadra
            AND MQ.id_usuario = "x00";',
        "7" => 'CALL sp_insertMinhasQuadras("x00","x01");',
        "8" => 'CALL sp_delMinhasQuadras("x00","x01");',
        "9" => 'SELECT ATV.*, SP.nome AS SPORT, EV.nome AS EVENTO, US.nome AS ATLETA, QD.lat, QD.lng , QD.nome AS QUADRA,
            ROUND(6371 *
                acos(
                    cos(radians(QD.lat)) *
                    cos(radians(x00)) *
                    cos(radians(QD.lng) - radians(x01)) +
                    sin(radians(QD.lat)) *
                    sin(radians(x00))
            ),3) AS distance
            FROM tb_atividades AS ATV 
            INNER JOIN tb_sport AS SP
            INNER JOIN tb_evento AS EV
            INNER JOIN tb_usuario AS US
            INNER JOIN tb_quadra AS QD
            INNER JOIN tb_kudos AS KD
            ON SP.id = ATV.id_sport
            AND EV.id = ATV.id_evento
            AND US.id = ATV.id_usuario
            AND QD.id = ATV.id_quadra
            
            AND(
            SELECT ROUND(6371 *
				acos(
					cos(radians(QD.lat)) *
					cos(radians(US.lat)) *
					cos(radians(QD.lng) - radians(US.lng)) +
					sin(radians(QD.lat)) *
					sin(radians(US.lat))
			),3) ) <= x02

            ORDER BY ATV.dia DESC        
            LIMIT x03,x04;',
        "10" => 'CALL sp_insertAtividades("x00","x01","x02","x03","x04","x05","x06","x07","x08");',
        "11" => 'CALL sp_delAtividades("x00");',
        "12" => 'SELECT * FROM tb_sport',
        "13" => 'SELECT * FROM tb_evento',
        "14" => 'INSERT INTO tb_sets (id,id_atividade,p1_score,p2_score,obs) VALUES ("x00","x01","x02","x03","x04")
            ON DUPLICATE KEY UPDATE p1_score="x02", p2_score="x03", obs="x04";',
        "15" => 'SELECT * FROM tb_sets WHERE id_atividade="x00"',
        "16" => 'DELETE FROM tb_sets WHERE AND id_atividade="x01"',
        "17" => 'DELETE FROM tb_sets WHERE id="x00" AND id_atividade="x01"',


    );

?>