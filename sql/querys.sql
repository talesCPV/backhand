

SELECT *, ROUND(6371 *
        acos(
            cos(radians(-23.01491109452432)) *
            cos(radians(lat)) *
            cos(radians(-45.564878769127105) - radians(lng)) +
            sin(radians(-23.01491109452432)) *
            sin(radians(lat))
        ),3) AS distance
FROM tb_usuario; -- HAVING distance <= 5


SELECT ROUND(6371 *
        acos(
            cos(radians(-23.01491109452432)) *
            cos(radians(lat)) *
            cos(radians(-45.564878769127105) - radians(lng)) +
            sin(radians(-23.01491109452432)) *
            sin(radians(lat))
        ),3) AS distance
FROM tb_usuario; -- HAVING distance <= 5


SELECT ATV.*, SP.nome AS SPORT, EV.nome AS EVENTO, US.nome AS ATLETA, QD.lat, QD.lng , QD.nome AS QUADRA
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
			),3) ) <= 2

            ORDER BY ATV.dia DESC
            LIMIT 10;