CREATE TABLE creators (
    creator_id INT PRIMARY KEY,
    creator_name VARCHAR(20),
    followers INT
);

CREATE TABLE posts (
    post_id VARCHAR(3) PRIMARY KEY,
    creator_id INT,
    publish_date DATE,
    impressions INT
);

INSERT INTO creators (creator_id, creator_name, followers) VALUES
(1, 'JohnDoe', 500),
(2, 'JaneSmith', 1000),
(3, 'AliceJohnson', 750);

INSERT INTO posts (post_id, creator_id, publish_date, impressions) VALUES
('P001', 1, '2024-05-30', 200),
('P002', 2, '2024-05-29', 350),
('P003', 3, '2024-05-28', 150);

-- Creaters who have more than 500 followers 
Select creator_name, followers
from creators
GROUP by creator_name
having followers>500;

-- Creators should have more than 100 impressions 
Select c.creator_name, p.impressions 
from creators c 
join posts p on 
c.creator_id = p.creator_id
GROUP by c.creator_name
having p.impressions > 100; 

--This query selects creators with over 50,000 followers, posts published in December 2023, and at least 3 posts with total impressions exceeding 100,000
select c.creator_name,count(p.post_id) as no_of_posts, sum(p.impressions) as total_impressions
from creators c
inner join posts p on c.creator_id=p.creator_id
where c.followers>50000 and strftime('%Y%m', p.publish_date)='202312'
group by c.creator_name,c.followers
having sum(p.impressions)>100000 and count(p.post_id)>=3






