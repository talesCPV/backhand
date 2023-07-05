<?php

    $query_db = array(
        "0" => 'SELECT * FROM tb_usuario WHERE email="x00" AND hash="x01";',
        "1" => 'INSERT INTO tb_usuario (id,email,hash,nome,nick,cel,lat,lng) VALUES ("x00","x01","x02","x03","x04","x05","x06","x07")
            ON DUPLICATE KEY UPDATE email="x01", hash="x02", nome="x03", nick="x04", cel="x05", class="x06", lat="x07", lng="x08" ;',
        "2" => 'DELETE FROM tb_usuario;',
        "3" => 'SELECT * FROM tb_quadra WHERE y00="x00" AND y01="x01";',
        "4" => 'INSERT INTO tb_quadra (id,nome,lat,lng,tipo) VALUES ("x00","x01","x02","x03","x04")
        ON DUPLICATE KEY UPDATE nome="x01", lat="x02", lng="x03", tipo="x04";',
        "5" => 'DELETE FROM tb_quadra;',
        "6" => 'SELECT AQ.* FROM tb_quadra AS AQ
            INNER JOIN tb_minhasquadras AS MQ
            ON AQ.id = MQ.id_quadra
            AND MQ.id_usuario = "x00";',
        "7" => 'INSERT INTO tb_minhasquadras (id_usuario,id_quadra) VALUES ("x00","x01");',
        "8" => 'DELETE FROM tb_minhasquadras WHERE id_usuario="x00" AND id_quadra="x01";',
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
        "10" => 'INSERT INTO tb_atividades (id,id_usuario,nome,id_sport,id_evento,parceiro,dia,duracao,id_quadra) VALUES ("x00","x01","x02","x03","x04","x05","x06","x07","x08")
            ON DUPLICATE KEY UPDATE nome="x02", id_sport="x03", id_evento="x04", parceiro="x05", dia="x06", duracao="x07", id_quadra="x08";',
        "11" => 'DELETE FROM tb_atividades WHERE id="x00";',
        "12" => 'SELECT * FROM tb_sport',
        "13" => 'SELECT * FROM tb_evento',


        "14" => 'INSERT INTO tb_kudos (id_usuario,id_atividade) VALUES ("x00","x01");',
        "15" => 'DELETE FROM tb_kudos WHERE id_usuario = "x00" AND id_atividade = "x01";',

    );

?>