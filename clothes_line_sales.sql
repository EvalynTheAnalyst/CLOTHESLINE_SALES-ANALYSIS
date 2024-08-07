-- creating a database
CREATE database ClothesLineSales;
USE ClothesLineSales;

-- creating table
CREATE TABLE clothessales(
DATE date,
customer_id int,
product_id int,
region text,
product_descriprion text,
product_category text,
product_line text,
raw_materials text,
quality int,
unit_price double,
sales_revenue double,
latitude double,
longitude double);

SELECT *
FROM clotheslinesales.clothessales;

#Top performing products to least performing products
WITH performing_products AS (
    SELECT 
        Product_Description,
        SUM(Sales_Revenue) AS Total_revenue,
        RANK() OVER (ORDER BY SUM(Sales_Revenue) DESC) AS Top_performing_products
    FROM clotheslinesales.clothessales
    GROUP BY Product_Description
)
SELECT 
    Product_Description,
    Total_revenue,
    Top_performing_products
FROM performing_products
ORDER BY Total_revenue DESC;

#Monthly sales per region
WITH sales_per_region AS(
SELECT 
	Region,
    COUNT(Customer_ID) AS num_of_customers,
    SUM(Sales_revenue) AS Total_revenue,
    ROW_NUMBER() OVER(ORDER BY SUM(Sales_Revenue) DESC) AS Best_performing_region
FROM clotheslinesales.clothessales
GROUP BY region)

SELECT 
	Region,
    num_of_customers,
    Total_revenue,
    Best_performing_region
FROM sales_per_region
ORDER BY Total_revenue DESC;

#MIN, MAX, AVG, VAR,STDV SALES 
SELECT 
    MAX(Sales_revenue) AS max_sales,
    MIN(Sales_revenue) As min_sales,
    AVG(Sales_Revenue) AS avg_sales,
    variance(Sales_revenue) AS var_sales,
    stddev(Sales_Revenue) AS stdv
FROM clotheslinesales.clothessales;

#MAX SALES  PER REGION AND PRODUCT
WITH ranked_products AS (
    SELECT 
        Region,
        Product_Description,
        Sales_Revenue,
        ROW_NUMBER() OVER (PARTITION BY Region ORDER BY Sales_Revenue DESC) AS rn
    FROM clotheslinesales.clothessales
)
SELECT 
    Region,
    Product_Description,
    Sales_Revenue AS max_sales
FROM ranked_products
WHERE rn = 1;
    

#MIN SELLING PRODUCT  
WITH ranked_products AS (
    SELECT 
        Region,
        Product_Description,
        Sales_Revenue,
        ROW_NUMBER() OVER (PARTITION BY Region ORDER BY Sales_Revenue) AS rn
    FROM clotheslinesales.clothessales
)
SELECT 
    Region,
    Product_Description,
    Sales_Revenue AS min_sales
FROM ranked_products
WHERE rn = 1;
    











