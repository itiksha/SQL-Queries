-- Create sachin Table
CREATE TABLE sachin (
    match_no INT PRIMARY KEY,
    runs_scored INT,
    status VARCHAR(10)
);

-- Input values to table 
INSERT INTO sachin (match_no, runs_scored, status)
VALUES 
    (1, 53, 'out'),
    (2, 59, 'not-out'),
    (3, 113, 'out'),
    (4, 29, 'out'),
    (5, 0, 'out'),
    (6, 39, 'out'),
    (7, 73, 'out'),
    (8, 149, 'out'),
    (9, 93, 'out'),
    (10, 25, 'out');

-- You need to write an SQL to get match number 
--when he completed 500 runs and his 
-- batting average at the end of 10 matches.
-- Batting Average = (Total runs scored) / 
-- (no of times batsman got out)

-- Warm-up 1
select 
sum(runs_scored) as total_score from sachin

-- Warm-up 2
select 
sum(case when status = 'out' then 1 else 0 end) over() as batting_average
from sachin

-- Warm-up 3
select 
sum(runs_scored) over()/ sum(case when status = 'out' then 1 else 0 end) over() as batting_average
from sachin
 
-- Warm-up 4
 select 
sum(runs_scored) over(order by match_no rows between unbounded preceding and current row) as running_sum
from sachin;

-- Final Result 

-- Common Table Expression (CTE) to calculate batting average and running sum
with cte as (
select *,
-- Calculate batting average: total runs scored / number of times batsman got out
sum(runs_scored) over()*1.0/ 
sum(case when status ='out' then 1 else 0 end) over()
as batting_average , 

-- Calculate running sum of runs scored up to the current match  
sum(runs_scored) over
(order by match_no rows BETWEEN unbounded preceding AND
 current row) as running_sum
  from sachin) 
 -- Final query to fetch match number and batting average when running_sum > 500
 select match_no, round(batting_average,2) as
 batting_average from
 -- Subquery to rank rows by running_sum and filter where running_sum > 500
 ( 
 Select *, row_number() over (order by running_sum) as rn
 from cte
 where running_sum > 500) 
 limit 1;  -- Limit to only one row (the earliest match where running sum exceeds 500)
 
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
