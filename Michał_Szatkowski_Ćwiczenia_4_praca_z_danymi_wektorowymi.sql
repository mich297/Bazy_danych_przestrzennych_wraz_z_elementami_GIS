--1 (Zad4)
SELECT count(*) as liczba_budynkow FROM popp, majrivers WHERE Contains(Buffer(majrivers.Geometry,100000), popp.Geometry);

CREATE TABLE tableB AS SELECT popp.PKUID, popp.Geometry, popp.cat, popp.F_CODEDESC, popp.F_CODE, popp.TYPE FROM popp, majrivers WHERE Contains(Buffer(majrivers.Geometry, 100000), popp.Geometry) AND popp.F_CODEDESC='Building'; 

--2(Zad5)
CREATE TABLE airportsNew (
    NAME VARCHAR(80),
    Geometry BLOB,
    ELEV DOUBLE
)

INSERT INTO airportsNEW SELECT NAME, Geometry, ELEV FROM airports;

--2a
SELECT MbrMaxY(Geometry), NAME, ELEV FROM airportsNew LIMIT 1;
SELECT MbrMinY(Geometry), NAME, ELEV FROM airportsNew LIMIT 1;

--2b
INSERT INTO airportsNEW(NAME, Geometry, ELEV) VALUES('airportB', (0.5*Distance((SELECT Geometry FROM airportsNew WHERE NAME='NOATAK'),(SELECT Geometry FROM airportsNew WHERE NAME='NIKOLSKI AS'))), (SELECT avg(ELEV) FROM airportsNew WHERE NAME="NIKOLSKI AS" OR NAME="NOATAK"));

--3(Zad6)
SELECT Area(Buffer(ShortestLine(lakes.Geometry, airports.Geometry)), 1000) FROM airports, lakes WHERE airports.NAME='AMBLER' AND lakes.NAMES='Iliamna Lake';

--4(Zad7)
SELECT SUM(Area(Intersection(tundra.Geometry, trees.Geometry))) AS "Tundra", SUM(Area(Intersection(swamp.Geometry, trees.Geometry))) AS "Bagna", VEGDESC FROM swamp, trees, tundra GROUP BY VEGDESC;

