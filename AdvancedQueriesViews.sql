-- Advanced Join Queries for A4 Part 2

-- List Number of Orders placed by customers
TTITLE COL 10 'Number of Customer Orders' SKIP 1 COL 5 '===================================';
SELECT customer_name, COUNT(O.order_number) AS Num_Orders
FROM customer C, orders O
WHERE C.customer_id = O.customer_id
GROUP BY customer_name
ORDER BY Num_Orders DESC;

-- List Customers (only names) who have ordered a specific product as well as the amount ordered
TTITLE COL 2 'Amount of Playstations Ordered by Customer' SKIP 1 COL 2 '=========================================';
SELECT customer_name, COUNT(OD.order_number) AS Num_Ordered
FROM customer c, product p, orders O, order_details OD
WHERE p.product_name = 'Playstation 5'
AND O.order_number = OD.order_number
AND p.product_id = OD.product_id
AND c.customer_id = O.customer_id
GROUP BY customer_name;

--  List the amount of products sold by each seller
TTITLE COL 10 'Seller Performance' SKIP 1 COL 5 '===========================';
SELECT seller_name, SUM(OD.quantity) AS NUM_SOLD_PRODUCTS
FROM seller s, product p, order_details OD
WHERE p.product_id = OD.product_id 
AND p.seller_id = s.seller_id
GROUP BY seller_name
ORDER BY NUM_SOLD_PRODUCTS DESC;



-- A4 View Creation

-- View for customers which are only in the brampton region

CREATE VIEW brampton_customers AS 
    (SELECT * 
     FROM customer
     WHERE region = 'brampton');

-- View for orders which have been placed on the current date

CREATE VIEW todays_orders AS
    (SELECT * 
      FROM orders
      WHERE order_date = trunc(CURRENT_DATE));
      
-- View for best selling products on the platform - Displays amount of all sold products in Descending order

CREATE VIEW best_sellers AS
    (SELECT P.product_name, P.product_description, SUM(OD.quantity) AS AMOUNTSOLD
     FROM product P, order_details OD
     WHERE P.product_id = OD.product_id
     GROUP BY product_name, product_description)
     ORDER BY SUM(OD.quantity) DESC;
