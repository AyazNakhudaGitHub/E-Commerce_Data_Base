#!/bin/sh
#export LD_LIBRARY_PATH=/usr/lib/oracle/12.1/client64/lib
sqlplus64 "dpferris/Waserto123@(DESCRIPTION=(ADDRESS=(PROTOCOL=TCP)(Host=oracle.scs.ryerson.ca)(Port=1521))(CONNECT_DATA=(SID=orcl)))" <<EOF
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
exit;
EOF