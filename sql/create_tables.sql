-- ============================================================================
-- This script creates the database tables
-- ============================================================================

-- Drop tables if they exist (in reverse order to handle foreign key constraints)
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS stores;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;

-- ============================================================================
-- CUSTOMERS TABLE
-- ============================================================================
CREATE TABLE customers (
    CustomerID INTEGER PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(150) NOT NULL UNIQUE,
    JoinDate DATE NOT NULL
);

-- ============================================================================
-- PRODUCTS TABLE
-- ============================================================================
CREATE TABLE products (
    ProductID INTEGER PRIMARY KEY,
    ProductName VARCHAR(200) NOT NULL,
    Category VARCHAR(50) NOT NULL,
    Price DECIMAL(10,2) NOT NULL CHECK (Price > 0)
);

-- ============================================================================
-- STORES TABLE
-- ============================================================================
CREATE TABLE stores (
    StoreID INTEGER PRIMARY KEY,
    StoreName VARCHAR(100) NOT NULL,
    Region VARCHAR(50) NOT NULL
);

-- ============================================================================
-- ORDERS TABLE
-- ============================================================================
CREATE TABLE orders (
    OrderID INTEGER PRIMARY KEY,
    OrderDate DATE NOT NULL,
    CustomerID INTEGER NOT NULL,
    StoreID INTEGER NOT NULL,
    TotalAmount DECIMAL(12,2) NOT NULL CHECK (TotalAmount >= 0),
    PaymentMethod VARCHAR(30) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
    FOREIGN KEY (StoreID) REFERENCES stores(StoreID)
);

-- ============================================================================
-- ORDER_ITEMS TABLE
-- ============================================================================
CREATE TABLE order_items (
    OrderID INTEGER NOT NULL,
    ProductID INTEGER NOT NULL,
    Quantity INTEGER NOT NULL CHECK (Quantity > 0),
    UnitPrice DECIMAL(10,2) NOT NULL CHECK (UnitPrice > 0),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);

-- ============================================================================
-- CREATE INDEXES FOR BETTER QUERY PERFORMANCE
-- ============================================================================

-- Customers indexes
CREATE INDEX idx_customers_email ON customers(Email);
CREATE INDEX idx_customers_join_date ON customers(JoinDate);

-- Products indexes
CREATE INDEX idx_products_category ON products(Category);
CREATE INDEX idx_products_price ON products(Price);

-- Stores indexes
CREATE INDEX idx_stores_region ON stores(Region);

-- Orders indexes
CREATE INDEX idx_orders_date ON orders(OrderDate);
CREATE INDEX idx_orders_customer ON orders(CustomerID);
CREATE INDEX idx_orders_store ON orders(StoreID);
CREATE INDEX idx_orders_payment_method ON orders(PaymentMethod);
CREATE INDEX idx_orders_total_amount ON orders(TotalAmount);

-- Order items indexes
CREATE INDEX idx_order_items_product ON order_items(ProductID);
CREATE INDEX idx_order_items_quantity ON order_items(Quantity);
CREATE INDEX idx_order_items_unit_price ON order_items(UnitPrice);

-- ============================================================================
