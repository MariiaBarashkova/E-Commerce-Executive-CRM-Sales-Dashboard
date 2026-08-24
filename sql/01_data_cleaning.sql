-- ================================================================
-- 01. DATA CLEANING & EXECUTIVE OVERVIEW
-- База данных: SQLite / PostgreSQL / BigQuery
-- Описание: Первичный осмотр данных, очистка транзакций и витрина KPI
-- ================================================================

-- 1. Первичный осмотр данных / Quick data overview
SELECT 
    COUNT(*) AS total_rows,                          -- Всего транзакций
    COUNT(CustomerID) AS rows_with_customer,         -- С заполненным CustomerID
    COUNT(*) - COUNT(CustomerID) AS missing_customer, -- Сколько записей без клиента
    COUNT(DISTINCT CustomerID) AS unique_customers,   -- Уникальных покупателей
    COUNT(DISTINCT InvoiceNo) AS unique_orders,       -- Уникальных заказов
    ROUND(MIN(UnitPrice), 2) AS min_price,            -- Самая дешёвая позиция
    ROUND(MAX(UnitPrice), 2) AS max_price,            -- Самая дорогая позиция
    MIN(Quantity) AS min_qty,                         -- Минимальное кол-во
    MAX(Quantity) AS max_qty                          -- Максимальное кол-во
FROM data;

-- 2. Создание "чистой" витрины продаж (cleaned_sales)
CREATE VIEW IF NOT EXISTS cleaned_sales AS
SELECT 
    InvoiceNo,
    StockCode,
    Description,
    Quantity,
    InvoiceDate,
    UnitPrice,
    CustomerID,
    Country,
    (Quantity * UnitPrice) AS Revenue          -- Выручка по строке заказа
FROM data
WHERE Quantity > 0                            -- Только продажи, без возвратов
  AND UnitPrice > 0                           -- Положительная цена
  AND CustomerID IS NOT NULL;                 -- Только авторизованные клиенты

-- 3. Создание витрины Executive Overview (динамика выручки и AOV)
CREATE VIEW IF NOT EXISTS vw_bi_executive_overview AS
SELECT 
    substr(InvoiceDate, 1, 7) AS revenue_month,
    ROUND(SUM(Revenue), 2) AS monthly_revenue,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    COUNT(DISTINCT CustomerID) AS unique_customers,
    ROUND(SUM(Revenue) / COUNT(DISTINCT InvoiceNo), 2) AS avg_order_value
FROM cleaned_sales
GROUP BY revenue_month;

-- 4. Выгрузка метрик выручки и помесячного роста (% MoM)
WITH monthly_metrics AS (
    SELECT 
        revenue_month,
        monthly_revenue,
        total_orders,
        avg_order_value
    FROM vw_bi_executive_overview
)
SELECT 
    revenue_month,
    monthly_revenue,
    total_orders,
    avg_order_value AS aov,
    ROUND(100.0 * (monthly_revenue - LAG(monthly_revenue) OVER (ORDER BY revenue_month)) / 
          LAG(monthly_revenue) OVER (ORDER BY revenue_month), 1) AS mom_growth_percent
FROM monthly_metrics
ORDER BY revenue_month;
