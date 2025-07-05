CREATE DATABASE internship_demo;
USE internship_demo;

CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    country VARCHAR(50)
);

INSERT INTO customers VALUES
(1,'Rahul', 'rahul@gmail.com', 'India'), 
(2,'Prakhar', 'prakhar@gmail.com', 'India'), 
(3,'Yash', 'yash@gmail.com', 'USA'), 
(4,'Parth', 'parth@gmail.com', 'India'), 
(5,'Tanay', 'tanay@outlook.com', 'USA'),
(6,'Shourya', 'shourya@outlook.com', 'India');

CREATE TABLE cars(
	id INT PRIMARY KEY,
    car_name VARCHAR(100)
);

select * from customers;
