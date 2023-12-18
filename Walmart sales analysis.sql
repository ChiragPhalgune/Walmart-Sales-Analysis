CREATE DATABASE IF NOT EXISTS salesDataWalmart;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity INT not null,
    VAT float(6,4) not null,
    total decimal(12, 4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs Decimal (10,2) not null,
    gross_margin_pct float(11,9),
    gross_income decimal(12,4) not null,
    rating float(2,1)
);

-- -----------------------------
-- -----------------------------

-- time_of_day

select
	time,
    (CASE
		when	 `time` between "00:00:00" and "12:00:00" then "Morning"
		when	 `time` between "12:00:01" and "16:00:00" then "Afternoon"
		else "Evening"
        end
    )as time_of_day
from sales;
alter table sales add column time_of_day varchar(20);

update sales
set time_of_day=(
	CASE
		when	 `time` between "00:00:00" and "12:00:00" then "Morning"
		when	 `time` between "12:00:01" and "16:00:00" then "Afternoon"
		else "Evening"
        end
);

-- -------------------------------
-- -------------------------------
-- ---day_name--

select	
	date,
    dayname(date) as day_name
from sales;

Alter table sales  add column day_name varchar(10);

update sales
set day_name = dayname(date);

-- -------------------------------
-- -------------------------------
-- --- month_name-----------------

select
	date,
    monthname(date)
from sales;

alter table sales add column month_name varchar(10);

update sales
set month_name= monthname(date);

-- -------------------------------
-- -------------------------------
-- --- product -------------------

-- how many unique product lines does the data have?
select 
	count(distinct product_line)
from sales;

-- Most common payment method

select 
	payment_method,
	count(payment_method) as cnt
from sales
group by payment_method
order by cnt desc;

-- what is most selling product line?

select 
	product_line,
	count(product_line) as cnt
from sales
group by product_line
order by cnt desc;

-- What is the total revenue by month?

select
	month_name as month,
    sum(total) as total_revenue
from sales
group by month_name
order by total_revenue desc;

-- What month had the largest COGS?

select 
	month_name as month,
    sum(cogs) as cogs
from sales
group by month_name
order by cogs desc;


-- what product line had the largest revenue?

select
	product_line,
    sum(total) as total_revenue
from sales
group by product_line
order by total_revenue desc;

-- What city had highest revenue?
select
	branch,
	city,
    sum(total) as total_revenue
from sales
group by city, branch
order by total_revenue desc;

-- What product line had the largest VAT?

select
	product_line,
    avg(VAT) as avg_tax
from sales
group by product_line
order by avg_tax desc;

--  Which branch sold more products than average product sold?

select
	branch,
    SUM(quantity) as qty
from sales
group by branch
having SUm(quantity) > (Select avg(quantity) from sales);    

-- What is the most common product line by gender
select
	gender,
    product_line,
    count(gender) as total_cnt
from sales
group by gender, product_line
order by total_cnt desc;

-- What is the average rating of each product?
select
	round(avg(rating),2) as avg_rating,
    product_line
from sales
group by product_line
order by avg_rating desc;

-- --------------------------------------------------------------
--
-- ---------------- Sales ---------------------------------------

-- Number of sales made in each time of the day per weekday
select
	time_of_day,
    count(*) as total_sales
from sales
Where day_name = "Sunday"
group by time_of_day
order by total_sales desc;

-- which of the customer type brings most revenue

select
	customer_type,
    SUM(total) as total_rev
from sales
group by customer_type
order by total_rev desc;
 
 
--  Which city has the largest tax percent/VAT (Value Added taxes)?

select
	city,
	avg(VAT) as vat
from sales
group by city
order by vat desc;

-- Which customer type pays the most tax?
select
	customer_type,
    avg(VAT) as vat
from sales
group by customer_type
order by vat desc;
-- ---------------------------------------------------------------------------
-- ------------------------Customers------------------------------------------
--  How many unique customer types does the data have?
select 
	distinct customer_type
from sales;

-- how many unique payment method does the data have?
select 
	distinct payment_method
from sales;

-- Which customer type buys the most?
select
	customer_type,
    sum(total) as total_sales
from sales
group by customer_type
order by total_sales desc;

-- What is the gender of all of the customers?

select
	gender,
    count(*) as gender_cnt
from sales
group by gender
order by gender_cnt;

-- What is the gender distribution of all branch?
select
	gender,
    count(*) as gender_cnt
from sales
where branch = "a"
group by gender
order by gender_cnt;

-- Which time of the day do customers give the most rating?

select
	time_of_day,
    Avg(rating) as avg_rating
from sales
group by time_of_day
order by avg_rating desc;

-- Which time of the day do customers buy the most?
select
	time_of_day,
    Avg(total) as total
from sales
group by time_of_day
order by total desc;

-- Which day of the week has highest ratings?
select
	day_name,
    avg(rating) as avg_rating
from sales
group by day_name
order by avg_rating desc;


	
