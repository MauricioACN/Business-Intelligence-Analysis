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

-- ============================================================================
-- DATA VALIDATION QUERIES
-- ============================================================================

-- Check for any referential integrity issues
SELECT 'Checking foreign key integrity...' as ValidationStep;

-- Check orders with invalid customer references
SELECT COUNT(*) as InvalidCustomerReferences
FROM orders o
LEFT JOIN customers c ON o.CustomerID = c.CustomerID
WHERE c.CustomerID IS NULL;

-- Check orders with invalid store references
SELECT COUNT(*) as InvalidStoreReferences
FROM orders o
LEFT JOIN stores s ON o.StoreID = s.StoreID
WHERE s.StoreID IS NULL;

-- Check order items with invalid order references
SELECT COUNT(*) as InvalidOrderReferences
FROM order_items oi
LEFT JOIN orders o ON oi.OrderID = o.OrderID
WHERE o.OrderID IS NULL;

-- Check order items with invalid product references
SELECT COUNT(*) as InvalidProductReferences
FROM order_items oi
LEFT JOIN products p ON oi.ProductID = p.ProductID
WHERE p.ProductID IS NULL;

-- ============================================================================
