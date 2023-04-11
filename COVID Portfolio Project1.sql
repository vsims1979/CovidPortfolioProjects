Select*
From PortfolioProjectCovid..CovidDeaths
where continent is not null
order by 3,4

--Select*
--From PortfolioProjectCovid..CovidVac
--order by 3,4

--select data that we are going to use
Select Location, date,total_cases,new_cases,total_deaths,population
From PortfolioProjectCovid..CovidDeaths
Where continent is not null
order by 1,2


--looking at total cases vs total deaths All
--Shows likelihood of death
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectCovid..CovidDeaths
Where continent is not null 
order by 1,2

--looking at total cases vs total deaths United States
Select Location, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectCovid..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2


--looking at total cases vs population United States
--shows percentage of population got covid
Select Location, date,population total_cases, (total_cases/population)*100 as DeathPercentage
From PortfolioProjectCovid..CovidDeaths
Where location like '%states%'
and continent is not null 
order by 1,2

--looking at total cases vs population All
Select Location, date,population total_cases, (total_cases/population)*100 as PercentagePopulationInfected
From PortfolioProjectCovid..CovidDeaths
Where continent is not null 
order by 1,2


--looking at countries with highest infection rate compared to population
Select Location,population, MAX(total_cases)as HighestInfecctionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From PortfolioProjectCovid..CovidDeaths
Where continent is not null
Group by location, population
Order by PercentagePopulationInfected DESC


--Showing Highest Death Count Per Population
Select Location, MAX(total_deaths)as TotalDeathCount
From PortfolioProjectCovid..CovidDeaths
Where continent is not null
Group by location
Order by TotalDeathCount DESC


--Continent With Highest Death Count Per Population
Select continent, MAX(total_deaths)as TotalDeathCount
From PortfolioProjectCovid..CovidDeaths
Where continent is not null
Group by continent
Order by TotalDeathCount DESC


--Continent
Select continent, date,total_cases,new_cases,total_deaths,population
From PortfolioProjectCovid..CovidDeaths
Where continent is not null
order by 1,2


--Continent Total Cases vs Total Deaths
Select continent, date, total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From PortfolioProjectCovid..CovidDeaths
Where continent is not null 
order by 1,2


--Continent Total Cases vs Population
Select continent, date,population total_cases, (total_cases/population)*100 as PercentagePopulationInfected
From PortfolioProjectCovid..CovidDeaths
Where continent is not null 
order by 1,2


--Continent With Highest Infecton Rate Compared to Population
Select continent,population, MAX(total_cases)as HighestInfecctionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From PortfolioProjectCovid..CovidDeaths
Where continent is not null
Group by continent, population
Order by PercentagePopulationInfected DESC



--Global Numbers
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_cases)/SUM(new_deaths)*100 as DeathPercentage
From PortfolioProjectCovid..CovidDeaths
where continent is not null 
order by 1,2


--Looking at CovidVac Table
Select*
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVacs vac
    On dea.location=vac.location
	and dea.date=vac.date


--Total Population vs Vaccinations
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVacs vac
    On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
Order by 2,3

--Show Precentage of Population that has recieved at least one Covid Vaccine
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order By dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVacs vac
    On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
Order by 2,3


--USE CTE

With PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated) 
as 
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order By dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVacs vac
    On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
--Order by 2,3
)
Select*,(RollingPeopleVaccinated/population)*100
From PopvsVac



--TEMP TABLE 


Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order By dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVacs vac
    On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
Order by 2,3


Select*,(RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated


--TEMP TABLE DROP

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)


Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order By dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVacs vac
    On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
Order by 2,3


Select*,(RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



--Creating views to store data for later visulizations

Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
,SUM(vac.new_vaccinations) OVER (Partition by dea.Location Order By dea.location, dea.date) as RollingPeopleVaccinated
--(RollingPeopleVaccinated/population)*100
From PortfolioProjectCovid..CovidDeaths dea
Join PortfolioProjectCovid..CovidVacs vac
    On dea.location=vac.location
	and dea.date=vac.date
Where dea.continent is not null
--Order by 2,3


Select *
From PercentPopulationVaccinated



Create View DeathPercentage as
Select SUM(new_cases) as total_cases, SUM(new_deaths) as total_deaths, SUM(new_cases)/SUM(new_deaths)*100 as DeathPercentage
From PortfolioProjectCovid..CovidDeaths
where continent is not null 
--order by 1,2


Select*
From DeathPercentage



Create View PercentagePopulationInfected as
Select continent,population, MAX(total_cases)as HighestInfecctionCount, MAX((total_cases/population))*100 as PercentagePopulationInfected
From PortfolioProjectCovid..CovidDeaths
Where continent is not null
Group by continent, population
--Order by PercentagePopulationInfected DESC