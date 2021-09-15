-- Queries used for Tableau Visualization

-- 1. TOTAL_CASES vs TOTAL_DEATHS vs DEATH_RATE
SELECT SUM(new_cases) AS total_cases, SUM(new_deaths) AS total_deaths, SUM(new_deaths)/SUM(new_cases) AS death_rate
FROM covid.coviddeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2;


-- 2. GETTING THE DEATH COUNT FOR EACH CONTINENT
SELECT location, SUM(new_deaths) as total_deaths 
FROM covid.coviddeaths
WHERE continent IS NULL AND location NOT IN ('World', 'European Union', 'International')
GROUP BY location ORDER BY total_deaths DESC;


-- 3. GETTING THE INFECTED POPULATION PERCENTAGE FOR EACH COUNTRY
SELECT location, population, MAX(total_cases) AS total_infection_count, (MAX(total_cases)/population)*100 AS percent_population_infected
FROM covid.coviddeaths
GROUP BY location ORDER BY percent_population_infected DESC;


-- 4. DAILY INFECTION COUNT & INFECTED POPULATION PERCENTAGE FOR EACH COUNTRY
SELECT location, population, date, total_cases AS total_infection_count, (total_cases/population)*100 AS percent_population_infected
FROM covid.coviddeaths
ORDER BY percent_population_infected DESC;


