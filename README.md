# ecommerce-sales-analysis-sql
# E-commerce Sales Analysis Using SQL

## Project Overview
This project analyses e-commerce sales data using SQL to understand revenue performance, customer behaviour, product performance and city-level sales.

The analysis uses three relational tables: `customers`, `products` and `orders`. SQL joins, aggregations, subqueries, Common Table Expressions (CTEs) and window functions are used to answer practical business questions.

**Note:** This is a learning project using a small sample dataset, not real company data.

## Business Objectives
- Calculate key sales performance metrics.
- Identify the highest-revenue cities and customers.
- Compare revenue across product categories.
- Rank products within each category.
- Identify customers who have never placed an order.
- Compare customer spending against the average.
- Analyse previous order revenue using window functions.
- Evaluate Electronics performance across cities.

## Tools and SQL Concepts
- SQL Server / T-SQL
- INNER JOIN and LEFT JOIN
- GROUP BY, HAVING and aggregate functions
- CASE expressions and subqueries
- Common Table Expressions (CTEs)
- Window functions: RANK(), LAG()
- NULL handling with ISNULL() and COALESCE()

## Database Structure
- **customers:** Customer ID, customer name and city.
- **products:** Product ID, product name and category.
- **orders:** Order ID, customer ID, product ID, order date and revenue.

The customer and product tables connect to the orders table through their respective IDs.

## Key Results

- **Total revenue:** ₹381,700
- **Total orders:** 15
- **Average order value:** ₹25,446.67
- **Top city by revenue:** Mumbai — ₹216,200
- **Top product by revenue:** Laptop — ₹250,000
- **Leading category:** Electronics — ₹315,700
- **Product with no recorded sales:** Bookshelf
- **Customer with no recorded orders:** Karan

## Business Recommendations

1. Investigate ways to improve Furniture sales through product visibility, promotions and pricing analysis.
2. Investigate why Bookshelf recorded no revenue and verify its availability and sales data.
3. Study Mumbai's strong sales performance to identify practices that might work in other cities.
4. Monitor dependence on Laptop revenue and explore opportunities to grow other products.

## Project Limitations
The dataset contains only 15 orders and seven customers. The findings demonstrate SQL analysis techniques but should not be generalised to a real business without a larger, representative dataset.

## Learning Outcomes
This project demonstrates the application of SQL to business analysis, including data aggregation, relational joins, customer analysis, product ranking, customer segmentation and window functions.
