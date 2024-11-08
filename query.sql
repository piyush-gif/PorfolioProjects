

select *
from CovidDeaths$

select location , date, population, total_cases, total_deaths, continent
from CovidDeaths$


select location , date, population, total_cases, total_deaths, continent
from CovidDeaths$
where location = 'nepal'

select date, total_cases, total_deaths, (total_deaths/total_cases) * 100 as deathpercentage
from PorfolioProject..CovidDeaths$
where continent is not null
group by date
order by 1,2

select  sum(new_cases) as total_Cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int)) / sum(new_cases) * 100 as deathpercenttage
from PorfolioProject..CovidDeaths$
where continent is not null

order by 1,2

-- total population vs vac

Select death.continent,death.location , death.date, death.population, vac.new_vaccinations
, sum(cast(new_vaccinations as int)) over (partition by death.location order by death.location,
death.date) as pplvacinated
from PorfolioProject..CovidDeaths$ death
join PorfolioProject..CovidVaccinations$ vac
	on death.location = vac.location and 
	death.date = vac.date
where death.continent is not null
order by 2,3

-- using cte
with PopvsVac  (continent, location, date, population, new_vaccinations, pplvacinated)
as
(
Select death.continent, death.location , death.date, death.population, vac.new_vaccinations
, sum(cast(new_vaccinations as int)) over (partition by death.location order by death.location,
death.date) as pplvacinated
from PorfolioProject..CovidDeaths$ death
join PorfolioProject..CovidVaccinations$ vac
	on death.location = vac.location and 
	death.date = vac.date
where death.continent is not null
)
select * , (pplvacinated / population) * 100
from PopvsVac


-- temp table
drop table if exists #PercentPopulationVaccinated
create table #PercentPopulationVaccinated(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
pplvacinated numeric
)

Select death.continent,death.location , death.date, death.population, vac.new_vaccinations
, sum(cast(new_vaccinations as int)) over (partition by death.location order by death.location,
death.date) as pplvacinated
from PorfolioProject..CovidDeaths$ death
join PorfolioProject..CovidVaccinations$ vac
	on death.location = vac.location and 
	death.date = vac.date
where death.continent is not null
order by 2,3

select * , (pplvacinated / population) * 100
from #PercentPopulationVaccinated


-- creating view to store data for later visulizations

create view percentpopulationvaccinated as 
Select death.continent,death.location , death.date, death.population, vac.new_vaccinations
, sum(cast(new_vaccinations as int)) over (partition by death.location order by death.location,
death.date) as pplvacinated
from PorfolioProject..CovidDeaths$ death
join PorfolioProject..CovidVaccinations$ vac
	on death.location = vac.location and 
	death.date = vac.date
where death.continent is not null


select * 
from percentpopulationvaccinated