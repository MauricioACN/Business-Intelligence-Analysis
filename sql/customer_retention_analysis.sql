-- Stored Procedure: Customer Retention Based on Order Frequency
-- ============================================================================

CREATE PROCEDURE GetCustomerRetentionByOrderFrequency(
    IN min_orders INT
)
BEGIN
    
    DECLARE total_customers INT;
    DECLARE retained_customers INT;
    DECLARE retention_percentage DECIMAL(5,2);
    
    -- Get total number of unique customers
    SELECT COUNT(DISTINCT customer_key) INTO total_customers FROM fact_sales;
    
    -- Get number of customers who meet the minimum order threshold
    SELECT COUNT(*) INTO retained_customers
    FROM (
        SELECT customer_key
        FROM fact_sales
        GROUP BY customer_key
        HAVING COUNT(DISTINCT order_id) >= min_orders
    ) as qualifying_customers;
    
    -- Calculate retention percentage
    SET retention_percentage = (retained_customers * 100.0) / total_customers;
    
    -- Return customers who meet the minimum order threshold
    SELECT 
        dc.customer_id,
        dc.customer_name,
        dc.email,
        COUNT(DISTINCT fs.order_id) as total_orders,
        SUM(fs.sales_amount) as total_spent,
        AVG(fs.sales_amount) as average_order_value,
        MIN(dd.full_date) as first_order_date,
        MAX(dd.full_date) as last_order_date
    FROM fact_sales fs
    INNER JOIN dim_customer dc ON fs.customer_key = dc.customer_key
    INNER JOIN dim_date dd ON fs.date_key = dd.date_key
    GROUP BY dc.customer_key, dc.customer_id, dc.customer_name, dc.email
    HAVING COUNT(DISTINCT fs.order_id) >= min_orders
    ORDER BY total_orders DESC, total_spent DESC;
    
    -- Return retention statistics
    SELECT 
        'RETENTION STATISTICS' as summary_type,
        total_customers as total_customers,
        retained_customers as customers_meeting_threshold,
        min_orders as minimum_orders_required,
        retention_percentage as retention_percentage,
        CONCAT(ROUND(retention_percentage, 1), '%') as retention_rate
    FROM dual;
    
END;