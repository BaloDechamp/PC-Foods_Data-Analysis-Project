-- Let's create a new database schema for this project
CREATE SCHEMA pizza_records;

-- Setting the Database to the defualt database
USE pizza_records;

-- Creating tables and defining relationships before importing data into each table
-- The Orders Table
DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id INT PRIMARY KEY NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL
);

-- Previewing the Table
SELECT * FROM orders;

-- The Pizzas Table
DROP TABLE IF EXISTS pizzas;

CREATE TABLE pizzas (
    pizza_id VARCHAR(100) PRIMARY KEY NOT NULL,
    pizza_type_id VARCHAR(100) NOT NULL,
    size TEXT NOT NULL,
    price DECIMAL(6, 2),
    FOREIGN KEY (pizza_type_id)
		REFERENCES pizza_types (pizza_type_id)
);

-- Previewing the Table
SELECT * FROM pizzas;

-- The Order Details Table
DROP TABLE IF EXISTS order_details;

CREATE TABLE order_details (
    order_details_id INT PRIMARY KEY NOT NULL,
    order_id INT NOT NULL,
    pizza_id VARCHAR(100) NOT NULL,
    quantity INT NOT NULL,
    FOREIGN KEY (order_id)
        REFERENCES orders (order_id),
	FOREIGN KEY (pizza_id)
		REFERENCES pizzas (pizza_id)
);

-- Previewing the Table
SELECT * FROM order_details;

-- Thw Pizza Types Table
DROP TABLE IF EXISTS pizza_types;

CREATE TABLE pizza_types (
	pizza_type_id VARCHAR(100) PRIMARY KEY NOT NULL,
	name TEXT NOT NULL,
	category TEXT NOT NULL,
	ingredients VARCHAR(100) NOT NULL
);

-- Previewing the Table
SELECT * FROM pizza_types;

-- Importing the dataset for each rable
-- The Order Table data importation
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/orders.csv" INTO TABLE orders
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Previewing the Table
SELECT * FROM orders;

-- The Pizza Types Table data importation
-- This was completed using the MYSQL Table Data Import Wizard as the dataset contained few rows

-- Previewing the Table
SELECT * FROM pizza_types;

-- The Pizza Table Data Importation
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/pizzas.csv" INTO TABLE pizzas
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Previewing the Table
SELECT * FROM pizzas;

-- The Order Details Table Importation
LOAD DATA INFILE "C:/Program Files/MySQL/Data_Set/order_details.csv" INTO TABLE order_details
FIELDS TERMINATED BY ',' ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Previewing the Table
SELECT * FROM order_details;

