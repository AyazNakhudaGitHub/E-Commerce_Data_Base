import java.util.*;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.util.Properties;
 
/**
 * Command line UI for the e-commerce database system
 
 *
 */
public class EcommerceUI {
 
    public static void main(String[] args) {
        Connection conn1 = null; // Connection Variable for db

        try {
            // registers Oracle JDBC driver - though this is no longer required
            // since JDBC 4.0, but added here for backward compatibility
            Class.forName("oracle.jdbc.OracleDriver");
 
           
            //   String dbURL1 = "jdbc:oracle:thin:username/password@oracle.scs.ryerson.ca:1521:orcl";  // that is school Oracle database and you can only use it in the labs
																						
         	
             String dbURL1 = "jdbc:oracle:thin:system/PASSWORD@localhost:1521:xe"; // replace PASSWORD with the password to your local oracle db instance
			/* This XE or local database that you installed on your laptop. 1521 is the default port for database, change according to what you used during installation. 
			xe is the sid, change according to what you setup during installation. */
			
			conn1 = DriverManager.getConnection(dbURL1); // Connecting to localhost db
            if (conn1 != null) {
                System.out.println("Connected with connection #1");
            }
 
            // Creating scanner in order to read user input from stdin
            Scanner scanner = new Scanner(System.in);
            // Main Menu Loop
			while (true) {
                String selectedOption; // Initialize var for user input

                printMenu(); // Print the menu options after every operation
                selectedOption = scanner.nextLine(); // read user input from stdin
                // If statements for provided options
                if (selectedOption.equals("X")){ // X closes menu
                    scanner.close();
                    break;
                }
                else if (selectedOption.equals("1")){ // 1 performs the delete tables function - deletes all tables for e-commerce system
                    deleteTables(conn1);
                }
                else if (selectedOption.equals("2")){ // 2 performs the create tables function - creates all tables for e-commerce system
                    createTables(conn1);
                }
                else if (selectedOption.equals("3")){ // 3 performs the populate tables function - populates tables with dummy data
                    populateTables(conn1);
                }
                else if (selectedOption.equals("4")){ // 4 performs the query tables function - performs a set of queries on the e-commerce system to generate reports with headers
                    queryTables(conn1);
                }
                else if (selectedOption.equals("5")){ // 5 allows the user to submit a query of their choosing - this allows them to pull specific records from the db and perform operations such as update/delete/create/insert
                    customQuery(scanner, conn1);
                }
                else{
                    System.out.println("Invalid Input");
                }
            }

 
        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
        } catch (SQLException ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (conn1 != null && !conn1.isClosed()) { // Close the connection after the menu is closed
                    conn1.close();
                }
     
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        }
			

    }

    // printMenu function - prints menu info and user options for ui
    public static void printMenu(){
        System.out.println("CPS510 E-commerce Command Line Interface");
        System.out.println("-----------------------------------------");
        System.out.println("Select an option to perform below:");
        System.out.println("1) Delete Tables");
        System.out.println("2) Create Tables");
        System.out.println("3) Populate Tables");
        System.out.println("4) Query Tables");
        System.out.println("5) Custom Query");
        System.out.println("X) Exit");
    }

    // Method to delete all tables and views within e-commerce system (deletes the tables and views defined in implementation)
    public static void deleteTables(Connection conn){
        String[] views = {"BEST_SELLERS", "BRAMPTON_CUSTOMERS", "TODAYS_ORDERS"}; // Views in the db
        for (int i = 0; i < views.length; i++){ // loop through the views and drop all of them
            String dropString = "DROP VIEW " + views[i];
            try (Statement stmt = conn.createStatement()) {
                try(ResultSet rs = stmt.executeQuery(dropString)){
                    System.out.println("View " + views[i] + " Deleted Successfully");
                }
                catch(SQLException ex){
                    System.out.println(ex.getMessage());
                }

            }
            catch (SQLException e) {
                System.out.println(e.getErrorCode());
            }
        }

        String[] tables = {"PRODUCT_CATEGORIES", "ORDER_DETAILS", "CART_PRODUCTS", "ORDERS", "PRODUCT", "SHIPPER", "SELLER", "CART", "CUSTOMER"}; // tables in the db
        for (int i = 0; i < tables.length; i++){ // loop through the tables and drop all of them
            String dropString = "DROP TABLE " + tables[i] + " CASCADE CONSTRAINTS";
            try (Statement stmt = conn.createStatement()) {
                try(ResultSet rs = stmt.executeQuery(dropString)){
                    System.out.println("Table " + tables[i] + " Deleted Successfully");
                }
                catch(SQLException ex){
                    System.out.println(ex.getMessage());
                }
            }
            catch (SQLException e) {
                System.out.println(e.getErrorCode());
            }
        }
    }

