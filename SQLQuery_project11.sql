use projects

/* Sales & Revenue Analysis */



select * from Sales_analysis
---1Q) Total Revenue generated 
select 
	sum(total_sale) as total_revenue 
from Sales_analysis

--- 2Q) AVerage order value
select 
	avg(total_sale) as average_total_sale 
from Sales_analysis

--- 3Q)Day with hoghest sales
select  
	Top 1 sale_date,sum(total_sale) as daily_sales
	from Sales_analysis group by sale_date
order by daily_sales desc

---- 4Q) Top revenue-contributing category
select 
	category,
	sum(total_sale) as revenue 
from Sales_analysis
group by category
order by revenue desc

--- 5Q) Top 2 categories by revenue
select Top 3
	category,
	sum(total_sale) as total_revenue
from Sales_analysis
group by category
order by total_revenue desc

---- 6Q) Profit margin per transaction 
select * from Sales_analysis

select  transactions_id,
	(total_sale-cogs) as profit 
from Sales_analysis
order by profit ;

--- 7Q) Average COGS per category 
select 
	category ,
	avg(cogs) as Avg_cogs
from Sales_analysis
group by category ;
--- 8 Q) Items sold per category
select 
	category,
	sum(total_sale) as total_item_sold
from Sales_analysis
group by category;

--- 9Q) Quantity  distibution 
select 
	category,
	count(*) as frequency 
from Sales_analysis
group by category
order by frequency;

--- 10 Q)Hour sales from distibution 
select 
	datepart(hour,sale_time) as sale_hour,sum(total_sale) as sales
	from Sales_analysis
	group by datepart(hour,sale_time) 
	order by sale_hour ;


/* Customer Analysis */

--- 11.Unique customer 
select * from sales_analysis
select count(distinct customer_id) as unique_customer from Sales_analysis;

--- 12Q)Gender distibution
select gender,
	count(*) as Gender_distibution 
	from Sales_analysis
	group by gender
	order by Gender_distibution desc;


--- 13Q) Average customer age 
select avg(age) as avg_age from Sales_analysis;

--- 14Q)Age group with highest spending 
select 
	case 
	when age between 18 and 25 then '18-25'
	when age between 26 and 35 then '26-35'
	when age between 36 and 50 then '36-50'
	else '50+'
	end as age_group,
	sum(total_sale) as total_spend
	from Sales_analysis
	group by
	case 
	when age between 18 and 25 then '18-25'
	when age between 26 and 35 then '26-35'
	when age between 36 and 50 then '36-50'
	else '50+'
	end 
	order by total_spend desc 


--- 15Q) Most popular category by gender 
select category,
		gender,
		sum(total_sale) as popular_sale
		from Sales_analysis
		group by category,gender
		order by category,popular_sale desc;

--- 16Q)Top spending customers 
select top 10 
	customer_id,
	sum(total_sale) as spending_cust
	from Sales_analysis
	group by customer_id
	order by spending_cust desc ;


--- 17 Q) Gender-wise AOV 
select 
	gender,
	avg(total_sale) as avg_order_sale
	from Sales_analysis
	group by gender 


---- 18 Q) Repeat purchase rate 
select 
	count(customer_id ) as total_customers,
	count(distinct customer_id) as unique_customers,
	(count(customer_id)-count(distinct customer_id)) as repeat_cutomer 
from Sales_analysis

--- 19Q) spending by age group
select 
	case
	when age between 18 and 25 then 'young'
	when age between 26 and 35 then 'middle-aged'
	when age between 36 and 50 then 'senior middle-aged'
	else 'Senior'
	end as age_group,
	avg(total_sale) as avg_spent
from Sales_analysis
group by 
	case
	when age between 18 and 25 then 'young'
	when age between 26 and 35 then 'middle-aged'
	when age between 36 and 50 then 'senior middle-aged'
	else 'Senior'
	end;


--- 20.Q) Correlation prep: age vs total sale 
select age,total_sale
	from Sales_analysis
	where age is not null


--- 21.Q) Montly sales trends 
select 
	month(sale_date) as monthly,
	sum(total_sale) as montly_sales
	from Sales_analysis
	group by month(sale_date)
	order by monthly

--- 22.Q) Day of week with most transcations 
select 
	datename(weekday,sale_date) as day_name,
	datepart(weekday,sale_date) as weekday_number,
	sum(total_sale) as total_sales
	from Sales_analysis
	group by datename(weekday,sale_date),datepart(weekday,sale_date)
	order by weekday_number

--- 23.Q) Sales by time
select 
	case 
	when datepart(hour,sale_time) between 6 and 11 then 'morning'
	when datepart(hour,sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	end as sale_by_time,
	sum(total_sale) as total_sales
	from   sales_analysis
	group by 
		case 
	when datepart(hour,sale_time) between 6 and 11 then 'morning'
	when datepart(hour,sale_time) between 12 and 17 then 'Afternoon'
	else 'Evening'
	end


--- 24 .Q) mintues by sales
select 
	 case
	 when datepart(minute,sale_time) between 1 and 20 then 'fast sales'
	 when datepart(minute,sale_time) between 21 and 45 then 'medium sale'
	 else 'slow sale'
	 end as minute_sales,
	 sum(total_sale) as total_sales
	 from Sales_analysis
	 group by
		case
	 when datepart(minute,sale_time) between 1 and 20 then 'fast sales'
	 when datepart(minute,sale_time) between 21 and 45 then 'medium sale'
	 else 'slow sale'
	 end
	 order by total_sales

--- 24.Q) Seasional Patterns 
select 
	month(sale_date) as monthh,sum(total_sale) as mothly_sales
	from Sales_analysis
	group by month(sale_date) 
	order by month(sale_date)

--- 25.Q)  Average transaction value over time 
select 
	sale_date,
	avg(total_sale) as avg_transaction_value
	from Sales_analysis
	group by sale_date
	order by sale_date;

/* Data Quality Checks */

---- 26.Missing values 
select 
	sum(case when age  is null then 1 else 0 end) as missing_age,
	sum(case when quantiy is null then 1 else 0 end) as missing_quantity,
	sum(case when total_sale is null then 1 else 0 end) as missing_totalsale
	from Sales_analysis;



select * from Sales_analysis;

--- 27.Q) check the outliers on quantity and price
select *
	from Sales_analysis
	where quantiy>1000 or 
	price_per_unit > 10000;

--- 28 Q) Duplicate transactions check 
select
	transactions_id,
	count(*) as countt
	from Sales_analysis
	group by transactions_id
	having count(*)>1;

--- 29.Q) Neagtive or zero values check 
select * 
	from Sales_analysis
	where total_sale<=0 or price_per_unit<=0;


---- 30.Rename 'quantiy' to quantity (if modifying schema)

alter table sales_analysis rename column quantiy to quantity;

Exec sp_rename 'sales_analysis.quantiy' ,'quantity'

select * from Sales_analysis;



