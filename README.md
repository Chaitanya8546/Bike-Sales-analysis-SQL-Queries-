# 🏍️ Bike Sales Analysis (PostgreSQL)

## 📌 Project Overview

This project analyzes **Indian two-wheeler sales data** using **PostgreSQL**.  
The dataset contains **10,000 sales records** across major brands like **Hero, Honda, Bajaj, Royal Enfield, TVS, Yamaha, Suzuki,** and **KTM**.

The goal is to demonstrate SQL skills through:

- Database design & schema creation  
- Data import from CSV  
- Analytical SQL queries using aggregations, window functions, grouping, and ranking  
- Business insights generation  

---

## 📂 Dataset Details

- **Rows:** 10,000  
- **Columns:** 10  

---

## 🛠️ Database Schema (PostgreSQL)

```sql
CREATE TABLE bike_sales (
    Sale_ID SERIAL PRIMARY KEY,
    Brand VARCHAR(50),
    Model VARCHAR(50),
    State VARCHAR(50),
    Sale_Date DATE,
    Units_Sold INT,
    Price NUMERIC(10,2),
    Revenue NUMERIC(12,2),
    Purchase_Mode VARCHAR(20),
    Dealer_Type VARCHAR(30)
);
```

---

## 📊 SQL Analysis Queries

### 1. Total sales records
```sql
SELECT COUNT(*) FROM bike_sales;
```

### 2. Top 5 brands by total units sold
```sql
SELECT brand, SUM(units_sold) AS total_units
FROM bike_sales
GROUP BY brand
ORDER BY total_units DESC
LIMIT 5;
```

### 3. Monthly revenue trend (last 2 years)
```sql
SELECT DATE_TRUNC('month', sale_date) AS month, SUM(revenue) AS monthly_revenue
FROM bike_sales
WHERE sale_date >= CURRENT_DATE - INTERVAL '2 years'
GROUP BY month
ORDER BY month;
```

### 4. Average price per brand
```sql
SELECT brand, ROUND(AVG(price), 2) AS avg_price
FROM bike_sales
GROUP BY brand
ORDER BY avg_price DESC;
```

### 5. Revenue contribution by state
```sql
SELECT state, SUM(revenue) AS total_revenue,
       ROUND(100.0 * SUM(revenue) / (SELECT SUM(revenue) FROM bike_sales), 2) AS percentage_share
FROM bike_sales
GROUP BY state
ORDER BY total_revenue DESC;
```

### 6. Most popular purchase mode
```sql
SELECT purchase_mode, COUNT(*) AS transactions
FROM bike_sales
GROUP BY purchase_mode
ORDER BY transactions DESC;
```

### 7. Highest revenue-generating dealer type
```sql
SELECT dealer_type, SUM(revenue) AS total_revenue
FROM bike_sales
GROUP BY dealer_type
ORDER BY total_revenue DESC;
```

### 8. Best-selling model in each brand
```sql
SELECT brand, model, total_units
FROM (
    SELECT brand, model, SUM(units_sold) AS total_units,
           RANK() OVER (PARTITION BY brand ORDER BY SUM(units_sold) DESC) AS rank
    FROM bike_sales
    GROUP BY brand, model
) ranked_models
WHERE rank = 1;
```

### 9. Yearly sales growth
```sql
SELECT EXTRACT(YEAR FROM sale_date) AS year,
       SUM(units_sold) AS total_units,
       LAG(SUM(units_sold)) OVER (ORDER BY EXTRACT(YEAR FROM sale_date)) AS previous_year_units,
       (SUM(units_sold) - LAG(SUM(units_sold)) OVER (ORDER BY EXTRACT(YEAR FROM sale_date))) AS growth_units
FROM bike_sales
GROUP BY year
ORDER BY year;
```

### 10. Highest revenue single transaction
```sql
SELECT sale_id, brand, model, state, revenue
FROM bike_sales
ORDER BY revenue DESC
LIMIT 1;
```

---

## 📈 Possible Insights

- **Hero** & **Honda** dominate sales volume, while **Royal Enfield** & **KTM** generate higher revenue per unit.  
- **Loan** & **EMI** purchases are more common for premium bikes.  
- **Maharashtra**, **Karnataka**, and **Tamil Nadu** contribute the largest revenue share.  
- **Authorized dealers** lead in sales, but **multi-brand dealers** also contribute significantly.  

---

## 🏆 Skills Demonstrated

✔️ Database design  
✔️ Data import (ETL)  
✔️ Aggregation & Grouping  
✔️ Window functions (`RANK`, `LAG`)  
✔️ Analytical SQL for business insights  

---

## ✨ Project Summary

This project showcases **SQL skills** and demonstrates how to derive **real-world business insights** from sales data using PostgreSQL.

---

## 👨‍💻 Author

**Chaitanya Hegde**  
📅 Year: 2025  
📍 Project Type: Data Analytics / SQL Queries  

