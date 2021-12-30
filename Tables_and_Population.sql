
-- Creation of tables

  
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
    category VARCHAR2(30) NOT NULL  -- categories can span multiple rows for a product this is how we avoid long parsing
);

    
CREATE TABLE shipper (
    shipper_ID int NOT NUll PRIMARY KEY,
    service_provider VARCHAR2(30)
    
);
    
    
    
CREATE TABLE cart (
    cart_ID int NOT NULL PRIMARY KEY, -- this customer id has that cart id
    customer_ID int REFERENCES Customer(Customer_ID)
    
);

CREATE TABLE cart_products (
    cart_ID int REFERENCES Cart(cart_ID), -- cart id relates to the cart that has the customers products
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
    order_number int REFERENCES orders(order_number), -- order number relates its details to higher level order info
    product_ID int REFERENCES product(product_ID),
    quantity int NOT NULL


);

-- Insertions (dummy data for the customer table):

INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address)
VALUES (1, 'joe','brampton', 'joe mama', 11223344,  'central peel1', 'central peel2');
INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address)
VALUES (2, 'Frank Wood','toronto', 'Frank Wood', 12345678,  '10 something lane', '10 something lane');
INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address)
VALUES (3, 'John Wood','brampton', 'John Wood', 11111111,  '10 nothing lane', '10 nothing lane');
INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address)
VALUES (4, 'Bill Wood','toronto', 'Bill Wood', 2222222,  '24 winter drive', '24 winter drive');
INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address)
VALUES (5, 'Sue Wood','mississauga', 'Sue Wood', 3333333,  '12 crescent', '12 cresecent');
INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address)
VALUES (6, 'John Rah','orangeville', 'John Rah', 4444444,  '22 bluebird lane', '22 bluebird lane');
INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address)
VALUES (7, 'Steve Smith','mississauga', 'Steve Smith', 555555,  '14 smithson', '14 smithson');
INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address)
VALUES (8, 'Jill Langley','caledon', 'Jill Langley', 666666,  '84 tree st', '84 tree st');

INSERT INTO Seller(seller_ID, seller_name, seller_email) VALUES (1, 'Christian Daniel', 'christain189@gmail.com');
INSERT INTO Seller(seller_ID, seller_name, seller_email) VALUES (2, 'Elizabeth Smith', 'smithelizabeth@gmail.com');

INSERT INTO Product(product_ID, seller_ID, unit_price, product_name, product_description) VALUES (1, 2, 599.99, 'Playstation 5', 'Sonys latest gaming console');
INSERT INTO Product(product_ID, seller_ID, unit_price, product_name, product_description) VALUES (2, 1, 9.99, 'Radio', 'AM and FM Radio receiver');
INSERT INTO Product(product_ID, seller_ID, unit_price, product_name, product_description) VALUES (3, 1, 599.99, 'Playstation 5', 'Sonys latest gaming console');
INSERT INTO Product(product_ID, seller_ID, unit_price, product_name, product_description) VALUES (4, 1, 699.99, 'Macbook', 'Apple Laptop');
INSERT INTO Product(product_ID, seller_ID, unit_price, product_name, product_description) VALUES (5, 2, 9.99, 'Milk', 'Milk Carton');

INSERT INTO product_categories(product_ID, category) VALUES (3, 'Electronic');
INSERT INTO product_categories(product_ID, category) VALUES (4, 'Electronic');
INSERT INTO product_categories(product_ID, category) VALUES (1, 'Electronic');
INSERT INTO product_categories(product_ID, category) VALUES (2, 'Electronic');
INSERT INTO product_categories(product_ID, category) VALUES (5, 'Food');
INSERT INTO product_categories(product_ID, category) VALUES (5, 'Dairy');

INSERT INTO shipper(shipper_ID, service_provider) VALUES (1, 'UPS');
INSERT INTO shipper(shipper_ID, service_provider) VALUES (2, 'FEDEX');

INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date)
   VALUES (100, 1, 1, DATE '2021-11-04');
INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date)
   VALUES (90, 2, 1, DATE '2020-11-04');
INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date)
   VALUES (95, 3, 2, DATE '2020-12-04');
   
INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date)
   VALUES (96, 3, 1, DATE '2021-12-04');
   
INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date)
   VALUES (97, 1, 1, DATE '2021-10-25');
INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date)
   VALUES (98, 2, 2, DATE '2021-10-04');
   
INSERT INTO order_details (order_number, product_ID, quantity) VALUES (100, 3, 1);
INSERT INTO order_details (order_number, product_ID, quantity) VALUES (100, 5, 4);
INSERT INTO order_details (order_number, product_ID, quantity) VALUES (100, 2, 1);

INSERT INTO order_details (order_number, product_ID, quantity) VALUES (90, 1, 2);
INSERT INTO order_details (order_number, product_ID, quantity) VALUES (90, 2, 1);

INSERT INTO cart (cart_ID, customer_ID) VALUES (1, 2);
INSERT INTO cart (cart_ID, customer_ID) VALUES (2, 3);
INSERT INTO cart (cart_ID, customer_ID) VALUES (3, 1);

INSERT INTO cart_products (cart_ID, product_ID, quantity) VALUES (1, 5, 3);
INSERT INTO cart_products (cart_ID, product_ID, quantity) VALUES (1, 2, 2);
INSERT INTO cart_products (cart_ID, product_ID, quantity) VALUES (1, 3, 1);

INSERT INTO cart_products (cart_ID, product_ID, quantity) VALUES (2, 4, 1);

INSERT INTO cart_products (cart_ID, product_ID, quantity) VALUES (3, 1, 2);