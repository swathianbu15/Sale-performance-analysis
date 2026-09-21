"""
=============================================================================
FINANCIAL DATA ANALYTICS CAPSTONE PROJECT: PYTHON EDA & STATISTICAL ANALYSIS
=============================================================================
Author: Data Analyst
Description: End-to-end Python exploratory data analysis script.
Cleans raw data, computes summary statistics, generates distributions,
evaluates correlations, and exports analytics tables.
"""

import pandas as pd
import numpy as np
import sqlite3

def run_eda():
    print("=" * 70)
    print("FINANCIAL DATASET: EXPLORATORY DATA ANALYSIS (EDA)")
    print("=" * 70)

    # 1. Load Data
    df = pd.read_excel('sheet.xlsx')
    print(f"\n[1] Raw Dataset Shape: {df.shape[0]} rows x {df.shape[1]} columns")

    # 2. Data Cleaning
    df.columns = [c.strip() for c in df.columns]
    missing_discounts = df['Discount Band'].isna().sum()
    df['Discount Band'] = df['Discount Band'].fillna('None')
    print(f"[2] Cleaning: Imputed {missing_discounts} missing 'Discount Band' values with 'None'.")
    print(f"    Cleaned column headers: {list(df.columns)}")

    # Data Types & Conversions
    num_cols = ['Units Sold', 'Manufacturing Price', 'Sale Price', 'Gross Sales', 'Discounts', 'Sales', 'COGS', 'Profit']
    for col in num_cols:
        df[col] = pd.to_numeric(df[col], errors='coerce')

    df['Date'] = pd.to_datetime(df['Date'])
    df['Year'] = df['Date'].dt.year
    df['Month Number'] = df['Date'].dt.month
    df['Month Name'] = df['Date'].dt.strftime('%B')
    df['Quarter'] = df['Date'].dt.to_period('Q').astype(str)
    df['Profit Margin %'] = (df['Profit'] / df['Sales']) * 100

    # 3. Overall Executive KPIs
    total_gross = df['Gross Sales'].sum()
    total_disc = df['Discounts'].sum()
    total_sales = df['Sales'].sum()
    total_cogs = df['COGS'].sum()
    total_profit = df['Profit'].sum()
    total_units = df['Units Sold'].sum()
    margin_pct = (total_profit / total_sales) * 100
    disc_rate = (total_disc / total_gross) * 100

    print("\n" + "=" * 50)
    print("EXECUTIVE KPI SUMMARY")
    print("=" * 50)
    print(f"Total Gross Sales:    ${total_gross:>14,.2f}")
    print(f"Total Discounts:      ${total_disc:>14,.2f}  ({disc_rate:.2f}% discount rate)")
    print(f"Total Net Revenue:    ${total_sales:>14,.2f}")
    print(f"Total COGS:           ${total_cogs:>14,.2f}")
    print(f"Total Net Profit:     ${total_profit:>14,.2f}")
    print(f"Overall Profit Margin:           {margin_pct:>9.2f}%")
    print(f"Total Units Sold:     {total_units:>15,.0f}")

    # 4. Segment Breakdown
    print("\n" + "=" * 50)
    print("SEGMENT PERFORMANCE BREAKDOWN")
    print("=" * 50)
    seg_df = df.groupby('Segment').agg({
        'Sales': 'sum',
        'Profit': 'sum',
        'Units Sold': 'sum'
    }).sort_values(by='Sales', ascending=False)
    seg_df['Profit Margin %'] = (seg_df['Profit'] / seg_df['Sales']) * 100
    seg_df['Revenue Share %'] = (seg_df['Sales'] / total_sales) * 100
    print(seg_df.map(lambda x: f"{x:,.2f}" if isinstance(x, (int, float)) else x))

    # 5. Country Breakdown
    print("\n" + "=" * 50)
    print("GEOGRAPHIC PERFORMANCE BREAKDOWN")
    print("=" * 50)
    country_df = df.groupby('Country').agg({
        'Sales': 'sum',
        'Profit': 'sum',
        'Units Sold': 'sum'
    }).sort_values(by='Profit', ascending=False)
    country_df['Profit Margin %'] = (country_df['Profit'] / country_df['Sales']) * 100
    print(country_df.map(lambda x: f"{x:,.2f}" if isinstance(x, (int, float)) else x))

    # 6. Discount Band Analysis
    print("\n" + "=" * 50)
    print("DISCOUNT BAND IMPACT ANALYSIS")
    print("=" * 50)
    disc_df = df.groupby('Discount Band').agg({
        'Sales': 'sum',
        'Profit': 'sum',
        'Discounts': 'sum'
    }).reindex(['None', 'Low', 'Medium', 'High'])
    disc_df['Profit Margin %'] = (disc_df['Profit'] / disc_df['Sales']) * 100
    print(disc_df.map(lambda x: f"{x:,.2f}" if isinstance(x, (int, float)) else x))

    # 7. Enterprise Segment Negative Profit Discovery
    enterprise_loss = df[df['Segment'] == 'Enterprise']
    print("\n" + "=" * 50)
    print("ENTERPRISE LOSS ROOT CAUSE ANALYSIS")
    print("=" * 50)
    ent_by_disc = enterprise_loss.groupby('Discount Band')[['Sales', 'Profit']].sum()
    ent_by_disc['Margin %'] = (ent_by_disc['Profit'] / ent_by_disc['Sales']) * 100
    print("Enterprise Performance by Discount Band:")
    print(ent_by_disc.map(lambda x: f"{x:,.2f}" if isinstance(x, (int, float)) else x))

    print("\n" + "=" * 70)
    print("EDA execution completed successfully!")
    print("=" * 70)

if __name__ == '__main__':
    run_eda()
