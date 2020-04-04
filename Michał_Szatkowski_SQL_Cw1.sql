
CREATE DATABASE s293246;
CREATE SCHEMA firma;
CREATE ROLE ksiegowosc;
GRANT USAGE ON SCHEMA firma TO ksiegowosc;
GRANT SELECT ON all tables IN SCHEMA "firma" TO ksiegowosc;

CREATE TABLE firma.pracownicy (
	id_pracownika SERIAL,
	imie VARCHAR(20) NOT NULL,
	nazwisko VARCHAR(20) NOT NULL,
	adres VARCHAR(40) NOT NULL,
	telefon VARCHAR(40) NOT NULL
);

ALTER TABLE firma.pracownicy ADD CONSTRAINT pracownicy_pk PRIMARY KEY(id_pracownika);
COMMENT ON TABLE firma.pracownicy IS 'Tabela zawierająca dane o pracownikach';
CREATE INDEX id_index ON firma.pracownicy USING btree (nazwisko);

CREATE TABLE firma.godziny (
	id_godziny SERIAL,
	data DATE NOT NULL,
	liczba_godzin INT NOT NULL,
	id_pracownika INT NOT NULL
);

ALTER TABLE firma.godziny ADD CONSTRAINT godziny_pk PRIMARY KEY(id_godziny);
COMMENT ON TABLE firma.godziny IS 'Tabela zawierająca informacje o godzinach';

CREATE TABLE firma.pensja_stanowisko (
    id_pensji SERIAL NOT NULL,
    stanowisko VARCHAR(20)  NOT NULL,
    kwota DECIMAL(8,2)  NOT NULL
);

ALTER TABLE firma.pensja_stanowisko ADD CONSTRAINT pensja_stanowiwsko_pk PRIMARY KEY(id_pensji);
COMMENT ON TABLE firma.pensja_stanowisko IS 'Tabela zawierająca informacje o stanowiskach i pensjach';

CREATE TABLE firma.premia (
    id_premii SERIAL NOT NULL,
    rodzaj VARCHAR(20)  NOT NULL,
    kwota DECIMAL(8,2)  NOT NULL
);

ALTER TABLE firma.premia ADD CONSTRAINT premia_pk PRIMARY KEY(id_premii);
COMMENT ON TABLE firma.premia IS 'Tabela zawierająca informacje o premiach';

CREATE TABLE firma.wynagrodzenie (
    id_wynagrodzenia SERIAL NOT NULL,
    data DATE NOT NULL,
    id_pracownika INT NOT NULL,
    id_godziny INT NOT NULL,
    id_pensji INT NOT NULL,
    id_premii INT NOT NULL
);

ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_pk PRIMARY KEY(id_wynagrodzenia);
COMMENT ON TABLE firma.wynagrodzenie IS 'Tabela zawierająca informacje o wynagrodzeniach';

ALTER TABLE firma.godziny ADD CONSTRAINT godziny_pracownicy
    FOREIGN KEY (id_pracownika)
    REFERENCES firma.pracownicy (id_pracownika)  
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_pracownicy
    FOREIGN KEY (id_pracownika)
    REFERENCES firma.pracownicy (id_pracownika)  
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_godziny
    FOREIGN KEY (id_godziny)
    REFERENCES firma.godziny (id_godziny)  
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_pensja_stanowisko
    FOREIGN KEY (id_pensji)
    REFERENCES firma.pensja_stanowisko (id_pensji)  
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

ALTER TABLE firma.wynagrodzenie ADD CONSTRAINT wynagrodzenie_premia
    FOREIGN KEY (id_premii)
    REFERENCES firma.premia (id_premii)  
    ON DELETE CASCADE
    ON UPDATE CASCADE
;

ALTER TABLE firma.godziny ADD miesiac INT NOT NULL;
ALTER TABLE firma.godziny ADD tydzien INT NOT NULL;

ALTER TABLE firma.wynagrodzenie ALTER COLUMN "data" TYPE VARCHAR(20);

ALTER TABLE firma.premia ALTER COLUMN rodzaj DROP NOT NULL;
ALTER TABLE firma.wynagrodzenie ALTER COLUMN id_premii DROP NOT NULL;

