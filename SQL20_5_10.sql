select * from OLYMPICS_HISTORY;
-- Question 5) Which nations have participated in all games:

with Main_table as (
				    select r.region, o.games from OLYMPICS_HISTORY o
		            inner join OLYMPICS_HISTORY_NOC_REGIONS r
		            on o.noc = r.noc
				   ),
Top_Country as	
(
select region, count(distinct(games)) as Count_games
from Main_table
group by region
order by Count_games DESC limit 4
)

select * from Top_Country;-- where count_games = (select max(Count_games) from Top_Country)

-- Question 6) fetch the list of all sports which have been part of every olympics.:

select sport, count(distinct(games)) as No_of_games
       
       from OLYMPICS_HISTORY
	   group by sport
	   order by No_of_games DESC
	   limit 5;
	   
-- Question 7) Identify the sport which were just played once in all of olympics.
with sports_min as
		( select sport, count(distinct(games)) as No_games
          from OLYMPICS_HISTORY
	      group by sport
	      having count(distinct(games)) = 1
		)
		
select distinct s.*, games 
from sports_min s
left join OLYMPICS_HISTORY o 
on s.sport = o.sport;

-- Question 8) fetch the total no of sports played in each olympics.
select games , count(distinct(sport)) as number_sports
       from OLYMPICS_HISTORY
	   group by games
	   order by number_sports DESC;
	   
-- Question 9) fetch the details of the oldest athletes to win a gold medal at the olympics.
select * from OLYMPICS_HISTORY;	

select * from 
       OLYMPICS_HISTORY 
	   where medal = 'Gold' 
	   and age = (select max(age) from OLYMPICS_HISTORY where medal = 'Gold' and age!= 'NA')

-- in Max() function will work only numeric val in my case we had string value
-- like 'NA' so we ignored it.

-- Question 10) get the ratio of male and female participants
with numbers as (
Select (select count(sex) from OLYMPICS_HISTORY where sex = 'M') as male,
       (select count(sex) from OLYMPICS_HISTORY where sex = 'F') as Female
from OLYMPICS_HISTORY limit 1
	)
select concat((female/female),':',(round(male::decimal/female::decimal,2))) as ratio from numbers;

-- used round function and ::decimal to get float value of dividing 2 integers number:
