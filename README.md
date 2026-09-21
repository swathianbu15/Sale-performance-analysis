# 📊 Global Financial Performance & Commercial Analytics Dashboard
### End-to-End Data Analytics Capstone Project | Power BI, Python & SQL

![Power BI](https://img.shields.io/badge/Power_BI-Desktop-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-3.14-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-SQLite_/_PostgreSQL-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-Data_Analysis-150458?style=for-the-badge&logo=pandas&logoColor=white)
![Status](https://img.shields.io/badge/Status-Completed-success?style=for-the-badge)

---

## 📌 1. Project Overview & Business Problem

This capstone project provides an **end-to-end commercial and financial evaluation** of global sales operations across **5 international markets** (Canada, France, Germany, Mexico, USA) and **5 customer segments** (Government, Small Business, Enterprise, Midmarket, Channel Partners) spanning **700 commercial transactions** across **2013 – 2014**.

### **The Business Problem:**
Despite top-line revenue exceeding **$118.7M**, leadership noticed margin compression in key segments and sought answers to critical strategic questions:
1. Which international markets and customer segments are the most and least profitable?
2. Why is the high-revenue **Enterprise segment failing to generate positive net profit**?
3. How do commercial **Discount Bands** impact price elasticity and profit margins?
4. What seasonal patterns dictate manufacturing and inventory procurement cycles?

---

## 🖥️ 2. Power BI Dashboard Preview

### **Executive Summary View:**
![Power BI Dashboard Overview](images/powerbi_dashboard_overview.png)

### **Detailed Multi-Page Analytics View:**
![Power BI Detailed Analytics Report](images/powerbi_detailed_report.png)

> **File Link:** Open the live interactive dashboard in Power BI Desktop via [`Financial_Analytics_Dashboard.pbix`](Financial_Analytics_Dashboard.pbix) or test it in any browser via [`dashboard.html`](dashboard.html).

---

## 📈 3. Key Performance Indicators (Executive Summary)

| KPI Metric | Value ($ / Units) | % Benchmark / Share | Operational Status |
| :--- | :---: | :---: | :--- |
| **Gross Sales** | **$127,931,598.50** | 100.00% | Catalog list volume |
| **Commercial Discounts** | **$9,205,248.24** | 7.20% | Price concessions granted |
| **Net Realized Revenue** | **$118,726,350.26** | 92.80% | Topline net cash intake |
| **Cost of Goods Sold (COGS)** | **$101,832,648.00** | 85.77% | Direct manufacturing costs |
| **Net Operating Profit** | **$16,893,702.26** | **14.23% Margin** | Operating bottom line |
| **Total Units Sold** | **1,125,806 Units** | 1,608 / order | Global volume distribution |

---

## 🔍 4. Key Analytical Insights & Visual Deep-Dive

### 📍 A. Geographic Market Breakdown
![Sales and Profit by Country](charts/sales_profit_by_country.png)

- **France** and **Germany** generated the highest profitability (**$3.78M** and **$3.68M**, with **15.53%** and **15.66%** profit margins).
- The **United States** drove the highest gross volume ($25.03M) but registered the lowest margin among developed markets (**11.97%**) due to heavy promotional discounting.

---

### 🏢 B. Segment Breakdown: The Enterprise Loss Discovery
![Sales by Segment](charts/sales_by_segment.png)

| Segment | Net Sales ($) | Net Profit ($) | Profit Margin % | Revenue Share % | Diagnosis |
| :--- | :---: | :---: | :---: | :---: | :--- |
| **Government** | $52,504,260.67 | **+$11,388,173.17** | **21.69%** | **44.22%** | **Primary Profit Engine (67.4% of total profit)** |
| **Small Business** | $42,427,918.50 | +$4,143,168.50 | 9.77% | 35.74% | High volume; moderate margin |
| **Channel Partners** | $1,800,593.64 | +$1,316,803.14 | **73.13%** | 1.52% | **Highest Margin Tier (High-ROI growth target)** |
| **Midmarket** | $2,381,883.08 | +$660,103.07 | 27.71% | 2.01% | Steady performance |
| **Enterprise** | $19,611,694.38 | **-$614,545.62** | **-3.13%** | 16.52% | ⚠️ **Severe Margin Erosion (Net Loss)** |

> **Root Cause Analysis:** SQL drill-down revealed that when Enterprise deals are granted **High Discounts**, profit crashes to **-$622,368.75 (-9.53% margin)**. The company was essentially subsidizing Enterprise volume below production cost.

---

### 🏷️ C. Price Elasticity & Discount Band Impact
![Discount Band Impact](charts/discount_band_impact.png)

- **No Discount:** Achieves a healthy **21.86%** profit margin.
- **Low Discount:** Retains **17.87%** margin.
- **Medium Discount:** Drops to **14.39%** margin.
- **High Discount:** Collapses to **9.07%** margin (and negative margins in the Enterprise segment). Over **$5.3M** in discounts was conceded in the High tier alone.

---

### 📅 D. Timeline Seasonality & Product Performance
| Monthly Trend | Product Profitability |
| :---: | :---: |
| ![Monthly Trend](charts/monthly_trend_sales_profit.png) | ![Product Profitability](charts/product_profitability_ranking.png) |

- **Q4 Surge:** Revenue spikes in **October ($12.38M)** and **December ($12.00M)** due to fiscal year-end budget utilization in public and enterprise sectors.
- **Product Leader:** **Paseo** is the anchor product, driving **$33.01M in sales and $4.80M in net profit** (28.4% of company total).

---

## 💻 5. Technical Stack & Implementation

```
Data Processing Pipeline:
Raw Data (Excel/Google Sheets)
   │
   ▼
Python (Pandas) ──► Data Cleaning, Imputation & Feature Engineering (Date Parsing, Margins)
   │
   ├──► SQLite Database (financial_analytics.db) ──► 9 SQL Analytical Queries (Window Functions)
   ├──► Power BI Desktop (Financial_Analytics_Dashboard.pbix) ──► Interactive Visuals & DAX Measures
   ├──► ReportLab ──► Executive Presentation Report (PDF)
   └──► HTML5/Chart.js ──► Standalone Web Dashboard (dashboard.html)
```

### **Core DAX Measures (Power BI):**
```dax
// 1. Total Net Sales
Total Net Sales = SUM(financials[Sales])

// 2. Total Net Profit
Total Net Profit = SUM(financials[Profit])

// 3. Profit Margin %
Profit Margin % = DIVIDE([Total Net Profit], [Total Net Sales], 0)

// 4. Discount Rate %
Discount Rate % = DIVIDE(SUM(financials[Discounts]), SUM(financials[Gross Sales]), 0)

// 5. Year-over-Year Sales Growth
YoY Sales Growth % = 
VAR CurrentSales = [Total Net Sales]
VAR PriorSales = CALCULATE([Total Net Sales], SAMEPERIODLASTYEAR(financials[Date]))
RETURN
DIVIDE(CurrentSales - PriorSales, PriorSales, 0)
```

### **SQL Window Function Example (MoM Growth):**
```sql
WITH MonthlyData AS (
    SELECT 
        Year, "Month Number" AS Month_Num, "Month Name" AS Month_Name,
        ROUND(SUM("Sales"), 2) AS Monthly_Sales,
        ROUND(SUM("Profit"), 2) AS Monthly_Profit
    FROM financials
    GROUP BY Year, "Month Number", "Month Name"
)
SELECT 
    Year, Month_Name, Monthly_Sales,
    LAG(Monthly_Sales, 1) OVER (ORDER BY Year, Month_Num) AS Prev_Month_Sales,
    ROUND(((Monthly_Sales - LAG(Monthly_Sales, 1) OVER (ORDER BY Year, Month_Num)) / 
          LAG(Monthly_Sales, 1) OVER (ORDER BY Year, Month_Num)) * 100, 2) AS MoM_Sales_Growth_Pct
FROM MonthlyData;
```

---

## 🎯 6. Strategic Recommendations for Leadership

1. **Immediate Cap on Enterprise Discounts:** Limit Enterprise discounts to a maximum of 5%. Terminating High discounts eliminates **$614K in annual losses** and increases net profit by **+$1.2M**.
2. **Aggressively Scale Channel Partners:** Channel Partners deliver an unmatched **73.13% net margin**. Expanding this channel from 1.5% to 5.0% of total revenue represents a high-ROI growth initiative.
3. **Protect Government Accounts:** The Government sector generates **67.4% of total profit**. Introduce VIP account management and early renewal programs ahead of Q4 procurement cycles.
4. **Realign United States Pricing:** Adjust US discounting policies to match European benchmarks (France/Germany ~15.6%), capturing an estimated **+$900K in additional profit**.

---

## 📁 7. Repository Structure & Deliverables

```
├── README.md                                <- Complete Project Documentation & Visuals
├── Financial_Analytics_Dashboard.pbix       <- Power BI Desktop Report (Main Submission)
├── Financial_Analytics_PowerBi_Report.pbix  <- Multi-Page Power BI Edition
├── Executive_Stakeholder_Report.pdf         <- Formal PDF Presentation Report
├── Executive_Summary_Report.md              <- Markdown Executive Summary
├── PowerBI_Corporate_Theme.json             <- Custom Power BI Color & Layout Theme
├── PowerBI_Project_Guide.md                 <- Step-by-step Power BI & DAX Build Guide
├── dashboard.html                           <- Interactive Standalone Web Dashboard
├── Financial_Interactive_Excel_Dashboard.xlsx <- Excel Workbook with Dashboard & Data Tabs
├── Financial_Data_Cleaned.xlsx              <- Cleaned Dataset (Excel format)
├── Financial_Data_Cleaned.csv               <- Cleaned Dataset (CSV format)
├── financial_analysis_queries.sql           <- 9 Production SQL Business Queries
├── SQL_Analysis_Results.md                  <- Benchmark Output of all SQL Queries
├── Financial_Analysis_EDA.ipynb             <- Jupyter Notebook with EDA Workflow
├── eda_analysis.py                          <- Standalone Python Analysis Script
├── images/                                  <- Power BI Dashboard Screenshots
│   ├── powerbi_dashboard_overview.png
│   └── powerbi_detailed_report.png
└── charts/                                  <- High-Resolution Analytical Visuals (PNG)
    ├── sales_profit_by_country.png
    ├── sales_by_segment.png
    ├── monthly_trend_sales_profit.png
    ├── product_profitability_ranking.png
    └── discount_band_impact.png
```

---

## 🚀 8. Quick Start / How to Run

1. **Power BI Desktop:** Double-click [`Financial_Analytics_Dashboard.pbix`](Financial_Analytics_Dashboard.pbix) to explore the report with live slicers and filters.
2. **Web Browser:** Double-click [`dashboard.html`](dashboard.html) to interact with the dashboard immediately in Chrome, Edge, or Firefox.
3. **Python Environment:** Run `python eda_analysis.py` or open [`Financial_Analysis_EDA.ipynb`](Financial_Analysis_EDA.ipynb) to inspect the data pipeline.
4. **SQL Queries:** Run the queries in [`financial_analysis_queries.sql`](financial_analysis_queries.sql) against [`financial_analytics.db`](financial_analytics.db).

---

## 🎓 Capstone Verification & Author
- **Course:** Data Analyst Course — Capstone Project Case Study
- **Tools:** Power BI, Python (Pandas/Matplotlib), SQL, Excel
- **Dataset:** Microsoft Financial Sample Dataset (700 records | 2013-2014)
- **Approved for Submission:** Axcentra Admin Team Verification
