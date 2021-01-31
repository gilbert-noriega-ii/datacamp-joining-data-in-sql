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

/*Begin by calculating the average life expectancy across all countries for 2015.*/

SELECT AVG(life_expectancy)
FROM populations
WHERE year = 2015;

/*Figure out which countries had high average life expectancies (at the country level) in 2015.*/

SELECT * 
FROM populations
WHERE life_expectancy > 1.15 *
   (SELECT AVG(life_expectancy)
    FROM populations
    WHERE year = 2015)
AND year = 2015;

/*Use your knowledge of subqueries in WHERE to get the urban area population for only capital cities.*/

SELECT name, country_code, urbanarea_pop
FROM cities
WHERE name IN
  (SELECT capital 
   FROM countries)
ORDER BY urbanarea_pop DESC;

/*The code given in query.sql selects the top nine countries in terms of number of cities appearing in the cities table. Recall that this corresponds to the most populous cities in the world. Your task will be to convert the commented out code to get the same result as the code shown.*/

/*SELECT countries.name AS country, COUNT(*) AS cities_num
  FROM cities
    INNER JOIN countries
    ON countries.code = cities.country_code
GROUP BY country
ORDER BY cities_num DESC, country
LIMIT 9;*/

SELECT name AS country,
  (SELECT COUNT(*)
   FROM cities
   WHERE countries.code = cities.country_code) AS cities_num
FROM countries
ORDER BY cities_num DESC, country
LIMIT 9;

