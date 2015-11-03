--CREATE VIEW origin AS
--    (SELECT city_no, name, lon, lat, to_city
--        FROM cities
--        JOIN paths ON (city_no = from_city)
--        WHERE name = 'Plovdiv');

SELECT origin.name, origin.lon, origin.lat,
       dest.name, dest.lon, dest.lat
    FROM origin,
         (SELECT c.city_no, c.name, c.lon, c.lat
            FROM origin o
            JOIN cities c ON (o.to_city = c.city_no))
         AS dest
    JOIN paths ON (dest.city_no = from_city)
