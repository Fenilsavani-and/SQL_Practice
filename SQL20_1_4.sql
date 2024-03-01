-- 1) How many olympics games have been held?
select * from OLYMPICS_HISTORY;

SELECT count(distinct(games)) as Total_games FROM OLYMPICS_HISTORY;

--2) List down all Olympics games held so far

SELECT distinct(games,city) as Games from OLYMPICS_HISTORY;

--3) Mention total numbers of nations who participate in each sports.

SELECT games, count(distinct(noc)) as Nation_count from OLYMPICS_HISTORY
group by games;

--4) Which year saw the highest and lowest no of countries participating in olympics
WITH 
Main_Table1 as
(
	select o.games, r.region 
	from OLYMPICS_HISTORY o  
	inner join OLYMPICS_HISTORY_NOC_REGIONS r on o.noc = r.noc
),
total_country as		 
(
	select games, count(distinct(region)) as region_number
	from Main_Table1
	group by games 
)

select concat( (select games
	   			from total_country 
	   		    limit 1),
			    '-',
			   (select min(region_number) from total_country)
			 ) as Min_country,
			 
	   concat( (select games
			    from total_country
				order by region_number desc
			    limit 1),
			  '-',
			 (select max(region_number) from total_country)
	         ) as Max_country
from total_country limit 1;
-- It is used with order by and limit and concat methods where we used parameters as select queries.
-- CONCAT((select'Not use at end ; in select query'),(),())

WITH participating_countries as
(
	select games, region
	from OLYMPICS_HISTORY oh
	join OLYMPICS_HISTORY_NOC_REGIONS nr on nr.noc = oh.noc
	group by games, nr.region
),
tot_countries as 
(
	SELECT games, count(1) as total_countries 	
	FROM participating_countries
	GROUP BY games
	ORDER BY total_countries
)
SELECT DISTINCT
	concat(first_value(games) over(order by total_countries), '-', 
		  	first_value(total_countries) over(order by total_countries)) as Lowest_Countries,
			
	concat(first_value(games) over(order by total_countries DESC), '-',
		  	first_value(total_countries) over(order by total_countries DESC)) as Highest_Countries
FROM tot_countries
-- first_value(it will take first row) from over(We will pass table name here with condition)

