-- Data Analysis
SELECT *
FROM world_life_expectancy;

/* A query to analyze improvment countries have made in increasing their citizen's life expectancy 
Assumption: we assume the countries have made improvment throughout the years since the intial recorded entry*/
SELECT country, 
MIN(`life expectancy`), 
MAX(`life expectancy`), 
ROUND(MAX(`Life expectancy`)-MIN(`life expectancy`),1) AS Life_increase_in_15_years
FROM world_life_expectancy
GROUP BY country 
HAVING MIN(`life expectancy`)<>0
AND  MAX(`life expectancy`)<>0
ORDER BY Life_increase_15_years DESC;

-- A query to see the avergae life expectancy change throughout the years

SELECT year, ROUND(AVG(`life expectancy`),2)
FROM world_life_expectancy
WHERE `life expectancy`<> 0
GROUP BY year
ORDER BY year;

-- To see the correlation between GDP and life expectancy 
SELECT country, ROUND(AVG(`life expectancy`),1) AS Life_Exp, ROUND(AVG(GDP),1) AS GDP
FROM world_life_expectancy
GROUP BY country
HAVING Life_Exp>0
AND GDP>0
ORDER BY GDP Asc; 

-- Using case statment to find countries that have higher GDP 
SELECT 
SUM(CASE WHEN GDP>=1500 THEN 1  ELSE 0 END) high_gdp_count
FROM world_life_expectancy;

-- Using case statment to find avergae life expectancy of countries that have GDP of equals to and more than 1,500
SELECT 
AVG(CASE WHEN GDP>=1500 THEN `life expectancy`  ELSE 0 END) high_gdp_life_expectancy
FROM world_life_expectancy;

-- To see the relation between GDP and life expectancy 
SELECT 
SUM(CASE WHEN GDP>=1500 THEN 1  ELSE 0 END) high_gdp_count,
AVG(CASE WHEN GDP>=1500 THEN `life expectancy`  ELSE 0 END) high_gdp_life_expectancy,
SUM(CASE WHEN GDP<=1500 THEN 1  ELSE 0 END) low_gdp_count,
AVG(CASE WHEN GDP<=1500 THEN `life expectancy`  ELSE NUll END) low_gdp_life_expectancy
FROM world_life_expectancy;

-- Relationship between average life expectancy and the status of the country
SELECT status, ROUND(AVG(`life expectancy`),1)
FROM world_life_expectancy
GROUP BY status;

-- TO see the effect of the number of countries included in each status on the average life expectancy of each status
SELECT 
status,
COUNT(DISTINCT country) AS number_of_countries_having_each_status,
ROUND(AVG(`life expectancy`),1) As avg_life_expectancy
FROM world_life_expectancy
GROUP BY status;

-- To see the relationship between BMI and life expectancy 
SELECT country, ROUND(AVG(`life expectancy`),1) AS Life_Exp, ROUND(AVG(BMI),1) AS BMI
FROM world_life_expectancy
GROUP BY country
HAVING Life_Exp>0
AND BMI>0
ORDER BY BMI DESC; 
/*Eventhough intial assumption was their will be negative relationship between BMI and life expectancy
we can see from the data that countries with higher BMI tend to have higher life expectancy with few outlies*/

-- To see the relationship between the number of adult mortality and average life expectancy 
SELECT country, 
year, 
`life expectancy`,
`Adult mortality`,
SUM(`Adult mortality`) OVER(PARTITION BY country ORDER BY year) as rolling_total
FROM world_life_expectancy;

/* To specifically see the relaionship between the number of adult mortality and average life expectancy in counties that have United in them
like United States, United Arab Emirates*/
SELECT country,
year,
`life expectancy`,
`Adult mortality`,
SUM(`Adult mortality`) OVER(PARTITION BY country ORDER BY year) as rolling_total
FROM world_life_expectancy
WHERE country like '%united%'; 







