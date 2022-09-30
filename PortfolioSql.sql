Select *
From PortfolioProject.coviddeaths
where continent is not null
order by 3, 4;

-- Select *
-- From PortfolioProject.covidvaccinations
-- order by 3, 4

-- Select Data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject.coviddeaths
order by 1, 2;

-- Looking at total cases versus total deaths
-- Shows percentage of dying if you contract covid in Afghanistan
Select Location, date, total_cases, total_deaths,(total_deaths/total_cases) * 100 as DeathPercentage
From PortfolioProject.coviddeaths
where Location like '%State%'
order by 1, 2;

-- Looking at Total Cases vs. Population
-- Shows what percenage of population contracted covid
Select Location, date, total_cases, population,(total_cases/population) * 100 as ContractPercent
From PortfolioProject.coviddeaths
where Location like '%Afghan%'
order by 1, 2;

-- Looking at Countries with highest Infection Rate compared to Population

Select Location, Population, MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population)) * 100 as ContractPercent
From PortfolioProject.coviddeaths
-- where Location like '%Afghan%'
Group By Location, Population
order by ContractPercent desc;

-- LET'S BREAK THINGS DOWN BY CONTINENT
Select continent, MAX(cast(Total_deaths as SIGNED)) as TotalDeathCount
From PortfolioProject.coviddeaths
-- where Location like '%Afghan%'
where continent is not null
Group By continent
order by TotalDeathCount desc;

-- Show Countries with highest Death Count per Population
Select location, MAX(cast(Total_deaths as SIGNED)) as TotalDeathCount
From PortfolioProject.coviddeaths
-- where Location like '%Afghan%'
where continent is not null
Group By location
order by TotalDeathCount desc;

-- Showing continents with the highest death count
Select continent, MAX(cast(Total_deaths as SIGNED)) as TotalDeathCount
From PortfolioProject.coviddeaths
-- where Location like '%Afghan%'
where continent is not null
Group By continent
order by TotalDeathCount desc;

-- Global Numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as SIGNED)) as total_deaths, sum(cast(new_deaths as SIGNED))/SUM(new_cases)*100 as DeathPercentage
From PortfolioProject.coviddeaths
-- where Location like '%State%'
where continent is not null
-- group by date
order by 1, 2;


-- Using CTE
With PopsvsVac(Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as SIGNED)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated

From PortfolioProject.coviddeaths dea
Join PortfolioProject.covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null
-- order by 2,3
)
Select *, (RollingPeopleVaccinated/Population) * 100
From PopsvsVac;

-- TEMP Table
Create Table PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric
)
-- Insert into PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as SIGNED)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated

From PortfolioProject.coviddeaths dea
Join PortfolioProject.covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null;
-- order by 2,3

-- Creat view to store data for visualizations
Create view PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(Cast(vac.new_vaccinations as SIGNED)) OVER (Partition by dea.location Order by dea.location,
dea.Date) as RollingPeopleVaccinated
From PortfolioProject.coviddeaths dea
Join PortfolioProject.covidvaccinations vac
	on dea.location = vac.location
    and dea.date = vac.date
where dea.continent is not null;

Select *
From percentpopulationvaccinated








