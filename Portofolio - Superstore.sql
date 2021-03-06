-- Database : Sample - Superstore, Source : Penguin Analytics

SELECT *
FROM Orders
ORDER BY [ORDER DATE];

SELECT *
FROM People;

SELECT *
FROM Returns;

-- Find the numbers of customers per city
SELECT City, Count(Distinct [Customer ID]) as [Number of Customers]
From Orders
Group by City
Order by [Number of Customers] DESC;

SELECT Region, Count(Distinct [Customer ID]) as [Number of Customers]
From Orders
Group by Region
Order by [Number of Customers] DESC;  

--Count the number of orders per city
SELECT City, Count([Order ID]) as [Number of Orders]
FROM Orders
Group By City
Order by 2 DESC;  

-- Find first order date of each customer
SELECT [Customer ID], min([order date]) as [First Order Date]
from Orders
group by [Customer ID] order by 2;    

--Find number of customer who made their first order in each city, each day (Using CTE)
WITH FirstOrder ([Customer ID], [First Order Date])
as
(SELECT [Customer ID], min([order date]) as [First Order Date]
from Orders
group by [Customer ID])

Select t2.City, t1.[first order date], count(t1.[customer id]) as [number of users]
FROM FirstOrder as t1 join Orders as t2 ON T1.[Customer ID]=T2.[Customer ID]
GROUP BY t2.City,t1.[first order date];   

-- Find the first order GMV(Sales) of each customer if there is a tie, use the order with lower order id (USING CTE)
WITH FirstOrder ([Customer ID], [First Order Date])
as
(SELECT [Customer ID], min([order date]) as [First Order Date]
from Orders
group by [Customer ID])

SELECT T1.[customer id], T1.sales
from orders as t1
JOIN FirstOrder AS T2 ON T1.[Customer ID]=T2.[Customer ID] AND T1.[Order Date]=T2.[First Order Date];

-- Splitting years from order date   
ALTER TABLE Orders
ADD Years INT;

update Orders
SET Years=DATEPART(Year,[Order Date]);


-- Sorting Total Sales Per Year in each city
SELECT Years, City, SUM([Sales]) as [Total Sales]
From Orders
Group by Years, City
Order by 1, 2 ASC;

-- Sorting Total Number of Sales Per Year in each city
SELECT Years, City, Count([Sales]) as [Total Number of Sales]
From Orders
Group by Years, City
Order by 1,2 DESC;

-- Find Customer With Most Orders
SELECT [Customer ID], [Customer Name], Count([Order ID]) as [Total Order]
From Orders
Group by [Customer ID], [Customer Name]
Order by 3 DESC;

-- Find Category With Best Selling
SELECT Category, SUM([Sales])
FROM Orders
Group By Category
Order By 2 DESC;

-- Which Category Best Selling in Each City
SELECT City, Category, SUM([SALES]) as [Total Sales]
FROM Orders
Group By City, Category
Order By 1;

-- Total Sales Each Category Per Year
SELECT Years, Category, SUM([SALES]) as [Total Sales]
FROM Orders
Group By Years, Category
Order By 1;

-- Total Item Sold Per Product in 2017
SELECT [Product Name], SUM([Quantity]) as Sold
FROM Orders WHERE Years=2017
GROUP BY [Product Name]
ORDER BY 2 DESC;

-- Product Returned Details
Select t1.Returned, t1.[Order ID], t2.[Product Name], t2.Category, t2.[Customer id], t2.Region
FROM Returns as t1 join Orders as t2 ON T1.[Order ID]=T2.[Order ID]
Order By T2.[Order Date];

-- Count Return Per Each Category
Select t2.Category, Count(t1.[Order ID]) as [Total Return]
FROM Returns as t1 join Orders as t2 ON T1.[Order ID]=T2.[Order ID]
Group By Category
Order By 2 DESC;  

-- Count Return For Each Product
Select t2.[Product Name], Count(t1.[Order ID]) as [Total Return]
FROM Returns as t1 join Orders as t2 ON T1.[Order ID]=T2.[Order ID]
Group By t2.[Product Name]
Order By 2 DESC;

-- Counting Total Sales for each month
SELECT Year([Order Date]) as Year, MONTH([Order Date]) as Month, Sum([Sales]) as [Total Sales]
FROM ORDERS
WHERE Year([Order Date]) IN (2016,2017)
GROUP BY Year([Order Date]), MONTH([Order Date])
ORDER BY 1,2;

