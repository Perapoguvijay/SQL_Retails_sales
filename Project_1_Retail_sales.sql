-- SQL Retail Sales Analysis -p1
create database projects;

--- CREATE Table
Drop Table if Exists sales_analysis;
CREATE TABLE sales_analysis (
transactions_id	int primary key,
sale_date	Date,
sale_time	Time,
customer_id	int,
gender	int,
age	 varchar(30),
category	varchar(20),
quantiy   int,
price_per_unit float,
cogs   float,
total_sale float
)


select * from sales_analysis;


select * from sales_analysis;
select count(*) from sales_analysis;

---- 
select * from sales_analysis 
where transactions_id is null;

---
select * from sales_analysis 
where sale_date is null;

--
select * from sales_analysis 
where sale_time is null;

--- 
select * from sales_analysis 
where 
transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantiy is null
or 
cogs is null
or total_sale is null ;

--- Data Cleaning 
delete from sales_analysis
where
transactions_id is null
or
sale_date is null
or
sale_time is null
or
gender is null
or
category is null
or
quantiy is null
or 
cogs is null
or total_sale is null;


--- Data ExPloration

--- How many sales we have ?

select count(*) as total_sales from sales_analysis;

---- How many unique customers we have?
select count(distinct customer_id) from sales_analysis;

--- How many uniue category we have ?
select count(distinct category) as cate from sales_analysis;
select distinct category from sales_analysis;


---- Data Analysis & Business Key problems & Answers
--- My Analysis & findings 
--- Q.1 Write a SQL query to retrieve all columns for sales modo on '2022-11-05'
select * from 
sales_analysis
where sale_date='2022-11-05';

--- Q-2 Write a SQL Query to retrieve all Transactions where the category 
---- is clothing and the quantiy sold is more than 4 month of nov-2022

select 
	* from sales_analysis
	where category='Clothing' 
		and
		format(sale_date,'yyyy-MM')='2022-11'
		and 
		quantiy>=4;

--- Q.3 write a SQL Query to calculate the total sales (total sales) for each category

select 
	category,sum(total_sale) as net_sale ,
	count(*) as total_orders
from sales_analysis
group by category

--- Q.4 Write a SQL Query to find the average age of customers who purchased items
--- from the 'Beauty' category.

select 
	avg(age) as avg_age
from sales_analysis
	where category='Beauty';
--- Q.5 Write a SQL Query to find all transactions where the total_sale
---- is greater the 1000

select * from sales_analysis
where total_sale>1000;

--- Q.6 Write a SQl query to find the total number of transactions 
---- (transaction_id) made by each gender in each category

select 
	category,
	gender,
	count(*) as total_trans
from sales_analysis
group by gender,category
order by category;

---Q.7  Write a SQl query to calculate the average sale for each month 
----. find out best selling month in each year
select year_1,
month_1 ,
avg_total_sale
from
(
select 
	year(sale_date)as year_1,
	month (sale_date) as month_1,
	avg(total_sale) as avg_total_sale,
	rank() over(partition by year(sale_date) order by avg(total_sale) desc) as rnk
from sales_analysis
group by year(sale_date),month(sale_date) 
) as t1 where rnk=1
---order by year(sale_date),avg_total_sale desc;

--- Q.8 Write a SQl Query to find the TOP 5 customers based on the highest total sale 

select top 5 customer_id ,sum(total_sale) as total_sales from sales_analysis
group by customer_id order by total_sales desc;


--- Q.9 Write a SQL query to find the number 
--- of unique Customers who purchased items for each category

select
	category,
	count(distinct customer_id ) as unique_customer
from sales_analysis
group by category 


---- Q.10 Write a SQL Query to create each shift and number of orders 
---     (Example Morning <=12,Afternoon Between 12 & 17, Evening >17)

select datepart(hour,sale_time) as Hourss from sales_analysis;

With hourly_sale
as(
select *, 
	case
	when datepart(hour,sale_time)<=12 then 'Morning'
	when datepart(hour,sale_time) between 12 and 17 then 'Afternoon'
	else 
		'Evening'
	end as shiftings
	from sales_analysis
) select shiftings,count(*) as total_orders from hourly_sale 
group by shiftings
;


select * from sales_analysis;