INSERT INTO firma.pracownicy (imie, nazwisko, adres, telefon) VALUES ('Borys', 'Bułat', 'Lodowa 435', 16786489);
INSERT INTO firma.pracownicy (imie, nazwisko, adres, telefon) VALUES ('Olaf', 'Skald', 'Górska 35', 170434043);
INSERT INTO firma.pracownicy (imie, nazwisko, adres, telefon) VALUES ('Julia', 'Trep', 'Wiejska 36', 123444999);
INSERT INTO firma.pracownicy (imie, nazwisko, adres, telefon) VALUES ('Joanna', 'Nora', 'Nowomiastowa 88', 234657435);
INSERT INTO firma.pracownicy (imie, nazwisko, adres, telefon) VALUES ('Lidia', 'Król', 'Zamkowa 22', 245097862);
INSERT INTO firma.pracownicy (imie, nazwisko, adres, telefon) VALUES ('Michał', 'Wieżowski', 'Wolnorynkowa 2', 259687654);
INSERT INTO firma.pracownicy (imie, nazwisko, adres, telefon) VALUES ('Maksymilian', 'Wrzesień', 'Bordowa 30', 268752345);
INSERT INTO firma.pracownicy (imie, nazwisko, adres, telefon) VALUES ('Anna', 'Myto', 'Juliusza 23', 457382026);
INSERT INTO firma.pracownicy (imie, nazwisko, adres, telefon) VALUES ('Zenon', 'Miejski', 'Skowowskiego 84', 728938293);
INSERT INTO firma.pracownicy (imie, nazwisko, adres, telefon) VALUES ('Julian', 'Braniec', 'Rynkowa 46', 908475743);

INSERT INTO firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) VALUES ('2020-01-20', 180, 1, EXTRACT(MONTH FROM DATE '2020-01-20'), EXTRACT(WEEK FROM DATE '2020-01-20'));
INSERT INTO firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) VALUES ('2020-01-01', 170, 2, EXTRACT(MONTH FROM DATE '2020-01-01'), EXTRACT(WEEK FROM DATE '2020-01-01'));
INSERT INTO firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) VALUES ('2020-01-01', 182, 3, EXTRACT(MONTH FROM DATE '2020-01-01'), EXTRACT(WEEK FROM DATE '2020-01-01'));
INSERT INTO firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) VALUES ('2020-01-04', 199, 4, EXTRACT(MONTH FROM DATE '2020-01-04'), EXTRACT(WEEK FROM DATE '2020-01-04'));
INSERT INTO firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) VALUES ('2020-01-22', 168, 5, EXTRACT(MONTH FROM DATE '2020-01-22'), EXTRACT(WEEK FROM DATE '2020-01-22'));
INSERT INTO firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) VALUES ('2020-01-13', 179, 6, EXTRACT(MONTH FROM DATE '2020-01-13'), EXTRACT(WEEK FROM DATE '2020-01-13'));
INSERT INTO firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) VALUES ('2020-01-03', 140, 7, EXTRACT(MONTH FROM DATE '2020-01-03'), EXTRACT(WEEK FROM DATE '2020-01-03'));
INSERT INTO firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) VALUES ('2020-01-06', 190, 8, EXTRACT(MONTH FROM DATE '2020-01-06'), EXTRACT(WEEK FROM DATE '2020-01-06'));
INSERT INTO firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) VALUES ('2020-01-11', 180, 9, EXTRACT(MONTH FROM DATE '2020-01-11'), EXTRACT(WEEK FROM DATE '2020-01-11'));
INSERT INTO firma.godziny (data, liczba_godzin, id_pracownika, miesiac, tydzien) VALUES ('2020-01-14', 200, 10, EXTRACT(MONTH FROM DATE '2020-01-14'), EXTRACT(WEEK FROM DATE '2020-01-14'));

INSERT INTO firma.pensja_stanowisko (stanowisko, kwota) VALUES ('Kierownik Zmiany', 8000);
INSERT INTO firma.pensja_stanowisko (stanowisko, kwota) VALUES ('Programista', 7000);
INSERT INTO firma.pensja_stanowisko (stanowisko, kwota) VALUES ('Kierownik', 10000);
INSERT INTO firma.pensja_stanowisko (stanowisko, kwota) VALUES ('Dyrektor', 200000);
INSERT INTO firma.pensja_stanowisko (stanowisko, kwota) VALUES ('Ochroniarz', 2900);
INSERT INTO firma.pensja_stanowisko (stanowisko, kwota) VALUES ('Sekretarz', 5000);
INSERT INTO firma.pensja_stanowisko (stanowisko, kwota) VALUES ('Stażysta', 550);
INSERT INTO firma.pensja_stanowisko (stanowisko, kwota) VALUES ('Menadżer', 6000);
INSERT INTO firma.pensja_stanowisko (stanowisko, kwota) VALUES ('Woźny', 2000);
INSERT INTO firma.pensja_stanowisko (stanowisko, kwota) VALUES ('Magazynier', 3000);

