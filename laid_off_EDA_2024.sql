-- Exploratory Data Analysis

CREATE TABLE layoffs_staging2024 
LIKE layoffs_2024;

INSERT layoffs_staging2024 
select *
from layoffs_2024;

select *
from layoffs_staging2024;

select max(total_laid_off), max(percentage_laid_off)
from layoffs_staging2024;

-- Information about companies that laid off 100% of their employees
select *
from layoffs_staging2024
where percentage_laid_off = '100%'
order by total_laid_off desc;

select count(company)
from layoffs_staging2024
where percentage_laid_off = '100%';

-- Companies who laid off the most employees
select company, sum(total_laid_off)
from layoffs_staging2024
group by company
order by sum(total_laid_off) desc;

-- Information per company (lay off date, number of employees)
select *
from layoffs_staging2024
where company = 'amazon';

-- Time range of lay offs
select min(`date`), max(`date`)
from layoffs_staging2024;

-- What industry was affected the most?
select industry, sum(total_laid_off)
from layoffs_staging2024
group by industry
order by sum(total_laid_off) desc;


-- Affected countries
select country, sum(total_laid_off), min(`date`), max(`date`)
from layoffs_staging2024
group by country
having sum(total_laid_off) is not null
order by sum(total_laid_off) desc;

-- Number of laid off employees per year
select year(`date`), sum(total_laid_off)
from layoffs_staging2024
group by year(`date`)
order by sum(total_laid_off) desc;

-- The progression of lay off - rolling total lay offs per month

select substring(`date`,1,7) as month, sum(total_laid_off)
from layoffs_staging2024
where substring(`date`,1,7) is not null
group by `month`
order by 1;

-- Rolling sum

with Rolling_Total as
(
select 	substring(`date`,1,7) as `month`, 
		sum(total_laid_off) as laid_off_sum
from layoffs_staging2024
where substring(`date`,1,7) is not null
group by `month`
order by `month`
)
select `month`, laid_off_sum,
sum(laid_off_sum) over (order by `month`) as Total
from Rolling_Total;


select company, year(`date`), sum(total_laid_off)
from layoffs_staging2024
group by company, year(`date`)
order by company;


with company_year (company, years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffs_staging2024
group by company, year(`date`)
), company_year_rank as
(select *, 
dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from company_year
where years is not null
)
select *
from company_year_rank
where ranking <= 5;


-- What industry was most affected in each country?
select country, industry, sum(total_laid_off) as total_laid_off,
dense_rank() over (partition by country order by sum(total_laid_off) desc) as industry_rank
from layoffs_staging2024
where total_laid_off is not null
-- where country = 'United Kingdom' and industry is not null
group by country, industry
order by 1, 3 desc;

-- Highest lay off year per country
SELECT country, max(year(`date`)) as highest_lay_off_year, max(total_laid_off)
from layoffs_staging2024
group by country
order by 2 desc;

-- Which countries had the highest lay off number and what percentage is that of the whole company on average?
select country, sum(total_laid_off) as total_laid_off, avg(percentage_laid_off), CONCAT(ROUND(avg(percentage_laid_off) * 100, 2), '%') AS percentage_value
from layoffs_staging2024
where total_laid_off is not null 
group by country
order by sum(total_laid_off) desc;


-- Which countries had the highest number of average lay off? We have to keep in mind that some countries only have a few companies on the list. 
select country, sum(total_laid_off) as total_laid_off, avg(percentage_laid_off), CONCAT(ROUND(avg(percentage_laid_off) * 100, 2), '%') AS percentage_value
from layoffs_staging2024
where total_laid_off is not null 
group by country
having avg(percentage_laid_off) is not null
order by cast(percentage_value as UNSIGNED) desc;

select *
from layoffs_staging2024
where country = 'denmark';

-- Is the lay off only centered to the capital?
select country, location, sum(total_laid_off)
from layoffs_staging2024
group by country, location
having sum(total_laid_off) is not null
order by 1, 3 desc;

-- Which industry is most affected in each country? The list only shows countries with 3 or more companies are affected per industry. In case the same number of company is affected in different industries, all industries are listed.

