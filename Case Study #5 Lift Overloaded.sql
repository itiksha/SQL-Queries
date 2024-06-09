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
