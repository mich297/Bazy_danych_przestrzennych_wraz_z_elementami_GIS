--zad1
--zadanie wykonano za pomocą zmiany stylu zmiennej unikalnej w ustawieniach. Ustawiono parametr VEGDESC jako zmienną unikalną.

--zad2
--zadanie wykonano za pomocą opcji "podziel warstwę wektorową", jako pole z unikalnym ID ustawiając po raz kolejny VEGDESC.

--zad3
--wykorzystano "okno SQL", znajdujące się w "Bazy danych->Zarządzanie bazami".
SELECT SUM(ST_Length(railroads.geometry)) AS Dlugosc_linii_kolejowych FROM regions, railroads WHERE regions.NAME_2='Matanuska-Susitna';

--zad4
--wykorzystano "Okno SQL". 
SELECT AVG(airports.ELEV) FROM airports WHERE airports.USE='Military';
SELECT COUNT(airports.ELEV) AS 'Liczba lotnisk' FROM airports WHERE airports.USE='Military'; --Przed następnym krokiem lotnisk było 8.
-- do dalszej części zadania wykorzystano funkcję "Otwórz tabelę atrybutów", po czym "Zaznacz obiekty używając wyrażenia".
USE='Military' AND ELEV>1400
--Było tylko jedno takie lotnisko. Usunięto je za pomocą funkcji "Usuń zaznaczone obiekty".

--zad5
--wykorzystano "Okno SQL".
--Warstwa w której znajdują się jedynie budynki z Bristol Bay:
SELECT * FROM popp, regions WHERE regions.NAME_2='Bristol Bay' AND popp.F_CODEDESC='Building' AND Contains(regions.geometry, popp.geometry);
--Ich ilość:
SELECT COUNT(*) AS 'Liczba Budynków' FROM popp, regions WHERE popp.F_CODEDESC='Building' AND regions.NAME_2='Bristol Bay' AND Contains(regions.geometry, popp.geometry);
--Wyszukiwanie które z budynków znajdują się w odległości 100km. Nazwy rzek pobrano z mapy. Nie tworzono nowej warstwy, gdyż są to dokłądnie te same budynki co poprzednio.
SELECT Zad5.cat, Zad5.F_CODEDESC, Zad5.F_CODE, Zad5.TYPE, Zad5.ID, Zad5.NAME_2, Zad5.TYPE_2, Zad5.geometry FROM Zad5, rivers WHERE (rivers.NAM='ALAGNAK RIVER' OR rivers.NAM='KING SALMON CREEK') AND Contains(Buffer(rivers.geometry, 100000), Zad5.geometry)
--Ich ilość:
SELECT COUNT(*) AS 'Liczba Budynków' FROM Zad5, rivers WHERE (rivers.NAM='ALAGNAK RIVER' OR rivers.NAM='KING SALMON CREEK') AND Contains(Buffer(rivers.geometry, 100000), Zad5.geometry);

--zad6
--wykorzystano opcje "narzędzia analizy -> przecięcia lniii" i "okna SQL".
SELECT COUNT(*) AS 'Liczba przecięć' FROM Zad6Przeciecia;

--zad7
--wykorzystano opcję "narzędzia geometrii->Wydobądź wierzchołki" i "Okno SQL". 
SELECT COUNT(*)  AS 'Liczba węzłów' FROM Zad7KolejWezly;

--zad 8
--Wykorzystano "Okno SQL", a także opcje znajdujące się w "Wektor->narzędzia geoprocesingu" takie jak "różnica" i "iloczyn". Powstała warstwa końcowa przedstawia najlepsze lokalizacje.
SELECT buffer(airports.geometry, 100000) FROM airports;
SELECT buffer(railroads.geometry, 50000) FROM railroads;
SELECT buffer(trails.geometry, 20000) FROM trails;

--zad9
--wykorzystano "Okno SQL" i opcje "Uprość geometrie".
SELECT( SELECT COUNT(*) AS valueOne FROM Zad9Wierzcholki) - ( SELECT COUNT(*) AS valueTwo FROM Zad9WierzcholkiUproszczone) AS 'różnica wierzchołków';
SELECT( SELECT st_area(geometry) AS valueOne FROM swamp) - ( SELECT st_area(geometry) AS valueTwo FROM Zad9UproszczonaGeometria) AS 'różnica pól';
