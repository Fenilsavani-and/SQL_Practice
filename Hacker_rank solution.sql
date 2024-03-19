with start as 
(
    select start_date,  row_number() over(order by start_date asc) as r1
    from Projects
    where start_date not in (select end_date from Projects)
),
end as(
    select end_date, row_number() over(order by end_date asc) as r2
    from Projects
    where end_date not in (select start_date from Projects)
)
select s.start_date, e.end_date from start s
inner join end e on s.r1=e.r2 
order by datediff(e.end_date, s.start_date) asc, start_date
--- Order by with datediff() function and find value in another column.

-- Made by Fenil Savani:::::
with fenil as (
    select case when start_date not in (select end_date from Projects) then start_date else 0 end as        sta
    from Projects
),
zeel as(
    select case when end_date not in (select start_date from Projects) then end_date else 0 end as ed
    from Projects
    )
SELECT t1.sta, t2.ed
FROM (  
    (SELECT distinct sta,
          row_number() over (ORDER BY sta asc) AS rn
   FROM fenil where sta != 0) as t1
    inner join
    (SELECT distinct ed, 
              row_number() over (ORDER BY ed asc) AS rn1
       FROM zeel where ed != 0) AS t2
    ON t1.rn = t2.rn1
    )
    order by datediff(t2.ed, t1.sta) ASC
----join where common column is not available in both table.