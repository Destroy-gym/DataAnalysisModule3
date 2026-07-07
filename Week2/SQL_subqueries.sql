USE coffeeshop_db;

-- =========================================================
-- SUBQUERIES & NESTED LOGIC PRACTICE
-- =========================================================

-- Q1) Scalar subquery (AVG benchmark):
--     List products priced above the overall average product price.
--     Return product_id, name, price.
SELECT product_id, name, price
FROM products
WHERE price > (
	SELECT AVG(price)
    FROM products
);

-- Q2) Scalar subquery (MAX within category):
--     Find the most expensive product(s) in the 'Beans' category.
--     (Return all ties if more than one product shares the max price.)
--     Return product_id, name, price.
SELECT p.product_id, p.name, p.price
FROM products AS p
WHERE p.price = (
	SELECT MAX(p.price)
    FROM products AS p
    INNER JOIN categories AS ca ON p.category_id = ca.category_id
    WHERE ca.name = 'Beans'
);
-- Q3) List subquery (IN with nested lookup):
--     List customers who have purchased at least one product in the 'Merch' category.
--     Return customer_id, first_name, last_name.
--     Hint: Use a subquery to find the category_id for 'Merch', then a subquery to find product_ids.
SELECT c.customer_id, c.first_name, c.last_name
FROM customers AS c
WHERE c.customer_id IN (
	SELECT DISTINCT o.customer_id
    FROM orders AS o
    INNER JOIN order_items AS oi ON o.order_id = oi.order_id
    INNER JOIN products AS p ON oi.product_id = p.product_id
    INNER JOIN categories AS ca ON p.category_id = ca.category_id
    WHERE ca.name = 'Merch'
);

-- Q4) List subquery (NOT IN / anti-join logic):
--     List products that have never been ordered (their product_id never appears in order_items).
--     Return product_id, name, price.

-- Q5) Table subquery (derived table + compare to overall average):
--     Build a derived table that computes total_units_sold per product
--     (SUM(order_items.quantity) grouped by product_id).
--     Then return only products whose total_units_sold is greater than the
--     average total_units_sold across all products.
--     Return product_id, product_name, total_units_sold.
