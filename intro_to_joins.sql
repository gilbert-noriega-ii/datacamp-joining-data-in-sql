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



/*Begin by selecting all columns from the cities table.*/

SELECT *
FROM cities;

/*Inner join the cities table on the left to the countries table on the right, keeping all of the fields in both tables.*/

SELECT * 
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

/*Modify the SELECT statement to keep only the name of the city, the name of the country, and the name of the region the country resides in.*/

SELECT cities.name AS city, countries.name AS country, countries.region
FROM cities
INNER JOIN countries
ON cities.country_code = countries.code;

/*Inner join countries on the left and languages on the right with USING(code).
Select the fields corresponding to:
    country name AS country,
    continent name,
    language name AS language, and
    whether or not the language is official.
Remember to alias your tables using the first letter of their names.*/

SELECT c.name AS country, continent, l.name AS language, official
FROM countries AS c
INNER JOIN languages AS l
USING(code);

/*Join populations with itself ON country_code.
Select the country_code from p1 and the size field from both p1 and p2. SQL won't allow same-named fields, so alias p1.size as size2010 and p2.size as size2015.*/

SELECT p1.country_code, p1.size AS size2010, p2.size AS size2015
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code;

/*Notice from the result that for each country_code you have four entries laying out all combinations of 2010 and 2015.

Extend the ON in your query to include only those records where the p1.year (2010) matches with p2.year - 5 (2015 - 5 = 2010). This will omit the three entries per country_code that you aren't interested in.*/

SELECT p1.country_code,
       p1.size AS size2010,
       p2.size AS size2015
FROM populations as p1
INNER JOIN populations as p2
ON p1.country_code = p2.country_code
AND p1.year = (p2.year - 5);

/*Add a new field to SELECT, aliased as growth_perc, that calculates the percentage population growth from 2010 to 2015 for each country, using p2.size and p1.size.*/

SELECT p1.country_code,
       p1.size AS size2010, 
       p2.size AS size2015,
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
FROM populations AS p1
INNER JOIN populations AS p2
ON p1.country_code = p2.country_code
AND p1.year = p2.year - 5;

/*Using the countries table, create a new field AS geosize_group that groups the countries into three groups:

If surface_area is greater than 2 million, geosize_group is 'large'.
If surface_area is greater than 350 thousand but not larger than 2 million, geosize_group is 'medium'.
Otherwise, geosize_group is 'small'.*/

SELECT name, continent, code, surface_area,
    CASE WHEN surface_area > 2000000 THEN 'large'
         WHEN surface_area > 350000 THEN 'medium'
         ELSE 'small' END
         AS geosize_group
FROM countries;

/*Using the populations table focused only for the year 2015, create a new field aliased as popsize_group to organize population size into

'large' (> 50 million),
'medium' (> 1 million), and
'small' groups.
Select only the country code, population size, and this new popsize_group as fields.*/

SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
         WHEN size > 1000000 THEN 'medium'
         ELSE 'small' END
         AS popsize_group
FROM populations
WHERE year = 2015;

/*Use INTO to save the result of the previous query as pop_plus. You can see an example of this in the countries_plus code in the assignment text. Make sure to include a ; at the end of your WHERE clause!

Then, include another query below your first query to display all the records in pop_plus using SELECT * FROM pop_plus; so that you generate results and this will display pop_plus in query result.*/

SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
        WHEN size > 1000000 THEN 'medium'
        ELSE 'small' END
        AS popsize_group
INTO pop_plus
FROM populations
WHERE year = 2015;

SELECT * 
FROM pop_plus;

/*Keep the first query intact that creates pop_plus using INTO.
Write a query to join countries_plus AS c on the left with pop_plus AS p on the right matching on the country code fields.
Sort the data based on geosize_group, in ascending order so that large appears on top.
Select the name, continent, geosize_group, and popsize_group fields.*/

SELECT country_code, size,
  CASE WHEN size > 50000000
            THEN 'large'
       WHEN size > 1000000
            THEN 'medium'
       ELSE 'small' END
       AS popsize_group
INTO pop_plus       
FROM populations
WHERE year = 2015;

SELECT name, continent, geosize_group, popsize_group
FROM countries_plus AS c
INNER JOIN pop_plus AS p
ON c.code = p.country_code
ORDER BY geosize_group;