-- =====================================================================
-- FINANCIAL DATA ANALYST CAPSTONE PROJECT: SQL ANALYSIS SCRIPT
-- Database: SQLite / MySQL / PostgreSQL Compatible
-- Table: financials
-- =====================================================================

-- 1. OVERALL BUSINESS HEALTH & EXECUTIVE KPIS
SELECT 
    ROUND(SUM("Gross Sales"), 2) AS Total_Gross_Sales,
    ROUND(SUM("Discounts"), 2) AS Total_Discounts,
    ROUND(SUM("Sales"), 2) AS Total_Net_Sales,
    ROUND(SUM("COGS"), 2) AS Total_COGS,
    ROUND(SUM("Profit"), 2) AS Total_Profit,
    ROUND((SUM("Profit") / SUM("Sales")) * 100, 2) AS Overall_Profit_Margin_Pct,
    ROUND(SUM("Units Sold"), 0) AS Total_Units_Sold,
    ROUND((SUM("Discounts") / SUM("Gross Sales")) * 100, 2) AS Overall_Discount_Rate_Pct
FROM financials;

-- 2. REVENUE AND PROFIT PERFORMANCE BY COUNTRY
SELECT 
    Country,
    ROUND(SUM("Sales"), 2) AS Total_Sales,
    ROUND(SUM("Profit"), 2) AS Total_Profit,
    ROUND((SUM("Profit") / SUM("Sales")) * 100, 2) AS Profit_Margin_Pct,
    ROUND(SUM("Units Sold"), 0) AS Total_Units_Sold,
    DENSE_RANK() OVER (ORDER BY SUM("Profit") DESC) AS Profit_Rank
FROM financials
GROUP BY Country
ORDER BY Total_Profit DESC;

-- 3. SEGMENT PERFORMANCE & PROFITABILITY BREAKDOWN
SELECT 
    Segment,
    ROUND(SUM("Sales"), 2) AS Total_Sales,
    ROUND(SUM("Profit"), 2) AS Total_Profit,
    ROUND((SUM("Profit") / SUM("Sales")) * 100, 2) AS Profit_Margin_Pct,
    ROUND(SUM("Units Sold"), 0) AS Total_Units_Sold,
    ROUND((SUM("Sales") * 100.0 / (SELECT SUM("Sales") FROM financials)), 2) AS Sales_Share_Pct
FROM financials
GROUP BY Segment
ORDER BY Total_Sales DESC;

-- 4. PRODUCT PROFITABILITY & VOLUME ANALYSIS
SELECT 
    Product,
    ROUND(SUM("Sales"), 2) AS Total_Sales,
    ROUND(SUM("Profit"), 2) AS Total_Profit,
    ROUND((SUM("Profit") / SUM("Sales")) * 100, 2) AS Profit_Margin_Pct,
    ROUND(SUM("Units Sold"), 0) AS Total_Units_Sold,
    ROUND(AVG("Sale Price"), 2) AS Avg_Sale_Price,
    ROUND(AVG("Manufacturing Price"), 2) AS Avg_Manufacturing_Cost
FROM financials
GROUP BY Product
ORDER BY Total_Profit DESC;

-- 5. DISCOUNT BAND IMPACT ANALYSIS (PRICE SENSITIVITY)
SELECT 
    "Discount Band",
    COUNT(*) AS Transaction_Count,
    ROUND(SUM("Gross Sales"), 2) AS Gross_Sales,
    ROUND(SUM("Discounts"), 2) AS Total_Discounts,
    ROUND(SUM("Sales"), 2) AS Net_Sales,
    ROUND(SUM("Profit"), 2) AS Total_Profit,
    ROUND((SUM("Profit") / SUM("Sales")) * 100, 2) AS Profit_Margin_Pct
FROM financials
GROUP BY "Discount Band"
ORDER BY Profit_Margin_Pct DESC;

-- 6. MONTH-OVER-MONTH (MoM) REVENUE & PROFIT GROWTH (WINDOW FUNCTION)
WITH MonthlyData AS (
    SELECT 
        Year,
        "Month Number" AS Month_Num,
        "Month Name" AS Month_Name,
        ROUND(SUM("Sales"), 2) AS Monthly_Sales,
        ROUND(SUM("Profit"), 2) AS Monthly_Profit
    FROM financials
    GROUP BY Year, "Month Number", "Month Name"
    ORDER BY Year, "Month Number"
)
SELECT 
    Year,
    Month_Num,
    Month_Name,
    Monthly_Sales,
    LAG(Monthly_Sales, 1) OVER (ORDER BY Year, Month_Num) AS Prev_Month_Sales,
    ROUND(
        ((Monthly_Sales - LAG(Monthly_Sales, 1) OVER (ORDER BY Year, Month_Num)) / 
        LAG(Monthly_Sales, 1) OVER (ORDER BY Year, Month_Num)) * 100, 
        2
    ) AS MoM_Sales_Growth_Pct,
    Monthly_Profit,
    ROUND(
        ((Monthly_Profit - LAG(Monthly_Profit, 1) OVER (ORDER BY Year, Month_Num)) / 
        LAG(Monthly_Profit, 1) OVER (ORDER BY Year, Month_Num)) * 100, 
        2
    ) AS MoM_Profit_Growth_Pct
FROM MonthlyData;

-- 7. YEAR-OVER-YEAR (YoY) SUMMARY (2013 vs 2014)
SELECT 
    Year,
    COUNT(*) AS Total_Orders,
    ROUND(SUM("Units Sold"), 0) AS Units_Sold,
    ROUND(SUM("Sales"), 2) AS Net_Sales,
    ROUND(SUM("Profit"), 2) AS Total_Profit,
    ROUND((SUM("Profit") / SUM("Sales")) * 100, 2) AS Profit_Margin_Pct
FROM financials
GROUP BY Year
ORDER BY Year;

-- 8. TOP 5 MOST PROFITABLE COUNTRY & PRODUCT COMBINATIONS
SELECT 
    Country,
    Product,
    ROUND(SUM("Sales"), 2) AS Total_Sales,
    ROUND(SUM("Profit"), 2) AS Total_Profit,
    ROUND((SUM("Profit") / SUM("Sales")) * 100, 2) AS Profit_Margin_Pct,
    ROUND(SUM("Units Sold"), 0) AS Units_Sold
FROM financials
GROUP BY Country, Product
ORDER BY Total_Profit DESC
LIMIT 5;

-- 9. UNDERPERFORMING OR NEGATIVE PROFIT SCENARIOS
SELECT 
    Country,
    Segment,
    Product,
    "Discount Band",
    ROUND(SUM("Sales"), 2) AS Sales,
    ROUND(SUM("Profit"), 2) AS Profit
FROM financials
GROUP BY Country, Segment, Product, "Discount Band"
HAVING SUM("Profit") < 0
ORDER BY Profit ASC
LIMIT 10;
