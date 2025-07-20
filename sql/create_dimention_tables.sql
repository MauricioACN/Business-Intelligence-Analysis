-- ============================================================================
-- Star Schema for the business questions
-- ============================================================================

SET FOREIGN_KEY_CHECKS = 0;

-- Drop existing tables
DROP TABLE IF EXISTS fact_sales;
DROP TABLE IF EXISTS dim_date;
DROP TABLE IF EXISTS dim_customer;
DROP TABLE IF EXISTS dim_product;
DROP TABLE IF EXISTS dim_store;

-- ============================================================================
-- DIMENSION TABLES
-- ============================================================================

-- Date Dimension
CREATE TABLE dim_date (
    date_key INT PRIMARY KEY,
    full_date DATE NOT NULL UNIQUE,
    day_of_month INT NOT NULL,
    month_number INT NOT NULL,
    month_name VARCHAR(10) NOT NULL,
    quarter INT NOT NULL,
    year INT NOT NULL,
    is_weekend BOOLEAN NOT NULL,
    INDEX idx_date (full_date),
    INDEX idx_year_month (year, month_number)
);

-- Customer Dimension
CREATE TABLE dim_customer (
    customer_key INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL UNIQUE,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    join_date DATE NOT NULL,
    customer_status VARCHAR(20) DEFAULT 'Active',
    INDEX idx_customer_id (customer_id),
    INDEX idx_join_date (join_date)
);

-- Product Dimension - Focused on category analysis
CREATE TABLE dim_product (
    product_key INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT NOT NULL UNIQUE,
    product_name VARCHAR(200) NOT NULL,
    category VARCHAR(50) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    INDEX idx_product_id (product_id),
    INDEX idx_category (category)
);

-- Store Dimension
CREATE TABLE dim_store (
    store_key INT PRIMARY KEY AUTO_INCREMENT,
    store_id INT NOT NULL UNIQUE,
    store_name VARCHAR(100) NOT NULL,
    region VARCHAR(50) NOT NULL,
    INDEX idx_store_id (store_id),
    INDEX idx_region (region)
);

-- ============================================================================
-- FACT TABLE
-- ============================================================================

CREATE TABLE fact_sales (
    sales_key BIGINT PRIMARY KEY AUTO_INCREMENT,
    date_key INT NOT NULL,
    customer_key INT NOT NULL,
    product_key INT NOT NULL,
    store_key INT NOT NULL,
    order_id INT NOT NULL,
    quantity_sold INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    sales_amount DECIMAL(12,2) NOT NULL,
    payment_method VARCHAR(30) NOT NULL,
    FOREIGN KEY (date_key) REFERENCES dim_date(date_key),
    FOREIGN KEY (customer_key) REFERENCES dim_customer(customer_key),
    FOREIGN KEY (product_key) REFERENCES dim_product(product_key),
    FOREIGN KEY (store_key) REFERENCES dim_store(store_key),
    INDEX idx_date_key (date_key),
    INDEX idx_customer_key (customer_key),
    INDEX idx_product_key (product_key),
    INDEX idx_store_key (store_key),
    INDEX idx_order_id (order_id),
    INDEX idx_payment_method (payment_method),
    INDEX idx_date_product (date_key, product_key),
    INDEX idx_date_store (date_key, store_key),
    INDEX idx_customer_order (customer_key, order_id)
);

SET FOREIGN_KEY_CHECKS = 1;