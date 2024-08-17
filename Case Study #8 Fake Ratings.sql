-- Create the product_ratings table
CREATE TABLE product_ratings (
    rating_id INT PRIMARY KEY,
    product_id INT,
    user_id INT,
    rating DECIMAL(2,1)
);

-- Insert data into the product_ratings table
INSERT INTO product_ratings (rating_id, product_id, user_id, rating)
VALUES
(1, 101, 1001, 4.5),
(2, 101, 1002, 4.8),
(3, 101, 1003, 4.9),
(4, 101, 1004, 5.0),
(5, 101, 1005, 3.2),
(6, 102, 1006, 4.7),
(7, 102, 1007, 4.0),
(8, 102, 1008, 4.1),
(9, 102, 1009, 3.8),
(10, 102, 1010, 3.9);

with RatingDifferences as (
  select rating_id,
  product_id,
  user_id,
  rating,
  avg(rating) over( partition by product_id) as avg_rating,
  abs(rating -  avg(rating) over( partition by product_id)) as deviation
from 
      product_ratings
),

MaxDeviation as ( 
  select 
  product_id,
  max(deviation) as max_deviation
  from RatingDifferences
  GROUP by product_id)
  
  select 
   r.rating_id,
   r.product_id,
   r.user_id,
   r.rating
   from 
   RatingDifferences r 
   inner join 
   MaxDeviation m on r.product_id = m.product_id and 
   r.deviation = m.max_deviation;
  



