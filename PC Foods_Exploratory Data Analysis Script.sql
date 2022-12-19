-- Exploratory Script for PC Foods Project

-- What's the total revenue of PC Foods in 2015?

SELECT 
    FORMAT(SUM(od.quantity * p.price), 2) AS total_revenue
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id;

-- On a daily basis, what's the average count of orders received?

SELECT 
	FORMAT(COUNT(order_id) / COUNT(DISTINCT(date)),0) AS avg_number_of_orders_daily
    FROM orders;

-- What's the average revenue made per day?

SELECT 
    FORMAT(SUM(od.quantity * p.price) / COUNT(DISTINCT (ord.date)), 2) AS avg_revenue_per_day
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id;

-- What's the average revenue made per order?

SELECT 
    FORMAT(SUM(od.quantity * p.price) / COUNT(ord.order_id), 2) AS avg_revenue_per_order
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id;

-- What's the total count of orders for PC foods in 2015?

SELECT 
    FORMAT(COUNT(DISTINCT (ord.order_id)),0) AS number_of_orders
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id;

-- What's the revenue on a monthly basis? and do we have seasonality in our sales?

SELECT
	MONTH(ord.date) AS months_no,
    MONTHNAME(ord.date) AS months,
    FORMAT(SUM(od.quantity * p.price), 2) AS total_revenue,
    FORMAT(COUNT(DISTINCT (ord.order_id)),0) AS number_of_orders
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
GROUP BY months_no;

--  Do we have a peak hour?

SELECT 
    CASE
        WHEN
            ord.time >= '10:00:00'
                AND ord.time <= '13:00:00'
        THEN
            '10am - 1pm'
        WHEN
            ord.time >= '13:00:01'
                AND ord.time <= '16:00:00'
        THEN
            '1pm - 4pm'
        WHEN
            ord.time >= '16:00:01'
                AND ord.time <= '19:00:00'
        THEN
            '4pm - 7pm'
        ELSE '7pm - 12am'
    END AS hours,
    FORMAT(COUNT(DISTINCT (od.order_id)), 0) AS number_of_orders
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
GROUP BY hours
ORDER BY number_of_orders DESC;

-- How many percentage does each hour group contribute to the entire revenue?

SELECT 
    CASE
        WHEN
            ord.time >= '10:00:00'
                AND ord.time <= '13:00:00'
        THEN
            '10am - 1pm'
        WHEN
            ord.time >= '13:00:01'
                AND ord.time <= '16:00:00'
        THEN
            '1pm - 4pm'
        WHEN
            ord.time >= '16:00:01'
                AND ord.time <= '19:00:00'
        THEN
            '4pm - 7pm'
        ELSE '7pm - 12am'
    END AS hours,
    FORMAT(SUM(od.quantity * p.price), 2) AS total_revenue,
    CONCAT(FORMAT(SUM(od.quantity * p.price) / (SELECT 
                        SUM(od.quantity * p.price)
                    FROM
                        order_details AS od
                            JOIN
                        pizzas AS p ON od.pizza_id = p.pizza_id) * 100, 2), '%') percentage_contributed
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
GROUP BY hours
ORDER BY percentage_contributed DESC;

-- How are our sales by Pizza category?

SELECT 
    pt.category AS pizza_category,
    FORMAT(COUNT(ord.order_id),0) AS number_of_orders,
    FORMAT(SUM(od.quantity * p.price), 2) AS total_revenue,
    CONCAT(FORMAT(SUM(od.quantity * p.price) / (SELECT 
                        SUM(od.quantity * p.price)
                    FROM
                        order_details od
                            JOIN
                        pizzas p ON od.pizza_id = p.pizza_id) * 100,
                2),
            '%') AS percentage_contributed_to_revenue
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
        JOIN
    pizza_types AS pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY category
ORDER BY percentage_contributed_to_revenue DESC;

-- What are the most ordered pizza type?

SELECT 
    p.pizza_type_id AS pizza_type,
    SUM(od.quantity) AS number_of_orders,
    FORMAT(SUM(od.quantity * p.price), 2) AS total_revenue,
    CONCAT(FORMAT(SUM(od.quantity * p.price) / (SELECT 
                        SUM(od.quantity * p.price)
                    FROM
                        order_details od
                            JOIN
                        pizzas p ON od.pizza_id = p.pizza_id) * 100, 2), '%') AS percentage_contributed_to_revenue
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
GROUP BY pizza_type
ORDER BY number_of_orders DESC
LIMIT 5;

-- What are the least ordered pizza type?

SELECT 
    p.pizza_type_id AS pizza_type,
    SUM(od.quantity) AS number_of_orders,
    FORMAT(SUM(od.quantity * p.price), 2) AS total_revenue,
    CONCAT(FORMAT(SUM(od.quantity * p.price) / (SELECT 
                        SUM(od.quantity * p.price)
                    FROM
                        order_details od
                            JOIN
                        pizzas p ON od.pizza_id = p.pizza_id) * 100, 2), '%') AS percentage_contributed_to_revenue
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
GROUP BY pizza_type
ORDER BY number_of_orders ASC
LIMIT 5;

-- is there a correlation between price and the number of orders received?
-- Creating a view to store the required data for this test.

CREATE VIEW test_data AS
SELECT 
    p.pizza_type_id AS pizza_type,
    FORMAT(AVG(p.price), 2) AS price,
    COUNT(ord.order_id) AS number_of_orders
FROM
    orders AS ord
        JOIN
    order_details AS od ON ord.order_id = od.order_id
        JOIN
    pizzas AS p ON od.pizza_id = p.pizza_id
GROUP BY pizza_type;

-- Defining variables for the formula to be used

SELECT 
	@price_mean := AVG(price),
	@num_of_orders_mean := AVG(number_of_orders),
    @std_dev := (stddev_samp(price) - stddev_samp(number_of_orders))
FROM test_data;

-- Calculating the relationship between price and number_of_orders received

SELECT SUM((price - @price_mean * (number_of_orders - @num_of_orders_mean))) / ((COUNT(price) - 1) * @std_dev) AS correlation_coffecient
FROM test_data;