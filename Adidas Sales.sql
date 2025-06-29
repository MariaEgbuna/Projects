-- PERFORMANCE ANALYSIS

 -- 1. What is the total revenue and profit generated by each product category?
SELECT asd.product, SUM(asd.total_sales) AS total_revenue
FROM adidas_sales_data AS asd
GROUP BY asd.product
ORDER BY total_revenue DESC;
-- Insight: Men's Street Footwear generated the highest revenue, significantly outperforming other categories.

-- 2. Which sales method generates the highest revenue across all products?
SELECT asd.sales_method, SUM(asd.total_sales) AS total_revenue
FROM adidas_sales_data AS asd
GROUP BY asd.sales_method;
-- Insight: The 'Online' sales method generated the highest total revenue, indicating its dominance in sales channels.

-- 3. What is the average operating margin across all product categories?
SELECT asd.product, AVG(asd.operating_margin_percent) AS avg_operating_margin
FROM adidas_sales_data AS asd
GROUP BY asd.product
ORDER BY avg_operating_margin;
-- Insight: Men's Athletic Footwear had the lowest average operating margin among all product categories.

-- 4. Which region generates the highest profit, and which has the lowest?
SELECT asd.region, SUM(asd.operating_profit) AS total_profit
FROM adidas_sales_data AS asd
GROUP BY asd.region
ORDER BY total_profit DESC;
-- Insight: The West Region has the highest profit at $13,017,707 and Midwest is at the bottom with $6,860,043.

-- 5. Avg Units sold per day
SELECT AVG(asd.units_sold) AS avg_units_sold
FROM adidas_sales_data AS asd;
-- On average 250+ units are sold daily.

-- REGIONAL AND TEMPORAL TRENDS

-- 6. How does the total revenue change across different weeks or months?
SELECT EXTRACT (YEAR FROM invoice_date) AS years, EXTRACT (MONTH FROM invoice_date) AS months, SUM(asd.total_sales) AS total_revenue
FROM adidas_sales_data AS asd
GROUP BY EXTRACT (YEAR FROM invoice_date), EXTRACT (MONTH FROM invoice_date)
ORDER BY years, months;
-- Insight: Revenue showed a significant increase from 2020 to 2021, with 2021 consistently having much higher monthly revenues (in millions), suggesting strong growth.

-- 7. Which region contributes the most to the total sales, and does it align with the highest profitability?
SELECT asd.region, SUM(asd.total_sales) AS total_revenue, SUM(asd.operating_profit) AS total_profit
FROM adidas_sales_data AS asd
GROUP BY asd.region;
-- Insight: The West region contributes the most to total sales and also generates the highest total profit, indicating strong alignment between sales volume and profitability in this region.

-- 8. Number of sales per day?
SELECT asd.invoice_date, COUNT(*) AS sales_count
FROM adidas_sales_data AS asd
GROUP BY asd.invoice_date
ORDER BY asd.invoice_date,sales_count DESC;

-- 9. Are there specific dates or weeks when certain products experienced a significant spike or drop in sales?
SELECT
    EXTRACT(YEAR FROM invoice_date) AS sales_year,
    EXTRACT(WEEK FROM invoice_date) AS sales_week,
    product,
    SUM(total_sales) AS weekly_total_sales
FROM adidas_sales_data
GROUP BY sales_year, sales_week, product
ORDER BY sales_year, sales_week, weekly_total_sales DESC;
-- Insight: While direct "significant" spikes/drops require further statistical definition or visualization, this query provides the necessary weekly product sales data to identify periods of unusually high or low performance. Initial observations show varying sales volumes across weeks for different products.

-- PROFITABILITY INSIGHTS

-- 10. Which product category has the highest operating profit across all sales methods?
SELECT asd.product, SUM(asd.operating_profit) AS total_profit
FROM adidas_sales_data AS asd
GROUP BY asd.product
ORDER BY total_profit DESC;
-- Insight: Based on the results, Men's Street Footwear has the highest operating profit across all sales methods.

-- 11. What is the average profit margin for products sold via In-store vs. Outlet methods?
SELECT asd.sales_method, AVG(asd.operating_margin_percent) AS avg_profit_margin
FROM adidas_sales_data AS asd
WHERE asd.sales_method IN ('In-store', 'Outlet')
GROUP BY asd.sales_method;
-- Insight: The Outlet sales method has a slightly higher average profit margin (approximately 39.49%) compared to the In-store method (approximately 35.61%).

-- 12. Which product had the lowest operating margin, and how can this be improved?
SELECT asd.product, AVG(asd.operating_margin_percent) AS operating_margin
FROM adidas_sales_data AS asd
GROUP BY asd.product
ORDER BY operating_margin
LIMIT 1;
--Insight: Men's Athletic Footwear had the lowest average operating margin (0.402702).

-- PRODUCT-SPECIFIC ANALYSIS

-- 13. What is the average units sold per day for each product category?
WITH DailyProductSales AS (
    SELECT invoice_date, product, SUM(units_sold) AS daily_units_sold
    FROM adidas_sales_data
    GROUP BY invoice_date, product
)
SELECT product, AVG(daily_units_sold) AS avg_units_sold_per_day
FROM DailyProductSales
GROUP BY product
ORDER BY avg_units_sold_per_day DESC;
-- Insights: Men's Street Footwear' have the highest average units sold daily.

-- 14. How does the performance of Women's Athletic Footwear compare to Women's Street Footwear in terms of sales and profit?
SELECT asd.product, SUM(asd.total_sales) AS total_revenue, SUM(asd.operating_profit) AS total_profit
FROM adidas_sales_data AS asd
WHERE asd.product IN ('Women''s Athletic Footwear', 'Women''s Street Footwear')
GROUP BY asd.product;
-- Insight: Women's Street Footwear performs better than Women's Athletic Footwear in terms of both total sales and total profit.
