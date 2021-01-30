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

/*Perform an inner join. Alias the name of the country field as country and the name of the language field as language.
Sort based on descending country name.*/

SELECT c.name AS country, local_name, l.name AS language, percent
FROM countries AS c
INNER JOIN languages AS l
ON c.code = l.code
ORDER BY country DESC;

/*Perform a left join instead of an inner join. Observe the result, and also note the change in the number of records in the result.*/

SELECT c.name AS country, local_name, l.name AS language, percent
FROM countries AS c
LEFT JOIN languages AS l
ON c.code = l.code
ORDER BY country DESC;

/*Begin with a left join with the countries table on the left and the economies table on the right.
Focus only on records with 2010 as the year.*/

SELECT name, region, gdp_percapita
FROM countries AS c
LEFT JOIN economies AS e
ON c.code = e.code
WHERE year = 2010;

/*Modify your code to calculate the average GDP per capita AS avg_gdp for each region in 2010.
Select the region and avg_gdp fields.*/

SELECT region, AVG(gdp_percapita) as avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
ON c.code = e.code
WHERE year = 2010
GROUP BY region;

/*Arrange this data on average GDP per capita for each region in 2010 from highest to lowest average GDP per capita.*/

SELECT region, AVG(gdp_percapita) as avg_gdp
FROM countries AS c
LEFT JOIN economies AS e
ON c.code = e.code
WHERE year = 2010
GROUP BY region
ORDER BY avg_gdp DESC;

/* convert this code to use RIGHT JOINs instead of LEFT JOINs
SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM cities
  LEFT JOIN countries
    ON cities.country_code = countries.code
  LEFT JOIN languages
    ON countries.code = languages.code
ORDER BY city, language;
*/

SELECT cities.name AS city, urbanarea_pop, countries.name AS country,
       indep_year, languages.name AS language, percent
FROM languages
  RIGHT JOIN countries
    ON languages.code = countries.code
  RIGHT JOIN cities
    ON countries.code = cities.country_code
ORDER BY city, language;

/*Choose records in which region corresponds to North America or is NULL.*/

SELECT name AS country, code, region, basic_unit
FROM countries
FULL JOIN currencies
USING (code)
WHERE region = 'North America' OR continent IS NULL
ORDER BY region;

/*Repeat the same query as above but use a LEFT JOIN instead of a FULL JOIN. Note what has changed compared to the FULL JOIN result!*/

SELECT name AS country, code, region, basic_unit
FROM countries
LEFT JOIN currencies
USING (code)
WHERE region = 'North America' OR continent IS NULL
ORDER BY region;

/*Repeat the same query as above but use an INNER JOIN instead of a FULL JOIN. Note what has changed compared to the FULL JOIN and LEFT JOIN results!*/

SELECT name AS country, code, region, basic_unit
FROM countries
INNER JOIN currencies
USING (code)
WHERE region = 'North America' OR continent IS NULL
ORDER BY region;

/*Choose records in which countries.name starts with the capital letter 'V' or is NULL.
Arrange by countries.name in ascending order to more clearly see the results.*/

SELECT countries.name, code, languages.name AS language
FROM languages
FULL JOIN countries
USING (code)
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
ORDER BY countries.name;

/*Repeat the same query as above but use a left join instead of a full join. Note what has changed compared to the full join result!*/

SELECT countries.name, code, languages.name AS language
FROM languages
LEFT JOIN countries
USING (code)
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
ORDER BY countries.name;

/*Repeat once more, but use an inner join instead of a left join. Note what has changed compared to the full join and left join results.*/

SELECT countries.name, code, languages.name AS language
FROM languages
INNER JOIN countries
USING (code)
WHERE countries.name LIKE 'V%' OR countries.name IS NULL
ORDER BY countries.name;

/*Complete a full join with countries on the left and languages on the right.
Next, full join this result with currencies on the right.
Use LIKE to choose the Melanesia and Micronesia regions (Hint: 'M%esia').
Select the fields corresponding to the country name AS country, region, language name AS language, and basic and fractional units of currency.*/

SELECT c1.name AS country, region, l.name AS language, basic_unit, frac_unit
FROM countries AS c1
FULL JOIN languages AS l
USING (code)
FULL JOIN currencies AS c2
USING (code)
WHERE region LIKE 'M%esia';

/*Create the cross join as described above. (Recall that cross joins do not use ON or USING.)
Make use of LIKE and Hyder% to choose Hyderabad in both countries.
Select only the city name AS city and language name AS language.*/

SELECT c.name AS city, l.name AS language
FROM cities AS c        
CROSS JOIN languages AS l
WHERE c.name LIKE 'Hyder%';

/*Use an inner join instead of a cross join. Think about what the difference will be in the results for this inner join result and the one for the cross join.*/

SELECT c.name AS city, l.name AS language
FROM cities as c  
INNER JOIN languages AS l
ON c.country_code = l.code
WHERE c.name LIKE 'Hyder%';

/*Select country name AS country, region, and life expectancy AS life_exp.
Make sure to use LEFT JOIN, WHERE, ORDER BY, and LIMIT.*/

SELECT c.name AS country, region, life_expectancy as life_exp
FROM countries as c
LEFT JOIN populations as p
ON c.code = p.country_code
WHERE year = 2010
ORDER BY life_exp
LIMIT 5;