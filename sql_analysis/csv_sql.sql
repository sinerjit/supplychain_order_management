COPY (
    SELECT 
        o.order_id, 
        c.contact_name AS customer_name,
        e.first_name || ' ' || e.last_name AS employee_name,
        (o.shipped_date - o.order_date) AS shipping_days,
        ROUND(SUM(od.quantity * od.unit_price * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS total_order_value,
        ROUND(SUM(od.quantity)::NUMERIC, 0) AS total_quantity,
        o.order_date,
        o.shipped_date
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN employees e ON o.employee_id = e.employee_id
    GROUP BY o.order_id, c.contact_name, e.first_name, e.last_name, o.order_date, o.shipped_date
    ORDER BY o.order_id
) TO '/path/to/output/order_analysis.csv'
WITH CSV HEADER;

COPY (
        SELECT 
        o.order_id,
        c.customer_id,
        c.company_name AS customer_name,
        c.city,
        c.country,
        p.product_id,
        p.product_name,
        cat.category_name,
        ROUND(SUM(od.quantity * od.unit_price)::NUMERIC, 2) AS total_revenue, -- Toplam gelir
        SUM(od.quantity) AS total_quantity, -- Toplam miktar
        ROUND(AVG(od.unit_price)::NUMERIC, 2) AS average_price, -- Ortalama birim fiyat
        ROUND(SUM(od.quantity * od.unit_price * (1 - COALESCE(od.discount, 0)))::NUMERIC, 2) AS revenue_after_discounts, -- İndirim sonrası toplam gelir
        COUNT(DISTINCT o.order_id) AS total_orders, -- Toplam sipariş sayısı
        o.order_date,
        o.shipped_date,
        (o.shipped_date - o.order_date) AS shipping_days -- Teslim süresi
    FROM orders o
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
    JOIN categories cat ON p.category_id = cat.category_id
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.shipped_date IS NOT NULL -- Gönderilen siparişler
    GROUP BY 
        o.order_id, 
        c.customer_id, 
        c.company_name, 
        c.city, 
        c.country, 
        p.product_id, 
        p.product_name, 
        cat.category_name, 
        o.order_date, 
        o.shipped_date
    ORDER BY total_revenue DESC -- Toplam gelir sırasına göre sıralama
) TO '/path/to/output/order_analysis.csv'
WITH CSV HEADER;



-- ** Python ** __
COPY (
    SELECT 
        o.order_id,
        o.customer_id,
        c.company_name,
		c.contact_name,
		c.city,
        c.country,
		c.clean_phone AS phone,
        o.order_date,
		o.shipped_date,
        o.freight,
        o.ship_country,
        od.product_id,
        p.product_name,
		cg.category_name,
        od.unit_price,
        od.quantity,
        od.discount,
        ROUND((od.unit_price * od.quantity ):: NUMERIC, 2) AS base_total_price
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    JOIN order_details od ON o.order_id = od.order_id
    JOIN products p ON od.product_id = p.product_id
	JOIN categories cg ON cg.category_id = p.category_id
	ORDER BY base_total_price DESC
) TO '/path/to/output/order_analysis.csv'
