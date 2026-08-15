-- Revenue by state
select customer_state ,sum(total_price) as Total_Revenue
from olist_ecommerce_clean
where order_status=='delivered'
group by customer_state
order by Total_Revenue desc;





-- 	Revenue by product category
select product_category_name_english,sum(total_price) as Revenue_by_product_category
from olist_ecommerce_clean
where order_status='delivered'
group by product_category_name_english
order by Revenue_by_product_category desc;





 select customer_state ,sum(total_price) as Total_Revenue
-- from olist_ecommerce_clean
-- where order_status=='delivered'
-- group by customer_state
-- order by Total_Revenue desc;



-- 	Revenue by product category
-- select product_category_name_english,sum(total_price) as Revenue_by_product_category
-- from olist_ecommerce_clean
-- where order_status='delivered'
-- group by product_category_name_english
-- order by Revenue_by_product_category desc;




-- orders by time of day
select time_of_day,count(distinct order_id) as Orders
from olist_ecommerce_clean
group by time_of_day;

-- What is the average freight cost per order?


select avg(sum_freight_cost) as Avg_freight_cost_per_order
from(select order_id,sum(freight_value) as sum_freight_cost
from olist_ecommerce_clean
where order_status='delivered'
group by order_id)t;

-- 
-- Which are the top 10 product categories by revenue?
SELECT product_category_name_english,SUM(total_price) AS total_revenue
FROM olist_ecommerce_clean
WHERE order_status = 'delivered'
GROUP BY product_category_name_english
ORDER BY total_revenue DESC
LIMIT 10;



-- 
-- Which states generate the most orders?
select customer_state,count(distinct order_id) as Total_Orders
from olist_ecommerce_clean
group by customer_state
order by Total_Orders desc;



-- Customer analytics questions
-- 1.Which customers placed the most orders?
select customer_unique_id,count(distinct order_id) as Total_Orders
from olist_ecommerce_clean
group by customer_unique_id
order by Total_Orders desc;


-- How many repeat customers are there?
select count(customer_unique_id) as total_repeat_customers
from(select customer_unique_id,count(distinct order_id ) as total_orders
from olist_ecommerce_clean
group by customer_unique_id
having count(distinct order_id)>1)t;

-- 
-- How many repeat customers are there?
select sum(case when total_orders > 1 then 1 end)*100.0 / count(customer_unique_id) as total_repeat_customers_percent 
from(select customer_unique_id,count(distinct order_id ) as total_orders
from olist_ecommerce_clean
group by customer_unique_id)as t;
-- 


-- Delivery and logistics questions

-- What percentage of delivered orders were late?

select sum( case when one_late_delivery = 1 then 1 else 0 end) *100.0 / count(order_id) as late_delivery_percent
from(select order_id,max(Late_Delivery)as one_late_delivery
from olist_ecommerce_clean
where order_status='delivered'
group by order_id) as t;


-- 
-- Which states have the highest average delivery time?
select customer_state,avg(one_delivery_day) as avg_delivery_time
from(select order_id,customer_state,max(Delivery_Days) as one_delivery_day
from olist_ecommerce_clean
where order_status='delivered' and Delivery_Days is not null
group by order_id,customer_state)as t
group by customer_state 
order by avg_delivery_time desc;




-- Which states have the highest average freight cost?

select customer_state,avg(one_freight_value) as avg_freight_cost
from(select order_id,customer_state,max(freight_value) as one_freight_value
from olist_ecommerce_clean
where order_status='delivered' 
group by order_id,customer_state) as t
group by customer_state
order by avg_freight_cost desc;



-- 
-- Find the top 3 customers by total spending.
select customer_unique_id,sum(total_price) as total_spending,rank()OVER (order by sum(total_price) desc) as rank
from olist_ecommerce_clean
where order_status= 'delivered'
group by customer_unique_id
limit 3;



-- Find the top 5 product categories by revenue in each state.
-- s
select customer_state,product_category_name_english,total_revenue,rn
from (select customer_state,product_category_name_english,sum(total_price) as total_revenue,rank()over(partition by customer_state order by total_price desc) as rn
from olist_ecommerce_clean
where order_status='delivered' 
group by customer_state,product_category_name_english
order by total_revenue DESC) as t
where rn<=5 
order by customer_state,rn ;

