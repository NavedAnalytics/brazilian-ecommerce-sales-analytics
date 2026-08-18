# Brazilian E-Commerce Sales & Customer Analytics

![Power BI](https://img.shields.io/badge/Power%20BI-Dashboard-F2C811?style=for-the-badge&logo=powerbi&logoColor=black)
![Python](https://img.shields.io/badge/Python-EDA%20%26%20Visualization-3776AB?style=for-the-badge&logo=python&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-Analytics-4479A1?style=for-the-badge&logo=postgresql&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-Data%20Analysis-150458?style=for-the-badge&logo=pandas&logoColor=white)

## Project Overview

This project delivers an end-to-end analysis of Brazilian e-commerce sales and customer behavior using the Olist e-commerce dataset.

The objective was to transform raw transactional data into actionable business insights across **sales performance, customer behavior, product performance, reviews, delivery operations, and logistics**.

The project combines **Python, SQL, Power BI, and data visualization** to demonstrate a complete data analytics workflow — from data cleaning and exploratory analysis to business-focused dashboard development.

---

## Business Objectives

The analysis focuses on answering key business questions:

- How is revenue and order volume performing over time?
- Which states and product categories generate the most revenue?
- What is the average order value and order frequency per customer?
- Which customers are repeat or high-value buyers?
- How does delivery performance vary by state and month?
- What percentage of orders are delivered late?
- How does delivery time affect customer review scores?
- Which product categories contribute most to overall revenue?
- What factors are associated with higher or lower customer satisfaction?

---

## Dataset

The project uses the **Brazilian Olist E-Commerce dataset**, which contains information related to:

- Orders
- Customers
- Products
- Sellers
- Payments
- Reviews
- Order items
- Product categories
- Customer locations
- Delivery information

### Analysis Period

**2016–2018**

### Key Tables / Data Sources

| Table | Purpose |
|---|---|
| `orders` | Order status, purchase and delivery information |
| `customers` | Customer and geographic information |
| `order_items` | Product-level order transactions |
| `order_payments` | Payment information |
| `order_reviews` | Customer review scores |
| `products` | Product attributes and categories |
| `sellers` | Seller information |
| `product_category_name_translation` | Product category translation |

For analysis and dashboard development, the relevant datasets were cleaned and combined into an analytical dataset.

---

# Project Workflow

```text
Raw Data
   ↓
Data Cleaning
   ↓
Data Integration / Merging
   ↓
Exploratory Data Analysis
   ↓
Feature Engineering
   ↓
SQL Analysis
   ↓
DAX Measures
   ↓
Power BI Dashboard
   ↓
Business Insights
```

---

## Data Preparation

The data preparation process included:

- Handling missing values
- Removing or filtering invalid records where appropriate
- Standardizing column names and formats
- Converting date fields into usable date/month dimensions
- Creating delivery-time features
- Creating late-delivery indicators
- Translating product category names
- Aggregating item-level records to the appropriate **order level**
- Validating duplicated order-level attributes
- Preparing analytical tables for Power BI and SQL analysis

A major consideration in this project was that **one `order_id` can appear across multiple rows** because an order can contain multiple items. Therefore, order-level metrics were calculated carefully to avoid double counting.

---

# Key KPIs

The dashboard tracks business-focused KPIs such as:

- **Total Revenue**
- **total_orders**
- **Average Order Value**
- **Orders per Customer**
- **Average Delivery Days**
- **Average Review Score**
- **Average Freight Cost per Order**
- **Total Late Deliveries**
- **Total Orders Deliveries**
- **Late_Delivery**
- **Late Delivery %**
- **avg_freight_CostbyCategory**
- **avg_order_customer_state_freight**
- **sum_of_revenue_per_order**
- **sum_of_freight_per_order**
- **Total Customers**
- **Total Orders Deliveries**
- **Zero**



Example dashboard snapshot:

| KPI | Value |
|---|---:|
| Total Revenue | R$15.42M |
| Total Orders | ~99K |
| Average Order Value | R$159.83 |
| Average Delivery Days | 12.09 days |
| Average Review Score | 4.0 |
| Orders per Customer | 1.03 |
| Late Delivery % | 9.03% |
| Average Freight Cost / Order | R$22.79 |

> KPI values can change depending on filters, aggregation logic, or the final cleaned dataset.

---

# Power BI Dashboard

The project contains a **4-page interactive Power BI dashboard**.

## 1. Executive Overview

Provides a high-level view of overall business performance.

### Main areas
- Revenue performance
- Order volume
- Average order value
- Customer satisfaction
- Monthly revenue trend
- Monthly orders trend
- Revenue by state
- Payment behavior
- Product category performance

---

## 2. Customer Analytics

Focuses on customer segmentation, purchasing behavior, and customer satisfaction.

### Key visuals
- Order distribution by state
- Orders by time of day
- Review score distribution
- Review score vs. delivery duration
- Customer purchasing behavior
- Orders per customer

### Business questions
- Which regions generate the highest order volume?
- When do customers place the most orders?
- How satisfied are customers?
- Does longer delivery time relate to lower review scores?
-
---

## 3. Product Analytics

Focuses on product and category performance.

### Key visuals
- Revenue by product category
- Order distribution by product category
- Revenue breakdown hierarchy
- Order freight vs. order revenue
- Pareto analysis of category revenue
- Product/category contribution to total revenue

### Business questions
- Which categories generate the most revenue?
- Is revenue concentrated among a small number of categories?
- Which categories have strong order volume?
- How does freight cost relate to order revenue?

---

## 4. Logistics & Delivery Analytics

Focuses on operational efficiency and customer delivery experience.

### Key visuals
- Average delivery time by state
- On-time vs. late delivery
- Average freight cost by state
- Average delivery time trend by month

### Business questions
- Which states experience the longest delivery times?
- Where are freight costs highest?
- What percentage of delivered orders are late?
- How does delivery performance change throughout the year?

---

# SQL Analysis

SQL was used to answer business questions and validate dashboard metrics.

Examples include:

### Total Orders

```sql
SELECT
    COUNT(DISTINCT order_id) AS total_orders
FROM olist_ecommerce_clean;
``` 

### Average Order Value

```sql
SELECT
    AVG(order_value) AS avg_order_value
FROM (
    SELECT
        order_id,
        SUM(total_price) AS order_value
    FROM olist_ecommerce_clean
    WHERE order_status = 'delivered'
    GROUP BY order_id
) AS t;
```

### Orders per Customer

```sql
SELECT
    COUNT(DISTINCT order_id) * 1.0 /
    COUNT(DISTINCT customer_unique_id) AS orders_per_customer
FROM olist_ecommerce_clean;
```

### Average Review Score

```sql
SELECT
    AVG(max_review_score) AS avg_review_score
FROM (
    SELECT
        order_id,
        MAX(review_score) AS max_review_score
    FROM olist_ecommerce_clean
    WHERE order_status = 'delivered'
      AND review_score IS NOT NULL
    GROUP BY order_id
) AS t;
```

### Late Delivery %

```sql
SELECT
    SUM(total_late_deliveries) * 100.0 /
    COUNT(order_id) AS late_delivery_percent
FROM (
    SELECT
        order_id,
        MAX(Late_Delivery) AS total_late_deliveries
    FROM olist_ecommerce_clean
    WHERE order_status = 'delivered'
    GROUP BY order_id
) AS t;
```

### Top 5 Product Categories by Revenue in Each State

```sql
SELECT
    customer_state,
    product_category_name_english,
    total_revenue,
    rn
FROM (
    SELECT
        customer_state,
        product_category_name_english,
        SUM(total_price) AS total_revenue,
        RANK() OVER (
            PARTITION BY customer_state
            ORDER BY SUM(total_price) DESC
        ) AS rn
    FROM olist_ecommerce_clean
    WHERE order_status = 'delivered'
    GROUP BY
        customer_state,
        product_category_name_english
) AS t
WHERE rn <= 5
ORDER BY
    customer_state,
    rn;
```

---Etc.,

# Power BI / DAX

DAX was used to create dynamic measures and KPI calculations.

Examples include:

### Average Delivery Days

```DAX
Avg Delivery Days = AVERAGEX(summarize(filter('olist_ecommerce_clean','olist_ecommerce_clean'[order_status]=="delivered" && not(ISBLANK('olist_ecommerce_clean'[Delivery_Days]))),'olist_ecommerce_clean'[order_id],'olist_ecommerce_clean'[Purchase_Month],"Delivery_Days",MAX('olist_ecommerce_clean'[Delivery_Days])),[Delivery_Days])
```

### Average Review Score

```DAX
Avg Review Score = AVERAGEX(SUMMARIZE(FILTER('olist_ecommerce_clean','olist_ecommerce_clean'[order_status]="delivered" && not(isblank('olist_ecommerce_clean'[review_score]))),'olist_ecommerce_clean'[order_id] ,"Review Score",MAX('olist_ecommerce_clean'[review_score])),[Review Score])    
```

### Orders per Customer

```DAX
Orders Per Customer =
DIVIDE(
    DISTINCTCOUNT('olist_ecommerce_clean'[order_id]),
    DISTINCTCOUNT('olist_ecommerce_clean'[customer_unique_id])
)
```



---etc.

# Python Analysis

Python was used for:

- Data cleaning
- Exploratory Data Analysis
- Aggregation and validation
- Feature engineering
- Statistical analysis
- Custom visualizations
- Dashboard-ready chart generation

### Libraries Used

```text
Python
Pandas
NumPy
Matplotlib
```

Example visualization topics:

- Monthly revenue trend
- Revenue by state
- Product category revenue
- Pareto analysis
- Delivery-time analysis
- Freight-cost analysis
- Review score analysis

---




## 📊 Key Business Insights

### 1. Overall Business Performance

* The platform generated approximately **R$15.42M in total revenue** from around **99K orders**.
* The **Average Order Value (AOV)** was approximately **R$159.83**, indicating a moderate average customer spend per order.
* The overall **average review score was around 4.0/5**, showing generally positive customer satisfaction.

### 2. Revenue & Sales Trends

* Revenue showed noticeable month-to-month fluctuations, with **stronger performance during the middle of the year** and a significant decline toward the end of the observed period.
* Order volume followed a similar seasonal pattern, indicating that sales activity was not evenly distributed throughout the year.
* The business should investigate the causes of high-performing months and replicate successful promotional or seasonal strategies.

### 3. Geographic Performance

* **São Paulo (SP)** was the strongest-performing state, generating approximately **R$5.92M in revenue** and more than **41K orders**.
* **Rio de Janeiro (RJ)** and **Minas Gerais (MG)** were the next major contributors, with approximately **R$2.13M** and **R$1.86M** in revenue respectively.
* Revenue and order volume are highly concentrated in a small number of states, suggesting that these regions are the platform's primary markets.

### 4. Customer Purchasing Behavior

* Customers placed approximately **1.03 orders per customer**, indicating that most customers made only a small number of purchases during the period.
* **Afternoon orders were the highest**, with roughly **32K orders**, followed by evening, morning, and night.
* This suggests that marketing campaigns, promotions, and customer engagement activities could be prioritized during high-traffic periods.

### 5. Product Performance

* Product revenue is concentrated among several major categories, with categories such as **health & beauty, watches & gifts, bed & bath, sports & leisure, and computers/accessories** among the important contributors.
* The product-category analysis shows that a relatively small group of categories contributes a substantial portion of overall revenue.
* This indicates an opportunity to focus inventory planning, promotions, and cross-selling strategies on high-performing categories.

### 6. Customer Satisfaction

* The majority of orders received **high review scores**, with approximately **57K orders receiving a 5-star rating**.
* However, lower review scores are still present, creating an opportunity to investigate the reasons behind dissatisfied customers.
* Delivery experience appears to be an important area to investigate because longer delivery times can negatively affect customer satisfaction.

### 7. Logistics & Delivery Performance

* The overall **average delivery time was approximately 12.09 days**.
* The **late delivery rate was 9.03%**, meaning roughly 9 out of every 100 orders experienced late delivery.
* Delivery performance varies significantly by state. **Roraima (RR)** had the highest average delivery time at approximately **29 days**, followed by **Amapá (AP)** and **Amazonas (AM)**.
* These regions may require logistics optimization, better seller coverage, or improved transportation planning.

### 8. Freight Cost

* Average freight cost also varies considerably across states.
* **Pernambuco (PE)** had the highest average freight cost at approximately **R$35.8**, followed by **Bahia (BA)** at around **R$30.0**.
* High freight-cost regions should be analyzed to identify opportunities for better shipping partnerships, regional fulfillment, or optimized delivery routes.

### 9. Key Business Recommendations

Based on the analysis, the following actions could improve business performance:

* Focus marketing and customer acquisition efforts on **high-performing states such as SP, RJ, and MG**.
* Investigate strategies to increase **repeat purchases and customer retention**, given the low order-per-customer ratio.
* Optimize logistics in states with **very high delivery times**.
* Investigate the causes of **late deliveries and low review scores**.
* Optimize shipping strategies in regions with **high freight costs**.
* Prioritize inventory and promotions for **high-revenue product categories**.
* Use high-order periods, particularly the **afternoon**, for targeted campaigns and promotional activities.

# Tools & Technologies

| Category | Tools |
|---|---|
| Programming | Python |
| Data Analysis | Pandas, NumPy |
| Visualization | Matplotlib, Power BI |
| Database / Querying | SQL |
| BI / Dashboarding | Power BI |
| Data Modeling | Power BI / DAX |
| Version Control | Git / GitHub |

---

# Project Structure

A recommended repository structure:

```text
Brazilian-Ecommerce-Sales-Customer-Analytics/
  --/datasets/Raw_Datasets/ Cleaned_Datasets/Merged_Datasets/
  --/notebooks/E-Commerce-Sales-Customer_Analytics.ipynb
  --/sql/database/E-Commerce_Sales_and_Customer_Analytics.db
  -- /sql/queries/buisnessanalysis.sql

  --/dashboard/Power_BI_Dashboards/E-Commerce Sales and Customer Analyst Dashboard.pbix
  --/dashboard/Python_Dashboards/
  -- /python/visualizations.py
  --  /README.md
  --  /.gitignore
  


```


# Skills Demonstrated

This project demonstrates practical experience in:

- SQL querying
- Data cleaning
- Exploratory Data Analysis
- Data aggregation
- Feature engineering
- Window functions
- Subqueries
- KPI development
- DAX measures
- Data modeling
- Business intelligence
- Dashboard design
- Customer analytics
- Sales analytics
- Logistics analytics
- Data storytelling

---

# Portfolio Value

This project was designed as an end-to-end **Data Analyst portfolio project** rather than a simple visualization exercise.

It demonstrates the ability to:

> **Take raw business data → clean and transform it → analyze it with SQL/Python → create dynamic Power BI metrics → build an interactive dashboard → communicate business insights.**

---

# Author

**Naved Khan**

Data Analytics Portfolio Project

**Core Skills:**  
SQL · Python · Excel · Power BI · Pandas · NumPy · Matplotlib · DAX · Data Cleaning · EDA · Data Visualization · Dashboard Development




---




# 🚀 How to Run the Project

1. Clone the repository

```bash
git clone https://github.com/NavedAnalytics/E-Commerce-Sales-Customer-Analytics.git
```

2. Install dependencies

```bash
pip install pandas  matplotlib
```

3. Open the notebook

```
notebooks/notebook/E-Commerce-Sales-Customer-Analytics.ipynb
```

4. Execute the notebook to reproduce the analysis.

---




# 📬 Contact

**Naved Khan**

GitHub: https://github.com/navedanalytics


## ⭐ If you found this project useful, please consider giving it a Star!
