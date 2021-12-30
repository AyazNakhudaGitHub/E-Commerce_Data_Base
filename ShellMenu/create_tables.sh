#!/bin/sh
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib
sqlplus64 "dpferris/Waserto123@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" <<EOF
CREATE TABLE customer (
    customer_ID int NOT NUll PRIMARY KEY,
    customer_name VARCHAR2(30),
    region VARCHAR2(30),
    card_holder VARCHAR(30) NOT NULL,
    card_no int NOT NULL UNIQUE,
    billing_address VARCHAR2(30) NOT NULL,
    delivery_address VARCHAR2(30) NOT NULL
);      
CREATE TABLE seller (
    seller_ID int NOT NUll PRIMARY KEY,
    seller_name VARCHAR2(30),
    seller_email  VARCHAR2(30)
);
CREATE TABLE product (
    product_ID int NOT NUll PRIMARY KEY,
    seller_ID int REFERENCES seller(seller_ID),
    unit_price float NOT NULL,
    product_name VARCHAR2(30) NOT NULL,
    product_description VARCHAR2(30) NOT NULL
);   
CREATE TABLE product_categories (
    product_ID int REFERENCES product(product_ID),
    category VARCHAR2(30) NOT NULL 
);   
CREATE TABLE shipper (
    shipper_ID int NOT NUll PRIMARY KEY,
    service_provider VARCHAR2(30)  
);   
CREATE TABLE cart (
    cart_ID int NOT NULL PRIMARY KEY, 
    customer_ID int REFERENCES Customer(Customer_ID) 
);
CREATE TABLE cart_products (
    cart_ID int REFERENCES Cart(cart_ID),
    product_ID int REFERENCES product(product_ID),
    quantity int NOT NULL
); 
CREATE TABLE orders (
    order_number int NOT NUll PRIMARY KEY,
    customer_ID int REFERENCES Customer(customer_ID),
    shipper_ID int REFERENCES Shipper(shipper_ID),
    order_date date
);
CREATE TABLE order_details (
    order_number int REFERENCES orders(order_number),
    product_ID int REFERENCES product(product_ID),
    quantity int NOT NULL
);
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
exit;
EOF