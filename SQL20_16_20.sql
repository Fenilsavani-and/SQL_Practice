-- Question 16) query to display for each Olympic Games, which country won 
-- the highest gold, silver and bronze medals
SELECT * FROM OLYMPICS_HISTORY;
with Main_tb as
(
	select games, region, medal 
	from OLYMPICS_HISTORY o 
	inner join OLYMPICS_HISTORY_NOC_REGIONS r
	on o.noc = r.noc
	where medal != 'NA' 
),
m_sum as (
	select games, region, 
		sum(case when medal= 'Gold' then 1 else 0 end ) as no_gold,
		sum(case when medal='Silver' then 1 else 0 end ) as no_silver,
		sum(case when medal='Bronze' then 1 else 0 end ) as no_bronze	
	from Main_tb  
	group by games, region
	order by games, no_gold, no_silver, no_bronze desc
	     )
select distinct games, 
	            concat((first_value(region) over(partition by games order by no_gold desc)),
					    '-',(first_value(no_gold) over(partition by games order by no_gold desc))) as mx_gold,
	            concat((first_value(region) over(partition by games order by no_silver desc)),
					    '-',(first_value(no_silver) over(partition by games order by no_silver desc))) as mx_silver,
	            concat((first_value(region) over(partition by games order by no_bronze desc)),
					    '-',(first_value(no_bronze) over(partition by games order by no_bronze desc))) as mx_bronze
from m_sum
order by games;
-- same one clumn to multiple columns we need sum(case)
-- first_value() over(Partition by column) which we want to group by so we will order by 

-- Question 17) Add Max medal country by games:
with Main_tb as
(
	select games, region, medal 
	from OLYMPICS_HISTORY o 
	inner join OLYMPICS_HISTORY_NOC_REGIONS r
	on o.noc = r.noc
	where medal != 'NA' 
),
m_sum as (
	select games, region, 
		sum(case when medal= 'Gold' then 1 else 0 end ) as no_gold,
		sum(case when medal='Silver' then 1 else 0 end ) as no_silver,
		sum(case when medal='Bronze' then 1 else 0 end ) as no_bronze,
		sum(case when medal in('Gold','Silver','Bronze') then 1 else 0 end ) as all_medal
	from Main_tb  
	group by games, region
	order by games, no_gold, no_silver, no_bronze desc
	    )


select distinct games, 
	            concat((first_value(region) over(partition by games order by no_gold desc)),
					    '-',(first_value(no_gold) over(partition by games order by no_gold desc))) as mx_gold,
	            concat((first_value(region) over(partition by games order by no_silver desc)),
					    '-',(first_value(no_silver) over(partition by games order by no_silver desc))) as mx_silver,
	            concat((first_value(region) over(partition by games order by no_bronze desc)),
					    '-',(first_value(no_bronze) over(partition by games order by no_bronze desc))) as mx_bronze,
				concat((first_value(region) over(partition by games order by all_medal desc)),
					    '-',(first_value(all_medal) over(partition by games order by all_medal desc))) as max_medal		
from m_sum
order by games;


-- Question 18) Query to fetch details of countries which have won silver or bronze medal but never won a gold medal.
-- create extension if not exists tablefunc;
with Main_tb as 
(
	select * 
	from crosstab( 'select region, medal, count(medal) as m_count 
					from OLYMPICS_HISTORY o 
					inner join OLYMPICS_HISTORY_NOC_REGIONS r
					on o.noc = r.noc
					where medal != ''NA''
					group by region, medal
					order by region, medal',
				  'values (''Bronze''), (''Gold''), (''Silver'')' -- Variable declaration.

				  )
				as (region varchar, Bronze bigint, Gold bigint, Silver bigint )
				order by gold DESC
),
t1 as (
		select region, COALESCE(bronze,0) as Bronze,
			   COALESCE(gold,0) as Gold,
			   COALESCE(silver,0) as Silver
		from Main_tb
		order by Silver DESC
	  ),
Final as(
		select distinct region, 
			   bronze,
			   (dense_rank() over(order by gold ASC)) as gold_null,
			   silver
		from t1 
-- here 1 means it will assign to 0  gold country
	    )
select region, bronze, 
	   case when gold_null = 1 then 0 end as gold,silver 
	   from Final 
	   where gold_null =1 
	   order by silver DESC;
	   
	   
-- Question 19 ) return the sport which has won India the highest no of medals. 
with Main_tb as
(
	select region, sport, medal 
	from OLYMPICS_HISTORY o 
	inner join OLYMPICS_HISTORY_NOC_REGIONS r
	on o.noc = r.noc
	where region = 'India' and  medal != 'NA' 
)
select sport, count(medal) as count_n 
from Main_tb
group by sport
order by count_n desc
limit 1
;

-- Question 20) SQL Query to fetch details of all Olympic Games where India won medal(s) in hockey.
with Main_tb as
(
	select region, sport,games, medal 
	from OLYMPICS_HISTORY o 
	inner join OLYMPICS_HISTORY_NOC_REGIONS r
	on o.noc = r.noc
	where region = 'India' and  medal != 'NA' and sport = 'Hockey'
)
select region, sport, games, count(medal) as count_n 
from Main_tb
group by region, sport, games
order by count_n desc;

	
---

