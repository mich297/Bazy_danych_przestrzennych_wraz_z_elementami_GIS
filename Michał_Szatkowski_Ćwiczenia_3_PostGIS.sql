CREATE DATABASE s293246;
CREATE EXTENSION postgis;

CREATE TABLE budynki(
    id SERIAL PRIMARY KEY,
    geometria GEOMETRY NOT NULL,
    nazwa VARCHAR(40) NOT NULL,
    wysokosc INT NOT NULL
);

CREATE TABLE drogi(
    id SERIAL PRIMARY KEY,
    geometria GEOMETRY NOT NULL,
    nazwa VARCHAR(40) NOT NULL
);

CREATE TABLE pktinfo(
    id SERIAL PRIMARY KEY,
    geometria GEOMETRY NOT NULL,
    nazwa VARCHAR(40) NOT NULL,
    liczprac INT NOT NULL
);

INSERT INTO budynki(geometria, nazwa, wysokosc) VALUES (ST_GeomFromText('POLYGON((8 1.5, 10.5 1.5, 10.5 4, 8 4, 8 1.5))',-1), 'BuildingA', 10);
INSERT INTO budynki(geometria, nazwa, wysokosc) VALUES (ST_GeomFromText('POLYGON((4 5, 6 5, 6 7, 4 7, 4 5))',-1), 'BuildingB', 12);
INSERT INTO budynki(geometria, nazwa, wysokosc) VALUES (ST_GeomFromText('POLYGON((3 6, 5 6, 5 8, 3 8, 3 6))',-1), 'BuildingC', 7);
INSERT INTO budynki(geometria, nazwa, wysokosc) VALUES (ST_GeomFromText('POLYGON((9 8, 10 8, 10 9, 9 9, 9 8))',-1), 'BuildingD', 11);
INSERT INTO budynki(geometria, nazwa, wysokosc) VALUES (ST_GeomFromText('POLYGON((1 1, 2 1, 2 2, 1 2, 1 1))',-1), 'BuildingF', 9);

INSERT INTO drogi(geometria, nazwa) VALUES (ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)',-1), 'RoadX');
INSERT INTO drogi(geometria, nazwa) VALUES (ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)',-1), 'RoadY');

INSERT INTO pktinfo(geometria, nazwa, liczprac) VALUES (ST_GeomFromText('POINT(1 3.5)',-1), 'G', 4);
INSERT INTO pktinfo(geometria, nazwa, liczprac) VALUES (ST_GeomFromText('POINT(5.5 1.5)',-1), 'H', 5);
INSERT INTO pktinfo(geometria, nazwa, liczprac) VALUES (ST_GeomFromText('POINT(9.5 6)',-1), 'I', 6);
INSERT INTO pktinfo(geometria, nazwa, liczprac) VALUES (ST_GeomFromText('POINT(6.5 6)',-1), 'J', 8);
INSERT INTO pktinfo(geometria, nazwa, liczprac) VALUES (ST_GeomFromText('POINT(6 9.5)',-1), 'K', 13);


SELECT SUM(ST_Length(drogi.geometria)) AS "Suma długości" FROM drogi;

SELECT geometria, ST_Area(geometria) AS pole, ST_Perimeter(geometria) AS obwód FROM budynki WHERE nazwa='BuildingA';

SELECT nazwa, ST_Area(geometria) AS pole FROM budynki ORDER BY nazwa;

SELECT nazwa, ST_Area(geometria) AS "Pole" FROM budynki ORDER BY ST_Area(GEOMETRIA) DESC LIMIT 2;

SELECT ST_Length(ST_ShortestLine(budynki.geometria, pktinfo.geometria)) AS "Najkrótsza Odległość" FROM budynki, pktinfo WHERE budynki.nazwa='BuildingC' AND pktinfo.nazwa='G';

SELECT ST_Area(ST_Difference(BudynekB.geometria,ST_Intersection(BudynekB.geometria, ST_Buffer(BudynekC.geometria, 0.5, 'join=mitre')))) AS "Pole częściowe" FROM budynki BudynekB, budynki BudynekC WHERE BudynekB.nazwa='BuildingB' AND BudynekC.nazwa='BuildingC';

SELECT budynki.* FROM budynki, drogi WHERE drogi.nazwa='RoadX' AND ST_Centroid(budynki.geometria) |>> drogi.geometria;

SELECT ST_Area(ST_SymDifference(geometria,ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))',-1))) AS "Pole różnicy" FROM budynki WHERE budynki.nazwa='BuildingC';
