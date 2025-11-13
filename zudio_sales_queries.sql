1️⃣ Create Table and Load Data
CREATE TABLE zudio_sales (
    id INT AUTO_INCREMENT PRIMARY KEY,
    Date DATE,
    City VARCHAR(100),
    Store_Type VARCHAR(50),
    Category VARCHAR(50),
    Revenue DECIMAL(10,2),
    Parking_Available VARCHAR(5)
);

2️⃣ Initial Data Audit
SELECT * FROM zudio_sales LIMIT 10;

SELECT COUNT(*) AS total_records,
       COUNT(DISTINCT City) AS unique_cities,
       COUNT(DISTINCT Category) AS unique_categories
FROM zudio_sales;

3️⃣ Check for Nulls & Duplicates
-- Check missing values
SELECT 
    SUM(CASE WHEN City IS NULL THEN 1 ELSE 0 END) AS null_city,
    SUM(CASE WHEN Category IS NULL THEN 1 ELSE 0 END) AS null_category,
    SUM(CASE WHEN Revenue IS NULL THEN 1 ELSE 0 END) AS null_revenue
FROM zudio_sales;

-- Detect duplicates
SELECT City, Category, Date, COUNT(*) 
FROM zudio_sales
GROUP BY City, Category, Date
HAVING COUNT(*) > 1;

4️⃣ Clean and Standardize Data
-- Remove duplicates
DELETE t1 FROM zudio_sales t1
JOIN zudio_sales t2 
ON t1.id > t2.id 
AND t1.City = t2.City 
AND t1.Category = t2.Category 
AND t1.Date = t2.Date;

-- Format categorical data
UPDATE zudio_sales
SET 
    City = TRIM(UPPER(City)),
    Store_Type = TRIM(LOWER(Store_Type)),
    Parking_Available = TRIM(LOWER(Parking_Available));

5️⃣ Extract Month for Trend Analysis
ALTER TABLE zudio_sales ADD COLUMN Month_Name VARCHAR(20);

UPDATE zudio_sales
SET Month_Name = MONTHNAME(Date);

 SQL ANALYSIS QUERIES 
🔹 1. Monthly Revenue Trend
SELECT Month_Name, ROUND(SUM(Revenue),2) AS total_revenue
FROM zudio_sales
GROUP BY Month_Name
ORDER BY STR_TO_DATE(Month_Name, '%M');


Insight: Revenue was stable most of the year, with a noticeable dip in December (post-festival slowdown).

🔹 2. Category Performance
SELECT Category, ROUND(SUM(Revenue),2) AS total_revenue
FROM zudio_sales
GROUP BY Category
ORDER BY total_revenue DESC;


Insight: The Kid’s category dominated total sales, outperforming Men’s and Women’s categories.

🔹 3. Store Type Contribution
SELECT Store_Type, ROUND(SUM(Revenue),2) AS total_revenue,
       ROUND(100.0 * SUM(Revenue) / (SELECT SUM(Revenue) FROM zudio_sales), 2) AS revenue_percentage
FROM zudio_sales
GROUP BY Store_Type
ORDER BY total_revenue DESC;


Insight: Rented stores contributed more revenue than owned ones, showing higher brand-driven performance.

🔹 4. Parking Impact
SELECT Parking_Available, ROUND(SUM(Revenue),2) AS total_revenue,
       ROUND(100.0 * SUM(Revenue) / (SELECT SUM(Revenue) FROM zudio_sales), 2) AS contribution_percent
FROM zudio_sales
GROUP BY Parking_Available;


Insight: Stores with parking availability contributed over 50% of total revenue — accessibility boosts footfall.

🔹 5. Top Cities for Kid’s Category
SELECT City, ROUND(SUM(Revenue),2) AS kids_revenue
FROM zudio_sales
WHERE Category = 'Kids'
GROUP BY City
ORDER BY kids_revenue DESC
LIMIT 5;


Insight: Jammu, Indore, and Hyderabad lead in Kid’s category sales — ideal for future expansion.
