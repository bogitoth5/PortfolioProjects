select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

select *
from PortfolioProject..CovidVaccinations
order by 3,4


--Select data that we are going to be using

Select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject..CovidDeaths
where continent is not null
order by 1,2

--Looking at Total cases vs Total Deaths
--Shows the likelihood of dying if you contract covid in Hungary

Select location, date, total_cases, total_deaths, (CONVERT(DECIMAL(18,2), total_deaths) / CONVERT(DECIMAL(18,2), total_cases) )*100 as DeathPercent
from PortfolioProject..CovidDeaths
where location = 'Hungary'
order by 1,2


--Looking at Total Cases vs Population (what percentage of the population got covid)
Select location, date, population, total_cases, (CONVERT(DECIMAL(18,2), total_cases) / CONVERT(DECIMAL(18,2), population) )*100 as CovidPercent
from PortfolioProject..CovidDeaths
where location = 'Hungary'
order by 1,2

--Looking at countries with highest infection rate compared to population
Select Location, Population, MAX(cast(total_cases as INT)) as HighestInfectionCount, max((total_cases/population))*100 as CovidPercent
From PortfolioProject..CovidDeaths
--Where location = 'Hungary'
where continent is not null
Group by Location, Population
order by CovidPercent desc

-- Showing countires with the highest death count per population
Select Location, MAX(cast(total_deaths as INT)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = 'Hungary'
where continent is not null
Group by Location
order by TotalDeathCount desc

-- Deaths percentage per population (exlcuding continents)
Select Location, Population, MAX(cast(total_deaths as INT)) as TotalDeathCount, max((total_deaths/population))*100 as DeathPercentage
From PortfolioProject..CovidDeaths
--Where location = 'Hungary'
where continent is not null
Group by Location, Population
order by DeathPercentage desc

-- Breaking things down by continent
Select continent, MAX(cast(total_deaths as INT)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = 'Hungary'
where continent is not null
Group by continent
order by TotalDeathCount desc

-- Death count in Europe
Select location, MAX(cast(total_deaths as INT)) as TotalDeathCount
From PortfolioProject..CovidDeaths
Where continent = 'Europe'
Group by location
order by TotalDeathCount desc

-- Death percentage per countries in EU
Select location, MAX(cast(total_deaths as INT)) as TotalDeathCount, max((total_deaths/population))*100 as DeathPertentage
From PortfolioProject..CovidDeaths
Where continent = 'Europe'
Group by location
order by DeathPertentage desc


--GLOBAL NUMBERS
SET ARITHABORT OFF
SET ANSI_WARNINGS OFF
Select date, sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths)/sum(new_cases)*100 as DeathPercent
from PortfolioProject..CovidDeaths
--where location = 'Hungary'
where continent is not null and new_cases>0 
group by date
order by 1,2


--Looking at total population vs vaccinations

select *
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..CovidDeaths dea
on dea.location = vac.location
and dea.date = vac.date
where vac.continent is not null
order by 2,3

SET ARITHABORT OFF
SET ANSI_WARNINGS OFF
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..CovidDeaths dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2, 3

--Looking at how many people is vaccinated in each country
SET ARITHABORT OFF
SET ANSI_WARNINGS OFF
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..CovidDeaths dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2, 3


-- Let's see what percentage of the population was vaccinated
SET ARITHABORT OFF
SET ANSI_WARNINGS OFF
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..CovidDeaths dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2, 3

--Use CTE
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as RollingPeopleVaccinated
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..CovidDeaths dea
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2, 3
)
Select *, (RollingPeopleVaccinated/Population)*100 as VaccinatedPercent
From PopvsVac


--Using total_vaccinations instead
With PopvsVac (Continent, Location, Date, Population, New_Vaccinations, People_Vaccinated, TotalVaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.people_vaccinated, vac.total_vaccinations
, sum(cast(vac.people_vaccinated as int)) over (partition by dea.location order by dea.location, dea.date) as TotalVaccinated
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..CovidDeaths dea
on dea.location = vac.location
and dea.date = vac.date
where dea.location ='Hungary'
--where dea.continent is not null
--order by 2, 3
)
Select *, (TotalVaccinated/Population)*100 as VaccinatedPercent
From PopvsVac



--Pertentage in Hungary
select dea.location, dea. date, dea.population, vac.people_vaccinated, (vac.people_vaccinated/dea.population)*100 as VaccinatedPercent
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..CovidDeaths dea
on dea.location = vac.location
and dea.date = vac.date
where dea.location ='Hungary'
--where vac.continent is not null
order by 2


-- Percent by country
select dea.continent, dea.location, dea.population, max(cast(vac.people_vaccinated as int)) as Vaccinated, max((vac.people_vaccinated/dea.population))*100 as VaccinatedPercent
from PortfolioProject..CovidVaccinations vac
join PortfolioProject..CovidDeaths dea
on dea.location = vac.location
and dea.date = vac.date
where vac.continent is not null
group by dea. continent, dea.location, dea.population
order by 5 desc



-- Creating view to store data for later visualizations

create view TotalDeathCount as
Select continent, MAX(cast(total_deaths as INT)) as TotalDeathCount
From PortfolioProject..CovidDeaths
--Where location = 'Hungary'
where continent is not null
Group by continent
--order by TotalDeathCount desc

select *
from TotalDeathCount