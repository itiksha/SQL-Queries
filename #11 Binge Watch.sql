-- Create the users table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(50),
    age INT,
    country VARCHAR(50)
);

-- Create the viewinghistory table
CREATE TABLE viewinghistory (
    id INT PRIMARY KEY,  -- Added a primary key for the viewing history table
    user_id INT,
    title VARCHAR(100),
    start_time DATETIME,
    end_time DATETIME,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert dummy data into the users table
INSERT INTO users (user_id, username, age, country)
VALUES
(1, 'alice', 25, 'USA'),
(2, 'bob', 22, 'USA'),
(3, 'charlie', 29, 'Canada'),
(4, 'david', 19, 'Canada'),
(5, 'eve', 30, 'UK');

-- Insert dummy data into the viewinghistory table
INSERT INTO viewinghistory (id, user_id, title, start_time, end_time)
VALUES
(1, 1, 'Stranger Things', '2024-08-01 18:00:00', '2024-08-01 20:00:00'),
(2, 1, 'Stranger Things', '2024-08-02 18:00:00', '2024-08-02 19:00:00'),
(3, 2, 'The Witcher', '2024-08-01 19:00:00', '2024-08-01 21:00:00'),
(4, 3, 'Black Mirror', '2024-08-01 20:00:00', '2024-08-01 22:00:00'),
(5, 4, 'Stranger Things', '2024-08-02 20:00:00', '2024-08-02 21:30:00'),
(6, 5, 'The Crown', '2024-08-03 18:00:00', '2024-08-03 20:30:00'),
(7, 5, 'Stranger Things', '2024-08-04 18:00:00', '2024-08-04 19:00:00');

-- Step 1: Calculate total viewing duration and unique user count for each series in each country
WITH binge_watch AS (
    SELECT 
        u.country,  -- The country of the user
        v.title,    -- The title of the TV series
        -- Calculate the total viewing duration in minutes for each series
        SUM(strftime('%s', v.end_time) - strftime('%s', v.start_time)) / 60 AS total_duration,  
        -- Count the number of unique users who watched the series
        COUNT(DISTINCT v.user_id) AS user_count  
    FROM 
        users u  -- The users table
    JOIN 
        viewinghistory v ON u.user_id = v.user_id  -- Join with viewing history on user ID
    WHERE 
        u.age BETWEEN 18 AND 30  -- Filter to include only users aged between 18 and 30
    GROUP BY 
        u.country, v.title  -- Group results by country and TV series title
),

-- Step 2: Rank series within each country based on total viewing duration
ranked_series AS (
    SELECT 
        country,          -- The country of the users
        title,            -- The title of the TV series
        total_duration,   -- The total viewing duration for the series in minutes
        user_count,       -- The number of unique users who watched the series
        -- Assign a rank to each series within each country based on the total duration (in descending order)
        ROW_NUMBER() OVER (PARTITION BY country ORDER BY total_duration DESC) AS series_rank  
    FROM 
        binge_watch  -- Use the results from the binge_watch CTE
)
  
-- Step 3: Select the top-ranked series for each country
SELECT 
    country,         -- The country of the users
    title,           -- The title of the TV series
    total_duration,  -- The total viewing duration for the series in minutes
    user_count       -- The number of unique users who watched the series
FROM 
    ranked_series  -- Use the results from the ranked_series CTE
WHERE 
    series_rank <= 1  -- Filter to keep only the top-ranked series in each country
ORDER BY 
    country,          -- Sort results by country
    series_rank;      -- Then sort by rank within each country (though this will always be 1)














