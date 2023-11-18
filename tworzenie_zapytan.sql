/* Tworzenie zapytań */
-- Wybieranie informacji z tabel


-- 1. Wykaz obłożenia miejsc noclegowych w hotelach w Polsce w 2022 r. 

SELECT DISTINCT rodzaje_obiektow
FROM st_wykorzystania_miejsc_noclegowych;

SELECT rodzaje_obiektow, wartosc AS "oblozenie_%_2022"
FROM st_wykorzystania_miejsc_noclegowych
WHERE nazwa = 'POLSKA' AND rok = 2022
ORDER BY wartosc DESC NULLS LAST;


-- 2. Wykaz wskaźników obłożenia obiektów noclegowych w Polsce według rodzaju w latach 2018-2022.  

COPY
(SELECT 
	t1.rodzaje_obiektow, 
	t1."oblozenie_%_2018", 
	t2."oblozenie_%_2019",
	t3."oblozenie_%_2020",
	t4."oblozenie_%_2021",
	t5."oblozenie_%_2022"
FROM (SELECT rodzaje_obiektow, wartosc AS "oblozenie_%_2018"
	FROM st_wykorzystania_miejsc_noclegowych
	WHERE nazwa = 'POLSKA' AND rok = 2018 AND wartosc IS NOT NULL) as t1
	, 
	(SELECT rodzaje_obiektow, wartosc AS "oblozenie_%_2019"
	FROM st_wykorzystania_miejsc_noclegowych
	WHERE nazwa = 'POLSKA' AND rok = 2019 AND wartosc IS NOT NULL) as t2
	,
	(SELECT rodzaje_obiektow, wartosc AS "oblozenie_%_2020"
	FROM st_wykorzystania_miejsc_noclegowych
	WHERE nazwa = 'POLSKA' AND rok = 2020 AND wartosc IS NOT NULL) as t3
	,
	(SELECT rodzaje_obiektow, wartosc AS "oblozenie_%_2021"
	FROM st_wykorzystania_miejsc_noclegowych
	WHERE nazwa = 'POLSKA' AND rok = 2021 AND wartosc IS NOT NULL) as t4
	,
	(SELECT rodzaje_obiektow, wartosc AS "oblozenie_%_2022"
	FROM st_wykorzystania_miejsc_noclegowych
	WHERE nazwa = 'POLSKA' AND rok = 2022 AND wartosc IS NOT NULL) as t5
WHERE t1.rodzaje_obiektow = t2.rodzaje_obiektow 
		AND t1.rodzaje_obiektow = t3.rodzaje_obiektow
		AND t1.rodzaje_obiektow = t4.rodzaje_obiektow
		AND t1.rodzaje_obiektow = t5.rodzaje_obiektow
ORDER BY "oblozenie_%_2022" DESC
)
TO '<ROOT_PATH>\wyniki\Oblozenie_obiektow_noclegowych_w_2018-2022.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- 3. Wykaz różnic w obłożeniu obiektów noclegowych w 2022 r. w porównaniu do 2018 r. 

COPY
(SELECT 
	t1.rodzaje_obiektow, 
	t1."oblozenie_%_2018", 
	t5."oblozenie_%_2022",
	"oblozenie_%_2022" - "oblozenie_%_2018" AS "wzrost/spadek (p.p.)"
FROM (SELECT rodzaje_obiektow, wartosc AS "oblozenie_%_2018"
	FROM st_wykorzystania_miejsc_noclegowych
	WHERE nazwa = 'POLSKA' AND rok = 2018 AND wartosc IS NOT NULL) as t1
	,
	(SELECT rodzaje_obiektow, wartosc AS "oblozenie_%_2022"
	FROM st_wykorzystania_miejsc_noclegowych
	WHERE nazwa = 'POLSKA' AND rok = 2022 AND wartosc IS NOT NULL) as t5
WHERE t1.rodzaje_obiektow = t5.rodzaje_obiektow
ORDER BY "wzrost/spadek (p.p.)" DESC
)
TO '<ROOT_PATH>\wyniki\Roznica_oblozenia_obiektow_noclegowych_2018-2022.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- 4. Zestawienie obłożenia wszystkich hoteli w Polsce w latach 2002 - 2022. 