    // Method to create all the tables and views
    public static void createTables(Connection conn){

        // Create the Customer table
        String createCustomer = "CREATE TABLE customer (customer_ID int NOT NUll PRIMARY KEY,customer_name VARCHAR2(30),region VARCHAR2(30),card_holder VARCHAR(30) NOT NULL,card_no int NOT NULL UNIQUE,billing_address VARCHAR2(30) NOT NULL,delivery_address VARCHAR2(30) NOT NULL)";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createCustomer)){
                System.out.println("Table Customer Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create the Seller table
        String createSeller = "CREATE TABLE seller (seller_ID int NOT NUll PRIMARY KEY,seller_name VARCHAR2(30),seller_email  VARCHAR2(30))";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createSeller)){
                System.out.println("Table Seller Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create the Product table
        String createProduct = "CREATE TABLE product (product_ID int NOT NUll PRIMARY KEY,seller_ID int REFERENCES seller(seller_ID),unit_price float NOT NULL,product_name VARCHAR2(30) NOT NULL,product_description VARCHAR2(30) NOT NULL)";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createProduct)){
                System.out.println("Table Product Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create the Product Categories table
        String createProductCategories = "CREATE TABLE product_categories (product_ID int REFERENCES product(product_ID),category VARCHAR2(30) NOT NULL )";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createProductCategories)){
                System.out.println("Table Product_Categories Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create the Shipper table
        String createShipper = "CREATE TABLE shipper (shipper_ID int NOT NUll PRIMARY KEY,service_provider VARCHAR2(30))";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createShipper)){
                System.out.println("Table Shipper Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create the Cart table
        String createCart = "CREATE TABLE cart (cart_ID int NOT NULL PRIMARY KEY, customer_ID int REFERENCES Customer(Customer_ID))";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createCart)){
                System.out.println("Table Cart Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create the Cart Products table
        String createCartProducts = "CREATE TABLE cart_products (cart_ID int REFERENCES Cart(cart_ID),product_ID int REFERENCES product(product_ID),quantity int NOT NULL)";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createCartProducts)){
                System.out.println("Table Cart_Products Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create the Orders table
        String createOrders = "CREATE TABLE orders (order_number int NOT NUll PRIMARY KEY,customer_ID int REFERENCES Customer(customer_ID),shipper_ID int REFERENCES Shipper(shipper_ID),order_date date)";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createOrders)){
                System.out.println("Table Orders Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create the Order Details table
        String createOrderDetails = "CREATE TABLE order_details (order_number int REFERENCES orders(order_number),product_ID int REFERENCES product(product_ID),quantity int NOT NULL)";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createOrderDetails)){
                System.out.println("Table Order_Details Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create the views

        // Create Brampton_Customers view
        String createBramptonCustomers = "CREATE VIEW brampton_customers AS (SELECT * FROM customer WHERE region = 'brampton')";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createBramptonCustomers)){
                System.out.println("View Brampton_Customers Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create Todays_Orders view
        String createTodaysOrders = "CREATE VIEW todays_orders AS(SELECT * FROM orders WHERE order_date = trunc(CURRENT_DATE))";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createTodaysOrders)){
                System.out.println("View Todays_Orders Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

        // Create Best_sellers view
        String createBestSellers = "CREATE VIEW best_sellers AS(SELECT P.product_name, P.product_description, SUM(OD.quantity) AS AMOUNTSOLD FROM product P, order_details OD WHERE P.product_id = OD.product_id GROUP BY product_name, product_description) ORDER BY SUM(OD.quantity) DESC";
        try (Statement stmt = conn.createStatement()) {
            try(ResultSet rs = stmt.executeQuery(createBestSellers)){
                System.out.println("View Best_Sellers Created");
            }
            catch(SQLException ex){
                System.out.println(ex.getMessage());
            }
        }
        catch (SQLException e) {
            System.out.println(e.getErrorCode());
        }

    }

    // Method to populate tables with dummy data
    public static void populateTables(Connection conn){
        // Array of statements which we perform to insert dummy data
        String[] populateQueries = {
            "INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address) VALUES (1, 'joe','brampton', 'joe mama', 11223344,  'central peel1', 'central peel2')",
            "INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address) VALUES (2, 'Frank Wood','toronto', 'Frank Wood', 12345678,  '10 something lane', '10 something lane')",
            "INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address) VALUES (3, 'John Wood','brampton', 'John Wood', 11111111,  '10 nothing lane', '10 nothing lane')",
            "INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address) VALUES (4, 'Bill Wood','toronto', 'Bill Wood', 2222222,  '24 winter drive', '24 winter drive')",
            "INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address) VALUES (5, 'Sue Wood','mississauga', 'Sue Wood', 3333333,  '12 crescent', '12 cresecent')",
            "INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address) VALUES (6, 'John Rah','orangeville', 'John Rah', 4444444,  '22 bluebird lane', '22 bluebird lane')",
            "INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address) VALUES (7, 'Steve Smith','mississauga', 'Steve Smith', 555555,  '14 smithson', '14 smithson')",
            "INSERT INTO Customer(customer_ID, customer_name, region, card_holder, card_no, billing_address, delivery_address) VALUES (8, 'Jill Langley','caledon', 'Jill Langley', 666666,  '84 tree st', '84 tree st')",
            "INSERT INTO Seller(seller_ID, seller_name, seller_email) VALUES (1, 'Christian Daniel', 'christain189@gmail.com')",
            "INSERT INTO Seller(seller_ID, seller_name, seller_email) VALUES (2, 'Elizabeth Smith', 'smithelizabeth@gmail.com')",
            "INSERT INTO Product(product_ID, seller_ID, unit_price, product_name, product_description) VALUES (1, 2, 599.99, 'Playstation 5', 'Sonys latest gaming console')",
            "INSERT INTO Product(product_ID, seller_ID, unit_price, product_name, product_description) VALUES (2, 1, 9.99, 'Radio', 'AM and FM Radio receiver')",
            "INSERT INTO Product(product_ID, seller_ID, unit_price, product_name, product_description) VALUES (3, 1, 599.99, 'Playstation 5', 'Sonys latest gaming console')",
            "INSERT INTO Product(product_ID, seller_ID, unit_price, product_name, product_description) VALUES (4, 1, 699.99, 'Macbook', 'Apple Laptop')",
            "INSERT INTO Product(product_ID, seller_ID, unit_price, product_name, product_description) VALUES (5, 2, 9.99, 'Milk', 'Milk Carton')",
            "INSERT INTO product_categories(product_ID, category) VALUES (3, 'Electronic')",
            "INSERT INTO product_categories(product_ID, category) VALUES (4, 'Electronic')",
            "INSERT INTO product_categories(product_ID, category) VALUES (1, 'Electronic')",
            "INSERT INTO product_categories(product_ID, category) VALUES (2, 'Electronic')",
            "INSERT INTO product_categories(product_ID, category) VALUES (5, 'Food')",
            "INSERT INTO product_categories(product_ID, category) VALUES (5, 'Dairy')",
            "INSERT INTO shipper(shipper_ID, service_provider) VALUES (1, 'UPS')",
            "INSERT INTO shipper(shipper_ID, service_provider) VALUES (2, 'FEDEX')",
            "INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date) VALUES (100, 1, 1, DATE '2021-11-04')",
            "INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date) VALUES (90, 2, 1, DATE '2020-11-04')",
            "INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date) VALUES (95, 3, 2, DATE '2020-12-04')", 
            "INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date) VALUES (96, 3, 1, DATE '2021-12-04')",
            "INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date) VALUES (97, 1, 1, DATE '2021-10-25')",
            "INSERT INTO orders (order_number, customer_ID, shipper_ID, order_date) VALUES (98, 2, 2, DATE '2021-10-04')",
            "INSERT INTO order_details (order_number, product_ID, quantity) VALUES (100, 3, 1)",
            "INSERT INTO order_details (order_number, product_ID, quantity) VALUES (100, 5, 4)",
            "INSERT INTO order_details (order_number, product_ID, quantity) VALUES (100, 2, 1)",
            "INSERT INTO order_details (order_number, product_ID, quantity) VALUES (90, 1, 2)",
            "INSERT INTO order_details (order_number, product_ID, quantity) VALUES (90, 2, 1)",
            "INSERT INTO cart (cart_ID, customer_ID) VALUES (1, 2)",
            "INSERT INTO cart (cart_ID, customer_ID) VALUES (2, 3)",
            "INSERT INTO cart (cart_ID, customer_ID) VALUES (3, 1)",
            "INSERT INTO cart_products (cart_ID, product_ID, quantity) VALUES (1, 5, 3)",
            "INSERT INTO cart_products (cart_ID, product_ID, quantity) VALUES (1, 2, 2)",
            "INSERT INTO cart_products (cart_ID, product_ID, quantity) VALUES (1, 3, 1)",
            "INSERT INTO cart_products (cart_ID, product_ID, quantity) VALUES (2, 4, 1)",
            "INSERT INTO cart_products (cart_ID, product_ID, quantity) VALUES (3, 1, 2)"
        };

        for (int i = 0; i < populateQueries.length; i++){ // Loop through array of statements and populate tables
            try (Statement stmt = conn.createStatement()) {
                try(ResultSet rs = stmt.executeQuery(populateQueries[i])){
                    System.out.println("Row Inserted");
                }
                catch(SQLException ex){
                    System.out.println(ex.getMessage());
                }
            }
            catch (SQLException e) {
                System.out.println(e.getErrorCode());
            }
        }
    }

    // Method to perform a set of queries on the db
    public static void queryTables(Connection conn){
        String[] headers = {
            "Number of Customer Orders",
            "Amount of Playstations Ordered by Customer",
            "Seller Performance",
            "Active Customers (Customers who Order)",
            "Products Which are Dairy products or Sold by Christian Daniel",
            "Unsold Products",
            "Customers Distinct Purchased Products",
            "Average Product Order Quantity by Customer"
        }; // Array of headers for reports - i.e., headers for reports generated by queries

        String[] queries = {
            "SELECT customer_name, COUNT(O.order_number) AS Num_Orders FROM customer C, orders O WHERE C.customer_id = O.customer_id GROUP BY customer_name ORDER BY Num_Orders DESC",
            "SELECT customer_name, COUNT(OD.order_number) AS Num_Ordered FROM customer c, product p, orders O, order_details OD WHERE p.product_name = 'Playstation 5' AND O.order_number = OD.order_number AND p.product_id = OD.product_id AND c.customer_id = O.customer_id GROUP BY customer_name",
            "SELECT seller_name, SUM(OD.quantity) AS NUM_SOLD_PRODUCTS FROM seller s, product p, order_details OD WHERE p.product_id = OD.product_id AND p.seller_id = s.seller_id GROUP BY seller_name ORDER BY NUM_SOLD_PRODUCTS DESC",
            "SELECT c.customer_id AS CID, c.customer_name AS CNAME, c.region AS CREGION, c.billing_address AS Bill_Addr, c.delivery_address AS Deliv_addr FROM customer c WHERE EXISTS (SELECT o.order_number FROM orders o WHERE o.customer_id = c.customer_id) GROUP BY c.customer_id, c.customer_name, c.region, c.billing_address, c.delivery_address ORDER BY c.customer_id ASC",
            "SELECT p.product_id, p.product_name, p.product_description, p.unit_price FROM product p WHERE EXISTS (SELECT pc.category FROM product_categories pc WHERE pc.product_id = p.product_id AND pc.category = 'Dairy') UNION (SELECT p1.product_id, p1.product_name, p1.product_description, p1.unit_price FROM product p1 WHERE EXISTS (SELECT s.seller_id FROM seller s WHERE s.seller_name = 'Christian Daniel' AND p1.seller_id = s.seller_id))",
            "SELECT product_id, product_name, product_description, unit_price FROM product MINUS (SELECT p.product_id, p.product_name, p.product_description, p.unit_price FROM product p, order_details OD WHERE OD.product_id = p.product_id)",
            "SELECT C.customer_id, C.customer_name, COUNT(DISTINCT OD.product_id) AS NUM_PURCHASED_PRODUCTS FROM customer C, order_details OD WHERE EXISTS (SELECT O.order_number, O.customer_id FROM orders O WHERE C.customer_id = O.customer_id AND OD.order_number = O.order_number) GROUP BY C.customer_id, C.customer_name",
            "SELECT C.customer_id, C.customer_name, AVG(OD.quantity) AS AVG_Purchase_Quantity FROM customer C, order_details OD WHERE EXISTS (SELECT O.order_number, O.customer_id FROM orders O WHERE C.customer_id = O.customer_id AND OD.order_number = O.order_number) GROUP BY C.customer_id, C.customer_name"
        }; // Array of queries which will be executed and generate reports

        for (int i = 0; i < queries.length; i++){ // loop through the queries in order to execute them and retrieve result set, we then print the results with the header above and the format of the results in terms of the column names
            try (Statement stmt = conn.createStatement()) {
                try(ResultSet rs = stmt.executeQuery(queries[i])){
                    ResultSetMetaData rsmd = rs.getMetaData();
                    int columnsNumber = rsmd.getColumnCount();
                    System.out.println(headers[i]); // Printing Header for format
                    System.out.println("--------------------------------------------");
                    System.out.print("Result Format: (");
                    for(int k = 1; k<=columnsNumber; k++){ // print the structure of the return values in terms of column names
                        System.out.print(rsmd.getColumnName(k));
                        if (k != columnsNumber) System.out.print(", ");
                    }
                    System.out.print(")");
                    System.out.println("");
                    while(rs.next()){ // Move through the result set (rows returned by query)
                        System.out.print("(");
                        for (int j = 1; j <= columnsNumber; j++) {
                            if (j > 1) System.out.print(",  ");
                            String columnValue = rs.getString(j);
                            System.out.print(columnValue);
                        }
                        System.out.print(")");
                        System.out.println("");
                    }
                    System.out.println("");
                }
                catch(SQLException ex){
                    System.out.println(ex.getMessage());
                }
            }
            catch (SQLException e) {
                System.out.println(e.getErrorCode());
            }
        }
    }

    // customQuery method accepts user input in the form of a SQL statement and attempts to execute
    public static void customQuery(Scanner scanner, Connection conn){
        System.out.println("Enter a Query/Operation for the DB below or Enter X to return to the Menu:");
        while(true){ // wait for user to input query or exit the custom query selection
            String userQuery = scanner.nextLine(); // read input from stdin
            if(userQuery.equals("X")) break;
            try (Statement stmt = conn.createStatement()) {
                try(ResultSet rs = stmt.executeQuery(userQuery)){ // attempt to execute user query
                    ResultSetMetaData rsmd = rs.getMetaData();
                    int columnsNumber = rsmd.getColumnCount();
                    System.out.println("--------------------------------------------");
                    System.out.print("Result Format: (");
                    for(int k = 1; k<=columnsNumber; k++){ // print the structure of the returned results
                        System.out.print(rsmd.getColumnName(k));
                        if (k != columnsNumber) System.out.print(", ");
                    }
                    System.out.print(")");
                    System.out.println("");
                    while(rs.next()){ // print the results one at a time
                        System.out.print("(");
                        for (int j = 1; j <= columnsNumber; j++) {
                            if (j > 1) System.out.print(",  ");
                            String columnValue = rs.getString(j);
                            System.out.print(columnValue);
                        }
                        System.out.print(")");
                        System.out.println("");
                    }
                    System.out.println("");
                }
                catch(SQLException ex){
                    System.out.println(ex.getMessage());
                }
            }
            catch (SQLException e) {
                System.out.println(e.getErrorCode());
            }
            break;
        }
    }
}
