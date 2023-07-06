
CREATE VIEW vw_distance AS
	SELECT lat1,lng1,lat2,lng2,ROUND(6371 *
        acos(
            cos(radians(lat1)) *
            cos(radians(lat2)) *
            cos(radians(lng1) - radians(lng2)) +
            sin(radians(lat1)) *
            sin(radians(lat2))
        ),3) AS distance;


