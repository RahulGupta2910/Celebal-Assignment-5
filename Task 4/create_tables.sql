-- This code creates a source database named 'celebal_source' and two tables named departments and products respectively

CREATE DATABASE IF NOT EXISTS celebal_source;
USE celebal_source;


-- Creating tables
CREATE TABLE departments (
  id INT PRIMARY KEY,
  name VARCHAR(100),
  location VARCHAR(100),
  head VARCHAR(100),
  budget DECIMAL(12,2),
  created_at DATE
);

CREATE TABLE products (
  product_id INT PRIMARY KEY,
  product_name VARCHAR(100),
  category VARCHAR(50),
  price DECIMAL(10, 2),
  in_stock TINYINT
);

-- Inserting sample data

INSERT INTO departments (id, name, location, head, budget, created_at) VALUES
(1, 'HR', 'New Delhi', 'Anita Sharma', 500000.00, '2018-01-10'),
(2, 'IT', 'Bengaluru', 'Rajesh Verma', 1200000.00, '2017-03-15'),
(3, 'Finance', 'Mumbai', 'Megha Jain', 800000.00, '2016-06-01'),
(4, 'Marketing', 'Gurgaon', 'Sandeep Mehta', 950000.00, '2019-08-20'),
(5, 'Sales', 'Chennai', 'Neha Gupta', 1100000.00, '2018-11-05'),
(6, 'Operations', 'Pune', 'Amit Khurana', 600000.00, '2020-01-25'),
(7, 'Legal', 'Hyderabad', 'Ritu Desai', 400000.00, '2020-05-10'),
(8, 'Research and Development', 'Noida', 'Vikram Bansal', 1500000.00, '2017-12-12'),
(9, 'Customer Service', 'Kolkata', 'Priya Singh', 450000.00, '2021-02-28'),
(10, 'Procurement', 'Jaipur', 'Arun Yadav', 550000.00, '2019-07-01'),
(11, 'Administration', 'Lucknow', 'Divya Mishra', 350000.00, '2016-04-18'),
(12, 'Logistics', 'Ahmedabad', 'Kunal Shah', 620000.00, '2020-09-30'),
(13, 'Training', 'Bhopal', 'Sonia Pathak', 300000.00, '2018-06-14'),
(14, 'Quality Assurance', 'Nagpur', 'Rohit Joshi', 700000.00, '2017-10-23'),
(15, 'Public Relations', 'Patna', 'Nidhi Kapoor', 480000.00, '2021-01-12');


INSERT INTO products (product_id, product_name, category, price, in_stock) VALUES
(201, 'Notebook', 'Stationery', 35.00, 1),
(202, 'Ball Pen', 'Stationery', 10.00, 1),
(203, 'Backpack', 'Accessories', 899.99, 1),
(204, 'Bluetooth Speaker', 'Electronics', 1599.00, 1),
(205, 'Desk Lamp', 'Home', 499.00, 0),
(206, 'Wireless Mouse', 'Electronics', 799.00, 1),
(207, 'Water Bottle', 'Accessories', 249.50, 1),
(208, 'Sticky Notes', 'Stationery', 45.00, 1),
(209, 'Portable Charger', 'Electronics', 1299.00, 0),
(210, 'LED Monitor', 'Electronics', 8499.00, 1),
(211, 'Whiteboard Marker', 'Stationery', 20.00, 1),
(212, 'Chair Cushion', 'Home', 349.00, 1),
(213, 'Smartphone Stand', 'Electronics', 199.00, 1),
(214, 'Sunglasses', 'Accessories', 699.00, 1),
(215, 'Extension Board', 'Electronics', 379.00, 1),
(216, 'File Organizer', 'Stationery', 159.00, 1),
(217, 'Hand Sanitizer', 'Personal Care', 75.00, 1),
(218, 'Yoga Mat', 'Fitness', 499.00, 0),
(219, 'Laptop Sleeve', 'Accessories', 999.00, 1),
(220, 'Wall Clock', 'Home', 650.00, 1);

-- Print Tables

select * from departments;
select * from products;
