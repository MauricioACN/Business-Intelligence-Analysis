-- Stored Procedure: Sales Trends by Product Category and Region
-- ============================================================================

CREATE PROCEDURE GetSalesTrendsByCategoryAndRegion(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    
    -- Sales by Product Category and Region
    SELECT 
        dp.category as product_category,
        ds.region,
        SUM(fs.sales_amount) as total_sales,
        AVG(fs.sales_amount) as average_sales,
        COUNT(*) as number_of_transactions,
        SUM(fs.quantity_sold) as total_units_sold
    FROM fact_sales fs
    INNER JOIN dim_date dd ON fs.date_key = dd.date_key
    INNER JOIN dim_product dp ON fs.product_key = dp.product_key
    INNER JOIN dim_store ds ON fs.store_key = ds.store_key
    WHERE dd.full_date BETWEEN start_date AND end_date
    GROUP BY dp.category, ds.region
    ORDER BY dp.category, ds.region;
    
    -- Summary by Product Category
    SELECT 
        'CATEGORY SUMMARY' as summary_type,
        dp.category as product_category,
        SUM(fs.sales_amount) as total_sales_by_category,
        AVG(fs.sales_amount) as average_sales_by_category,
        COUNT(DISTINCT ds.region) as regions_sold_in,
        COUNT(*) as total_transactions
    FROM fact_sales fs
    INNER JOIN dim_date dd ON fs.date_key = dd.date_key
    INNER JOIN dim_product dp ON fs.product_key = dp.product_key
    INNER JOIN dim_store ds ON fs.store_key = ds.store_key
    WHERE dd.full_date BETWEEN start_date AND end_date
    GROUP BY dp.category
    ORDER BY total_sales_by_category DESC;
    
    -- Summary by Region
    SELECT 
        'REGION SUMMARY' as summary_type,
        ds.region,
        SUM(fs.sales_amount) as total_sales_by_region,
        AVG(fs.sales_amount) as average_sales_by_region,
        COUNT(DISTINCT dp.category) as categories_sold,
        COUNT(*) as total_transactions
    FROM fact_sales fs
    INNER JOIN dim_date dd ON fs.date_key = dd.date_key
    INNER JOIN dim_product dp ON fs.product_key = dp.product_key
    INNER JOIN dim_store ds ON fs.store_key = ds.store_key
    WHERE dd.full_date BETWEEN start_date AND end_date
    GROUP BY ds.region
    ORDER BY total_sales_by_region DESC;
    
END;