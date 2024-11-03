-- US HOUSEHOLD INCOME EXPLORATORY DATA ANALYSIS
SELECT * 
FROM us_household_income.us_household_income;

SELECT * 
FROM us_household_income.us_household_income_statistics;

-- To identify the states with the largest area of land and area of water adn smallest area of land and area of water
SELECT state_name, SUM(ALand), SUM(AWater)
FROM us_household_income 
GROUP BY State_name
ORDER BY 2 DESC;
  
SELECT state_name, SUM(ALand), SUM(AWater)
FROM us_household_income 
GROUP BY State_name
ORDER BY 3 DESC;

-- To identify the top ten largest states by land mass
SELECT state_name, SUM(ALand), SUM(AWater)
FROM us_household_income 
GROUP BY State_name
ORDER BY 2 DESC
LIMIT 10;

-- To join the two tables togerther to facilitate our query
SELECT * 
FROM us_household_income u
JOIN us_household_income_statistics us
ON u.id=us.id;

-- To display all the data entries that are null in us_household_income table but that have values in the us_household_income_statistics table
SELECT * 
FROM us_household_income u
RIGHT JOIN us_household_income_statistics us
ON u.id=us.id
WHERE u.id IS NULL;
/*It looks like their is a large amount of records missing from the us_household_income table (we must fix these missing records going back
or altogether ignore these records if irrelevant*/ 

-- To get the records that have entries in both table(full records)
SELECT *
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id=us.id
WHERE mean<>0;

-- To find average and median income by state
SELECT u.state_name, ROUND(AVG(mean),2), ROUND(AVG(Median),2)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id=us.id
WHERE mean<>0
GROUP BY u.state_name
ORDER BY 2
;

-- To find the top 3 states that have the highest average income 
SELECT u.state_name, ROUND(AVG(mean),2), ROUND(AVG(Median),2)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id=us.id
WHERE mean<>0
GROUP BY u.state_name
ORDER BY 2 DESC
LIMIT 3
;

-- To identify the relationship between the average income and type of location
SELECT type, ROUND(AVG(mean),1), ROUND(AVG(Median),1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id=us.id
WHERE mean<>0
GROUP BY 1
ORDER BY 2 DESC
LIMIT 30
;

-- To identify the number of data points taken, to insure our immediate above result is accurate
SELECT type, Count(type), ROUND(AVG(mean),1), ROUND(AVG(Median),1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id=us.id
WHERE mean<>0
GROUP BY 1
ORDER BY 2 DESC
LIMIT 30
;

/* It can be seen from the data that the average and median income are extremly low for the community location type. 
To insure the logical validity of the data, we can further see the states this community location type is located at*/
SELECT state_name
FROM us_household_income
WHERE Type= 'Community';

-- To filter out outliers to get a more representative output
SELECT type, Count(type), ROUND(AVG(mean),1), ROUND(AVG(Median),1)
FROM us_household_income u
INNER JOIN us_household_income_statistics us
ON u.id=us.id
WHERE mean<>0
GROUP BY 1
HAVING count(type)>100
ORDER BY 4 DESC
LIMIT 30
;

-- To see the average income per city 
SELECT u.State_name, city, ROUND(AVG(mean),1)
FROM us_household_income u
JOIN us_household_income_statistics us
ON u.id=us.id
WHERE mean<>0
GROUP BY u.State_name, city
ORDER BY 3 DESC
LIMIT 30
;


