-- ================================================================
-- 03. CUMULATIVE COHORT LTV ANALYSIS
-- База данных: SQLite / PostgreSQL / BigQuery
-- Описание: Расчет накопленной ценности клиента (Cumulative LTV) от M0 до M6
-- ================================================================

WITH user_cohorts AS (
    SELECT 
        CustomerID,
        substr(InvoiceDate, 1, 7) AS activity_month,
        MIN(substr(InvoiceDate, 1, 7)) OVER (PARTITION BY CustomerID) AS cohort_month,
        Revenue
    FROM cleaned_sales
),
cohort_revenue AS (
    SELECT 
        cohort_month,
        ((CAST(substr(activity_month, 1, 4) AS INT) - CAST(substr(cohort_month, 1, 4) AS INT)) * 12 + 
         (CAST(substr(activity_month, 6, 2) AS INT) - CAST(substr(cohort_month, 6, 2) AS INT))) AS month_number,
        SUM(Revenue) AS month_revenue
    FROM user_cohorts
    GROUP BY cohort_month, month_number
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
    ROUND(SUM(CASE WHEN cr.month_number <= 0 THEN cr.month_revenue ELSE 0 END) / cs.cohort_size, 2) AS "LTV_by_month_0",
    ROUND(SUM(CASE WHEN cr.month_number <= 1 THEN cr.month_revenue ELSE 0 END) / cs.cohort_size, 2) AS "LTV_by_month_1",
    ROUND(SUM(CASE WHEN cr.month_number <= 2 THEN cr.month_revenue ELSE 0 END) / cs.cohort_size, 2) AS "LTV_by_month_2",
    ROUND(SUM(CASE WHEN cr.month_number <= 3 THEN cr.month_revenue ELSE 0 END) / cs.cohort_size, 2) AS "LTV_by_month_3",
    ROUND(SUM(CASE WHEN cr.month_number <= 6 THEN cr.month_revenue ELSE 0 END) / cs.cohort_size, 2) AS "LTV_by_month_6"
FROM cohort_sizes cs
LEFT JOIN cohort_revenue cr ON cs.cohort_month = cr.cohort_month
GROUP BY cs.cohort_month, cs.cohort_size
ORDER BY cs.cohort_month;
