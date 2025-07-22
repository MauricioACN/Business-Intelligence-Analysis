-- Stored Procedure: Sales Analysis by Time Period
-- ============================================================================

CREATE PROCEDURE GetSalesByTimePeriod(
    IN start_date DATE,
    IN end_date DATE
)
BEGIN
    
    -- Daily Sales Analysis
    SELECT 
        'DAILY SALES' as analysis_type,
        fs.sale_date as period_date,
        SUM(fs.sales_amount) as total_sales,
        AVG(fs.sales_amount) as average_sales,
        COUNT(*) as number_of_transactions
    FROM fact_sales fs
    INNER JOIN dim_date dd ON fs.date_key = dd.date_key
    WHERE dd.full_date BETWEEN start_date AND end_date
    GROUP BY fs.sale_date
    ORDER BY fs.sale_date;
    
    -- Monthly Sales Analysis
    SELECT 
        'MONTHLY SALES' as analysis_type,
        CONCAT(dd.year, '-', LPAD(dd.month_number, 2, '0')) as period_date,
        dd.month_name,
        dd.year,
        SUM(fs.sales_amount) as total_sales,
        AVG(fs.sales_amount) as average_sales,
        COUNT(*) as number_of_transactions
    FROM fact_sales fs
    INNER JOIN dim_date dd ON fs.date_key = dd.date_key
    WHERE dd.full_date BETWEEN start_date AND end_date
    GROUP BY dd.year, dd.month_number, dd.month_name
    ORDER BY dd.year, dd.month_number;
    
    -- Yearly Sales Analysis
    SELECT 
        'YEARLY SALES' as analysis_type,
        dd.year as period_date,
        SUM(fs.sales_amount) as total_sales,
        AVG(fs.sales_amount) as average_sales,
        COUNT(*) as number_of_transactions
    FROM fact_sales fs
    INNER JOIN dim_date dd ON fs.date_key = dd.date_key
    WHERE dd.full_date BETWEEN start_date AND end_date
    GROUP BY dd.year
    ORDER BY dd.year;
    
END;
