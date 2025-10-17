-- TABLE CREATION --
DROP TABLE IF EXISTS bike_sales;

CREATE TABLE bike_sales (
    sale_id        INTEGER PRIMARY KEY,
    brand          VARCHAR(50) NOT NULL,
    model          VARCHAR(50),
    state          VARCHAR(50),
    sale_date      DATE,
    units_sold     SMALLINT,
    price          NUMERIC(12,2),
    revenue        NUMERIC(14,2),
    purchase_mode  VARCHAR(20),
    dealer_type    VARCHAR(30)
);

-- Indexes to speed up common analytical queries
CREATE INDEX IF NOT EXISTS idx_bike_sales_brand ON bike_sales(brand);
CREATE INDEX IF NOT EXISTS idx_bike_sales_state ON bike_sales(state);
CREATE INDEX IF NOT EXISTS idx_bike_sales_saledate ON bike_sales(sale_date);

SELECT * FROM bike_sales
LIMIT 10; --Checking created table --

-- Cleaning Data --
-- 1. ensure revenue matches units_sold * price --
UPDATE bike_sales
SET revenue = units_sold * price
WHERE revenue IS NULL OR revenue <> units_sold * price;

-- Data validation checks --
-- Count rows
SELECT COUNT(*) AS total_rows FROM bike_sales;

-- Check for NULLs --
SELECT
  SUM(CASE WHEN brand IS NULL THEN 1 ELSE 0 END) AS brand_nulls,
  SUM(CASE WHEN sale_date IS NULL THEN 1 ELSE 0 END) AS sale_date_nulls
FROM bike_sales;

-- Find duplicate sale_ids --
SELECT sale_id, COUNT(*) FROM bike_sales GROUP BY sale_id HAVING COUNT(*) > 1;

--show any rows where revenue != units_sold * price --
SELECT * FROM bike_sales WHERE revenue <> units_sold * price LIMIT 20;


-- MY ANALYSIS QUERIES WITH TABLE "bike_sales" --

-- Query 1. Total sales records --
SELECT COUNT(*) AS total_sales_records FROM bike_sales;

-- Query 2. Top 5 brands by total units sold --
SELECT brand, SUM(units_sold) AS total_units
FROM bike_sales
GROUP BY brand
ORDER BY total_units DESC
LIMIT 5;

-- Query 3. Monthly revenue trend (last 2 years) --
SELECT DATE_TRUNC('month', sale_date)::date AS month,
       SUM(revenue) AS monthly_revenue
FROM bike_sales
WHERE sale_date >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY month
ORDER BY month;

-- Query 4. Average price per brand --
SELECT brand, ROUND(AVG(price), 2) AS avg_price
FROM bike_sales
GROUP BY brand
ORDER BY avg_price DESC;

-- Query 5. Revenue contribution by state --
SELECT state, SUM(revenue) AS total_revenue,
       ROUND(100.0 * SUM(revenue) / (SELECT SUM(revenue) FROM bike_sales),
	   2) AS percentage_share
FROM bike_sales
GROUP BY state
ORDER BY total_revenue DESC;

-- Query 6. Most popular purchase mode --
SELECT purchase_mode, COUNT(*) AS transactions
FROM bike_sales
GROUP BY purchase_mode
ORDER BY transactions DESC;

-- Query 7. Highest revenue-generating dealer type --
SELECT dealer_type, SUM(revenue) AS total_revenue
FROM bike_sales
GROUP BY dealer_type
ORDER BY total_revenue DESC;

-- Query 8. Best-selling model in each brand --
SELECT brand, model, total_units
FROM (
    SELECT brand, model, SUM(units_sold) AS total_units,
           RANK() OVER (PARTITION BY brand ORDER BY SUM(units_sold) DESC) AS rk
    FROM bike_sales
    GROUP BY brand, model
) ranked_models
WHERE rk = 1;

-- Query 9. Yearly sales growth --
WITH yearly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM sale_date)::int AS year,
        SUM(units_sold) AS total_units
    FROM bike_sales
    GROUP BY EXTRACT(YEAR FROM sale_date)
)
SELECT 
    year,
    total_units,
    LAG(total_units) OVER (ORDER BY year) AS previous_year_units,
    (total_units - LAG(total_units) OVER (ORDER BY year)) AS growth_units,
    ROUND(100.0 * (total_units - LAG(total_units) OVER (ORDER BY year)) / 
          NULLIF(LAG(total_units) OVER (ORDER BY year), 0), 2) AS growth_percent
FROM yearly_sales
ORDER BY year;

-- Query 10. Highest revenue single transaction --
SELECT sale_id, brand, model, state, revenue
FROM bike_sales
ORDER BY revenue DESC
LIMIT 1;

--Skills Demonstrated
-- Database design
-- Data import (ETL)
-- Aggregation & Grouping
-- Window functions (RANK, LAG)
-- Analytical SQL for business insights
-- This project focusing on showcase SQL skills and provide real-world business
-- insights from sales data -





 	


























