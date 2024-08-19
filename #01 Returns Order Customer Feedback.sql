-- Create table orders
CREATE TABLE orders_o (
    order_id INT,            -- Unique identifier for the order
    order_date DATE,         -- Date when the order was placed
    customer_name VARCHAR(20),  -- Name of the customer who placed the order
    sales INT                -- Sales amount for the order
);

-- Create table returns
CREATE TABLE returns_r (
    order_id INT,            -- Unique identifier for the returned order
    return_date DATE        -- Date when the order was returned
);

-- Insert data into orders_o table
INSERT INTO orders_o (order_id, order_date, customer_name, sales) 
VALUES
    (1, '2023-01-01', 'Rishi', 1239),
    (2, '2023-01-02', 'Rishi', 1239),
    (3, '2023-01-03', 'Rishi', 1239),
    (4, '2023-01-03', 'Rishi', 1239),
    (5, '2023-01-01', 'kiara', 1239),
    (6, '2023-01-02', 'kiara', 1239),
    (7, '2023-01-03', 'kiara', 1239);

-- Insert data into returns table
INSERT INTO returns_r (order_id, return_date)
VALUES
    (1, '2023-01-02'),
    (2, '2023-01-04'),
    (3, '2023-01-05'),
    (7, '2023-01-10');


-- Write a query to return customer_name and % of return order (below 50% returns of products)
-- Select customer name, total orders, total returns, and percentage of return orders for each customer
SELECT 
    o.customer_name, 
    COUNT(DISTINCT o.order_id) AS total_orders, -- Count the total number of distinct orders for each customer
    COUNT(DISTINCT r.order_id) AS total_returns, -- Count the total number of distinct return orders for each customer
    CONCAT(
        ROUND(
            CAST(COUNT(DISTINCT r.order_id) AS FLOAT) / COUNT(DISTINCT o.order_id) * 100, -- Calculate the percentage of return orders for each customer
            2
        ),
        '%' -- Add percentage sign to the result
    ) AS perc
FROM 
    orders_o o 
LEFT JOIN 
    returns_r r ON o.order_id = r.order_id -- Left join orders and returns tables on order_id
HAVING 
    CAST(COUNT(DISTINCT r.order_id) AS FLOAT) / COUNT(DISTINCT o.order_id) > 0.5; -- Filter the result to include only customers with return percentage above 50%
