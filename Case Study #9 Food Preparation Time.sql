CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    restaurant_id INT,
    order_time TIME,
    expected_delivery_time TIME,
    actual_delivery_time TIME,
    rider_delivery_mins INT
);

INSERT INTO orders (order_id, restaurant_id, order_time, expected_delivery_time, actual_delivery_time, rider_delivery_mins) VALUES
(1, 101, '12:00:00', '12:30:00', '12:45:00', 15),
(2, 102, '12:15:00', '12:45:00', '12:55:00', 10),
(3, 103, '12:30:00', '13:00:00', '13:10:00', 15),
(4, 101, '12:45:00', '13:15:00', '13:21:00', 5),
(5, 102, '13:00:00', '13:30:00', '13:36:00', 10),
(6, 103, '13:15:00', '13:45:00', '13:58:00', 10),
(7, 101, '13:30:00', '14:00:00', '14:12:00', 20),
(8, 102, '13:45:00', '14:15:00', '14:25:00', 10),
(9, 103, '14:00:00', '14:30:00', '14:30:00', 5),
(10, 101, '14:15:00', '14:45:00', '15:05:00', 15);


-- Define a Common Table Expression (CTE) to calculate the total delivery time in minutes
WITH cte AS (
    SELECT 
        restaurant_id,                  -- Select the restaurant ID
        order_time,                     -- Select the order time
        actual_delivery_time,           -- Select the actual delivery time
        rider_delivery_mins,            -- Select the time taken by the rider to deliver

        -- Calculate the total delivery time in minutes using strftime to convert times to seconds
        -- and then dividing by 60 to convert seconds to minutes
        (strftime('%s', actual_delivery_time) - strftime('%s', order_time)) / 60.0 AS total_delivery_mins
    FROM orders
)

-- Main query to calculate the average food preparation time for each restaurant
SELECT 
    restaurant_id,                     -- Select the restaurant ID
    -- Calculate the average food preparation time by subtracting rider delivery minutes from the total delivery time,
    -- and round the result to 2 decimal places
    ROUND(AVG(total_delivery_mins - rider_delivery_mins), 2) AS avg_food_prep_mins
FROM 
    cte                                -- Use the CTE defined above
GROUP BY 
    restaurant_id                      -- Group by restaurant ID to calculate averages per restaurant
ORDER BY 
    avg_food_prep_mins;                -- Order the results by average food preparation time in ascending order
