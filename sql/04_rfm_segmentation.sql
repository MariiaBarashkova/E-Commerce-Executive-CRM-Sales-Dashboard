-- ================================================================
-- 04. RFM CUSTOMER SEGMENTATION
-- База данных: SQLite / PostgreSQL / BigQuery
-- Описание: Расчет Recency, Frequency, Monetary и ранжирование через NTILE(4)
-- ================================================================

WITH max_db_date AS (
    SELECT MAX(DATE(InvoiceDate)) AS last_date FROM cleaned_sales
),
customer_rfm AS (
    SELECT 
        s.CustomerID,
        CAST(julianday(m.last_date) - julianday(MAX(DATE(s.InvoiceDate))) AS INT) AS recency_days,
        COUNT(DISTINCT s.InvoiceNo) AS frequency_orders,
        ROUND(SUM(s.Revenue), 2) AS total_spent
    FROM cleaned_sales s
    CROSS JOIN max_db_date m
    GROUP BY s.CustomerID
),
rfm_scores AS (
    SELECT 
        CustomerID,
        recency_days,
        frequency_orders,
        total_spent,
        NTILE(4) OVER (ORDER BY recency_days DESC) AS r_score,   -- 4 = давность минимальная (недавно)
        NTILE(4) OVER (ORDER BY frequency_orders ASC) AS f_score, -- 4 = частота максимальная
        NTILE(4) OVER (ORDER BY total_spent ASC) AS m_score       -- 4 = сумма максимальная
    FROM customer_rfm
)
SELECT 
    CASE 
        WHEN r_score = 4 AND f_score >= 3 AND m_score >= 3 THEN '1. VIP / Топ-клиенты'
        WHEN r_score >= 3 AND f_score >= 2 THEN '2. Лояльные / Перспективные'
        WHEN r_score <= 2 AND f_score >= 3 THEN '3. Под риском ухода (были активны)'
        ELSE '4. Спящие / Потерянные'
    END AS customer_segment,
    COUNT(*) AS customers_count,
    ROUND(AVG(recency_days), 1) AS avg_recency_days,
    ROUND(AVG(frequency_orders), 1) AS avg_orders_per_customer,
    ROUND(AVG(total_spent), 2) AS avg_revenue_per_customer
FROM rfm_scores
GROUP BY customer_segment
ORDER BY customer_segment;