COPY
(SELECT rok, wartosc AS "oblozenie_hoteli_%"
FROM st_wykorzystania_miejsc_noclegowych
WHERE 
	nazwa = 'POLSKA' AND 
	rodzaje_obiektow ='hotele' AND 
	rok BETWEEN 2002 AND 2022
ORDER BY rok ASC
)
TO '<ROOT_PATH>\wyniki\Oblozenie_hoteli_w_Polsce_w_latach_2002-2022.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- 5. Lista najmniejszego i największego obłożenia hoteli w Polsce w latach 2002-2022. 

SELECT max(wartosc), min(wartosc)
FROM st_wykorzystania_miejsc_noclegowych
WHERE 
	nazwa = 'POLSKA' AND 
	rodzaje_obiektow ='hotele';
	
SELECT rok, wartosc 
FROM st_wykorzystania_miejsc_noclegowych
WHERE wartosc = '44.10' or wartosc = '26.00' AND 
	nazwa = 'POLSKA' AND 
	rodzaje_obiektow ='hotele'
ORDER BY wartosc, rok;


-- 6. Zestawienie wykorzystania miejsc noclegowych w poszczególnych województwach w 2022 r.  

COPY
(SELECT nazwa AS "wojewodztwo", round((sum(wartosc)/count(nazwa)),2) AS "wartosc (%)"
FROM st_wykorzystania_miejsc_noclegowych
WHERE 
	nazwa NOT ILIKE 'POLSKA' AND 
	rodzaje_obiektow NOT ILIKE 'ogółem' AND
	rok = 2022 AND
	wartosc IS NOT NULL AND 
	wartosc > 0
GROUP BY nazwa
ORDER BY "wartosc (%)" DESC
)
TO '<ROOT_PATH>\wyniki\Wykorzystanie_obiektow_noclegowych_w_wojewodztwach_w_2022.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- 7. Wyróżnienie rodzajów udogodnień, które są najbardziej powszechne w miejscach zakwaterowania oraz porównanie procentowe wyniku z 2021 r. do 2009 r.

SELECT DISTINCT rodzaje_udogodnien
FROM obiekty_z_udogodnieniem_dla_niepelnosprawnych;

UPDATE obiekty_z_udogodnieniem_dla_niepelnosprawnych
SET rodzaje_udogodnien = 'winda przystosowana dla osób niepełnosprawnych'
WHERE rodzaje_udogodnien = 'winda przystosowana dla osób niepełnosprawnych ruchowo';

UPDATE obiekty_z_udogodnieniem_dla_niepelnosprawnych
SET rodzaje_udogodnien = 'pokoje/łazienki przystosowane dla osób niepełnosprawnych'
WHERE rodzaje_udogodnien = 'pokoje/łazienki przystosowane dla osób niepełnosprawnych ruchowo (w tym na wózkach inwalidzkich)';

UPDATE obiekty_z_udogodnieniem_dla_niepelnosprawnych
SET rodzaje_udogodnien = 'parking z wyznaczonymi miejscami dla osób niepełnosprawnych'
WHERE rodzaje_udogodnien = 'parking z wyznaczonymi miejscami dla osób niepełnosprawnych ruchowo';

SELECT 
t1.rodzaje_udogodnien, 
t1."ilosc_2021",
t2."ilosc_2009",
t1."ilosc_2021" - t2."ilosc_2009" AS "roznica_ilosciowa",
CAST(ROUND(((t1."ilosc_2021"::numeric - t2."ilosc_2009"::numeric)* 100 )/(t2."ilosc_2009"::numeric),2) AS numeric(5,2)) 
AS "roznica_procentowa"
FROM 
	(SELECT rodzaje_udogodnien, sum(wartosc) AS "ilosc_2021"
	FROM obiekty_z_udogodnieniem_dla_niepelnosprawnych
	WHERE 
	rok = 2021 
	GROUP BY rodzaje_udogodnien) AS t1
JOIN
	(SELECT rodzaje_udogodnien, sum(wartosc) AS "ilosc_2009"
	FROM obiekty_z_udogodnieniem_dla_niepelnosprawnych
	WHERE  
	rok = 2009 
	GROUP BY rodzaje_udogodnien) AS t2
ON t1.rodzaje_udogodnien = t2.rodzaje_udogodnien
ORDER BY "ilosc_2021" DESC NULLS LAST;