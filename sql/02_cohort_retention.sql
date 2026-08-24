-- ================================================================
-- 02. COHORT RETENTION & REPEAT PURCHASES
-- База данных: SQLite / PostgreSQL / BigQuery
-- Описание: Матрица удержания клиентов, интервалы между заказами и популярные товары
-- ================================================================

-- 1. Когортный анализ удержания (Cohort Retention Analysis Matrix)
WITH user_cohorts AS (
    SELECT 
        CustomerID,
        substr(InvoiceDate, 1, 7) AS activity_month,
        MIN(substr(InvoiceDate, 1, 7)) OVER (PARTITION BY CustomerID) AS cohort_month
    FROM cleaned_sales
),
cohort_index_calc AS (
    SELECT DISTINCT
        CustomerID,
        cohort_month,
        activity_month,
        ((CAST(substr(activity_month, 1, 4) AS INT) - CAST(substr(cohort_month, 1, 4) AS INT)) * 12 + 
         (CAST(substr(activity_month, 6, 2) AS INT) - CAST(substr(cohort_month, 6, 2) AS INT))) AS month_number
    FROM user_cohorts
),
cohort_sizes AS (
    SELECT 
        cohort_month,
        COUNT(DISTINCT CustomerID) AS cohort_size
    FROM user_cohorts
    GROUP BY cohort_month
)
SELECT 
    cs.cohort_month,
    cs.cohort_size,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cic.month_number = 0 THEN cic.CustomerID END) / cs.cohort_size, 1) AS "Month_0_%",
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cic.month_number = 1 THEN cic.CustomerID END) / cs.cohort_size, 1) AS "Month_1_%",
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cic.month_number = 2 THEN cic.CustomerID END) / cs.cohort_size, 1) AS "Month_2_%",
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cic.month_number = 3 THEN cic.CustomerID END) / cs.cohort_size, 1) AS "Month_3_%",
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cic.month_number = 4 THEN cic.CustomerID END) / cs.cohort_size, 1) AS "Month_4_%",
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN cic.month_number = 5 THEN cic.CustomerID END) / cs.cohort_size, 1) AS "Month_5_%"
FROM cohort_sizes cs
LEFT JOIN cohort_index_calc cic ON cs.cohort_month = cic.cohort_month
GROUP BY cs.cohort_month, cs.cohort_size
ORDER BY cs.cohort_month;

-- 2. Средний интервал времени между повторными покупками
WITH distinct_orders AS (
    SELECT DISTINCT
        CustomerID,
        InvoiceNo,
        DATE(InvoiceDate) AS order_date
    FROM cleaned_sales
),
orders_with_lag AS (
    SELECT 
        CustomerID,
        InvoiceNo,
        order_date,
        ROW_NUMBER() OVER (PARTITION BY CustomerID ORDER BY order_date, InvoiceNo) AS order_num,
        LAG(order_date) OVER (PARTITION BY CustomerID ORDER BY order_date, InvoiceNo) AS prev_order_date
    FROM distinct_orders
),
time_diffs AS (
    SELECT 
        CustomerID,
        order_num,
        CAST(julianday(order_date) - julianday(prev_order_date) AS INT) AS days_since_last
    FROM orders_with_lag
    WHERE prev_order_date IS NOT NULL
)
SELECT 
    order_num AS order_number,
    COUNT(*) AS reorder_events,
    ROUND(AVG(days_since_last), 1) AS avg_days_to_next_order
FROM time_diffs
WHERE order_num <= 5
GROUP BY order_num
ORDER BY order_num;

-- 3. Топ-3 популярных товара в каждой когорте
WITH user_first_cohort AS (
    SELECT DISTINCT
        CustomerID,
        MIN(substr(InvoiceDate, 1, 7)) OVER (PARTITION BY CustomerID) AS cohort_month
    FROM cleaned_sales
),
cohort_products AS (
    SELECT 
        fc.cohort_month,
        s.Description,
        SUM(s.Quantity) AS total_qty,
        ROUND(SUM(s.Revenue), 2) AS total_revenue
    FROM cleaned_sales s
    JOIN user_first_cohort fc ON s.CustomerID = fc.CustomerID
    WHERE s.Description IS NOT NULL AND s.Description != ''
    GROUP BY fc.cohort_month, s.Description
),
ranked_products AS (
    SELECT 
        cohort_month,
        Description,
        total_qty,
        total_revenue,
        ROW_NUMBER() OVER (PARTITION BY cohort_month ORDER BY total_qty DESC) AS rank_in_cohort
    FROM cohort_products
)
SELECT 
    cohort_month,
    rank_in_cohort AS product_rank,
    Description AS product_name,
    total_qty AS quantity_sold,
    total_revenue
FROM ranked_products
WHERE rank_in_cohort <= 3
ORDER BY cohort_month, product_rank;