INSERT INTO firma.premia (rodzaj, kwota) VALUES ('Skuteczność', 200);
INSERT INTO firma.premia (rodzaj, kwota) VALUES ('Skuteczność', 500);
INSERT INTO firma.premia (rodzaj, kwota) VALUES ('Skuteczność', 1000);
INSERT INTO firma.premia (rodzaj, kwota) VALUES ('Brak', 0);
INSERT INTO firma.premia (rodzaj, kwota) VALUES ('Nadgodziny', 300);
INSERT INTO firma.premia (rodzaj, kwota) VALUES ('Nadgodziny', 400);
INSERT INTO firma.premia (rodzaj, kwota) VALUES ('Nadgodziny', 800);
INSERT INTO firma.premia (rodzaj, kwota) VALUES ('Pomocność', 300);
INSERT INTO firma.premia (rodzaj, kwota) VALUES ('Pomocność', 400);
INSERT INTO firma.premia (rodzaj, kwota) VALUES ('Pomocność', 500);

INSERT INTO firma.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES ('2020-02-03', 1, 1, 1, 7);
INSERT INTO firma.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES ('2020-02-03', 2, 2, 3, 6);
INSERT INTO firma.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES ('2020-02-03', 3, 3, 3, 1);
INSERT INTO firma.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES ('2020-02-03', 4, 4, 8, 3);
INSERT INTO firma.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES ('2020-02-03', 5, 5, 7, 4);
INSERT INTO firma.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES ('2020-02-05', 6, 6, 5, 4);
INSERT INTO firma.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES ('2020-02-05', 7, 7, 4, 4);
INSERT INTO firma.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES ('2020-02-05', 8, 8, 9, 10);
INSERT INTO firma.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES ('2020-02-05', 9, 9, 2, 6);
INSERT INTO firma.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES ('2020-02-05', 10, 10, 1, 10);

SELECT id_pracownika, nazwisko FROM firma.pracownicy;

SELECT wynagrodzenie.id_pracownika FROM firma.wynagrodzenie INNER JOIN firma.pensja_stanowisko ON pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji
INNER JOIN firma.premia ON premia.id_premii = wynagrodzenie.id_premii WHERE premia.kwota + pensja_stanowisko.kwota > 1000;

SELECT wynagrodzenie.id_pracownika FROM firma.wynagrodzenie INNER JOIN firma.pensja_stanowisko ON pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji
INNER JOIN firma.premia ON premia.id_premii = wynagrodzenie.id_premii WHERE premia.kwota = 0 AND pensja_stanowisko.kwota > 2000;

SELECT imie, nazwisko, adres, telefon FROM firma.pracownicy WHERE imie LIKE 'J%';

SELECT imie, nazwisko, adres, telefon FROM firma.pracownicy WHERE nazwisko LIKE 'N%' AND imie LIKE '%a';

SELECT pracownicy.imie, pracownicy.nazwisko, CASE WHEN godziny.liczba_godzin<160 THEN 0 ELSE godziny.liczba_godzin-160 END AS "nadgodziny" 
FROM firma.pracownicy INNER JOIN firma.godziny godziny ON pracownicy.id_pracownika = godziny.id_pracownika;

SELECT pracownicy.imie, pracownicy.nazwisko FROM firma.pracownicy INNER JOIN firma.wynagrodzenie ON wynagrodzenie.id_pracownika = pracownicy.id_pracownika 
INNER JOIN firma.pensja_stanowisko ON wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji WHERE pensja_stanowisko.kwota >= 1500 AND pensja_stanowisko.kwota <= 3000;

SELECT pracownicy.imie, pracownicy.nazwisko FROM firma.pracownicy INNER JOIN firma.godziny ON pracownicy.id_pracownika = godziny.id_pracownika 
INNER JOIN firma.wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika INNER JOIN firma.premia ON wynagrodzenie.id_premii = premia.id_premii 
WHERE premia.kwota = 0 AND godziny.liczba_godzin > 160;

SELECT pracownicy.*, pensja_stanowisko.kwota FROM firma.pracownicy INNER JOIN firma.wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
INNER JOIN firma.pensja_stanowisko ON pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji ORDER BY pensja_stanowisko.kwota;

