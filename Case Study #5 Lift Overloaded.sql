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
with Passengers as ( 
select 
l.id,
lp.passenger_name,
lp.weight_kg,
l.capacity_kg,
sum(lp.weight_kg) over(partition by l.id order by lp.weight_kg 
rows between unbounded preceding and current row) as running_sum
from lifts l 
inner join lift_passengers lp on
l.id = lp.lift_id
) 

select 
id,
Group_CONCAT(passenger_name,',') as passenger_list
from 
Passengers
where 
running_sum < capacity_kg 
group by id
;
