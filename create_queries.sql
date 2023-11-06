 /* Creating queries */
-- Select information from tables


-- 1. List the occupancy of accommodation hotels in Poland in 2022 r. 

SELECT DISTINCT rodzaje_obiektów
FROM St_wykorzystania_miejsc_noclegowych;

SELECT rodzaje_obiektów, wartosc AS "obłożenie_%_2022"
FROM St_wykorzystania_miejsc_noclegowych
WHERE Nazwa = 'POLSKA' AND rok = 2022
ORDER BY wartosc DESC NULLS LAST;


-- 2. List the occupancy rate of each accommodation facility in Poland from 2018 to 2022.  

COPY
(SELECT 
	t1.rodzaje_obiektów, 
	t1."obłożenie_%_2018", 
	t2."obłożenie_%_2019",
	t3."obłożenie_%_2020",
	t4."obłożenie_%_2021",
	t5."obłożenie_%_2022"
FROM (SELECT rodzaje_obiektów, wartosc AS "obłożenie_%_2018"
	FROM St_wykorzystania_miejsc_noclegowych
	WHERE Nazwa = 'POLSKA' AND rok = 2018 AND wartosc IS NOT NULL) as t1
	, 
	(SELECT rodzaje_obiektów, wartosc AS "obłożenie_%_2019"
	FROM St_wykorzystania_miejsc_noclegowych
	WHERE Nazwa = 'POLSKA' AND rok = 2019 AND wartosc IS NOT NULL) as t2
	,
	(SELECT rodzaje_obiektów, wartosc AS "obłożenie_%_2020"
	FROM St_wykorzystania_miejsc_noclegowych
	WHERE Nazwa = 'POLSKA' AND rok = 2020 AND wartosc IS NOT NULL) as t3
	,
	(SELECT rodzaje_obiektów, wartosc AS "obłożenie_%_2021"
	FROM St_wykorzystania_miejsc_noclegowych
	WHERE Nazwa = 'POLSKA' AND rok = 2021 AND wartosc IS NOT NULL) as t4
	,
	(SELECT rodzaje_obiektów, wartosc AS "obłożenie_%_2022"
	FROM St_wykorzystania_miejsc_noclegowych
	WHERE Nazwa = 'POLSKA' AND rok = 2022 AND wartosc IS NOT NULL) as t5
WHERE t1.rodzaje_obiektów = t2.rodzaje_obiektów 
		AND t1.rodzaje_obiektów = t3.rodzaje_obiektów
		AND t1.rodzaje_obiektów = t4.rodzaje_obiektów
		AND t1.rodzaje_obiektów = t5.rodzaje_obiektów
ORDER BY "obłożenie_%_2022" DESC
)
TO 'D:\projekt_1\Oblozenie_obiektow_noclegowych_w_2018-2022.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- 3. List the difference in the occupancy of accommodation facilities in 2022 compared to 2018. In which facilities has there been an increase? 

COPY
(SELECT 
	t1.rodzaje_obiektów, 
	t1."obłożenie_%_2018", 
	t5."obłożenie_%_2018",
	"obłożenie_%_2022" - "obłożenie_%_2018" AS obłożenie_%_2018"
FROM (SELECT rodzaje_obiektów, wartosc AS "obłożenie_%_2018"
	FROM St_wykorzystania_miejsc_noclegowych
	WHERE Nazwa = 'POLSKA' AND rok = 2018 AND wartosc IS NOT NULL) as t1
	,
	(SELECT rodzaje_obiektów, wartosc AS "obłożenie_%_2022"
	FROM St_wykorzystania_miejsc_noclegowych
	WHERE Nazwa = 'POLSKA' AND rok = 2022 AND wartosc IS NOT NULL) as t5
WHERE t1.rodzaje_obiektów = t5.rodzaje_obiektów
ORDER BY "wzrost/spadek (p.p.)" DESC;
)
TO 'D:\projekt_1\Wzrost,spadek_obłożenia.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- 4. List the occupancy of all hotels in Poland in the years 2002 - 2022. 

