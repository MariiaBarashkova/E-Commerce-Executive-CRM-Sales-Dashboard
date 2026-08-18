# 🚀 Сквозная BI-система продаж и удержания клиентов для E-Commerce

---

<a name="english"></a>
## 🇬🇧 English Version

### 📌 Project Overview

This project presents the development of an end-to-end BI system for an online retailer, built on top of a cleaned SQL data warehouse. The solution transforms raw transactional data into actionable business insights for executive reporting, CRM retention strategies, and inventory planning.

---

### 🎯 Business Context & Problem Statement

The management and marketing teams of an e-commerce retailer face a **lack of a single source of truth** for sales data. Reports are manually compiled from spreadsheets, leading to:

| Problem | Business Impact |
|---------|-----------------|
| C-Level has no real-time visibility into revenue trends & AOV | Delayed strategic decisions |
| CRM team cannot identify customer churn patterns | **75% of customers lost after first transaction** |
| Procurement misses inventory planning for peak season (Q4) | Stockouts & lost revenue |

---

### 🎯 Project Goals

| Goal | Target |
|------|--------|
| Build an interactive BI dashboard on top of cleaned SQL data | Reduce report preparation time: **4 hours → 0 minutes (auto-refresh)** |
| Identify retention opportunities via cohort analysis | Increase M1 Retention: **15% → 20%** |
| Segment customer base using RFM for targeted CRM campaigns | Launch personalized marketing campaigns |

---

### 📐 Project Scope

#### ✅ In Scope 

- Data cleaning & aggregation of **500k+ transactions** (2010–2011)
- Creation of **3 BI dashboard pages**:
  - 📊 **Overview:** Revenue, AOV, MoM growth
  - 👥 **Cohorts / LTV:** Retention matrix & cumulative LTV
  - 🎯 **RFM Segmentation:** Customer segments for CRM
- End-to-end Business Requirements Document (BRD)
- BPMN process flow diagram

#### ❌ Out of Scope 

- Live API integration with 3rd-party CRM systems
- Machine Learning models for churn prediction
- Row-Level Security (RLS) for multi-user access

---

### 🛠️ Tech Stack

| Layer | Technology |
|-------|------------|
| Data Warehouse | SQLite / Google BigQuery |
| Data Processing | SQL (CTE, Window Functions, PIVOT) |
| BI Visualization | Tableau / Power BI / Looker Studio |
| Version Control | Git / GitHub |
| Documentation | Markdown, BPMN |

---

### 📊 Key Results & Business Impact

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Report preparation time | 4 hours (manual) | 0 minutes (auto) | **-100%** |
| M1 Retention Rate | 15% | Target: 20% | **+5 p.p.** |
| Customer segmentation | None | 4 RFM segments | **CRM-ready** |
| Peak season inventory | Reactive | Proactive (Q4) | **Reduced stockouts** |

---

**📄 Project Documentation**

The complete project documentation package is available below:

| Document | Description |
|----------|-------------|
| **[📘 Business Requirements Document (BRD.md)](./BRD.md)** | Complete Business Requirements Document: goals, stakeholders, scope, success metrics, and RACI matrix. |

---


<a name="русский"></a>
## 🇷🇺 Русская версия

### 📌 Описание проекта

Проект представляет собой разработку сквозной BI-системы для интернет-магазина на базе очищенного SQL-хранилища данных. Решение превращает сырые транзакционные данные в структурированные бизнес-инсайты для руководства, отдела маркетинга и закупок.

---

### 🎯 Текущая ситуация и проблема

Руководство и отдел маркетинга онлайн-ритейлера сталкиваются с **отсутствием единой точки правды** по продажам. Отчеты собираются вручную из таблиц, из-за чего:

| Проблема | Влияние на бизнес |
|----------|-------------------|
| C-Level не видит оперативную динамику выручки и AOV | Задержка стратегических решений |
| Отдел CRM не знает, когда клиенты уходят в отток | **Потеря 75% покупателей после первой транзакции** |
| Закупки не успевают подготовить складской запас | Дефицит товаров в пиковый сезон (Q4) |

---

### 🎯 Цели проекта

| Цель | Целевой показатель |
|------|-------------------|
| Создать интерактивный BI-дашборд на основе очищенных SQL-данных | Сокращение времени подготовки отчетов: **4 часа → 0 минут (автообновление)** |
| Выявить точки удержания через когортный анализ | Повышение M1 Retention: **15% → 20%** |
| Сегментировать базу по RFM для точечных CRM-рассылок | Запуск персонализированных кампаний |

---

### 📐 Границы проекта

#### ✅ Входит в проект (In Scope)

- Очистка и агрегация **500k+ транзакций** за 2010–2011 гг.
- Создание **3 страниц BI-дашборда**:
  - 📊 **Обзор:** Выручка, AOV, MoM рост
  - 👥 **Когорты / LTV:** Матрица удержания и накопленный LTV
  - 🎯 **RFM-сегментация:** Готовые сегменты для CRM
- Сквозной бизнес-документ требований (BRD)
- BPMN-схема бизнес-процессов

#### ❌ Не входит в проект (Out of Scope)

- Интеграция с живыми API сторонних CRM-систем
- Построение ML-моделей прогнозирования оттока
- Настройка сложных прав доступа (RLS) на уровне пользователей

---

### 🛠️ Технологический стек

| Уровень | Технологии |
|---------|------------|
| Хранилище данных | SQLite / Google BigQuery |
| Обработка данных | SQL (CTE, оконные функции, PIVOT) |
| Визуализация | Tableau / Power BI / Looker Studio |
| Контроль версий | Git / GitHub |
| Документация | Markdown, BPMN |

---

### 📊 Ключевые результаты и бизнес-эффект

| Метрика | До проекта | После проекта | Улучшение |
|---------|------------|---------------|-----------|
| Время подготовки отчетов | 4 часа (вручную) | 0 минут (авто) | **-100%** |
| M1 Retention Rate | 15% | Целевой: 20% | **+5 п.п.** |
| Сегментация клиентов | Отсутствует | 4 RFM-сегмента | **Готово для CRM** |
| Управление запасами | Реактивное | Проактивное (Q4) | **Снижение дефицита** |

---

**📄 Документация проекта**

Полный пакет проектной документации доступен по ссылке ниже:

| Документ | Описание |
|----------|----------|
| **[📘 Business Requirements Document (BRD.md)](./BRD.md)** | Полный документ бизнес-требований: цели, стейкхолдеры, scope, метрики успеха и RACI-матрица. |
