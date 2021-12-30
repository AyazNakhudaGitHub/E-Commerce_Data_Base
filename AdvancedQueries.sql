-- Advanced Queries for A5
-- Queries which use EXIST, IN, MINUS, their negations, or UNION

-- Provide a List of Customers who have placed orders on the platform
TTITLE COL 15 'Active Customers (Customers who Order)' SKIP 1 COL 15 '=====================================';
SELECT c.customer_id AS CID, c.customer_name AS CNAME, c.region AS CREGION, c.billing_address AS Bill_Addr, c.delivery_address AS Deliv_addr
FROM customer c
WHERE EXISTS
(SELECT o.order_number
FROM orders o
WHERE o.customer_id = c.customer_id)
GROUP BY c.customer_id, c.customer_name, c.region, c.billing_address, c.delivery_address
ORDER BY c.customer_id ASC;

-- List the products on the platform which are either in the Dairy category or sold by seller Christian Daniel
TTITLE COL 10 'Products Which are Dairy products or Sold by Christian Daniel' SKIP 1 COL 20 '===================================';
SELECT p.product_id, p.product_name, p.product_description, p.unit_price
FROM product p
WHERE EXISTS
(SELECT pc.category
FROM product_categories pc
WHERE pc.product_id = p.product_id AND pc.category = 'Dairy')
UNION
(SELECT p1.product_id, p1.product_name, p1.product_description, p1.unit_price
FROM product p1 
WHERE EXISTS (SELECT s.seller_id FROM seller s
WHERE s.seller_name = 'Christian Daniel' AND p1.seller_id = s.seller_id));

-- List the products which have yet to be sold on the platform

--SELECT product_id, product_name, product_description, unit_price
--FROM product
--WHERE product_id NOT IN
--(SELECT order_details.product_id FROM order_details); THIS QUERY IS EQUIVALENT TO THE ONE BELOW WHICH USES MINUS
TTITLE COL 20 'Unsold Products' SKIP 1 COL 15 '===========================';
SELECT product_id, product_name, product_description, unit_price
FROM product
MINUS
(SELECT p.product_id, p.product_name, p.product_description, p.unit_price
 FROM product p, order_details OD
 WHERE OD.product_id = p.product_id);
 
-- List the amount of distinct products a customer has purchased
TTITLE COL 10 'Customers Distinct Purchased Products' SKIP 1 COL 10 '======================================';
SELECT C.customer_id, C.customer_name, COUNT(DISTINCT OD.product_id) AS NUM_PURCHASED_PRODUCTS
FROM customer C, order_details OD
WHERE EXISTS
(SELECT O.order_number, O.customer_id
FROM orders O
WHERE C.customer_id = O.customer_id AND OD.order_number = O.order_number)
GROUP BY C.customer_id, C.customer_name;

-- Get the Average Number of Products a Customer orders
TTITLE COL 10 'Average Product Order Quantity by Customer' SKIP 1 COL 10 '=========================================';
SELECT C.customer_id, C.customer_name, AVG(OD.quantity) AS AVG_Purchase_Quantity
FROM customer C, order_details OD
WHERE EXISTS
(SELECT O.order_number, O.customer_id
FROM orders O
WHERE C.customer_id = O.customer_id AND OD.order_number = O.order_number)
GROUP BY C.customer_id, C.customer_name;