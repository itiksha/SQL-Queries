-- Create Customers Table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    credit_limit INT
);

-- Insert data into Customers Table
INSERT INTO customers (customer_id, credit_limit)
VALUES
    (1, 5000),
    (2, 7000),
    (3, 10000);

-- Create Loans Table
CREATE TABLE loans (
    customer_id INT,
    loan_id INT PRIMARY KEY,
    loan_due_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert data into Loans Table
INSERT INTO loans (customer_id, loan_id, loan_due_date)
VALUES
    (1, 101, '2024-06-15'),
    (2, 102, '2024-06-20'),
    (3, 103, '2024-07-01');

-- Create Credit Card Bills Table
CREATE TABLE credit_card_bills (
    customer_id INT,
    bill_id INT PRIMARY KEY,
    bill_due_date DATE,
    balance_amount INT,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Insert data into Credit Card Bills Table
INSERT INTO credit_card_bills (customer_id, bill_id, bill_due_date, balance_amount)
VALUES
    (1, 201, '2024-06-10', 500),
    (2, 202, '2024-06-15', 700),
    (3, 203, '2024-06-20', 1000);

-- Create Customer Transactions Table
CREATE TABLE customer_transactions (
    loan_bill_id INT PRIMARY KEY,
    transaction_type VARCHAR(10),
    transaction_date DATE
);

-- Insert data into Customer Transactions Table
INSERT INTO customer_transactions (loan_bill_id, transaction_type, transaction_date)
VALUES
    (101, 'purchase', '2024-06-05'),
    (102, 'payment', '2024-06-18'),
    (201, 'purchase', '2024-06-08'),
    (202, 'payment', '2024-06-10'); 


-- Calculate CIBIL Score using below formula 
-- Final Credit score formula = (on_time_loan_or_bill_payment)/total_bills_and_loans * 70 + Credit Utilization Ratio * 30 

 with all_bills as (
 select customer_id,loan_id as bill_id,loan_due_date as due_date,0 as balance_amount 
 from loans 
 union all
 select customer_id,bill_id,bill_due_date as due_date, balance_amount 
 from credit_card_bills 
 )

 , on_time_calc as 
 (select b.customer_id,sum(b.balance_amount ) as balance_amount ,count(*) as total_bills , 
 sum(case when ct.transaction_date<=due_date then 1 else 0 end) as on_time_payments
 from all_bills b 
 inner join customer_transactions ct on 
 b.bill_id = ct.loan_bill_id
 group by b.customer_id) 

 select c.customer_id , (ot.on_time_payments*1.0/ot.total_bills)*70 +
 (case when ot.balance_amount *1.0/c.credit_limit < 0.3 then 1 
 when ot.balance_amount *1.0/c.credit_limit < 0.5 then 0.7
 else 0.5 end)
 * 30 as cibil_score 
 from customers c 
 inner join on_time_calc ot on c.customer_id=ot.customer_id

