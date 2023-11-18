-- /* Tworzenie i kopiowanie tabel */

DROP TABLE IF EXISTS st_wykorzystania_miejsc_noclegowych; 
DROP TABLE IF EXISTS placowki_gastronomiczne;
DROP TABLE IF EXISTS obiekty_z_zapleczem_sportowo_rekreacyjnym;
DROP TABLE IF EXISTS obiekty_z_udogodnieniem_dla_niepelnosprawnych;
DROP TABLE IF EXISTS obiekty_z_zapleczem_konferencyjnym;
DROP TABLE IF EXISTS st_wykorzystania_hoteli;


-- Tabela 1. "stopień wykorzystania miejsc noclegowych"

CREATE TABLE st_wykorzystania_miejsc_noclegowych(
	kod varchar(10),
	nazwa varchar(30),
	rodzaje_obiektow varchar(100),
	rok INTEGER,
	wartosc decimal(5,2),
	jednostka_miary varchar(10),
	atrybut varchar(10)
);

COPY st_wykorzystania_miejsc_noclegowych
FROM '<ROOT_PATH>\dane\st_wykorzystania_miejsc_noclegowych.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');

-- Tabela 2. "placówki gastronomiczne"

CREATE TABLE placowki_gastronomiczne(
		kod varchar(10),
		nazwa varchar(30),
		rodzaje_obiektow varchar(100),
		rodzaje_placowek varchar(100),
		rok INTEGER,
		wartosc INTEGER,
		jednostka_miary varchar(10),
		atrybut varchar(10)
	);

COPY placowki_gastronomiczne
FROM '<ROOT_PATH>\dane\placowki_gastronomiczne.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');

-- Tabela 3. "obiekty z zapleczem sportowo rekreacyjnym"

CREATE TABLE obiekty_z_zapleczem_sportowo_rekreacyjnym(
		kod varchar(10),
		nazwa varchar(30),
		rodzaje_urzadzen varchar(100),
		rok INTEGER,
		wartosc INTEGER,
		jednostka_miary varchar(10),
		atrybut varchar(10)
	);

COPY obiekty_z_zapleczem_sportowo_rekreacyjnym
FROM '<ROOT_PATH>\dane\obiekty_z_zapleczem_sportowo_rekreacyjnym.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');

-- Tabela 4. "obiekty z udogodnieniem dla niepełnosprawnych"

CREATE TABLE obiekty_z_udogodnieniem_dla_niepelnosprawnych(
		kod varchar(10),
		nazwa varchar(30),
		rodzaje_udogodnien varchar(100),
		rok INTEGER,
		wartosc INTEGER,
		jednostka_miary varchar(10),
		atrybut varchar(10)
	);

COPY obiekty_z_udogodnieniem_dla_niepelnosprawnych
FROM '<ROOT_PATH>\dane\obiekty_z_udogodnieniem_dla_niepelnosprawnych.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');

-- Tabela 5. "obiekty z zapleczem konferencyjnym"

CREATE TABLE obiekty_z_zapleczem_konferencyjnym(
		kod varchar(10),
		nazwa varchar(30),
		zaplecze_konferencyjne varchar(100),
		rok INTEGER,
		wartosc INTEGER,
		jednostka_miary varchar(10),
		atrybut varchar(10)
	);

COPY obiekty_z_zapleczem_konferencyjnym
FROM '<ROOT_PATH>\dane\obiekty_z_zapleczem_konferencyjnym.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');

-- Tabela 6. "stopień wykorzystania hoteli"

CREATE TABLE st_wykorzystania_hoteli(
		kod varchar(10),
		nazwa varchar(30),
		wyszczegolnienie varchar(100),
		kategorie varchar(100),
		rok INTEGER,
		wartosc decimal(5,2),
		jednostka_miary varchar(10),
		atrybut varchar(10)
	);

COPY st_wykorzystania_hoteli
FROM '<ROOT_PATH>\dane\st_wykorzystania_hoteli.txt'
WITH (FORMAT CSV, HEADER,DELIMITER ';');