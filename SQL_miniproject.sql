-- ====================================
-- E-COMMERCE SALES ANALYSIS PROJECT
-- ====================================

DROP TABLE IF EXISTS products;

CREATE TABLE products (
    product_id VARCHAR(10) PRIMARY KEY,
    product_name VARCHAR(50),
    category VARCHAR(50)
);

INSERT INTO products (product_id, product_name, category)
VALUES
('P201', 'Laptop', 'Electronics'),
('P202', 'Mouse', 'Electronics'),
('P203', 'Chair', 'Furniture'),
('P204', 'Desk', 'Furniture'),
('P205', 'Monitor', 'Electronics'),
('P206', 'Keyboard', 'Electronics'),
('P207', 'Bookshelf', 'Furniture');

-- SELECT * FROM products;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    order_date VARCHAR(20),
    revenue REAL
);

DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id VARCHAR(10) PRIMARY KEY,
    customer_name VARCHAR(15),
    city VARCHAR(15)
);

INSERT INTO customers (customer_id, customer_name, city)
VALUES
('C101', 'Rahul', 'Mumbai'),
('C102', 'Priya', 'Delhi'),
('C103', 'Amit', 'Mumbai'),
('C104', 'Neha', 'Pune'),
('C105', 'Arjun', 'Delhi'),
('C106', 'Meera', 'Pune'),
('C107', 'Karan', 'Ahmedabad');

-- Select * from customers;

DROP TABLE IF EXISTS orders;

CREATE TABLE orders (
    order_id VARCHAR(10) PRIMARY KEY,
    customer_id VARCHAR(10),
    product_id VARCHAR(10),
    order_date VARCHAR(20),
    revenue REAL
);

INSERT INTO orders (order_id, customer_id, product_id, order_date, revenue)
VALUES
('O1001', 'C101', 'P201', '2026-01-01', 100000),
('O1002', 'C102', 'P202', '2026-01-02', 4000),
('O1003', 'C103', 'P203', '2026-01-03', 15000),
('O1004', 'C104', 'P201', '2026-01-04', 50000),
('O1005', 'C102', 'P203', '2026-01-05', 10000),
('O1006', 'C101', 'P202', '2026-01-06', 3200),
('O1007', 'C105', 'P203', '2026-01-07', 10000),
('O1008', 'C103', 'P205', '2026-01-08', 24000),
('O1009', 'C106', 'P204', '2026-01-09', 16000),
('O1010', 'C104', 'P203', '2026-01-10', 15000),
('O1011', 'C102', 'P201', '2026-01-11', 50000),
('O1012', 'C101', 'P205', '2026-01-12', 24000),
('O1013', 'C105', 'P206', '2026-01-13', 6000),
('O1014', 'C106', 'P206', '2026-01-14', 4500),
('O1015', 'C103', 'P201', '2026-01-15', 50000);

-- Select * from orders;

-- =====================================
-- SECTION 1: OVERALL SALES KPIs
-- =====================================
SELECT
COUNT(*) AS total_orders,
SUM(revenue) AS total_revenue,
AVG(revenue) AS avg_order_value,
MIN(revenue) AS smallest_order,
MAX(revenue) AS largest_order
FROM orders;

-- SECTION 2: CITY PERFORMANCE
Select
  c.city,
  SUM(o.revenue) as total_revenue,
  AVG(o.revenue) as avg_order_revenue,
  COUNT(*) AS order_count
FROM orders o
JOIN customers c
  ON o.customer_id=c.customer_id
GROUP BY c.city
ORDER BY SUM(o.revenue) DESC;

-- SECTION 3: CATEGORY PERFORMANCE
Select
  p.category,
  SUM(o.revenue) as total_revenue
from orders o
JOIN products p
  ON o.product_id=p.product_id
GROUP BY p.category
ORDER BY SUM(o.revenue) DESC;

-- Q4. Top 3 customers by revenue
Select TOP 3
  c.customer_id,
  c.customer_name,
  SUM(o.revenue) As total_revenue
From orders o
JOIN customers c
  ON o.customer_id=c.customer_id
GROUP BY c.customer_name,c.customer_id
ORDER BY SUM(o.revenue) DESC;

-- Q5. Customers who never ordered
SELECT
    c.customer_id,
    c.customer_name,
    c.city
FROM customers c
LEFT JOIN orders o
    ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Q6. Customers above average revenue
WITH total_spending AS(
  SELECT
    c.customer_id,
    c.customer_name,
    COALESCE(SUM(o.revenue),0) as total_revenue
  FROM orders o
  JOIN customers c
    ON o.customer_id=c.customer_id
  GROUP BY c.customer_id,c.customer_name
)
SELECT  
  customer_id,
  customer_name,
  total_revenue
FROM total_spending
WHERE total_revenue > (
  SELECT AVG(total_revenue)
  FROM total_spending
)
ORDER BY total_revenue DESC;

-- Q7. Rank products within each category
WITH product_totals AS(
  Select
    p.category,
    p.product_name,
    SUM(o.revenue) as product_revenue
  FROM products p
  LEFT JOIN orders o
    ON p.product_id=o.product_id
  GROUP BY p.category,p.product_name
)
Select
  category,
  product_name,
  ISNULL(product_revenue,0) as product_revenue,
  RANK() Over(
    Partition By category
    ORDER BY ISNULL(product_revenue,0) DESC
  ) AS product_rank
FROM product_totals
ORDER BY category,product_rank;

-- Q8. Find the highest-revenue customer in each city
WITH customer_revenue AS(
  Select
    c.city,
    c.customer_name,
    COALESCE(SUM(o.revenue),0) as total_revenue
  FROM customers c
  LEFT JOIN orders o
    ON c.customer_id=o.customer_id
  GROUP BY c.city,c.customer_name
),
ranked_customers AS(
  SELECT 
    city,
    customer_name,
    total_revenue,
    RANK() OVER(
      Partition By city
      ORDER BY total_revenue DESC
    ) as customer_rank
  FROM customer_revenue
)
SELECT
  city,
  customer_name,
  total_revenue,
  customer_rank
FROM ranked_customers
WHERE customer_rank=1
ORDER BY city;

-- Q9. Previous order revenue by customer
Select
  o.order_id,
  c.customer_name,
  o.order_date,
  o.revenue,
  LAG(o.revenue) OVER(
    Partition By o.customer_id
    ORDER BY o.order_date
  ) AS previous_order_revenue
From orders o
JOIN customers c
  ON o.customer_id=c.customer_id
ORDER BY c.customer_name,o.order_date

-- Q10. Electronics performance by city
Select
  c.city,
  SUM(o.revenue) as electronic_revenue,
  COUNT(o.order_id) as electronics_order_count,
  AVG(o.revenue) as Avg_revenue_ELec_order
FROM orders o
JOIN customers c
  ON o.customer_id=c.customer_id
JOIN products p
  ON o.product_id=p.product_id
WHERE p.category='Electronics'
GROUP BY c.city
HAVING SUM(o.revenue) > 20000
ORDER BY electronic_revenue DESC;

