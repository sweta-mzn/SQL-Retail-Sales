select * from retail_sales;
select count(*) from retail_sales;
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date IS NULL
        OR transactions_id IS NULL
        OR sale_time IS NULL
        OR customer_id IS NULL
        OR gender IS NULL
        OR age IS NULL
        OR category IS NULL
        OR quantity IS NULL
        OR cogs IS NULL
        OR total_sale IS NULL;
        
	delete from retail_sales 
    where sale_date IS NULL
    OR transactions_id IS NULL
    OR sale_time IS NULL
    OR customer_id IS NULL
    OR gender IS NULL
    OR age IS NULL
    OR category IS NULL
    OR quantity IS NULL
    OR cogs IS NULL
    OR total_sale IS NULL;
    
    /* data exploration */
    
    /* how much sales do we have? */
    
    SELECT 
    COUNT(*) AS total_sale
FROM
    retail_sales;
    
    /* how many unique customers do we have?*/
    SELECT 
    COUNT(DISTINCT customer_id) AS num_of_customers
FROM
    retail_sales;
    
select * from retail_sales limit10;

/* what are the unique categories of goods being sold and what were their numbers */
SELECT DISTINCT
    category, count(*) as sales_per_category
FROM
    retail_sales
    group by category;
    
    /* total sales for each category*/
SELECT DISTINCT
    category, count(*) as num_per_category,

    sum(total_sale) as sales_per_category
FROM
    retail_sales
    group by category;


/* Data Analysis or Business Key problems */
/* My analysis and findings*/

-- Q.1 write a sql query to retrive all columns for sales made on '2022-11-05'
SELECT 
    *
FROM
    retail_sales
WHERE
    sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 1 in the month of Nov-2022
SELECT 
    *
FROM
    retail_sales
WHERE
lower(category)= 'clothing'
AND quantity > 1
        AND sale_date between '2022-11-01' and '2022-11-30';
/*      
3 Write a SQL query to calculate the total sales (total_sale) for each category.
*/
SELECT 
    category, SUM(total_sale) AS sale_per_category
FROM
    retail_sales
GROUP BY category
;

/*
Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
*/
SELECT 
    AVG(age) AS avg_age_beauty
FROM
    retail_sales
WHERE
    category = 'beauty';
    
    /*Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
    */
    
    SELECT 
    *
FROM
    retail_sales
WHERE
    total_sale > 1000;
    
/*Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
*/
SELECT 
    category,
    gender,
    COUNT(transactions_id) AS transactions_per_gen_category
FROM
    retail_sales
GROUP BY category , gender;

/*Q.7:
Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
*/
SELECT 
    year,
    month,
    avg_sale
FROM (
    SELECT 
        YEAR(sale_date) AS year, 
        MONTH(sale_date) AS month,
        AVG(total_sale) AS avg_sale,
        RANK() OVER (
            PARTITION BY YEAR(sale_date) 
            ORDER BY AVG(total_sale) DESC
        ) AS rnk
    FROM retail_sales
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) AS t1
WHERE rnk = 1;

/* write a sql query to find the top 5 customers based on the highest total sales */

SELECT 
    customer_id, SUM(total_sale) AS highest_sale
FROM
    retail_sales
GROUP BY customer_id
ORDER BY highest_sale DESC
LIMIT 5;

/* write a sql query to find the number of unique customers who purchased from items from each category */

SELECT 
    category,
    COUNT(DISTINCT customer_id) AS num_unique_customers
FROM
    retail_sales
GROUP BY category;

/* write a sql query to create each shift and number of orders */
select case when hour (sale_time) < 12 then 'morning'
 when
hour(sale_time) between 12 and 17 then 'afternoon'
else 'evening'
end as shift,
count(*) as total_orders
from retail_sales
group by shift;



