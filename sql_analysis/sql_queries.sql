-- **Examining the Tables**
SELECT table_name 
FROM information_schema.tables 
WHERE table_schema = 'public';

SELECT c.customer_id 
FROM customers c 
LIMIT 10;

SELECT column_name, data_type 
FROM information_schema.columns
WHERE table_name = 'order_details';

SELECT "customer_id" FROM "customers"
UNION
SELECT "customer_id" FROM "orders";

-- **Listing of Customers**
SELECT * 
FROM customers
ORDER BY company_name ASC;

SELECT * 
FROM customers;

SELECT product_id, product_name, units_in_stock, units_on_order
FROM products
WHERE units_in_stock < 0;

SELECT customer_id, company_name 
FROM customers 
WHERE region IS NULL;

SELECT customer_id, phone
FROM customers 

-- **Cleaning Phone Numbers**
ALTER TABLE customers ADD COLUMN clean_phone VARCHAR(15);

UPDATE customers
SET clean_phone = REGEXP_REPLACE(phone, '\D', '', 'g');


-- **Filtering by Order Date**
SELECT * 
FROM orders
WHERE order_date > '1997-01-01';

-- **Filtering by Product Prices**
SELECT product_id, product_name, unit_price 
FROM products
WHERE unit_price BETWEEN 20 AND 50;

-- **Top Countries by Customer Count**
--CREATE INDEX idx_customers_country ON customers(country);
-- SET enable_seqscan = OFF;
-- EXPLAIN SELECT c.customer_id, c.company_name, c.country
-- FROM customers c
-- WHERE c.country = 'Germany';
SELECT c.country, 
       COUNT(customer_id) AS total_customers
FROM customers c
GROUP BY c.country
ORDER BY total_customers DESC;

-- **Summarizing Data with Aggregate Functions**
SELECT 
    ROUND(MIN(unit_price)::NUMERIC, 2) AS min_price,
    ROUND(MAX(unit_price)::NUMERIC, 2) AS max_price,
    ROUND(AVG(unit_price)::NUMERIC, 2) AS avg_price
FROM products;

-- **Total Orders Per Customer**
SELECT c.customer_id, c.company_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY total_orders DESC;
-- **2. Count of Customers with Orders**
-- This query counts the number of distinct customers who have placed at least one order.
SELECT COUNT(DISTINCT customer_id) AS customers_with_orders
FROM orders;
-- **3. Customers Without Orders**
-- This query identifies customers who have not placed any orders by checking for NULL values in the orders table.
SELECT c.customer_id, c.company_name
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- **Category-Based Products**
SELECT ct.category_name, COUNT(p.product_id) AS total_products
FROM categories ct
JOIN products p ON ct.category_id = p.category_id
GROUP BY ct.category_name;

-- **Products Above the Average Price**
-- SELECT product_name, unit_price
-- FROM products
-- WHERE unit_price > (SELECT AVG(unit_price) FROM products);
SELECT 
    product_name, 
    unit_price,
    (SELECT ROUND(AVG(unit_price)::NUMERIC, 2) FROM products) AS average_price
FROM products
WHERE unit_price > (SELECT AVG(unit_price) FROM products);

-- **Best-Selling Products**
SELECT p.product_name, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC
LIMIT 10;

-- **Classifying Products by Price Category**
SELECT product_name, unit_price,
       CASE 
         WHEN unit_price < 20 THEN 'Cheap'
         WHEN unit_price BETWEEN 20 AND 50 THEN 'Moderate'
         ELSE 'Expensive'
       END AS price_category
FROM products;

-- **Top-Selling Categories**
SELECT ct.category_name, SUM(od.quantity) AS total_sales
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories ct ON p.category_id = ct.category_id
GROUP BY ct.category_name
ORDER BY total_sales DESC;

-- **Customer Region Analysis**
SELECT c.country, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.country
ORDER BY total_orders DESC;

-- **Employee Performance**
SELECT e.employee_id, 
	e.first_name || ' ' || e.last_name AS employee_name, 
	COUNT(o.order_id) AS total_orders
FROM employees e
JOIN orders o ON e.employee_id = o.employee_id
GROUP BY e.employee_id, employee_name
ORDER BY total_orders DESC;

-- **Annual Sales Trends**
SELECT EXTRACT(YEAR FROM o.order_date) AS order_year, 
	ROUND(SUM(od.quantity * od.unit_price)::NUMERIC, 2) AS total_sales
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_year
ORDER BY order_year;

-- **Customer Spending Analysis**
SELECT c.customer_id, c.company_name, 
	ROUND(SUM(od.quantity * od.unit_price):: NUMERIC, 2) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY total_spent DESC
LIMIT 10;

-- **Most Profitable Products**
SELECT p.product_name, ROUND(SUM(od.quantity * od.unit_price):: NUMERIC, 2) AS total_revenue
FROM order_details od
JOIN products p ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_revenue DESC
LIMIT 10;

-- **Top Customers by Order Count**
SELECT c.customer_id, c.company_name, COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY total_orders DESC
LIMIT 10;

SELECT o.order_id, ROUND(SUM(od.unit_price * od.quantity)::NUMERIC, 2) AS total_sales
FROM orders o
JOIN order_details od ON od.order_id = o.order_id
GROUP BY o.order_id
ORDER BY total_sales DESC;

-- **Orders and Products Relationship**
SELECT 
    o.order_id,
    o.order_date,
    p.product_name,
    od.quantity
FROM orders o
RIGHT JOIN order_details od ON o.order_id = od.order_id
JOIN products p ON od.product_id = p.product_id
ORDER BY o.order_id;

-- **Categories and Products Overview**
SELECT 
    c.category_id,
    c.category_name,
    p.product_id,
    p.product_name
FROM categories c
FULL JOIN products p ON c.category_id = p.category_id
ORDER BY c.category_id;

