-- ============================================================================

-- Drop procedure if exists
DROP PROCEDURE IF EXISTS LoadStarSchemaData;

-- Create the procedure
CREATE PROCEDURE LoadStarSchemaData()
BEGIN
    -- Clear fact table
    DELETE FROM fact_sales;
    DELETE FROM dim_customer;
    DELETE FROM dim_product; 
    DELETE FROM dim_store;
    
    -- Load Customer Dimension
    INSERT INTO dim_customer (customer_id, customer_name, email, join_date)
    SELECT CustomerID, Name, Email, JoinDate
    FROM customers;
    
    -- Load Product Dimension
    INSERT INTO dim_product (product_id, product_name, category, price)
    SELECT ProductID, ProductName, Category, Price
    FROM products;
    
    -- Load Store Dimension
    INSERT INTO dim_store (store_id, store_name, region)
    SELECT StoreID, StoreName, Region
    FROM stores;
    
    -- Load Fact Sales
    INSERT INTO fact_sales (
        date_key, customer_key, product_key, store_key,
        order_id, quantity_sold, unit_price, sales_amount, payment_method
    )
    SELECT 
        DATE_FORMAT(o.OrderDate, '%Y%m%d') as date_key,
        dc.customer_key,
        dp.product_key,
        ds.store_key,
        o.OrderID,
        oi.Quantity,
        oi.UnitPrice,
        (oi.Quantity * oi.UnitPrice) as sales_amount,
        o.PaymentMethod
    FROM orders o
    JOIN order_items oi ON o.OrderID = oi.OrderID
    JOIN dim_customer dc ON o.CustomerID = dc.customer_id
    JOIN dim_product dp ON oi.ProductID = dp.product_id
    JOIN dim_store ds ON o.StoreID = ds.store_id
    JOIN dim_date dd ON DATE_FORMAT(o.OrderDate, '%Y%m%d') = dd.date_key;
    
    -- Verification
    SELECT 'ETL completed successfully' as Status;
    SELECT 'Customers' as Dimension, COUNT(*) as Records FROM dim_customer
    UNION ALL
    SELECT 'Products', COUNT(*) FROM dim_product
    UNION ALL
    SELECT 'Stores', COUNT(*) FROM dim_store
    UNION ALL
    SELECT 'Sales Facts', COUNT(*) FROM fact_sales;
    
END;