-- /* 
-- 	Count the number of food records 
-- */

-- SELECT 
-- 	  f.price_last_updated_ts
-- 	, f.food_id
-- 	, f.item_name
-- 	, CASE
-- 		WHEN item_name ILIKE '%canned%' THEN 'Y'
-- 		ELSE 'N'
-- 	  END AS is_item_canned
-- 	, f.storage_type
-- 	, f.package_size
-- 	, f.package_size_uom AS package_size_unit_of_measurment 
-- 	, f.brand_name
-- 	, f.package_price
-- FROM 
-- 	foods f
-- WHERE 
-- 	brand_name IS NULL 

	
	
-- SELECT 
-- 	DISTINCT(COALESCE(storage_type, 'Unknown'))
-- FROM
-- 	foods f


-- SELECT 
-- 	*
-- FROM 
-- 	foods
-- WHERE
-- 	storage_type IS NULL


-- UPDATE foods
-- 	SET storage_type = 'Unknown'
-- 	WHERE
-- 	storage_type IS NULL
	
	
-- SELECT 
-- 	  f.food_id
-- 	, f.item_name
-- 	, f.storage_type
-- 	, f.package_size
-- 	, f.package_size_uom AS package_size_unit_of_measurment 
-- 	, f.brand_name
-- 	, f.package_price
-- FROM 
-- 	foods f
-- WHERE 
-- 	food_id IN (13, 15, 17)
-- AND 
-- 	brand_name ILIKE 'H-E-B (Private label)'
	
	
-- SELECT 
-- 	  f.brand_name
-- 	, f.storage_type
-- 	, COUNT(*) AS record_count
-- FROM
-- 	foods f 
-- GROUP BY 
-- 	f.brand_name
-- 	, f.storage_type
	
	

	
-- /*percentage of brands that are 'H-E-B (private label)'
-- using a cross join*/
	
-- SELECT 
-- 	ROUND(
-- 		  CAST(n.heb_records AS DECIMAL(10,2)) / 
-- 		  CAST(d.total_records AS DECIMAL(10,2)), 2
-- 		)
-- FROM
-- 	(
-- 	SELECT 
-- 		COUNT(f.brand_name) AS heb_records
-- 	FROM
-- 		foods f
-- 	WHERE
-- 		brand_name ILIKE 'H-E-B (private label)'
-- 	 ) AS n	  
-- 		  CROSS JOIN	  
-- 	(
-- 	SELECT
-- 		COUNT(f.brand_name) AS total_records
-- 	FROM 
-- 		foods f
-- 	) AS d

-- /* Percentage of brands that are 'H-E-B (private label)'
-- using a subquery*/
	
-- SELECT 
-- 	ROUND((
-- 	SELECT 
-- 		CAST(COUNT(f.brand_name) AS DECIMAL(10,2))
-- 	FROM
-- 		foods f
-- 	WHERE
-- 		brand_name ILIKE 'H-E-B (private label)'
-- 	) / 
-- 		CAST(COUNT(f.brand_name) AS DECIMAL(10,2)), 2)
-- FROM 
-- 	foods f
	
	
-- SELECT 
-- 	  f.food_id
-- 	, f.item_name
-- 	, f.storage_type
-- 	, f.package_size
-- 	, f.package_size_uom AS package_size_unit_of_measurment 
-- 	, f.brand_name
-- 	, f.package_price
-- 	, f.price_last_updated_ts AT time zone 'America/New_York' AS price_last_updated_est_ts
-- 	, CURRENT_TIMESTAMP 
-- 	, CURRENT_TIMESTAMP - (f.price_last_updated_ts AT time zone 'America/New_York') AS days_since
-- 	, CURRENT_DATE - 
-- 		CAST((f.price_last_updated_ts AT time zone 'America/New_York') AS date)
-- FROM 
-- 	foods f



-- SELECT 
-- 	  f.food_id
-- 	, NULL as drink_id
-- 	, f.item_name
-- 	, f.storage_type
-- 	, f.package_size
-- 	, f.package_size_uom AS package_size_unit_of_measurment 
-- 	, f.brand_name
-- 	, f.package_price
-- 	, f.price_last_updated_ts
-- 	, 'foods_data' AS source_table
-- FROM 
-- 	foods f
	
