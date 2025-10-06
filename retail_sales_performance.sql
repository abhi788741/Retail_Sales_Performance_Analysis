create database retail_sales;
use retail_sales;
rename table retail_sales_dataset to sales_performance;

# New Calculated columns
alter table sales_performance add column Age_Group varchar(20);
set sql_safe_updates=0;
update sales_performance
set Age_Group = case
when Age >= 60 then 'Senior'
when Age > 30 then 'Adult'
else 'Young'
end;

# New Calculated columns
alter table sales_performance add column Sales_Classification varchar(20);
update sales_performance
set Sales_Classification = case
when Total_Amount >=1500 then 'High'
when Total_AMount >=500 then 'Medium'
else 'Low'
end;

select * from sales_performance;

# Checking Duplicates in Transaction
select Transaction_ID,count(*) 
from sales_performance 
group by Transaction_ID
having count(*)>1;

# Checking Missing Values in columns or table
select Transaction_ID,Date,Customer_ID,Gender,Age,
Product_Category,Quantity,Price_per_Unit,
Total_Amount,Age_Group,Sales_Classification
from sales_performance
where Transaction_ID and Date and Customer_ID and Gender and Age and
Product_Category and Quantity and Price_per_Unit and
Total_Amount and Age_Group and Sales_Classification is null;

#Checking Data_types 
describe sales_performance;

# First 10 Transactions
select * 
from sales_performance
limit 10;

# Total Revenue
select sum(Total_Amount) as Total_Revenue 
from sales_performance;

# Total Transactions
select count(Transaction_ID)
from sales_performance;

# Distinct Product_categories
select distinct Product_Category
from sales_performance;

# Total distinct Customers
select distinct count(Customer_ID)
from sales_performance;

# Quantity Sold
select sum(Quantity) as Quantity_Sold
from sales_performance;

# Customer by Gender
select Gender,count(Customer_ID)
from sales_performance
group by Gender;

# sales by Gender
select Gender,sum(Total_Amount) as Sales
from sales_performance
group by Gender;

#sales by Product_Category
select Product_Category,sum(Total_Amount)
from sales_performance
group by Product_Category
order by sum(Total_Amount)
desc;

# Revenue share by Year
select sum(Total_Amount),
year(Date) 
from sales_performance 
group by year(Date);

# Revenue by month
select monthname(Date),sum(Total_Amount)
from sales_performance
group by monthname(Date)
order by sum(Total_Amount) desc;

# Revenue by Quarter
select quarter(Date),sum(Total_Amount)
from sales_performance
group by quarter(Date)
order by quarter(Date) asc;

# Revenue by Day
select dayname(Date),sum(Total_Amount)
from sales_performance
group by dayname(Date);

# Top 10 customers by revenue
select Customer_ID,max(Total_Amount)
from sales_performance
group by Customer_ID
order by max(Total_Amount) 
desc
limit 10;

# Average Age of Customers who spend above average revenue.
select avg(Age)
from sales_performance
where Total_Amount>
(select avg(Total_Amount) from sales_performance);

# Customers by each Age Group
select count(Customer_ID),Age_Group
from sales_performance
group by Age_Group;

# Highest Quantity Sold Category
select Product_Category,sum(Quantity)
from sales_performance
group by Product_Category;

# Average Revenue by categorry
select avg(Total_Amount),Product_Category
from sales_performance
group by Product_Category;

# Product Category having highest ratio of female to male of purchase
select Product_Category,Gender,count(Gender)
from sales_performance
group by Product_Category,Gender
order by count(Gender) desc;

# Which product category drives the highest sales during festival months (e.g., October, November)?
select Product_Category,monthname(Date),sum(Total_Amount)
from sales_performance
where monthname(Date) like '%November'
group by Product_Category,monthname(Date) 
order by sum(Total_Amount) desc;

# Which age group spends the most on Electronics?
select Product_Category,Age_Group,sum(Total_Amount)
from sales_performance
where Product_Category='Electronics'
group by Age_Group;

# Which customer segment (Gender + Age Group) generates maximum revenue?
select Age_Group,Gender,sum(Total_Amount)
from sales_performance
group by Age_Group,Gender
order by Age_Group asc;

# Which day of the week has the highest average revenue ?
select dayname(Date) as Day,
avg(Total_Amount) as Average_Revenue
from sales_performance
group by dayname(Date)
order by avg(Total_Amount) desc;

