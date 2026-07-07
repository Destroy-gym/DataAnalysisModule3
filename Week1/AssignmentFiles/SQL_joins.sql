USE coffeeshop_db;

-- =========================================================
-- JOINS & RELATIONSHIPS PRACTICE
-- =========================================================

-- Q1) Join products to categories: list product_name, category_name, price.
SELECT p.name AS product_name, c.name AS category_name, p.price
FROM products AS p
INNER JOIN categories AS c
    ON p.category_id = c.category_id;

-- Q2) For each order item, show: order_id, order_datetime, store_name,
--     product_name, quantity, line_total (= quantity * products.price).
--     Sort by order_datetime, then order_id.
SELECT oi.order_item_id, o.order_id, o.order_datetime, s.name AS store_name, p.name AS product_name, oi.quantity, SUM(oi.quantity * p.price) AS line_total
FROM order_items AS oi
INNER JOIN orders AS o 
    ON oi.order_id = o.order_id
INNER JOIN stores AS s 
    ON o.store_id = s.store_id
INNER JOIN products AS p 
    ON oi.product_id = p.product_id
GROUP BY oi.order_item_id
ORDER BY o.order_datetime, o.order_id;
-- Q3) Customer order history (PAID only):
--     For each order, show customer_name, store_name, order_datetime,
--     order_total (= SUM(quantity * products.price) per order).
SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name), s.name AS store_name, o.order_datetime, SUM(oi.quantity * p.price) AS order_total
FROM  orders AS o
INNER JOIN customers AS c 
    ON o.customer_id = c.customer_id
INNER JOIN stores AS s 
    ON o.store_id = s.store_id
INNER JOIN order_items AS oi 
    ON o.order_id = oi.order_id
INNER JOIN products AS p 
    ON oi.product_id = p.product_id
WHERE o.status = 'paid'
GROUP BY o.order_id
ORDER BY o.order_id;

-- Q4) Left join to find customers who have never placed an order.
--     Return first_name, last_name, city, state.
SELECT c.first_name, c.last_name, c.city, c.state
FROM customers AS c
LEFT JOIN orders AS o 
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q5) For each store, list the top-selling product by units (PAID only).
--     Return store_name, product_name, total_units.
--     Hint: Use a window function (ROW_NUMBER PARTITION BY store) or a correlated subquery.

-- Q6) Inventory check: show rows where on_hand < 12 in any store.
--     Return store_name, product_name, on_hand.
SELECT s.name AS store_name, p.name AS product_name, i.on_hand
FROM inventory AS i
INNER JOIN stores AS s 
    ON i.store_id = s.store_id
INNER JOIN products AS p 
    ON i.product_id = p.product_id
WHERE on_hand < 12;
-- Q7) Manager roster: list each store's manager_name and hire_date.
--     (Assume title = 'Manager').

-- Q8) Using a subquery/CTE: list products whose total PAID revenue is above
--     the average PAID product revenue. Return product_name, total_revenue.

-- Q9) Churn-ish check: list customers with their last PAID order date.
--     If they have no PAID orders, show NULL.
--     Hint: Put the status filter in the LEFT JOIN's ON clause to preserve non-buyer rows.

SELECT c.customer_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, MAX(DATE(o.order_datetime)) AS last_paid_date
FROM customers AS c
LEFT JOIN orders AS o 
    ON c.customer_id = o.customer_id AND o.status = 'paid'
GROUP BY c.customer_id, customer_name;

-- Q10) Product mix report (PAID only):
--     For each store and category, show total units and total revenue (= SUM(quantity * products.price)).
SELECT s.name AS store_name, ca.category_id, ca.name AS category_name, SUM(oi.quantity) AS total_units, SUM(oi.quantity * p.price) AS total_revenue
FROM categories AS ca
INNER JOIN products AS p 
    ON ca.category_id = p.category_id
INNER JOIN order_items AS oi 
    ON p.product_id = oi.product_id
INNER JOIN orders AS o 
    ON oi.order_id = o.order_id
INNER JOIN stores AS s 
    ON o.store_id = s.store_id
WHERE o.status = 'paid'
GROUP BY store_name, category_name;