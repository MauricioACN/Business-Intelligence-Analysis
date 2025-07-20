-- ============================================================================

DROP PROCEDURE IF EXISTS PopulateDateDimension;

CREATE PROCEDURE PopulateDateDimension()
BEGIN
    DECLARE v_current_date DATE DEFAULT '2010-01-01';
    DECLARE v_end_date DATE DEFAULT '2050-12-31';
    DECLARE v_date_key INT;
    DECLARE v_finished INTEGER DEFAULT 0;
    
    -- Clear existing data first
    DELETE FROM dim_date;
    
    -- Reset auto increment if needed
    ALTER TABLE dim_date AUTO_INCREMENT = 1;
    
    -- Main loop
    WHILE v_current_date <= v_end_date DO
        SET v_date_key = CAST(DATE_FORMAT(v_current_date, '%Y%m%d') AS UNSIGNED);
        
        INSERT INTO dim_date (
            date_key,
            full_date,
            day_of_month,
            month_number,
            month_name,
            quarter,
            year,
            is_weekend
        ) VALUES (
            v_date_key,
            v_current_date,
            DAY(v_current_date),
            MONTH(v_current_date),
            MONTHNAME(v_current_date),
            QUARTER(v_current_date),
            YEAR(v_current_date),
            CASE WHEN DAYOFWEEK(v_current_date) IN (1,7) THEN 1 ELSE 0 END
        );
        
        SET v_current_date = DATE_ADD(v_current_date, INTERVAL 1 DAY);
    END WHILE;
    
END;