select *
from PortfolioProject..CovidDeaths
where continent is not null
order by 3,4

--select *
--from PortfolioProject..CovidVaccinations
--order by 3,4;

Select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
order by 1,2

--Loking for total cases vs total deaths

Select location,date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where location like '%Italy%'
order by 1,2

--Take a look at total case vs population

Select location,date,population,total_cases,
(total_cases/population)*100 as Cases_Per_Population
from PortfolioProject..CovidDeaths
order by 1,2

--Countries with highest infection rate compared to population

Select location,population,max(total_cases) as HighestInfectedCountry,
max((total_cases/population))*100 as HighestInfectedCountryPercent
from PortfolioProject..CovidDeaths
group by location,population
order by HighestInfectedCountryPercent desc

--Countries with highest death count per population

Select location,max(cast(total_deaths as bigint)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount desc

--Breaking down by continent with highest death count per population

Select continent,max(cast(total_deaths as bigint)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount desc

--CAST IS USED TO DECLARE DATA TYPES OR CHANGE IN BETWEEN THE PROCESS

Select location,max(cast(total_deaths as bigint)) as TotalDeathCount
from PortfolioProject..CovidDeaths
where continent is null
group by location
order by TotalDeathCount desc

--TOTAL DEATHS IN PERCENTAGE AND NUMBERS

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as bigint)) as total_deaths,sum(cast(new_deaths as bigint))/sum(new_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
group by date
order by 1,2

select sum(new_cases) as total_cases, sum(cast(new_deaths as bigint)) as total_deaths,sum(cast(new_deaths as bigint))/sum(new_cases)*100 as Death_Percentage
from PortfolioProject..CovidDeaths
where continent is not null
--group by date
order by 1,2

--VACCINATION TABLE

select * from PortfolioProject..CovidVaccinations

select * from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location=vac.location 
and dea.date=vac.date

--TOTAL POPULATION VS VACCINATIONS

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 1,2,3

--TOTAL VACCINATIONS BY DATE AND LOCATION

select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as Vaccination_By_Date
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
order by 2,3

--USING CTE TO DEFINE VACCINATIONS BY POPULATION

with popvsvac (continent,location,date,population,new_vaccinations,Vaccination_By_Date)
as 
(
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as Vaccination_By_Date
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null
--order by 2,3
)
select *,(Vaccination_By_Date/population)*100 as VAC_PERCENTAGE
from popvsvac

--CREATE A VIEW FOR VISUALIZATION

create view PercentPopulationVaccinated as 
select dea.continent, dea.location, dea.date,dea.population, vac.new_vaccinations,
sum(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.date) as Vaccination_By_Date
from PortfolioProject..CovidDeaths as dea
join PortfolioProject..CovidVaccinations as vac
on dea.location=vac.location 
and dea.date=vac.date
where dea.continent is not null 

select * from PercentPopulationVaccinated 