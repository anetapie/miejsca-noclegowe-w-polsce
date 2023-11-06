/* Create and copy tables */

-- DROP TABLE 
-- -- St_wykorzystania_miejsc_noclegowych, 
-- -- placówki_gastronomiczne,
-- -- obiekty_z_zapleczem_sportowo_rekreacyjnym, 
-- -- obiekty_z_udogodnieniem_dla_niepełnosprawnych,
-- -- obiekty_z_zapleczem_konferencyjnym,
-- -- st_wykorzystania_hoteli;


-- Table 1.
CREATE TABLE St_wykorzystania_miejsc_noclegowych(
	Kod varchar(10),
	Nazwa varchar(30),
	Rodzaje_obiektów varchar(100),
	Rok INTEGER,
	Wartosc decimal(5,2),
	Jednostka_miary varchar(10),
	Atrybut varchar(10)
);

COPY St_wykorzystania_miejsc_noclegowych
FROM 'D:\project_accommodation_in_poland\St_wykorzystania_miejsc_noclegowych.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');

-- Table 2.

CREATE TABLE placowki_gastronomiczne(
		Kod varchar(10),
		Nazwa varchar(30),
		Rodzaje_obiektów varchar(100),
		Rodzaje_placówek varchar(100),
		Rok INTEGER,
		Wartosc INTEGER,
		Jednostka_miary varchar(10),
		Atrybut varchar(10)
	);

COPY placowki_gastronomiczne
FROM 'D:\project_accommodation_in_poland\Placowki_gastronomiczne.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');

-- Table 3.

CREATE TABLE obiekty_z_zapleczem_sportowo_rekreacyjnym(
		Kod varchar(10),
		Nazwa varchar(30),
		Rodzaje_urządzeń varchar(100),
		Rok INTEGER,
		Wartosc INTEGER,
		Jednostka_miary varchar(10),
		Atrybut varchar(10)
	);

COPY obiekty_z_zapleczem_sportowo_rekreacyjnym
FROM 'D:\project_accommodation_in_poland\obiekty_z_zapleczem_sportowo_rekreacyjnym.txt'
	WITH (FORMAT CSV, HEADER,DELIMITER ';');

-- Table 4.

CREATE TABLE obiekty_z_udogodnieniem_dla_niepełnosprawnych(
		Kod varchar(10),
		Nazwa varchar(30),
		Rodzaje_udogodnień varchar(100),
		Rok INTEGER,
		Wartosc INTEGER,
		Jednostka_miary varchar(10),
		Atrybut varchar(10)
	);

COPY obiekty_z_udogodnieniem_dla_niepełnosprawnych
FROM 'D:\project_accommodation_in_poland\Obiekty_z_udogodnieniem_dla_niepelnosprawnych.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');

-- Table 5.

CREATE TABLE obiekty_z_zapleczem_konferencyjnym(
		Kod varchar(10),
		Nazwa varchar(30),
		Zaplecze_konferencyjne varchar(100),
		Rok INTEGER,
		Wartosc INTEGER,
		Jednostka_miary varchar(10),
		Atrybut varchar(10)
	);

COPY obiekty_z_zapleczem_konferencyjnym
FROM 'D:\project_accommodation_in_poland\Obiekty_z_zapleczem_konferencyjnym.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');

-- Table 6.

CREATE TABLE st_wykorzystania_hoteli(
		Kod varchar(10),
		Nazwa varchar(30),
		Wyszczególnienie varchar(100),
		Kategorie varchar(100),
		Rok INTEGER,
		Wartosc decimal(5,2),
		Jednostka_miary varchar(10),
		Atrybut varchar(10)
	);

COPY st_wykorzystania_hoteli
FROM 'D:\project_accommodation_in_poland\St_wykorzystania_hoteli_wg_kategorii.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');