-- 	UNION ALL
	
-- SELECT
-- 	  NULL AS food_id
-- 	, d. drink_id
-- 	, d.item_name
-- 	, d.storage_type
-- 	, d.package_size
-- 	, d.package_size_uom AS package_size_unit_of_measurment 
-- 	, d.brand_name
-- 	, d.package_price
-- 	, d.price_last_updated_ts
-- 	, 'drinks_data' AS source_table
-- FROM 
-- 	drinks d
	
-- SELECT 
-- 	* 
-- FROM 
-- 	food_inventories
	
	
-- DROP DATABASE advsql_analytics_mentor;

/*
Covid 19 Data Exploration 
Skills used: Joins, CTE's, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
*/

SELECT * FROM CovidDeaths;

--Select data that we are going to be using

SELECT 
location, 
date, 
total_cases, 
new_cases, 
total_deaths, 
population
FROM CovidDeaths;


--Looking at total cases vs total desths and the percent of deaths in the United Stated 

SELECT
Location, 
date, 
total_cases, 
total_deaths, 
ROUND((CAST (total_deaths AS FLOAT ))/(CAST (total_cases AS FLOAT ))*100, 5) as DeathPercentage
FROM CovidDeaths
WHERE location = 'United States';


--Looking at Total Cases vs Population and the percent of the population that has had covid in the United States

SELECT 
location,
date,
population, 
total_cases, 
((CAST (total_cases AS FLOAT))/(CAST (population AS FLOAT)))*100 as PercentOfPopInfected
FROM CovidDeaths
WHERE location = 'United States';

--Looking at the countries with the highest infection rate compared to population and the percent of the population infected 

SELECT 
location, 
population,
MAX(CAST (total_cases AS int)) AS HighestInfectionCount,
MAX((CAST (total_cases AS FLOAT))/(CAST (population AS FLOAT)))*100 AS PercentOfPopInfected
FROM CovidDeaths
WHERE continent IS NOT ''
GROUP BY location, population
ORDER BY PercentOfPopInfected DESC;


--Looking at countries with the highest death count per population

SELECT 
location, 
MAX(CAST (Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE continent IS NOT ''
GROUP BY location 
ORDER BY TotalDeathCount DESC;


--Looking at contintents with the highest death count per population

SELECT 
location, 
MAX(CAST (Total_deaths as int)) as TotalDeathCount
FROM CovidDeaths
WHERE continent IS ''
AND location <> 'High income' 
AND location <> 'Upper middle income'
AND location <> 'Lower middle income'
AND location <> 'Low income'
GROUP BY location 
ORDER BY TotalDeathCount DESC;


-- Global Numbers

SELECT
SUM(new_cases) AS total_cases, 
SUM(new_deaths) AS total_deaths, 
ROUND(SUM(new_deaths)/SUM(new_cases)*100, 5) AS DeathPercentage
FROM CovidDeaths
WHERE continent is not '';


-- Death percentage grouped by location

SELECT
location,
SUM(new_cases) AS total_cases, 
SUM(new_deaths) AS total_deaths, 
ROUND(SUM(new_deaths)/SUM(new_cases)*100, 5) AS DeathPercentage
FROM CovidDeaths
WHERE continent is not ''
GROUP BY location;



-- Looking at Total Population vs Vaccinations

SELECT 
dea.continent, 
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(CAST (vac.new_vaccinations AS int)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVac
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
WHERE dea.continent is not ''
ORDER BY  dea.location, dea.date;


-- Using a CTE 

WITH PopvsVac (continent, location, date, population, new_vaccintations, RollingPeopleVac)
AS (
SELECT 
dea.continent, 
dea.location,
dea.date,
dea.population,
vac.new_vaccinations,
SUM(CAST (vac.new_vaccinations AS FLOAT)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVac
FROM CovidDeaths dea
JOIN CovidVaccinations vac
    ON dea.location = vac.location
    AND dea.date = vac.date 
WHERE dea.continent is not ''

)

SELECT *, (RollingPeopleVac/population)*100 AS Perc
 FROM PopvsVac;

