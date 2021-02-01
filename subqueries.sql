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

/*The last type of subquery you will work with is one inside of FROM.
You will use this to determine the number of languages spoken for each country, identified by the country's local name! 
Begin by determining for each country code how many languages are listed in the languages table using SELECT, FROM, and GROUP BY.
Alias the aggregated field as lang_num.*/

SELECT code, COUNT(name) AS lang_num
FROM languages
GROUP BY code;

/*Include the previous query (aliased as subquery) as a subquery in the FROM clause of a new query.
Select the local name of the country from countries.
Also, select lang_num from subquery.
Make sure to use WHERE appropriately to match code in countries and in subquery.
Sort by lang_num in descending order.*/

SELECT local_name, lang_num
FROM countries,
  	(SELECT code, COUNT(name) AS lang_num
    FROM languages
    GROUP BY code) AS subquery
WHERE countries.code = subquery.code
ORDER BY lang_num DESC;

/*In this exercise, for each of the six continents listed in 2015, you'll identify which country had the maximum inflation rate (and how high it was) using multiple subqueries. The table result of your query in Task 3 should look something like the following, where anything between < > will be filled in with appropriate values:
Now it's time to append the second part's query to the first part's query using AND and IN to obtain the name of the country, its continent, and the maximum inflation rate for each continent in 2015!
For the sake of practice, change all joining conditions to use ON instead of USING (based upon the same column, code).*/

SELECT name, continent, inflation_rate
FROM countries
JOIN economies
ON countries.code = economies.code
WHERE year = 2015;

/*Select the maximum inflation rate in 2015 AS max_inf grouped by continent using the previous step's query as a subquery in the FROM clause.
Thus, in your subquery you should:
Create an inner join with countries on the left and economies on the right with USING (without aliasing your tables or columns).
Retrieve the country name, continent, and inflation rate for 2015.
Alias the subquery as subquery.
This will result in the six maximum inflation rates in 2015 for the six continents as one field table. Make sure to not include continent in the outer SELECT statement.*/

SELECT MAX(inflation_rate) AS max_inf
FROM (
      SELECT name, continent, inflation_rate
      FROM countries
      INNER JOIN economies
      USING(code)
      WHERE year = 2015) AS subquery
GROUP BY continent;

/*Now it's time to append your second query to your first query using AND and IN to obtain the name of the country, its continent, and the maximum inflation rate for each continent in 2015.
For the sake of practice, change all joining conditions to use ON instead of USING.*/

SELECT name, continent, inflation_rate
FROM countries
INNER JOIN economies
ON countries.code = economies.code
WHERE year = 2015
AND inflation_rate IN (
        SELECT MAX(inflation_rate) AS max_inf
        FROM (
             SELECT name, continent, inflation_rate
             FROM countries
             INNER JOIN economies
             on countries.code = economies.code
             WHERE year = 2015) AS subquery
        GROUP BY continent);

/*Use a subquery to get 2015 economic data for countries that do not have

gov_form of 'Constitutional Monarchy' or
'Republic' in their gov_form.

Here, gov_form stands for the form of the government for each country. Review the different entries for gov_form in the countries table.

Select the country code, inflation rate, and unemployment rate.
Order by inflation rate ascending.
Do not use table aliasing in this exercise.*/

SELECT code, inflation_rate, unemployment_rate
FROM economies
WHERE year = 2015 AND code NOT IN
  	(SELECT code
  	 FROM countries
  	 WHERE (gov_form = 'Constitutional Monarchy' OR gov_form LIKE '%Republic'))
ORDER BY inflation_rate;

/*In this exercise, you'll need to get the country names and other 2015 data in the economies table and the countries table for Central American countries with an official language.
Select unique country names. Also select the total investment and imports fields.
Use a left join with countries on the left. (An inner join would also work, but please use a left join here.)
Match on code in the two tables AND use a subquery inside of ON to choose the appropriate languages records.
Order by country name ascending.
Use table aliasing but not field aliasing in this exercise.*/

SELECT DISTINCT name, total_investment, imports
FROM countries AS c
LEFT JOIN economies AS e
ON (c.code = e.code
AND c.code IN (
          SELECT l.code
          FROM languages AS l
          WHERE official = 'true'
        ) )
WHERE region = 'Central America' AND year = 2015
ORDER BY name;

/*Let's ease up a bit and calculate the average fertility rate for each region in 2015.*/

SELECT region, continent, AVG(fertility_rate) AS avg_fert_rate
FROM populations AS p
INNER JOIN countries AS c
ON c.code = p.country_code
WHERE year = 2015
GROUP BY region, continent
ORDER BY avg_fert_rate;

/*You are now tasked with determining the top 10 capital cities in Europe and the Americas in terms of a calculated percentage using city_proper_pop and metroarea_pop in cities.*/

SELECT name, country_code, city_proper_pop, metroarea_pop, city_proper_pop / metroarea_pop * 100 AS city_perc
FROM cities
WHERE name IN
    (SELECT capital
    FROM countries
    WHERE (continent = 'Europe'
          OR continent LIKE '% America'))
AND metroarea_pop IS NOT NULL
ORDER BY city_perc DESC
LIMIT 10;