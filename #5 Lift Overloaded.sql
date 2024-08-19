-- Create table: lifts
CREATE TABLE lifts (
    id INT PRIMARY KEY,
    capacity_kg INT
);

-- Insert data into table: lifts
INSERT INTO lifts (id, capacity_kg) VALUES
(1, 300),
(2, 350);

-- Create table: lift_passengers
CREATE TABLE lift_passengers (
    passenger_name VARCHAR(10) PRIMARY KEY,
    weight_kg INT,
    lift_id INT,
    FOREIGN KEY (lift_id) REFERENCES lifts(id)
);

-- Insert data into table: lift_passengers
INSERT INTO lift_passengers (passenger_name, weight_kg, lift_id) VALUES
('Rahul', 85, 1),
('Adarsh', 73, 1),
('Riti', 95, 1),
('Dheeraj', 80, 1),
('Vimal', 83, 2),
('Neha', 77, 2),
('Priti', 73, 2),
('Himanshi', 85, 2);


-- Que For each lift find the comma separated list of people who can be accomodated. The comma separated list should have people in the order of their weight in increasing order

-- 1st Warm up
select  
p.passenger_name , 
p.weight_kg 
from lifts l 
join 
lift_passengers p 
on l.id = p.lift_id;

--  2nd Warm up
with Eighty as ( 
select  
weight_kg 
from 
lift_passengers
where weight_kg = 80
)
select  
passenger_name , 
weight_kg 
from 
lift_passengers
where weight_kg > (select  
weight_kg 
from 
lift_passengers
where weight_kg = 80);

-- Third Warm up 
select  p1.passenger_name , p1.weight_kg
from  lift_passengers p1
join lift_passengers p2 on 
p1.weight_kg > p2.weight_kg 
where p2.weight_kg = 83 ;


-- Fourth Warm up(which throws an error)
select p2.passenger_name, p2.weight_kg 
from lift_passengers p2
join lift_passengers p1 on 
p2.weight_kg > p1.weight_kg 
where p1.weight_kg = 49;
and p2.weight_kg < 95;


-- Fifth Warm up (which return blank)
SELECT p2.passenger_name, p2.weight_kg 
FROM lift_passengers p2
JOIN lift_passengers p1 ON p2.weight_kg > p1.weight_kg 
WHERE p1.weight_kg = 49;

-- Sixth Warm up (which actually make some sense)
select 
l.id,
lp.weight_kg,
l.capacity_kg,
sum(lp.lift_id) over(partition by l.id order by lp.weight_kg 
rows between unbounded preceding and current row) as running_sum
from lifts l 
inner join lift_passengers lp on
l.id = lp.lift_id;

-- Final Result (which actually return desired result)
-- Common Table Expression (CTE) named "Passengers"
-- This CTE calculates the running sum of passenger weights for each lift
WITH Passengers AS (
    SELECT 
        l.id,
        lp.passenger_name,
        lp.weight_kg,
        l.capacity_kg,
        -- Calculate the running sum of passenger weights within each lift partition
        SUM(lp.weight_kg) OVER (PARTITION BY l.id ORDER BY lp.weight_kg ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_sum
    FROM 
        lifts l 
    INNER JOIN 
        lift_passengers lp ON l.id = lp.lift_id
) 
-- Main query to aggregate passenger names into a list for each lift
SELECT 
    id,
    -- Concatenate passenger names into a comma-separated list
    GROUP_CONCAT(passenger_name, ',') AS passenger_list
FROM 
    Passengers
-- Filter lifts where the total weight of passengers does not exceed the lift's capacity
WHERE 
    running_sum < capacity_kg 
GROUP BY 
    id;
