#!/bin/sh
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib
sqlplus64 "dpferris/Waserto123@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" <<EOF
SET LINESIZE 150
SET PAGESIZE 100
TTITLE COL 10 'Number of Customer Orders' SKIP 1 COL 5 '===================================';
SELECT customer_name, COUNT(O.order_number) AS Num_Orders
FROM customer C, orders O
WHERE C.customer_id = O.customer_id
GROUP BY customer_name
ORDER BY Num_Orders DESC;
TTITLE COL 2 'Amount of Playstations Ordered by Customer' SKIP 1 COL 2 '=========================================';
SELECT customer_name, COUNT(OD.order_number) AS Num_Ordered
FROM customer c, product p, orders O, order_details OD
WHERE p.product_name = 'Playstation 5'
AND O.order_number = OD.order_number
AND p.product_id = OD.product_id
AND c.customer_id = O.customer_id
GROUP BY customer_name;
TTITLE COL 10 'Seller Performance' SKIP 1 COL 5 '===========================';
SELECT seller_name, SUM(OD.quantity) AS NUM_SOLD_PRODUCTS
FROM seller s, product p, order_details OD
WHERE p.product_id = OD.product_id 
AND p.seller_id = s.seller_id
GROUP BY seller_name
ORDER BY NUM_SOLD_PRODUCTS DESC;
TTITLE COL 15 'Active Customers (Customers who Order)' SKIP 1 COL 15 '=====================================';
SELECT c.customer_id AS CID, c.customer_name AS CNAME, c.region AS CREGION, c.billing_address AS Bill_Addr, c.delivery_address AS Deliv_addr
FROM customer c
WHERE EXISTS
(SELECT o.order_number
FROM orders o
WHERE o.customer_id = c.customer_id)
GROUP BY c.customer_id, c.customer_name, c.region, c.billing_address, c.delivery_address
ORDER BY c.customer_id ASC;
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
TTITLE COL 20 'Unsold Products' SKIP 1 COL 15 '===========================';
SELECT product_id, product_name, product_description, unit_price
FROM product
MINUS
(SELECT p.product_id, p.product_name, p.product_description, p.unit_price
 FROM product p, order_details OD
 WHERE OD.product_id = p.product_id);
TTITLE COL 10 'Customers Distinct Purchased Products' SKIP 1 COL 10 '======================================';
SELECT C.customer_id, C.customer_name, COUNT(DISTINCT OD.product_id) AS NUM_PURCHASED_PRODUCTS
FROM customer C, order_details OD
WHERE EXISTS
(SELECT O.order_number, O.customer_id
FROM orders O
WHERE C.customer_id = O.customer_id AND OD.order_number = O.order_number)
GROUP BY C.customer_id, C.customer_name;
TTITLE COL 10 'Average Product Order Quantity by Customer' SKIP 1 COL 10 '=========================================';
SELECT C.customer_id, C.customer_name, AVG(OD.quantity) AS AVG_Purchase_Quantity
FROM customer C, order_details OD
WHERE EXISTS
(SELECT O.order_number, O.customer_id
FROM orders O
WHERE C.customer_id = O.customer_id AND OD.order_number = O.order_number)
GROUP BY C.customer_id, C.customer_name;
exit;
EOF