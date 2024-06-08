
-- Create the business_operations table
CREATE TABLE business_operations (
    order_id SERIAL PRIMARY KEY,
    business_date DATE,
    city_id INT
);

-- Insert the sample data into the business_operations table
INSERT INTO business_operations (business_date, city_id) VALUES
('2020-01-02', 3),
('2020-07-01', 7),
('2021-01-01', 3),
('2021-02-03', 19),
('2022-12-01', 3),
('2022-12-15', 3),
('2022-02-28', 12);

-- Write a SQL to find year wise number of new cities added to the business

-- I have attempted to solve it multiple times, and at last, I have arrived at the final result, which is correct 

-- Attempt 1 
select business_date from business_operations;

-- Attempt 2 
select max(business_date) as Max_Date 
    from business_operations; 

-- Attempt 3 
select year(business_date) from business_operations;

-- Attempt 4 
SELECT EXTRACT(YEAR FROM business_date) AS Lastest_Year
FROM business_operations; 

-- Attempt 5 
SELECT  min(business_date) as Min_Date
FROM business_operations
group by strftime('%Y', business_date);

-- Attempt 6
SELECT 
    strftime('%Y', business_date) AS Max_Year,
    COUNT(DISTINCT city_id) AS no_of_new_cities
FROM 
    business_operations
GROUP BY 
    Max_Year;

-- Attempt 7 
SELECT 
    year,
    COUNT(city_id) AS no_of_new_cities
FROM (
    SELECT 
        strftime('%Y', business_date) AS year,
        city_id
    FROM 
        business_operations
    GROUP BY 
        YEAR(business_date), city_id
) AS sub
GROUP BY 
    year;
    
-- Final Result

Select 
Count (*) as no_of_new_cities,
 Min_Year 
    from ( 
Select 
city_id,
min(strftime('%Y', business_date)) as Min_Year 
from 
business_operations
group by 
city_id
 ) as Sub 
   Group by Min_Year;
