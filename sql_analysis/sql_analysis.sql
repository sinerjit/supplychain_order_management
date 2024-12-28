-- **Most Profitable Product Groups**!
SELECT c.category_name, 
       ROUND(SUM(od.quantity * (od.unit_price - (od.unit_price * 0.6))):: NUMERIC, 2) AS total_profit
FROM order_details od
JOIN products p ON od.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY total_profit DESC
LIMIT 10;



-- **Delivery Time Analysis**
SELECT ROUND(AVG((o.shipped_date - o.order_date)):: numeric ,2) AS average_delivery_time
FROM orders o
WHERE o.shipped_date IS NOT NULL;



-- **Sales Season Analysis**
SELECT DATE_PART('month', o.order_date) AS order_month, 
       ROUND(SUM(od.quantity * od.unit_price)::NUMERIC, 2) AS total_revenue
FROM orders o
JOIN order_details od ON o.order_id = od.order_id
GROUP BY order_month
ORDER BY total_revenue DESC;



-- **Effect of Discounts on Income**
SELECT 
    ROUND(SUM(od.quantity * od.unit_price)::NUMERIC, 2) AS revenue_without_discount,
    ROUND(SUM(od.quantity * od.unit_price * (1 - od.discount))::NUMERIC, 2) AS revenue_with_discount,
    ROUND((SUM(od.quantity * od.unit_price) - 
           SUM(od.quantity * od.unit_price * (1 - od.discount)))::NUMERIC, 2) AS discount_impact
FROM order_details od;



-- **Income Projection**!
WITH monthly_revenue AS (
    SELECT 
        DATE_PART('year', o.order_date) AS order_year, 
        DATE_PART('month', o.order_date) AS order_month, 
        SUM(od.quantity * od.unit_price) AS revenue
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    WHERE DATE_PART('year', o.order_date) BETWEEN 1996 AND 1998
    GROUP BY DATE_PART('year', o.order_date), DATE_PART('month', o.order_date)
)
SELECT ROUND(CAST(AVG(revenue) * 12 AS NUMERIC), 2) AS projected_annual_revenue
FROM monthly_revenue;

-- SELECT 
--     DATE_PART('year', o.order_date) AS order_year, 
--     ROUND(SUM(od.quantity * od.unit_price) :: NUMERIC, 2) AS total_revenue
-- FROM orders o
-- JOIN order_details od ON o.order_id = od.order_id
-- WHERE DATE_PART('year', o.order_date) BETWEEN 1996 AND 1998
-- GROUP BY DATE_PART('year', o.order_date)
-- ORDER BY order_year;

-- SELECT ROUND(AVG(total_revenue) :: NUMERIC, 2) AS avg_annual_revenue
-- FROM (
--     SELECT 
--         DATE_PART('year', o.order_date) AS order_year, 
--         SUM(od.quantity * od.unit_price) AS total_revenue
--     FROM orders o
--     JOIN order_details od ON o.order_id = od.order_id
--     WHERE DATE_PART('year', o.order_date) BETWEEN 1996 AND 1998
--     GROUP BY DATE_PART('year', o.order_date)
-- ) yearly_revenue;



-- **VIP Customers**

-- Calculate total income
SELECT SUM(od.quantity * od.unit_price) * 0.2 AS revenue_threshold
FROM order_details od;

-- Calculate total revenue for each customer
SELECT c.customer_id, 
       c.contact_name, 
       ROUND(SUM(od.quantity * od.unit_price) :: NUMERIC, 2) AS customer_revenue
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_details od ON o.order_id = od.order_id
GROUP BY c.customer_id, c.contact_name
ORDER BY customer_revenue DESC;

-- High-Value Customers Based on Revenue Threshold
WITH total_revenue AS (
    SELECT SUM(od.quantity * od.unit_price) AS all_revenue
    FROM order_details od
),
customer_revenue AS (
    SELECT c.customer_id, 
           c.contact_name, 
           SUM(od.quantity * od.unit_price) AS customer_revenue
    FROM customers c
    JOIN orders o ON c.customer_id = o.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    GROUP BY c.customer_id, c.contact_name
)
SELECT cr.customer_id, 
       cr.contact_name, 
       ROUND(CAST(cr.customer_revenue AS NUMERIC), 2) AS customer_revenue
FROM customer_revenue cr
JOIN total_revenue tr ON true
WHERE cr.customer_revenue >= (tr.all_revenue * 0.05)
ORDER BY cr.customer_revenue DESC;








