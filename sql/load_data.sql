-- ============================================================================
-- This script loads data from CSV files into the database tables
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- ============================================================================
-- LOAD CUSTOMERS DATA
-- ============================================================================
LOAD DATA LOCAL INFILE '/Users/alejandrocano/Desktop/Proyectos/Business-Intelligence-Analysis/data/customers.csv'
INTO TABLE customers
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(CustomerID, Name, Email, JoinDate);

-- Verify customers data load
SELECT 'Customers loaded:' as Status, COUNT(*) as RecordCount FROM customers;

-- ============================================================================
-- LOAD PRODUCTS DATA
-- ============================================================================
LOAD DATA LOCAL INFILE '/Users/alejandrocano/Desktop/Proyectos/Business-Intelligence-Analysis/data/products.csv'
INTO TABLE products
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(ProductID, ProductName, Category, Price);

-- Verify products data load
SELECT 'Products loaded:' as Status, COUNT(*) as RecordCount FROM products;

-- ============================================================================
-- LOAD STORES DATA
-- ============================================================================
LOAD DATA LOCAL INFILE '/Users/alejandrocano/Desktop/Proyectos/Business-Intelligence-Analysis/data/stores.csv'
INTO TABLE stores
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(StoreID, StoreName, Region);

-- Verify stores data load
SELECT 'Stores loaded:' as Status, COUNT(*) as RecordCount FROM stores;

-- ============================================================================
-- LOAD ORDERS DATA
-- ============================================================================
LOAD DATA LOCAL INFILE '/Users/alejandrocano/Desktop/Proyectos/Business-Intelligence-Analysis/data/orders.csv'
INTO TABLE orders
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderID, OrderDate, CustomerID, StoreID, TotalAmount, PaymentMethod);

-- Verify orders data load
SELECT 'Orders loaded:' as Status, COUNT(*) as RecordCount FROM orders;

-- ============================================================================
-- LOAD ORDER ITEMS DATA
-- ============================================================================
LOAD DATA LOCAL INFILE '/Users/alejandrocano/Desktop/Proyectos/Business-Intelligence-Analysis/data/order_items.csv'
INTO TABLE order_items
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(OrderID, ProductID, Quantity, UnitPrice);

-- Verify order items data load
SELECT 'Order Items loaded:' as Status, COUNT(*) as RecordCount FROM order_items;

-- ============================================================================
-- RE-ENABLE FOREIGN KEY CHECKS
-- ============================================================================
SET FOREIGN_KEY_CHECKS = 1;
