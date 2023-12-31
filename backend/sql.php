<?php

    $query_db = array(
        "0" => 'SELECT * FROM tb_usuario WHERE email="x00" AND hash="x01";',
        "1" => 'CALL sp_insertUsuario("x00","x01","x02","x03","x04","x05","x06","x07","x08");',
        "2" => 'CALL sp_delUsuario("x00")',
        "3" => 'CALL sp_findQuadra("x00",x01,"x02");',
        "4" => 'CALL sp_insertQuadra("x00","x01","x02","x03","x04")',
        "5" => 'CALL sp_delQuadra("x00")',
        "6" => 'SELECT * FROM vw_minhasQuadras WHERE id_usuario = "x00";',
        "7" => 'CALL sp_minhasQuadras("x00","x01");',
        "8" => 'CALL sp_tornQuadras("x00",x01,x02);',
        "9" => 'SELECT DB.*, (SELECT fn_calcDist(DB.lat,DB.lng,x00,x01)) AS distance 
            FROM vw_dashboard AS DB
            WHERE (SELECT fn_calcDist(DB.lat,DB.lng,x00,x01))<= x02
            LIMIT x03,x04;',
        "10" => 'CALL sp_insertAtividades("x00","x01","x02","x03","x04","x05","x06","x07","x08");',
        "11" => 'CALL sp_delAtividades("x00");',
        "12" => 'SELECT * FROM tb_sport',
        "13" => 'SELECT * FROM tb_evento',
        "14" => 'SELECT * FROM vw_allAtivAtleta WHERE id_ativ="x00" ORDER BY id_ativ, ativ_owner DESC;',
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
        "25" => 'SELECT * FROM vw_friends WHERE y00 = x00;',
        "26" => 'CALL sp_usersByName(x00,"%x01%",x02,x03);',
        "27" => 'SELECT * FROM vw_perfil WHERE id = x00;',
        "28" => 'SELECT * FROM vw_dashboard WHERE id=x00',
        "29" => 'SELECT * FROM vw_dashboard_atleta WHERE id_atleta=x00;',
        "30" => 'CALL sp_editAtvAtl("x00","x01","x02","x03");',
        "31" => 'SELECT * FROM tb_equip WHERE id_owner=x00;',
        "32" => 'CALL sp_addEquip("x00","x01","x02","x03","x04","x05")',
        "33" => 'CALL sp_addEquipManut("x00","x01","x02","x03","x04")',
        "34" => 'SELECT * FROM tb_equip_manut WHERE id_equip=x00;',
        "35" => 'CALL sp_delEquipManut("x00")',
        "36" => 'CALL sp_delEquip("x00")',
        "37" => 'CALL sp_newTorn("x00",x01,"x02",x03,x04,x05,x06,"x07");',
        "38" => 'CALL sp_delTorn("x00")',
        "39" => 'SELECT * FROM vw_my_torn WHERE id_atleta=x00 OR id_owner=x00 GROUP BY id',
        "40" => 'SELECT * FROM vw_torn WHERE id=x00',
        "41" => 'CALL sp_inviteTorn("x00",x01,x02)',
        "42" => 'SELECT * FROM vw_torn_invite WHERE id_torn=x00;',
        "43" => 'CALL sp_acceptInviteTorn("x00",x01,x02);',
        "44" => 'CALL sp_fillPlayerTorn("x00",x01,"x02");',
        "45" => 'SELECT * FROM vw_torn_jogo WHERE id_torn=x00 ORDER BY grupo;',
        "46" => 'CALL sp_torn_gamesets("x00",x01,x02,"x03");',
        "47" => 'CALL sp_tornJogoUpdate("x00",x01,x02,x03,x04,"x05")',
        "48" => 'SELECT * FROM vw_tabela WHERE id_torn=x00 ORDER BY grupo, WIN DESC, SET_SALDO DESC, GAME_SALDO DESC;'

    );

    $query_json = array(
        
        "1" => "CALL sp_AtvAtl(\"@OWNER\",@CLAUSE,'(@FIELDS)','(@VALUES)');",
        "2" => "CALL sp_sets(\"@OWNER\",@CLAUSE,'(@FIELDS)','(@VALUES)');",
        "3" => "CALL sp_gameTorn(\"@OWNER\",@CLAUSE,'(@FIELDS)','(@VALUES)');",
        "4" => "CALL sp_addcourts_torn(\"@OWNER\",@CLAUSE,'(@FIELDS)','(@VALUES)');",
        "5" => "CALL sp_atvGuest(\"@OWNER\",@CLAUSE,'(@FIELDS)','(@VALUES)');",
        

    );


?>