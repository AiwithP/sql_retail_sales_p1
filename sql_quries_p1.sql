drop table if exists reatils_sales;
CREATE TABLE retail_sales

            (
                transaction_id INT PRIMARY KEY,	
                sale_date DATE,	 
                sale_time TIME,	
                customer_id	INT,
                gender	VARCHAR(15),
                age	INT,
                category VARCHAR(15),	
                quantity	INT,
                price_per_unit FLOAT,	
                cogs	FLOAT,
                total_sale FLOAT
            );

--Data Clining
SELECT * FROM retail_sales
WHERE 
transaction_id IS NULL
or 
sale_date IS NULL
or
sale_time IS NULL
or
customer_id IS NULL
or
gender IS NULL
or
age IS NULL
or
category IS NULL
or
quantity IS NULL
or
price_per_unit IS NULL
or
cogs IS NULL
or
total_sale IS NULL;
--

DELETE FROM retail_sales
WHERE 
transaction_id IS NULL
or 
sale_date IS NULL
or
sale_time IS NULL
or
customer_id IS NULL
or
gender IS NULL
or
age IS NULL
or
category IS NULL
or
quantity IS NULL
or
price_per_unit IS NULL
or
cogs IS NULL
or
total_sale IS NULL;

--Data Exploration

--How many sales we have
SELECT COUNT (*) as total_sale FROM retail_sales

--How many unique customer we have 
SELECT COUNT (DISTINCT customer_id) FROM retail_sales 

SELECT COUNT (DISTINCT category) FROM retail_sales 

--data analysis & Business key problem & answer

-- to retrieve all collumns for sales made om '2022-11-05'
SELECT * FROM retail_sales
 WHERE sale_date = '2022-11-05'

-- retrieve all trasaction where the category is Clothing and the quantity sold is more than 4 in nov 2022
SELECT * FROM retail_sales
 WHERE category = 'Clothing' 
and 
TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
and 
quantity >= 4 

--sql quary to calculate the total sales for each category
SELECT category, 
SUM(total_sale) as net_sale,
COUNT(*) as total_order
from retail_sales
GROUP BY 1

--find the avg age of customer who purchased item from Beauty category
select Round(AVG(age),2) as avg_age 
from retail_sales
where category = 'Beauty'

--find the trasaction where the total_sale is greater than 1000.
select * from retail_sales
where total_sale >1000;

-- find the total number of transaction (transaction_id) made by each gender and each category
select category, gender,
count(*) as total_trans
from retail_sales
group by category, gender

--calculate the avaerage sale for each month Find out best selling month to each year

select 
	EXTRACT(YEAR FROM sale_date) as year,
	EXTRACT(MONTH FROM sale_date) as month,
	Avg(total_sale) as avg_sale,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
ORDER BY 1, 3 DESC

--find the top 5 customer based on the highest total sales
select customer_id,
sum(total_sale) as total_sales
from retail_sales 
group by 1
order by 2 desc
limit 5
-- find the number of unique customer who purchase item from each category
select
	category,
	count(distinct customer_id) as cst_unique
from retail_sales
group by category

-- create each shift and number and number of orders(morning, Evening, Afternoon)
with hourly_sale
as
(
select *,
 case
 	WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'Morning'
	 WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
	 ELSE 'Evening'
  END as shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

--End Of Project