SELECT pracownicy.*, pensja_stanowisko.kwota+premia.kwota AS "pensja i premia" FROM firma.pracownicy INNER JOIN firma.wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika 
INNER JOIN firma.pensja_stanowisko ON pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji INNER JOIN firma.premia ON premia.id_premii = wynagrodzenie.id_premii ORDER BY pensja_stanowisko.kwota+premia.kwota DESC;

SELECT pensja_stanowisko.stanowisko, COUNT(pensja_stanowisko.stanowisko) FROM firma.pensja_stanowisko INNER JOIN firma.wynagrodzenie ON pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji 
INNER JOIN firma.pracownicy ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika GROUP BY pensja_stanowisko.stanowisko;

SELECT pensja_stanowisko.stanowisko, AVG(pensja_stanowisko.kwota+premia.kwota), MIN(pensja_stanowisko.kwota+premia.kwota), MAX(pensja_stanowisko.kwota+premia.kwota) FROM firma.pensja_stanowisko 
INNER JOIN firma.wynagrodzenie ON pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji INNER JOIN firma.premia ON premia.id_premii = wynagrodzenie.id_premii WHERE pensja_stanowisko.stanowisko = 'Kierownik' GROUP BY pensja_stanowisko.stanowisko;

SELECT SUM(pensja_stanowisko.kwota+premia.kwota) AS "Suma wszystkich wynagrodzeń" FROM firma.wynagrodzenie INNER JOIN firma.pensja_stanowisko ON wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji 
INNER JOIN firma.premia ON wynagrodzenie.id_premii = premia.id_premii;

SELECT pensja_stanowisko.stanowisko, SUM(pensja_stanowisko.kwota+premia.kwota) AS "Suma wynagrodzeń na stanowisko" FROM firma.wynagrodzenie 
INNER JOIN firma.pensja_stanowisko ON wynagrodzenie.id_pensji = pensja_stanowisko.id_pensji INNER JOIN firma.premia ON wynagrodzenie.id_premii = premia.id_premii GROUP BY pensja_stanowisko.stanowisko;

SELECT pensja_stanowisko.stanowisko, COUNT(premia.kwota>0) AS "Liczba premii" FROM firma.pensja_stanowisko INNER JOIN firma.wynagrodzenie ON pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji 
INNER JOIN firma.premia ON premia.id_premii = wynagrodzenie.id_premii WHERE premia.kwota > 0 GROUP BY pensja_stanowisko.stanowisko;

DELETE FROM firma.pracownicy USING firma.wynagrodzenie, firma.pensja_stanowisko WHERE pracownicy.id_pracownika = wynagrodzenie.id_pracownika AND pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji AND pensja_stanowisko.kwota < 1200;

UPDATE firma.pracownicy SET telefon=CONCAT('(+48) ', telefon);

UPDATE firma.pracownicy SET telefon=CONCAT(SUBSTRING(telefon, 1, 9), '-', SUBSTRING(telefon, 10, 3), '-', SUBSTRING(telefon, 13, 3));

SELECT imie, UPPER(nazwisko) AS "nazwisko", adres, telefon FROM firma.pracownicy WHERE LENGTH(nazwisko) = (SELECT MAX(length(nazwisko)) FROM firma.pracownicy);

SELECT md5(pracownicy.imie) AS "imie", md5(pracownicy.nazwisko) AS "nazwisko", md5(pracownicy.adres) AS "adres", md5(pracownicy.telefon) AS "telefon", md5(CAST(pensja_stanowisko.kwota AS VARCHAR(20))) AS "pensja" FROM firma.pracownicy 
INNER JOIN firma.wynagrodzenie ON wynagrodzenie.id_pracownika = pracownicy.id_pracownika INNER JOIN firma.pensja_stanowisko ON pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji;

SELECT CONCAT('Pracownik ', pracownicy.imie, ' ', pracownicy.nazwisko, ', w dniu ', wynagrodzenie."data", ' otrzymał pensję całkowitą na kwotę ', pensja_stanowisko.kwota+premia.kwota,'zł, gdzie wynagrodzenie zasadnicze wynosiło: ', pensja_stanowisko.kwota, 'zł, premia: ', premia.kwota, 'zł.') 
AS "raport" FROM firma.pracownicy INNER JOIN firma.wynagrodzenie ON pracownicy.id_pracownika = wynagrodzenie.id_pracownika INNER JOIN firma.pensja_stanowisko ON pensja_stanowisko.id_pensji = wynagrodzenie.id_pensji INNER JOIN firma.premia ON premia.id_premii = wynagrodzenie.id_premii;
