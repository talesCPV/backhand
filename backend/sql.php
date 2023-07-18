<?php

    $query_db = array(
        "0" => 'SELECT * FROM tb_usuario WHERE email="x00" AND hash="x01";',
        "1" => 'CALL sp_insertUsuario("x00","x01","x02","x03","x04","x05","x06","x07","x08");',
        "2" => 'CALL sp_delUsuario("x00")',
        "3" => 'SELECT * FROM tb_quadra WHERE y00="x00" AND y01="x01";',
        "4" => 'CALL sp_insertQuadra("x00","x01","x02","x03","x04")',
        "5" => 'CALL sp_delQuadra("x00")',
        "6" => 'SELECT * FROM vw_minhasQuadras WHERE id_usuario = "x00";',
        "7" => 'CALL sp_insertMinhasQuadras("x00","x01");',
        "8" => 'CALL sp_delMinhasQuadras("x00","x01");',
        "9" => 'SELECT DB.*, (SELECT fn_calcDist(DB.lat,DB.lng,x00,x01)) AS distance 
            FROM vw_dashboard AS DB
            WHERE (SELECT fn_calcDist(DB.lat,DB.lng,x00,x01))<= x02
            LIMIT x03,x04;',
        "10" => 'CALL sp_insertAtividades("x00","x01","x02","x03","x04","x05","x06","x07","x08");',
        "11" => 'CALL sp_delAtividades("x00");',
        "12" => 'SELECT * FROM tb_sport',
        "13" => 'SELECT * FROM tb_evento',
        "14" => 'CALL sp_insertSets("x00","x01","x02","x03","x04");',
        "15" => 'SELECT * FROM tb_sets WHERE id_atividade="x00" ORDER BY id ASC;',
        "16" => 'DELETE FROM tb_sets WHERE AND id_atividade="x01"',
        "17" => 'CALL sp_delSets("x00","x01");',
        "18" => 'CALL sp_kudos("x00",x01);',    
        "19" => 'CALL sp_message("x00","x01","x02","x03");',
        "20" => 'CALL sp_delMessage("x00",x01);',
        "21" => 'CALL sp_viewKudos(x00,x01);',
        "22" => 'SELECT * from vw_message WHERE id_atividade = x00 ORDER BY id;',
        "23" => 'CALL sp_follow("x00",x01);',
        "24" => 'CALL sp_searchFriends("x00",x01);',
        "25" => 'SELECT * FROM vw_friends WHERE userID = x00;',
        "26" => 'CALL sp_usersByName(x00,"%x01%",0,10);',
    );

?>