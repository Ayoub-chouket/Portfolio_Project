
select * from Portfolio_Project..CovidVaccinations
order by 2,3;



select * from Portfolio_Project..CovidDeaths
order by 2,3;


select location, date, total_cases, new_cases, total_deaths, population
from Portfolio_Project..CovidDeaths
order by 1,2;


-- Total Cases VS Total Deaths


select location, date, total_cases, total_deaths, (total_deaths/total_cases)* 100 as Death_Percentage
from Portfolio_Project..CovidDeaths
where location like '%tunisia%'
order by 1,2;


-- Total Cases VS Population 

select location, date, population, total_cases, (total_cases/population)* 100 as Percent_Population_Infected
from Portfolio_Project..CovidDeaths
where location like '%tunisia%'
order by 1,2;


-- Countries with highest Infection Rate compared to Population


select location, population, max(total_cases) as highest_Infection_count, max((total_cases/population))* 100 
as Percent_Population_Infected
from Portfolio_Project..CovidDeaths
group by location, population
order by Percent_Population_Infected desc


-- Countries with the highest Death count per Population

select location, max(cast(total_deaths as int)) as Total_Death_count
 from Portfolio_Project..CovidDeaths
 where continent is not null
 group by location 
 order by Total_Death_count desc 


 -- BREAK THINGS BY CONTINENT --

 -- Continent with the highest Death count per Population

 select continent, max(cast(total_deaths as int)) as Total_Death_count
 from Portfolio_Project..CovidDeaths
 where continent is not null
 group by continent 
 order by Total_Death_count desc 


 -- Global Death_Percentage

 select sum(new_cases) as Total_Cases, sum(cast(new_deaths as int)) as Total_Deaths,
 sum(cast(new_deaths as int))/sum(new_cases)* 100 as Death_Percentage
 from Portfolio_Project..CovidDeaths
 where continent is not null
 order by 1,2

 -- Total Population vs Total Vaccinations

 with PopvsVac (continent, location, Date, population, new_vaccinations, Rolling_Peopel_Vaccinated)
 as
 (
 select dea.continent, dea.location, dea.Date , dea.population, vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as int))
 over (partition by dea.location order by dea.location,dea.date) as Rolling_Peopel_Vaccinated
 from Portfolio_Project..CovidDeaths as dea 
 join Portfolio_Project..CovidVaccinations as vac 
    on dea.location = vac.location 
    and dea.date = vac.date 
 where dea.continent is not null 
 --order by 2,3
)

select *,(Rolling_Peopel_Vaccinated/population)*100 as Vaccination_percentage
from PopvsVac 


--Temp Table

create table #Rolling_Peopel_Vaccinated (
continent nvarchar(255),
location nvarchar(255),
Date datetime,
population numeric,
new_Vaccination numeric,
rolling_peopel_vaccinated numeric)

insert into #Rolling_Peopel_Vaccinated 
select dea.continent, dea.location, dea.Date , dea.population, vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as int))
 over (partition by dea.location order by dea.location,dea.date) as Rolling_Peopel_Vaccinated
 from Portfolio_Project..CovidDeaths as dea 
 join Portfolio_Project..CovidVaccinations as vac 
    on dea.location = vac.location 
    and dea.date = vac.date 
 where dea.continent is not null 
 --order by 2,3

 select * ,(Rolling_Peopel_Vaccinated/population)*100 as Vaccination_percentage
from  #Rolling_Peopel_Vaccinated 

--Creating View to Store Data for later Visualizations

create view Rolling_Peopel_Vaccinated as 
select dea.continent, dea.location, dea.Date , dea.population, vac.new_vaccinations
 ,sum(cast(vac.new_vaccinations as int))
 over (partition by dea.location order by dea.location,dea.date) as Rolling_Peopel_Vaccinated
 from Portfolio_Project..CovidDeaths as dea 
 join Portfolio_Project..CovidVaccinations as vac 
    on dea.location = vac.location 
    and dea.date = vac.date 
 where dea.continent is not null 


select * from Rolling_Peopel_Vaccinated