-- Counting Total Profit for each month
SELECT Year([Order Date]) as Year, MONTH([Order Date]) as Month, Sum([Profit]) as [Profit]
FROM ORDERS
WHERE Year([Order Date]) IN (2016,2017)
GROUP BY Year([Order Date]), MONTH([Order Date])
ORDER BY 1,2;

--Find out which category earn most profit
SELECT Category, Sum([Profit]) as [Profit]
FROM ORDERS
WHERE Year([Order Date]) IN (2017)
GROUP BY Category
ORDER BY 2 DESC;

--Find out which product earn most profit
SELECT [Product Name], Sum([Profit]) as [Profit], Sum([Quantity]) as Sold
FROM ORDERS
WHERE Year([Order Date]) IN (2017)
GROUP BY [Product Name]
ORDER BY 2 DESC;

-- Comparing Total Sales with previous month
SELECT Year([Order Date]) as Year, MONTH([Order Date]) as Month, SUM([Sales]) AS [TOTAL SALES],
LAG(SUM([SALES])) OVER (ORDER BY Year([Order Date]), MONTH([Order Date])) AS [TOTAL SALES PREVIOUS MONTH]
FROM ORDERS
WHERE Year([Order Date]) IN (2016,2017)
GROUP BY Year([Order Date]), MONTH([Order Date])
ORDER BY 1,2;

-- Comparing Sales from each product with previous month
SELECT Year([Order Date]) as Year, MONTH([Order Date]) as Month, [Product Name], SUM([Sales]) AS [TOTAL SALES],
LAG(SUM([SALES])) OVER (ORDER BY Year([Order Date]), MONTH([Order Date])) AS [TOTAL SALES PREVIOUS MONTH]
FROM ORDERS
WHERE Year([Order Date]) IN (2016,2017)
GROUP BY Year([Order Date]), MONTH([Order Date]), [Product Name]
ORDER BY 1,2;

-- Comparing Total Sales Each Month With First Month Of The Year
SELECT Year([Order Date]) as Year, MONTH([Order Date]) as Month, SUM([Sales]) AS [TOTAL SALES],
LAG(SUM([SALES]), MONTH([Order Date]) - 1) OVER (ORDER BY Year([Order Date]), MONTH([Order Date])) AS [TOTAL SALES PREVIOUS YEAR]
FROM ORDERS
WHERE Year([Order Date]) IN (2016,2017)
GROUP BY Year([Order Date]), MONTH([Order Date])
ORDER BY 1,2;

-- Comparing Total Sales With The Same Month Of Previous Year
SELECT Year([Order Date]) as Year, MONTH([Order Date]) as Month, SUM([Sales]) AS [TOTAL SALES],
LAG(SUM([SALES]), 12) OVER (ORDER BY Year([Order Date]), MONTH([Order Date])) AS [TOTAL SALES 1st MONTH]
FROM ORDERS
GROUP BY Year([Order Date]), MONTH([Order Date])
ORDER BY 1,2;

-- Find out how many days to process orders for each order
SELECT [ORDER ID], DATEDIFF(DD, [ORDER DATE], [SHIP DATE]) AS [DAYS TO PROCEED ORDER], [ORDER DATE], [Ship Mode] 
FROM Orders
WHERE Year([Order Date])=2017
ORDER BY 3 ASC;

SELECT [ORDER ID], DATEDIFF(DD, [ORDER DATE], [SHIP DATE]) AS [DAYS TO PROCEED ORDER], [ORDER DATE], [Ship Mode] 
FROM Orders
WHERE Year([Order Date])=2017 AND [SHIP MODE] = 'Standard Class'
ORDER BY 2 ASC;

--The data shows the longest days to proceed orders is 7 days using Standard Class and the fastest days to proceed orders using Standard Class is 4 days


-- Find out if there's no sale for n consecutive days
SELECT * FROM
(SELECT [ORDER DATE], DATEDIFF(Day, [Order Date], LEAD([ORDER DATE]) OVER (ORDER BY [ORDER DATE])) AS [Gap]
FROM Orders
WHERE Year([Order Date])=2017) AS [NO SALES]
WHERE [NO SALES].GAP > 1

-- Product sold using discount details
SELECT [Order ID], [Order Date], [Product Name], Discount
FROM Orders
WHERE Year([Order Date])=2017 AND Discount > 0
ORDER BY [ORDER DATE];

-- Find out how many product sold with discount
SELECT [Product Name], COUNT([Discount]) AS [Discount Count]
FROM Orders
WHERE Year([Order Date])=2017 AND Discount > 0
GROUP BY [Product Name]
ORDER BY 2 DESC;
