CREATE DATABASE retail_sales;
use retail_sales;
SELECT * FROM sales_data;

-- CHAGE COLUMNS DATATYPE --
ALTER TABLE sales_data
MODIFY sale_date date;

UPDATE sales_data
SET sale_date = STR_TO_DATE(sale_date, '%d-%m-%Y');


ALTER TABLE sales_data
MODIFY sale_time TIME; 

ALTER TABLE sales_data
CHANGE ï»¿transactions_id transactions_id TEXT,
MODIFY customer_id TEXT,
MODIFY age TEXT;


-- DATA ANALYSIS & BUSINESS KEY PROBELEMS & ANSWERS

-- My Analysis & Findings

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM sales_data
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT * FROM
    sales_data
WHERE
    category = 'Clothing'
        AND sale_date BETWEEN '2022-11-01' AND '2022-11-30';
        

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
    category, SUM(total_sale) AS sales
FROM
    sales_data
GROUP BY category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
    ROUND(AVG(age), 0)
FROM
    sales_data
WHERE
    category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM
    sales_data
WHERE
    total_sale > '1000';


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT 
    category, gender, COUNT(*) AS No_of_transaction
FROM
    sales_data
GROUP BY category , gender
ORDER BY category , gender;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	Year,
	Month,
    Avg_sale
FROM
(	SELECT
		YEAR(sale_date) AS Year,
		MONTH(sale_date) AS Month,
		ROUND(AVG(total_sale),2) AS Avg_sale,
		RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS RNK
	FROM sales_data
	GROUP BY Year, Month
)AS t1
WHERE RNK = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales
SELECT DISTINCT
    customer_id, SUM(total_sale) AS sale
FROM
    sales_data
GROUP BY 1
ORDER BY sale DESC
LIMIT 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
    category, COUNT(DISTINCT customer_id) AS cnt_uniqe_cust
FROM
    sales_data
GROUP BY category;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(SELECT *,
		CASE
			WHEN HOUR(sale_time) <12 THEN 'Morning'
            WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
            WHEN HOUR(sale_time) > 17 THEN'Evening'
		END AS Shift
FROM sales_data)
SELECT Shift,
	   COUNT(*) AS Num_of_order
FROM hourly_sale
GROUP BY Shift;


