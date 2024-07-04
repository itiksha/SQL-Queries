CREATE TABLE users (
    user_id INT PRIMARY KEY,
    username VARCHAR(10),
    opening_balance INT
);

CREATE TABLE transactions (
    id INT PRIMARY KEY,
    from_userid INT,
    to_userid INT,
    amount INT,
    FOREIGN KEY (from_userid) REFERENCES users(user_id),
    FOREIGN KEY (to_userid) REFERENCES users(user_id)
);

INSERT INTO users (user_id, username, opening_balance) VALUES
(100, 'Ankit', 1000),
(101, 'Rahul', 9000),
(102, 'Amit', 5000),
(103, 'Agam', 7500);

INSERT INTO transactions (id, from_userid, to_userid, amount) VALUES
(1, 100, 102, 500),
(2, 102, 101, 700),
(3, 101, 102, 600),
(4, 102, 100, 1500),
(5, 102, 101, 800),
(6, 102, 101, 300);

-- You are given a list of users and their opening account balance along with the trasaction done by them. 
-- Write a SQL to calculate their account balance at the end of all the transactions. 
-- Please note that users can do transactions among themselves as well.


-- Calculate the total amount sent by each user
with total_sent as ( 
select from_userid as user_id,
sum(amount) as total_sent from transactions
group by from_userid),  

-- Calculate the total amount received by each user
total_received as ( 
select to_userid as user_id,
sum(amount) as total_received from transactions
group by to_userid),  

-- combine the result to get the net amount for each user
net_transactions AS (
    SELECT 
        u.user_id,
        coalesce(ts.total_sent,0) as total_sent,
        coalesce(tr.total_received,0) as total_received,
        coalesce(tr.total_received,0) - coalesce(ts.total_sent,0) AS net_transaction
    FROM users u
    LEFT JOIN total_sent ts ON u.user_id = ts.user_id
    LEFT JOIN total_received tr ON u.user_id = tr.user_id
)

-- Calculate the final balance by adding the net transaction amount to the opening balance
SELECT 
    u.user_id,
    u.username,
    u.opening_balance + nt.net_transaction AS final_balance
FROM users u
JOIN net_transactions nt ON u.user_id = nt.user_id;
