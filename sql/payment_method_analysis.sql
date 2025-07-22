-- Stored Procedure: Payment Method Distribution in Top Revenue Region
-- ============================================================================

CREATE PROCEDURE GetPaymentMethodDistributionTopRegion()
BEGIN
    
    DECLARE top_region VARCHAR(50);
    DECLARE top_region_revenue DECIMAL(15,2);
    DECLARE total_transactions_in_region INT;
    
    -- Find the region with highest total revenue
    SELECT ds.region, SUM(fs.sales_amount)
    INTO top_region, top_region_revenue
    FROM fact_sales fs
    INNER JOIN dim_store ds ON fs.store_key = ds.store_key
    GROUP BY ds.region
    ORDER BY SUM(fs.sales_amount) DESC
    LIMIT 1;
    
    -- Get total transactions in the top region
    SELECT COUNT(*) INTO total_transactions_in_region
    FROM fact_sales fs
    INNER JOIN dim_store ds ON fs.store_key = ds.store_key
    WHERE ds.region = top_region;
    
    -- Payment method distribution in top revenue region
    SELECT 
        top_region as top_revenue_region,
        top_region_revenue as total_region_revenue,
        fs.payment_method,
        COUNT(*) as transaction_count,
        SUM(fs.sales_amount) as total_revenue_by_method,
        ROUND((COUNT(*) * 100.0) / total_transactions_in_region, 2) as percentage_of_transactions,
        ROUND((SUM(fs.sales_amount) * 100.0) / top_region_revenue, 2) as percentage_of_revenue,
        AVG(fs.sales_amount) as average_transaction_value
    FROM fact_sales fs
    INNER JOIN dim_store ds ON fs.store_key = ds.store_key
    WHERE ds.region = top_region
    GROUP BY fs.payment_method
    ORDER BY transaction_count DESC;
    
    -- Regional revenue comparison
    SELECT 
        'REGIONAL COMPARISON' as summary_type,
        ds.region,
        SUM(fs.sales_amount) as total_revenue,
        COUNT(*) as total_transactions,
        AVG(fs.sales_amount) as average_transaction_value,
        CASE 
            WHEN ds.region = top_region THEN 'TOP REVENUE REGION'
            ELSE 'OTHER REGION'
        END as region_status
    FROM fact_sales fs
    INNER JOIN dim_store ds ON fs.store_key = ds.store_key
    GROUP BY ds.region
    ORDER BY total_revenue DESC;
    
END;