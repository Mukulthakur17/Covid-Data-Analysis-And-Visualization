-- CHECKING OUR DATA
SELECT * FROM covid.coviddeaths
WHERE continent IS NOT NULL 
ORDER BY 3,4;

-- SELECTING DATA THAT WE ARE GOIN TO USE
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid.coviddeaths ORDER BY 1, 2;

-- LOOKING AT TOTAL CASES/ TOTAL DEATHS PERCENTAGE
-- SHOWS LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_percentage
FROM covid.coviddeaths
-- WHERE location = "India"
WHERE location LIKE "%india%" ORDER BY 1, 2;