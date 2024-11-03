-- DATA CLEANING
SELECT *
FROM world_life_expectancy;

SELECT *
FROM (SELECT ROW_ID, CONCAT(COUNTRY, YEAR), ROW_NUMBER() OVER(PARTITION BY CONCAT(COUNTRY, YEAR) ORDER BY CONCAT(COUNTRY, YEAR)) AS row_numcol
FROM world_life_expectancy) AS row_numtable
WHERE row_numcol>1;

SET SQL_SAFE_UPDATES = 0;

DELETE FROM world_life_expectancy
WHERE 
ROW_ID IN(
SELECT ROW_ID
FROM (
SELECT row_id, 
CONCAT(country, year), 
ROW_NUMBER() OVER(PARTITION BY CONCAT(country, year) ORDER BY CONCAT (country, year)) AS row_num
FROM world_life_expectancy) AS row_table
WHERE row_num>1);

SELECT * 
FROM world_life_expectancy
WHERE Status = '';

/* Inorder to populate the country's status data where it's missing, 
I referneced the previous years data for both developing and developed countries*/

SELECT DISTINCT (status) 
FROM world_life_expectancy
WHERE Status <> '';
SELECT DISTINCT (status) 
FROM world_life_expectancy
WHERE Status <> NULL;
SELECT DISTINCT(country)
FROM world_life_expectancy
WHERE Status <> 'Developing';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.country = t2.country 
SET t1.Status='Developing'
WHERE t1.status=''
AND t2.status<>''
AND t2.status='Developing'
;

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.country=t2.country 
SET t1.status='developed'
WHERE t1.status= ''
AND t2.status<>''
AND t2.status = 'developed';
 
 /* Inorder to populate the missing life expectancy data, I took the average of the pevious year and the next year life expectancy data. 
 Since their are only two missing values it's not going to affect the accuracy of out data and it will give us a relatively accurate data 
 for exploratory data analysis*/
 
SELECT * 
FROM world_life_expectancy
WHERE `life expectancy` = '';

SELECT t1.country, t1.year, t1.`Life expectancy`, 
t2.country, t2.year, t2.`Life expectancy`, 
t3.country, t3.year, t3.`Life expectancy`,
ROUND(t2.`Life expectancy`+t3.`Life expectancy`/2,1)
FROM world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.country=t2.country
AND t1.year=t2.year-1
JOIN world_life_expectancy t3
ON t1.country = t3.country
AND t1.year=t3.year+1
WHERE t1.`life expectancy` = '';

UPDATE world_life_expectancy t1
JOIN world_life_expectancy t2
ON t1.country=t2.country
AND t1.year=t2.year-1
JOIN world_life_expectancy t3
ON t1.country = t3.country
AND t1.year=t3.year+1
SET t1.`life expectancy`= ROUND((t2.`Life expectancy`+t3.`Life expectancy`)/2,1)
WHERE t1.`life expectancy` = ''
;




