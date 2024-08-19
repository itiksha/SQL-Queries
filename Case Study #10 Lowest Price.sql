-- Create the products table
CREATE TABLE products (
    id INT PRIMARY KEY,
    name VARCHAR(25),
    category VARCHAR(10),
    price INT
);

-- Insert values into the products table
INSERT INTO products (id, name, category, price) VALUES
(1, 'Cripps Pink', 'apple', 10),
(2, 'Navel Orange', 'orange', 12),
(3, 'Golden Delicious', 'apple', 6),
(4, 'Clementine', 'orange', 14),
(5, 'Pinot Noir', 'grape', 20),
(6, 'Bing Cherries', 'cherry', 36);

-- Create the purchases table
CREATE TABLE purchases (
    id INT PRIMARY KEY,
    product_id INT,
    stars INT,
    FOREIGN KEY (product_id) REFERENCES products(id)
);

-- Insert values into the purchases table
INSERT INTO purchases (id, product_id, stars) VALUES
(1, 1, 2),
(2, 3, 3),
(3, 2, 2),
(4, 4, 4),
(5, 6, 5),
(6, 6, 4);

with RatedProducts as (
select 
p.category,
p.price
from 
products p 
inner join purchases s
on p.id = s.product_id and 
s.stars >= 4
  group by category
),


LowestPrices as (
  select 
  category,
  min(price) as min_price
  from RatedProducts 
  group by category
  )
  

 select 
 c.category,
 coalesce(lp.min_price, 0) as price
 from 
 (select distinct category from products) c
 left join 
 lowestprices lp
 ON
 c.category = lp.category
 ORDER by c.category;
