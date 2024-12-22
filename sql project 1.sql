--Create Database
Create Database Retail_sales_analysis

--Create Table
drop table if exists retail_Sales_tb;
Create Table retail_Sales_tb 
(
             transactions_id Int Primary key,
             sale_date date,
             sale_time time,
             customer_id int,
             gender varchar(10),
             age int,	
			 category varchar(25),
			 quantity int,	
             price_per_unit float,	
             cogs float,	
             total_sale float

);
--Delete Null values
Delete from retail_Sales_tb
where quantity is null
or 
price_per_unit is null
or 
total_sale is null

--Data exploration

--How many sales we have
Select count(total_sale) as total_sales from retail_Sales_tb

--How many unique customer we have
select count(distinct(customer_id)) as total_customers from retail_Sales_tb

--How many unique categories  we have
select count(distinct(category)) as total_category from retail_Sales_tb

--Data Analysis and Business key Problems & answers

--My Analysis & findings:

-- Q1:Write a SQL query to retrieve all columns for sales made on '2022-11-05:
 Select * from retail_sales_tb where sale_date = '2022-11-05'
 
-- Q2: Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
 Select  *
 from retail_sales_tb 
 where category = 'Clothing' and
 quantity >=4
 and  to_char(sale_date,'YYYY-MM') = '2022-11'

 
--Q3:Write a SQL query to calculate the total sales (total_sale) for each category.

Select category, sum(total_sale) as total_sales
from retail_sales_tb
group by 1

--Q4:Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age))
from retail_sales_tb
where category = 'Beauty' 

--Q5:Write a SQL query to find all transactions where the total_sale is greater than 1000.:

  select *
  from retail_sales_tb
  where total_sale>1000 
 
--Q6:Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
	
select count(transactions_id),category,gender
from retail_sales_tb
group by 2,3
order by 2

--Q7:Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
with cte1 as (select round(avg(total_sale)) as avg_sales,
extract(Year from sale_date) as Year, 
extract(Month from sale_date)as Month,
rank() over(partition by extract(Year from sale_date) order by round(avg(total_sale)) desc) as rank
from retail_sales_tb
group by 2,3)
select * from cte1 where rank = 1

--Q8:Write a SQL query to find the top 5 customers based on the highest total sales **:
select  sum(total_sale) as sales,customer_id,
rank() over(order by sum(total_sale) desc ) as rank
from retail_sales_tb
group by 2
limit 5

--Q9:Write a SQL query to find the number of unique customers who purchased items from each category.:

select count(distinct(customer_id)) as count of unique customers,category
from retail_sales_tb
group by 2

--Q10:Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):

with cte1 as (select *, 
case
when extract (hour from sale_time)< 12  then  'morning'
when extract (hour from sale_time) between 12 and 17 then 'Afternoon'
when extract (hour from sale_time) >17  then 'Night'
end as shifts 
from retail_sales_tb)

select shifts,count(customer_id) as orders from cte1
group by shifts

--End of Project