select country, industry, company_count
FROM
(
SELECT 
    country, industry, COUNT(*) AS company_count,
    rank() OVER (PARTITION BY country ORDER BY COUNT(*) DESC) AS `rank`
FROM 
    layoffs_staging2024
GROUP BY 
    country, industry
    ) AS ranked
   WHERE 
    `rank` = 1 and company_count>=3
    order by 3 desc;

-- Which industries were most affected in the world?
select industry, count(industry)
from layoffs_staging2024
where industry is not null
group by industry
order by 2 desc;


-- Creating new table with updated information
select *
from layoffs_backup_2024;

CREATE TABLE layoffs_backup_2024 
LIKE layoffs_2024;

INSERT layoffs_backup_2024
select *
from layoffs_2024;

update layoffs_staging2024
set company = trim(company);


-- Changing date to date type (mm/dd/yy)
select `date`,
str_to_date(`date`,'%m.%d.%Y')
from layoffs_staging2024;

update layoffs_staging2024
set `date` = str_to_date(`date`,'%m.%d.%Y');

alter table layoffs_staging2024
modify column `date` date;



-- Added total employee column - calculated from total laid off and percentage, where those numbers were available. These are only approximate numbers. The numbers we got like this can be false, since it is calculated from the lay off in each occurrance. The number calculated based on the dates for the first round of lay off should be the most correct.

UPDATE layoffs_staging2024
SET total_employee = (total_laid_off / percentage_laid_off) * 100
WHERE total_laid_off IS NOT NULL 
  AND percentage_laid_off IS NOT NULL 
  AND percentage_laid_off != 0;

-- As seen here, the total number of employee cant be calculated, since the percentage of the 1st layoff round was unknown. Only the 3nd round is known, so the number we get is already a reduced number and not the original employee number.

select *
from layoffs_staging2024
where company = 'amazon'
order by `date`;


with Layoffrounds as (
select *,
dense_rank() over (partition by company order by total_employee desc) as layoff_rounds
from layoffs_staging2024
where total_employee is not null
) 
select *
from Layoffrounds
where layoff_rounds = 1;


						WITH RankedCompanies AS (
							SELECT 
								company,
								total_employee,
								DENSE_RANK() OVER (PARTITION BY company ORDER BY total_employee DESC) AS layoff_rounds
							FROM 
								layoffs_staging2024
							WHERE 
								total_employee IS NOT NULL
						),
						CompanyMaxEmployees AS (
							SELECT 
								company,
								total_employee AS max_total_employee
							FROM 
								RankedCompanies
							WHERE 
								layoff_rounds = 1
						)
						UPDATE 
							layoffs_staging2024
						SET 
							total_employee = (
								SELECT max_total_employee
								FROM CompanyMaxEmployees
								WHERE layoffs_staging2024.company = CompanyMaxEmployees.company
							)
						WHERE 
							total_employee IS NOT NULL;


-- Drop the total_employee column, since it is not usable
ALTER TABLE layoffs_staging2024
DROP COLUMN total_employee;

select *
from layoffs_staging2024;


-- Counting the layoff rounds for each company
select company, count(company) as layoff_rounds
from layoffs_staging2024
group by company
order by 1;


CREATE TABLE layoff_rounds AS
SELECT 
    company, 
    COUNT(company) AS layoff_rounds
FROM 
    layoffs_staging2024
GROUP BY 
    company
ORDER BY 
    company;


-- Checking how many rounds it took to close a company
select *
from layoffs_staging2024 as s
join layoff_rounds as r 
on r.company = s.company
where s.percentage_laid_off = '100%'
order by layoff_rounds
;

select *
from layoffs_staging2024
where company = 'Convoy'
order by 6 desc;

-- Where did the largest number of companies close? And in what industries?

select country, count(company)
from layoffs_staging2024
where percentage_laid_off = 100
group by country
order by 2 desc;

-- When was the last round of layoff in each industry? Where did the layoff take the longest?

select industry, count(company), min(`date`), max(`date`)
from layoffs_staging2024
where percentage_laid_off = 100
group by industry
order by 4;

select industry, count(company), min(`date`), max(`date`), 
-- DATEDIFF(MAX(`date`), MIN(`date`)) AS days_elapsed, 
DATEDIFF(max(`date`), min(`date`)) / 365.25 AS years_passed
from layoffs_staging2024
where percentage_laid_off = 100
group by industry
order by 5 desc
;


















 