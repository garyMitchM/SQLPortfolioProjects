/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Windows Functions, Aggregate Functions, Converting Data Types
*/


--Select data that we are going to be using
SELECT 
	  dea.location 
	, dea.date 
	, dea.total_cases 
	, dea.new_cases 
	, dea.total_deaths 
	, dea.population
FROM 
	CovidDeaths dea
	;


--Looking at total cases vs total deaths and the percent of deaths in the United Stated 
SELECT
	  dea.location 
	, dea.date 
	, dea.total_cases 
	, dea.total_deaths 
	, ROUND((CAST (dea.total_deaths AS FLOAT ))/(CAST (dea.total_cases AS FLOAT ))*100, 5) as DeathPercentage
FROM 
	CovidDeaths dea
WHERE 
	1=1
	AND dea.location = 'United States'
	;


--Looking at Total Cases vs Population and the percent of the population that has had covid in the United States
SELECT 
	  dea.location
	, dea.date
	, dea.population 
	, dea.total_cases 
	, ((CAST (dea.total_cases AS FLOAT))/(CAST (dea.population AS FLOAT)))*100 AS PercentOfPopInfected
FROM 
	CovidDeaths dea
WHERE 
	1=1
	AND dea.location = 'United States'
	;

--Looking at the countries with the highest infection rate compared to population and the percent of the population infected 
SELECT 
	  dea.location 
	, dea.population
	, MAX(CAST (dea.total_cases AS int)) AS HighestInfectionCount
	, MAX((CAST (dea.total_cases AS FLOAT))/(CAST (dea.population AS FLOAT)))*100 AS PercentOfPopInfected
FROM 
	CovidDeaths dea
WHERE 
	1=1
	AND dea.continent IS NOT ''
GROUP BY 
	  dea.location
	, dea.population
ORDER BY 
	PercentOfPopInfected DESC
	;


--Looking at countries with the highest death count per population
SELECT 
	  dea.location 
	, MAX(CAST (dea.Total_deaths as int)) as TotalDeathCount
FROM 
	CovidDeaths dea
WHERE 
	1=1
	AND dea.continent IS NOT ''
GROUP BY 
	dea.location 
ORDER BY 
	TotalDeathCount DESC
	;


--Looking at continents with the highest death count per population
SELECT 
	  dea.location  
	, MAX(CAST (dea.Total_deaths as int)) as TotalDeathCount
FROM 
	CovidDeaths dea
WHERE 
	1=1
	AND dea.continent IS ''
	AND dea.location <> 'High income' 
	AND dea.location <> 'Upper middle income'
	AND dea.location <> 'Lower middle income'
	AND dea.location <> 'Low income'
GROUP BY 
	dea.location 
ORDER BY 
	TotalDeathCount DESC
	;


-- Global Numbers
SELECT
	  SUM(dea.new_cases) AS total_cases 
	, SUM(dea.new_deaths) AS total_deaths 
	, ROUND(SUM(dea.new_deaths)/SUM(dea.new_cases)*100, 5) AS DeathPercentage
FROM 
	CovidDeaths dea
WHERE 
	1=1
	AND dea.continent is not ''
	;


-- Death percentage grouped by location
SELECT
	  dea.location
	, SUM(dea.new_cases) AS total_cases 
	, SUM(dea.new_deaths) AS total_deaths 
	, ROUND(SUM(dea.new_deaths)/SUM(dea.new_cases)*100, 5) AS DeathPercentage
FROM 
	CovidDeaths dea
WHERE 
	1=1
	AND dea.continent is not ''
GROUP BY 
	dea.location
	;


-- Looking at Total Population vs Vaccinations
SELECT 
	  dea.continent 
	, dea.location
	, dea.date
	, dea.population
	, vac.new_vaccinations
	, SUM(CAST (vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVac
FROM 
	CovidDeaths dea
	
JOIN CovidVaccinations vac
     ON dea.location = vac.location
    AND dea.date = vac.date 
WHERE 
	1=1
	AND dea.continent is not ''
ORDER BY  
	  dea.location
	, dea.date
	;


-- Using a CTE 
WITH PopvsVac AS (
	  dea.continent
	, dea.location
	, dea.date
	, dea.population
	, vac.new_vaccintations
	, RollingPeopleVac
) AS (
SELECT 
	  dea.continent 
	, dea.location
	, dea.date
	, dea.population
	, vac.new_vaccinations
	, SUM(CAST (vac.new_vaccinations AS FLOAT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVac
FROM 
	CovidDeaths dea
	
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
WHERE 
	1=1
	AND dea.continent is not ''

)

SELECT 
	  *
	, (RollingPeopleVac/dea.population)*100 AS Perc
 FROM 
	PopvsVac
	;

