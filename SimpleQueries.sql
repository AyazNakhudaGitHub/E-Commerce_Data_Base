
-- Customer Table Query
-- This query provides insight into the distribution of the customers on the platform
-- by providing a count of all customers in unique regions, this informs which regions have the most customers and which have the least

COLUMN NumberOfCustomers JUSTIFY LEFT;
COLUMN REGION JUSTIFY LEFT;

TTITLE COL 10 'Customer Region Insights' SKIP 1 COL 5 '===================================';

SELECT region, COUNT(customer_ID) AS NumberOfCustomers
FROM Customer 
GROUP BY region
ORDER BY NumberOfCustomers DESC;


-- Product Table Query
-- This query allows quick viewing of the distinct products on the platform based on name, description and price
TTITLE COL 10 'Distinct Products Sorted by Price' SKIP 1 COL 9 '===================================';

SELECT DISTINCT product_name, product_description, unit_price AS Price
FROM Product
ORDER BY Price ASC;

-- Product Category Query
-- provide an overview of the quantity of products on the platform in each category
TTITLE COL 10 'Product Category Metrics' SKIP 1 COL 5 '===================================';

SELECT category, COUNT(product_ID) AS NumOfProducts
FROM product_categories
GROUP BY category
ORDER BY NumOfProducts ASC;

-- Orders Table Query
-- Retrieve the distinct orders by customer and order number placed on a specific date
-- order by the order number to determine those placed first, shows which customers have placed orders on a specific date
TTITLE COL 1 'Distinct Customer Orders on Nov 4 2021' SKIP 1 COL 2 '===============================';

SELECT DISTINCT order_date, customer_id, order_number 
FROM orders
WHERE order_date = '04-NOV-21'
ORDER BY order_number;

--Seller Query
-- Display all products sold by all sellers on the platform and display by increasing price
TTITLE COL 30 'Distinct Products Sorted by Price (Asc)' SKIP 1 COL 30 '=======================================';

SELECT DISTINCT seller.seller_ID, seller.seller_name, product.product_name, product.product_description, product.unit_price
FROM Seller, Product
WHERE seller.seller_ID = product.seller_id
ORDER BY product.unit_price;

-- order_details Table Query
-- Display metrics on the quantity of products which have been sold (displayed per product)
TTITLE COL 1 'Sold Product Metrics (Quantity of Sold Products)' SKIP 1 COL 4 '=================================';

SELECT product_ID, SUM(quantity) AS NumOrdered
FROM order_details 
GROUP BY product_id
ORDER BY NumOrdered DESC;

-- cart and cart_products Table Query
-- Display metrics on the Quantity of products currently in customer carts (displayed per product)
-- Essentially reports the contents of customer cart
TTITLE COL 2 'Cart Product Metrics (Quantity of Products in Carts)' SKIP 1 COL 7 '===================================';

SELECT cart.customer_ID, cart.cart_ID, product_ID, SUM(quantity) AS NumOfProduct
FROM cart_products, cart
WHERE cart.cart_ID = cart_products.cart_ID
GROUP BY cart.customer_ID, cart.cart_ID, product_ID
ORDER BY NumOfProduct DESC;

-- shipper Table Query
-- Display the quantity of orders which each shipping service is responsible for
TTITLE COL 10 'Shipped Orders by Shipping Service' SKIP 1 COL 9 '===================================';

SELECT orders.shipper_ID, shipper.service_provider, COUNT(orders.shipper_ID) AS NumOrdersShipped
FROM orders, shipper
WHERE orders.shipper_ID = shipper.shipper_ID
GROUP BY orders.shipper_ID, shipper.service_provider
ORDER BY NumOrdersShipped;
