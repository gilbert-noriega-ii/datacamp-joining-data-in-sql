/* populations table fields are 

pop_id
country_code
year 
fertility_rate
life_expectancy
size

*/

/* countries table fields are 

code
name 
continent
region
surface_area
indep_year
local_name
gov_form
capital
cap_long
cap_lat

*/

/* languages table fields are 

lang_id
code
name
percent
official

*/

/* economies table fields are 

econ_id
code
year 
income_group
gdp_percapita
gross_savings
inflation_rate
total_investment
unemployment_rate
imports
exports

*/

/* currencies table fields are 

curr_id
code
basic_unit
curr_code
frac_unit
frac_perbasic

*/

/* cities table fields are 

name
country_code
city_proper_pop
metroarea_pop
urbanarea_pop

*/

/* economies2010 table fields are

code
year
income_group
gross_savings

*/

/* economies2010 table fields are

code
year
income_group
gross_savings

*/



/*Combine these two tables into one table containing all of the fields in economies2010. The economies table is also included for reference.
Sort this resulting single table by country code and then by year, both in ascending order.*/

SELECT *
FROM economies2010
UNION
SELECT *
FROM economies2015
ORDER BY code, year;

/*Determine all (non-duplicated) country codes in either the cities or the currencies table. The result should be a table with only one field called country_code.
Sort by country_code in alphabetical order.*/

SELECT country_code
FROM cities
UNION
SELECT code
FROM currencies
ORDER BY country_code;

/*Determine all combinations (include duplicates) of country code and year that exist in either the economies or the populations tables. Order by code then year.
The result of the query should only have two columns/fields. Think about how many records this query should result in.
You'll use code very similar to this in your next exercise after the video. Make note of this code after completing it.*/

SELECT code, year
FROM economies
UNION ALL
SELECT country_code, year
FROM populations
ORDER BY code, year;

/*Repeat the previous UNION ALL exercise, this time looking at the records in common for country code and year for the economies and populations tables.*/

SELECT code, year
FROM economies
INTERSECT
SELECT country_code, year
FROM populations
ORDER BY code, year;

/*Which countries also have a city with the same name as their country name?*/

SELECT name
FROM countries
INTERSECT
SELECT name
FROM cities;

/*Get the names of cities in cities which are not noted as capital cities in countries as a single field result.
Order the resulting field in ascending order.*/

SELECT name
FROM cities
EXCEPT
SELECT capital
FROM countries
ORDER BY name;

/*Determine the names of capital cities that are not listed in the cities table.
Order the resulting field in ascending order.*/

SELECT capital
FROM countries
EXCEPT
SELECT name
FROM cities
ORDER BY capital;

/*Select all country codes in the Middle East as a single field result using SELECT, FROM, and WHERE.*/

SELECT code
FROM countries
WHERE region = 'Middle East';

/*Select only unique languages by name appearing in the languages table.
Order the resulting single field table by name in ascending order.*/

SELECT DISTINCT name
FROM languages
ORDER BY name;

/*Now combine the previous two queries into one query:
Add a WHERE IN statement to the SELECT DISTINCT query, 
and use the commented out query from the first instruction in there. 
That way, you can determine the unique languages spoken in the Middle East.*/

SELECT DISTINCT name
FROM languages
WHERE code IN
  (SELECT code
  FROM countries
  WHERE region = 'Middle East')
ORDER BY name;

/*Begin by determining the number of countries in countries that are listed in Oceania using SELECT, FROM, and WHERE.*/

SELECT COUNT(*)
FROM countries
WHERE continent = 'Oceania';

/*Identify the currencies used in Oceanian countries.*/

SELECT code, name, basic_unit AS currency
FROM countries AS c1
JOIN currencies AS c2 
USING(code)
WHERE continent LIKE 'Oceania';

/*Note that not all countries in Oceania were listed in the resulting inner join with currencies. Use an anti-join to determine which countries were not included!*/

SELECT code, name
FROM countries 
WHERE continent LIKE 'Oceania'
AND code NOT IN
  	(SELECT code
	 FROM currencies);

/*Identify the country codes that are included in either economies or currencies but not in populations.
Use that result to determine the names of cities in the countries that match the specification in the previous instruction.*/

SELECT name
FROM cities AS c1
WHERE country_code IN
(
    SELECT e.code
    FROM economies AS e
    UNION
    SELECT c2.code
    FROM currencies AS c2
    EXCEPT
    SELECT p.country_code
    FROM populations AS p
);