--Question 11) fetch the top 5 athletes who have won the most gold medals.
select * from OLYMPICS_HISTORY;

with Main_tb as
(
	select name, team, count(medal) as medals
		   from OLYMPICS_HISTORY
		   where medal = 'Gold'
		   group by name, team
		   order by medals DESC
),
t1 as
(
	select *, dense_rank() over (order by medals desc) as dense_rk
	from Main_tb
)
select name, team, medals from t1 where dense_rk < 6;
-- dense_rank() help to assign number to top records  to pull data of 5 most numbers:
-- rank() do same bt it assign index number to records which starts from.

--Question 12)  fetch the top 5 athletes who have won the most medals (Medals include gold, silver and bronze).
with Main_tb as
(
	select name, team, count(medal) as medals
		   from OLYMPICS_HISTORY
	       where medal in ('Gold','Silver','Bronze')
		   group by name, team
		   order by medals DESC
),
t1 as 
(
	select *, dense_rank() over(order by medals desc) as rnk
	from Main_tb 
)
select name, team, medals from t1 where rnk <6;

--Question 13) top 5 most successful countries in olympics
select * from OLYMPICS_HISTORY_NOC_REGIONS;
with Main_tb as
(
select r.region, count(medal) as medals
	   from OLYMPICS_HISTORY o 
	   inner join OLYMPICS_HISTORY_NOC_REGIONS r
	   on o.noc = r.noc
	   where o.medal in ('Gold', 'Silver','Bronze')
	   group by r.region
	   order by medals desc
	   limit 5
)
select *, dense_rank() over(order by medals) as rk
from Main_tb;

--Question 14) list down the  total gold, silver and bronze medals won by each country.
with Main_tb as
(
	select r.region, o.medal
	   from OLYMPICS_HISTORY o 
	   inner join OLYMPICS_HISTORY_NOC_REGIONS r
	   on o.noc = r.noc
	   where o.medal in ('Gold', 'Silver','Bronze')
	   	
)
select region,
       sum(case when medal = 'Gold' then 1 else 0 end) as Gold,
	   sum(case when medal = 'Silver' then 1 else 0 end) as Silver,
	   sum(case when medal = 'Bronze' then 1 else 0 end) as Bronze 
from Main_tb 
group by region
order by Gold DESC;
-- when we create multiple column from 1 given column then always use 'case'
-- statements.


-- Question 15) list down the  total gold, silver and bronze medals won by 
--each country corresponding to each olympic games.

with Main_tb as
(
	select o.games, r.region, o.medal
	   from OLYMPICS_HISTORY o 
	   inner join OLYMPICS_HISTORY_NOC_REGIONS r
	   on o.noc = r.noc
	   where o.medal in ('Gold', 'Silver','Bronze')
	   	
)
select games, region,
       sum(case when medal = 'Gold' then 1 else 0 end) as Gold,
	   sum(case when medal = 'Silver' then 1 else 0 end) as Silver,
	   sum(case when medal = 'Bronze' then 1 else 0 end) as Bronze 
from Main_tb 
group by games, region
order by games, region;


