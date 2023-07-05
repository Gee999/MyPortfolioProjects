SELECT *
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 3, 4

--SELECT *
--FROM PortfolioProject.dbo.CovidVaccinations
--ORDER BY 3, 4

SELECT location, date, total_cases, new_cases, total_deaths, population
FROM PortfolioProject.dbo.CovidDeaths
ORDER BY 1,2



SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
WHERE location Like '%states%'
ORDER BY 1,2

SELECT location, date,population, total_cases, (total_cases/population)*100 AS DeathPercentage
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location Like '%states%'
ORDER BY 1,2

SELECT location,population, MAX (total_cases) AS HighestInfectionCount, MAX ((total_cases/population))*100 AS PercentPopulationInfected
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location Like '%states%'
GROUP BY Location, population
ORDER BY 4 DESC


SELECT Continent,MAX (Cast(total_deaths AS int)) AS TotalDeathCount
FROM PortfolioProject.dbo.CovidDeaths
--WHERE location Like '%states%'
Where Continent IS NOT NULL
GROUP BY Continent
ORDER BY 2 DESC

SELECT *
FROM PortfolioProject..CovidVaccinations

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM (Cast (vac.new_vaccinations as int))OVER (partition by dea.location Order by dea.location, dea.date)AS 
RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS Dea
JOIN PortfolioProject..CovidVaccinations AS Vac
	ON Dea.location = Vac.location
	And Dea.date= Vac.date
	WHERE dea.continent IS NOT NULL
	Order by 2,3

WITH PopVsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
AS (SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM (Cast (vac.new_vaccinations as int))OVER (partition by dea.location Order by dea.location, dea.date)AS 
RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS Dea
JOIN PortfolioProject..CovidVaccinations AS Vac
	ON Dea.location = Vac.location
	And Dea.date= Vac.date
	WHERE dea.continent IS NOT NULL)
	--Order by 2,3

SELECT *, (RollingPeopleVaccinated/population) *100
FROM PopVsVac


DROP TABLE IF exists #PercentpopulationVaccinated
CREATE TABLE #PercentpopulationVaccinated
(Continent nvarchar (255), 
location nvarchar (255),
date datetime,
population numeric, 
new_vaccinations numeric,
RollingPeopleVaccinated numeric)

INSERT INTO #PercentpopulationVaccinated

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM (Cast (vac.new_vaccinations as int))OVER (partition by dea.location Order by dea.location, dea.date)AS 
RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS Dea
JOIN PortfolioProject..CovidVaccinations AS Vac
	ON Dea.location = Vac.location
	And Dea.date= Vac.date
	--WHERE dea.continent IS NOT NULL

SELECT*, (RollingPeopleVaccinated/population) *100
FROM #PercentpopulationVaccinated


CREATE VIEW PercentpopulationVaccinated AS
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, 
SUM (Cast (vac.new_vaccinations as int))OVER (partition by dea.location Order by dea.location, dea.date)AS 
RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths AS Dea
JOIN PortfolioProject..CovidVaccinations AS Vac
	ON Dea.location = Vac.location
	And Dea.date= Vac.date
	--WHERE dea.continent IS NOT NULL