COPY
(SELECT rok, wartosc AS "obłożenie_hoteli_%"
FROM St_wykorzystania_miejsc_noclegowych
WHERE 
	Nazwa = 'POLSKA' AND 
	rodzaje_obiektów ='hotele' AND 
	rok BETWEEN 2002 AND 2022
ORDER BY rok ASC
)
TO 'D:\projekt_1\Oblozenie_hoteli_w_Polsce_w_latach_2002-2022.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


-- 5. List the smallest and largest hotel occupancy in Poland in the years 2002 - 2022. 

SELECT max(wartosc), min(wartosc)
FROM St_wykorzystania_miejsc_noclegowych
WHERE 
	Nazwa = 'POLSKA' AND 
	rodzaje_obiektów ='hotele';
	
	
SELECT rok, wartosc 
FROM St_wykorzystania_miejsc_noclegowych
WHERE wartosc = (SELECT max(wartosc)
FROM St_wykorzystania_miejsc_noclegowych
WHERE 
	Nazwa = 'POLSKA' AND 
	rodzaje_obiektów ='hotele')
ORDER BY rok;


SELECT rok, wartosc 
FROM St_wykorzystania_miejsc_noclegowych
WHERE wartosc = (SELECT min(wartosc)
FROM St_wykorzystania_miejsc_noclegowych
WHERE 
	Nazwa = 'POLSKA' AND 
	rodzaje_obiektów ='hotele')
ORDER BY rok;

-- 6. List the use of accommodation places in each region in 2022 r.  

COPY
(SELECT nazwa AS "województwo", round((sum(wartosc)/count(nazwa)),2) AS "wartość (%)"
FROM St_wykorzystania_miejsc_noclegowych
WHERE 
	Nazwa NOT ILIKE 'POLSKA' AND 
	rodzaje_obiektów NOT ILIKE 'ogółem' AND
	rok = 2022 AND
	wartosc IS NOT NULL AND 
	wartosc > 0
GROUP BY nazwa
ORDER BY "wartość (%)" DESC
)
TO 'D:\projekt_1\Wykorzystanie_obiektow_noclegowych_w_wojewodztwach_w_2022.csv'
WITH (FORMAT CSV, HEADER, DELIMITER ',');


7. List the type of amenities that are most common in accommodation places and compare the percentage of 2022 to 2002. 

SELECT DISTINCT rodzaje_udogodnień
FROM obiekty_z_udogodnieniem_dla_niepełnosprawnych;


UPDATE obiekty_z_udogodnieniem_dla_niepełnosprawnych
SET rodzaje_udogodnień = 'winda przystosowana dla osób niepełnosprawnych'
WHERE rodzaje_udogodnień = 'winda przystosowana dla osób niepełnosprawnych ruchowo';

UPDATE obiekty_z_udogodnieniem_dla_niepełnosprawnych
SET rodzaje_udogodnień = 'pokoje/łazienki przystosowane dla osób niepełnosprawnych'
WHERE rodzaje_udogodnień = 'pokoje/łazienki przystosowane dla osób niepełnosprawnych ruchowo (w tym na wózkach inwalidzkich)';

SELECT 
t1.rodzaje_udogodnień, 
t1."ilość_2021",
t2."ilość_2009",
t1."ilość_2021" - t2."ilość_2009" AS "różnica_ilościowa",
CAST(ROUND(((t1."ilość_2021"::numeric - t2."ilość_2009"::numeric)* 100 )/(t2."ilość_2009"::numeric),2) AS numeric(5,2)) 
AS "różnica_procentowa"
FROM 
	(SELECT rodzaje_udogodnień, sum(wartosc) AS "ilość_2021"
	FROM obiekty_z_udogodnieniem_dla_niepełnosprawnych
	WHERE 
	rok = 2021 
	GROUP BY rodzaje_udogodnień) AS t1
JOIN
	(SELECT rodzaje_udogodnień, sum(wartosc) AS "ilość_2009"
	FROM obiekty_z_udogodnieniem_dla_niepełnosprawnych
	WHERE  
	rok = 2009 
	GROUP BY rodzaje_udogodnień) AS t2
ON t1.rodzaje_udogodnień = t2.rodzaje_udogodnień
ORDER BY "ilość_2021" DESC NULLS LAST;