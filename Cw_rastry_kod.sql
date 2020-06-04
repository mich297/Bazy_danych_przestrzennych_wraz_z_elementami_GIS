--Michał Szatkowski
--Tworzenie rastrów z istniejących rastrów i interakcja z wektorami
--1 ST_Intersects - przecięcie rastra i wektora.
CREATE TABLE schema_szatkowski.intersects AS
SELECT a.rast, b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';
--dodanie klucza głównego typu serial.
alter table schema_szatkowski.intersects
add column rid SERIAL PRIMARY KEY;
--dodanie indeksu przestrzennego
CREATE INDEX idx_intersects_rast_gist ON schema_szatkowski.intersects
USING gist (ST_ConvexHull(rast));

--dodanie ograniczeń constraints dla rastra

-- schema::name table_name::name raster_column::name
SELECT AddRasterConstraints('schema_szatkowski'::name, 'intersects'::name,'rast'::name);

--2 ST_Clip - obcięcie rastra na podstawie wektora
CREATE TABLE schema_szatkowski.clip AS
SELECT ST_Clip(a.rast, b.geom, true), b.municipality
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality like 'PORTO';

--3 ST_Union - połączenie
CREATE TABLE schema_szatkowski.union AS
SELECT ST_Union(ST_Clip(a.rast, b.geom, true))
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast);

--Tworzenie rastrów z wektorów (rastrowanie)
--1 ST_AsRaster - rastrowanie tabeli z parafiami o takiej samej charakterystyce przestrzennej
CREATE TABLE schema_szatkowski.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

--2 ST_Union - połączenie rekordów z przykładu 1
DROP TABLE schema_szatkowski.porto_parishes; --> drop table porto_parishes first
CREATE TABLE schema_szatkowski.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1
)
SELECT st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

--3 ST_Tile - generowanie kafelków z rastra
DROP TABLE schema_szatkowski.porto_parishes; --> drop table porto_parishes first
CREATE TABLE schema_szatkowski.porto_parishes AS
WITH r AS (
SELECT rast FROM rasters.dem
LIMIT 1 )
SELECT st_tile(st_union(ST_AsRaster(a.geom,r.rast,'8BUI',a.id,-32767)),128,128,true,-32767) AS rast
FROM vectors.porto_parishes AS a, r
WHERE a.municipality ilike 'porto';

--Konwertowanie rastrów na wektory (wektoryzowanie)
--1 ST_Intersection - zwrot par wartości geometria-piksel
create table schema_szatkowski.intersection as
SELECT a.rid,(ST_Intersection(b.geom,a.rast)).geom,(ST_Intersection(b.geom,a.rast)).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--2 ST_DumpAsPolygons - konwersja rastrów na wektory
CREATE TABLE schema_szatkowski.dumppolygons AS
SELECT a.rid,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).geom,(ST_DumpAsPolygons(ST_Clip(a.rast,b.geom))).val
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--Analiza rastrów
--1 ST_Band - wyodrębnianie pasm z rastra
CREATE TABLE schema_szatkowski.landsat_nir AS
SELECT rid, ST_Band(rast,4) AS rast
FROM rasters.landsat8;

--2 ST_Clip - przykład wycięcia rastra z innego rastra
CREATE TABLE schema_szatkowski.paranhos_dem AS
SELECT a.rid,ST_Clip(a.rast, b.geom,true) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.parish ilike 'paranhos' and ST_Intersects(b.geom,a.rast);

--3 ST_Slope - generowanie nachylenia
CREATE TABLE schema_szatkowski.paranhos_slope AS
SELECT a.rid,ST_Slope(a.rast,1,'32BF','PERCENTAGE') as rast
FROM schema_szatkowski.paranhos_dem AS a;

--4 ST_Reclass - reklasyfikacja rastra
CREATE TABLE schema_szatkowski.paranhos_slope_reclass AS
SELECT a.rid,ST_Reclass(a.rast,1,']0-15]:1, (15-30]:2, (30-9999:3', '32BF',0)
FROM schema_szatkowski.paranhos_slope AS a;

--5 ST_SummaryStats - generowanie statystyk
SELECT st_summarystats(a.rast) AS stats
FROM schema_szatkowski.paranhos_dem AS a;

--6 ST_SummaryStats oraz Union - generowanie pojedyńczej statystyki
SELECT st_summarystats(ST_Union(a.rast))
FROM schema_szatkowski.paranhos_dem AS a;

--7 ST_SummaryStats - z lepszą kontrolą złożonego typu danych 
WITH t AS (
SELECT st_summarystats(ST_Union(a.rast)) AS stats
FROM schema_szatkowski.paranhos_dem AS a
)
SELECT (stats).min,(stats).max,(stats).mean FROM t;

--8 - ST_SummaryStats - w połączeniu z GROUP BY
WITH t AS (
SELECT b.parish AS parish, st_summarystats(ST_Union(ST_Clip(a.rast, b.geom,true))) AS stats
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
group by b.parish
)
SELECT parish,(stats).min,(stats).max,(stats).mean FROM t;

