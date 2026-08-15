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
| Total Revenue | R$16.19M |
| Total Orders | ~99K |
| Average Order Value | R$167.80 |
| Average Delivery Days | 12.09 days |
| Average Review Score | 4.16 |
| Orders per Customer | 1.03 |
| Late Delivery % | 8.13% |
| Average Freight Cost / Order | R$23.97 |

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
- Review score drivers
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



Looking at your Brazilian E-Commerce dashboard (2016–2018), here are the key insights that stand out:

Overall Business Performance

Your e-commerce business made R$16.19 Million in total revenue from 99,000 orders, between 2016 and 2018. On average, each order was worth R$167.80, and customers rated their experience 4.16 out of 5 — which is a good score overall.

1. Most of Your Business Comes From a Few States

Almost all your sales come from just a handful of states — especially São Paulo (SP), which alone brings in R$6.08 Million, more than one-third of all revenue. Along with Rio de Janeiro and Minas Gerais, these three states make up more than half your business.

What this means: Your business is too dependent on one region. If something goes wrong there (competition, economic slowdown, delivery issues), it will hurt your whole business badly. Other states like Roraima, Amapá, and Amazonas barely contribute anything — this is an untapped opportunity if you can fix delivery there.

2. Customers Are Not Coming Back

This is the most important problem in your data.

On average, each customer places only 1.03 orders — which basically means almost every customer buys once and never returns.

What this means: You are spending money and effort to attract new customers, but you're not keeping them. A healthy business usually earns much more from repeat customers than new ones, because repeat customers are cheaper to sell to and trust you more. Right now, you're leaking almost all future revenue by not bringing customers back.

What you can do: Introduce loyalty programs, personalized follow-up emails/offers, discounts on second purchases, or subscription-style products.

3. Shipping Costs Are High and Hurting Remote Regions

On average, you spend R$23.97 on freight for every order — that's about 14% of the order's value just going to shipping. In far-away states like Roraima, Amapá, and Amazonas delivery takes 26 to 29 days on average, and freight costs are also the highest there.

What this means: Customers in these regions are likely avoiding your store because shipping takes too long and costs too much — not because they don't want your products. This directly explains why those states show almost no sales.

What you can do: Consider regional warehouses, partnerships with local delivery services, or adjusted pricing/shipping options for far states.

4. Slow Delivery Is Lowering Customer Happiness

Even though only about 8% of orders are officially "late," your average delivery time is 12 days, which is quite long. Looking at customer reviews, you can clearly see that the longer delivery takes, the lower customers rate their experience.

Also, you have a fairly large group of unhappy customers — around 11,000 one-star reviews, more than the combined total of 2-star and 3-star reviews. This shows a "love it or hate it" pattern: most people are satisfied, but a meaningful group has a genuinely bad experience.

What this means: Since customers rarely return anyway (see point 2), a bad delivery experience may be permanently losing that customer, with no second chance to win them back.

5. Most Customers Pay With Credit Cards

About 75% of all payments are made using credit cards, while only about 20% use boleto (a common Brazilian payment method), and very few use debit cards or vouchers.

What this means: You're heavily relying on one payment method. If there's ever an issue with card payment processing, or if economic conditions make credit less accessible, a large part of your revenue could be at risk.

6. A Few Product Categories Drive Most of the Revenue

Your top-selling categories are Health & Beauty, Watches & Gifts, and Bed/Bath/Table items. These categories bring in the most money, while categories like cool_stuff,auto and garden_tools contribute very little.

What this means: It's good to know your strong categories, but it's worth checking if these categories are also profitable — not just high in sales. Some categories (like furniture or gifts) often cost more to ship, which can eat into profits even if sales look strong.

Summary: What to Focus On First

1	Issue is that customers don't return (1.03 orders/customer).It matters beacause biggest growth opportunity retention is cheaper than new customer acquisition
2	 Issue is high freight cost & slow delivery in remote states .It matters beacause  it actively blocking sales growth in untapped regions
3	 Issue is Delivery delays hurting reviews . It matters beacause it directly connected to customer satisfaction and lost repeat business
4	 Issue is heavy reliance on one region (SP) and one payment method (credit card).It matters because	business risk if either is disrupted


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

GitHub: https://github.com/NavedAnalytics


## ⭐ If you found this project useful, please consider giving it a Star!
