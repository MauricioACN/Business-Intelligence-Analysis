-- This script executes all the analytical stored procedures to analyze results
-- ============================================================================

-- ============================================================================
-- 1. SALES ANALYSIS BY TIME PERIODS
-- ============================================================================
SELECT 'EXECUTING: Sales Analysis by Time Periods' as analysis_step;

-- Analyze sales for whole years
CALL GetSalesByTimePeriod('2023-01-01', '2023-12-31');

-- ============================================================================
-- 2. SALES TRENDS BY PRODUCT CATEGORY AND REGION
-- ============================================================================
SELECT 'EXECUTING: Sales Trends by Category and Region' as analysis_step;

-- Analyze category and region performance for 2023
CALL GetSalesTrendsByCategoryAndRegion('2023-01-01', '2023-12-31');

-- ============================================================================
-- 3. CUSTOMER RETENTION ANALYSIS
-- ============================================================================
SELECT 'EXECUTING: Customer Retention Analysis' as analysis_step;

-- Find customers with at least 5 orders (loyal customers)
CALL GetCustomerRetentionByOrderFrequency(3);

-- ============================================================================
-- 4. PAYMENT METHOD DISTRIBUTION IN TOP REVENUE REGION
-- ============================================================================
SELECT 'EXECUTING: Payment Method Analysis in Top Region' as analysis_step;

-- Analyze payment methods in the highest revenue region
CALL GetPaymentMethodDistributionTopRegion();