--9 ST_Value - wyodrębnianie wartości piksela
SELECT b.name,st_value(a.rast,(ST_Dump(b.geom)).geom)
FROM
rasters.dem a, vectors.places AS b
WHERE ST_Intersects(a.rast,b.geom)
ORDER BY b.name;

--10 ST_TPI 
create table schema_szatkowski.tpi30 as --40.696s
select ST_TPI(a.rast,1) as rast
from rasters.dem a;

--dodanie indeksu przestrzennego
CREATE INDEX idx_tpi30_rast_gist ON schema_szatkowski.tpi30
USING gist (ST_ConvexHull(rast));

--dodanie ograniczeń constraints dla rastra
SELECT AddRasterConstraints('schema_szatkowski'::name, 'tpi30'::name,'rast'::name);

--10v2 ST_TPI - tylko dla gminy Porto 
create table schema_szatkowski.tpi30_porto as --1.828s
SELECT ST_TPI(a.rast,1) as rast
FROM rasters.dem AS a, vectors.porto_parishes AS b
WHERE ST_Intersects(a.rast, b.geom) AND b.municipality ilike 'porto';

--dodanie indeksu przestrzennego
CREATE INDEX idx_tpi30_porto_rast_gist ON schema_szatkowski.tpi30_porto
USING gist (ST_ConvexHull(rast));

--dodanie ograniczeń constraints dla rastra
SELECT AddRasterConstraints('schema_szatkowski'::name, 'tpi30_porto'::name,'rast'::name);

--ST_TPI ze zmniejszonym obszarem zainteresowania wykonuje sie o wiele szybciej, bo w 1.828s, podczas gdy całość trwa 40.696s

--Algebra map
--1 Wyrażenie Algebry Map
CREATE TABLE schema_szatkowski.porto_ndvi AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, 1,
r.rast, 4,
'([rast2.val] - [rast1.val]) / ([rast2.val] + [rast1.val])::float','32BF'
) AS rast
FROM r;

--dodanie indeksu przestrzennego
CREATE INDEX idx_porto_ndvi_rast_gist ON schema_szatkowski.porto_ndvi
USING gist (ST_ConvexHull(rast));

--dodanie ograniczeń constraints dla rastra
SELECT AddRasterConstraints('schema_szatkowski'::name, 'porto_ndvi'::name,'rast'::name);

--2 Funkcja zwrotna - tworzenie funkcji
create or replace function schema_szatkowski.ndvi(
value double precision [] [] [],
pos integer [][],
VARIADIC userargs text []
)
RETURNS double precision AS
$$
BEGIN
--RAISE NOTICE 'Pixel Value: %', value [1][1][1];-->For debug purposes
RETURN (value [2][1][1] - value [1][1][1])/(value [2][1][1]+value [1][1][1]); --> NDVI calculation!
END;
$$
LANGUAGE 'plpgsql' IMMUTABLE COST 1000;

CREATE TABLE schema_szatkowski.porto_ndvi2 AS
WITH r AS (
SELECT a.rid,ST_Clip(a.rast, b.geom,true) AS rast
FROM rasters.landsat8 AS a, vectors.porto_parishes AS b
WHERE b.municipality ilike 'porto' and ST_Intersects(b.geom,a.rast)
)
SELECT
r.rid,ST_MapAlgebra(
r.rast, ARRAY[1,4],
'schema_szatkowski.ndvi(double precision[], integer[],text[])'::regprocedure, --> This is the function!
'32BF'::text
) AS rast
FROM r;


--dodanie indeksu przestrzennego
CREATE INDEX idx_porto_ndvi2_rast_gist ON schema_szatkowski.porto_ndvi2
USING gist (ST_ConvexHull(rast));

--dodanie ograniczeń constraints dla rastra
SELECT AddRasterConstraints('schema_szatkowski'::name, 'porto_ndvi2'::name,'rast'::name);

--Eksport danych

--1 ST_AsTiff - utworzenie danych wyjściowych w reprezentacji binarnej pliku .tiff
SELECT ST_AsTiff(ST_Union(rast))
FROM schema_szatkowski.porto_ndvi;

--2 ST_AsGDALRaster - nie zapisuje na dysku, jednak zapisuje w dowolnej reprezentacji binarnej GDAL
SELECT ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
FROM schema_szatkowski.porto_ndvi;

SELECT ST_GDALDrivers();

--Przykład 3 - Zapisywanie danych na dysku za pomocą dużego obiektu (large object, lo)
CREATE TABLE tmp_out AS
SELECT lo_from_bytea(0,
ST_AsGDALRaster(ST_Union(rast), 'GTiff', ARRAY['COMPRESS=DEFLATE', 'PREDICTOR=2', 'PZLEVEL=9'])
) AS loid
FROM schema_szatkowski.porto_ndvi;
----------------------------------------------
SELECT lo_export(loid, 'D:\MaterialyNaStudia\6_semestr_IO\GIS\GISOSTATNI\ZadanieQGISpliki\myraster.tiff') --> Save the file in a place where the user postgres have access. In windows a flash drive usualy works fine.
FROM tmp_out;
----------------------------------------------
SELECT lo_unlink(loid)
FROM tmp_out; --> Delete the large object.