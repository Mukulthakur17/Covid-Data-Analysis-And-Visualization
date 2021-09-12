-- 1. CHECKING THE DATA
SELECT * FROM covid.coviddeaths
WHERE continent IS NOT NULL 
ORDER BY 3,4;


-- 2. SELECTING DATA THAT WE ARE GOIN TO USE
SELECT location, date, total_cases, new_cases, total_deaths, population
FROM covid.coviddeaths ORDER BY 1, 2;


-- 3. TOTAL CASES vs TOTAL DEATHS 
-- SHOWS LIKELIHOOD OF DYING IF YOU CONTRACT COVID IN YOUR COUNTRY
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as death_rate
FROM covid.coviddeaths
-- WHERE location = "India"
WHERE location LIKE "%india%" ORDER BY 1, 2;


-- 4. TOTAL CASES vs POPULATION
-- SHOWS WHAT PERCENT OF TOTAL POPULATION GOT INFECTED BY COVID
SELECT location, date, total_cases, population, (total_cases/population)*100 as percent_population_infected
FROM covid.coviddeaths 
WHERE location LIKE "%india%" ORDER BY 1, 2;


-- 5. COUNTRIES WITH HIGHEST INFECTION RATE
SELECT location, population, max(total_cases) as higest_infection_count, max((total_cases/population)*100) as percent_population_infected
FROM covid.coviddeaths
GROUP BY location ORDER BY percent_population_infected DESC;


-- 6. COUNTRIES WITH HIGHEST DEATH COUNT and DEATH PERCENTAGE
SELECT location, max(total_deaths) as total_death_count, max((total_deaths/population)*100) as percent_population_died
FROM covid.coviddeaths WHERE continent IS NOT NULL
GROUP BY location ORDER BY percent_population_died DESC;


-- 7. CONTINENTS WITH HIGHEST DEATH COUNT
SELECT continent, max(total_deaths) as total_death_count, max((total_deaths/population)*100) as percent_population_died
FROM covid.coviddeaths WHERE continent IS NOT NULL
GROUP BY continent ORDER BY percent_population_died DESC;


-- 8. GLOABAL NUMBERS
SELECT date, SUM(new_cases) as new_cases, SUM(new_deaths) as new_deaths, (SUM(new_deaths)/SUM(new_cases))*100 as death_rate
FROM covid.coviddeaths WHERE continent IS NOT NULL
GROUP BY date ORDER BY 1;


-- 9. CALCULATING CUMULATIVE PEOPLE VACCINATED USING NEW VACCINATIONS COLOUMN
SELECT  dea.location, dea.date, dea.new_cases, dea.total_cases, dea.new_deaths, dea.total_deaths, 
vac.new_vaccinations, SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as total_vaccinations
FROM covid.covidvaccinations vac JOIN covid.coviddeaths dea
ON vac.location = dea.location AND vac.date = dea.date
WHERE dea.continent IS NOT NULL 
ORDER BY 1, 2;


-- 10. PERCENTAGE OF TOTAL PEOPLE THAT GOT VACCINATED USING THE TABLE OBTAINED IN PREVIOUS QUERY
-- USING CTE TO PERFORM THE CALCULATION ON PARTITION BY DATA
WITH popvsvac(location, date, population, new_cases, total_cases, new_vaccinations, total_vaccinations)
AS
(
SELECT  dea.location, dea.date, dea.population, dea.new_cases, dea.total_cases, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as total_vaccinations
FROM covid.covidvaccinations vac JOIN covid.coviddeaths dea
ON vac.location = dea.location AND vac.date = dea.date
WHERE dea.continent IS NOT NULL 
)
SELECT * , (total_vaccinations/population)*100 as percent_population_vaccinated
FROM popvsvac;
-- WHERE location LIKE "%india%"


-- 11. CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS
CREATE VIEW covid.worktable AS
( 
SELECT  dea.continent, dea.location, dea.date, dea.population, dea.new_cases, dea.total_cases, vac.new_vaccinations, 
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) as total_vaccinations
FROM covid.covidvaccinations vac JOIN covid.coviddeaths dea
ON vac.location = dea.location AND vac.date = dea.date
WHERE dea.continent IS NOT NULL
);


-- 12. REVIEWING THE VIEW
SELECT * FROM covid.worktable;