-- US HOUSEHOLD INCOME DATA CLEANING 

use us_household_income;

SELECT * 
FROM us_household_income.us_household_income;

SELECT * 
FROM us_household_income.us_household_income_statistics;

-- To change the column name 
ALTER TABLE us_household_income_statistics CHANGE COLUMN `ï»¿id` `id` int;

-- To insure all rows have been imported 
SELECT count(id) 
FROM us_household_income.us_household_income;

SELECT count(id) 
FROM us_household_income.us_household_income_statistics;

-- To display duplicates us_household_income
SELECT  id, COUNT(ID)
FROM us_household_income
GROUP BY ID 
HAVING COUNT(ID)>1;
 
 -- Another method to display duplicates us_household_income 
SELECT * FROM(
SELECT row_id, id, 
ROW_NUMBER() OVER(PARTITION BY id order by id) AS Duplicates
 FROM us_household_income) AS duplicates 
 WHERE duplicates>1
 ;

-- To delete duplicate entries for us_household_income
-- First turning off safe updates 
SET SQL_SAFE_UPDATES=0;
DELETE FROM us_household_income
WHERE row_id IN (
SELECT row_id 
FROM(
SELECT row_id, 
id, 
ROW_NUMBER() OVER(PARTITION BY id order by id) AS Duplicates
 FROM us_household_income) AS duplicates 
 WHERE duplicates>1)
 ;

-- To display duplicates us_household_income_stastics
SELECT  id, COUNT(id)
FROM us_household_income_statistics
GROUP BY ID 
HAVING COUNT(ID)>1;
-- We have no duplicates so none was deleted 

-- To see if tehir is any issue with state name spelling 
SELECT DISTINCT(state_name), COUNT(state_name)
FROM us_household_income
GROUP BY state_name;

-- To correct the state name from georia to Georgia
UPDATE us_household_income
SET state_name= 'georgia'
WHERE State_name = 'georia';

-- To change state name capitalization error
UPDATE us_household_income
SET state_name= 'Alabama'
WHERE State_name = 'alabama';

-- To see if tehir is any issue with state name spelling 
SELECT DISTINCT(state_ab), COUNT(state_name)
FROM us_household_income
GROUP BY state_ab;

-- TO display and fill the place name where it's missing (Alabama state, Vinemont city)
SELECT * 
FROM us_household_income 
WHERE place=''
ORDER BY 1;

 UPDATE us_household_income
 SET place = 'Autaugaville' 
 WHERE place = ''
 AND county = 'Autauga County'
 AND city= 'Vinemont';
 
-- To see if tehir is any issue with Type column 
SELECT Type, COUNT(TYPE) 
FROM us_household_income 
GROUP BY TYPE
ORDER BY 1;

-- To fix spelling error in the type column
UPDATE us_household_income
SET Type = 'Borough'
WHERE type = 'Boroughs';
 
-- To identify any issues with ALand and Awater column entries
SELECT ALand, AWater
FROM us_household_income
WHERE AWATER =0 
OR ALand=0
OR AWATER =''
OR ALand=''
OR AWATER IS NULL
OR ALand IS NULL
ORDER BY 1;


