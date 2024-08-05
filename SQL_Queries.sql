SELECT * FROM salesdatawalmart.`walmartsalesdata.csv`;
-- DATA CLEANING
`checking for null and not null values`
DESCRIBE salesdatawalmart.`walmartsalesdata.csv`;
-- ANALYSIS
-- Adding a column
#1- time_of_day
SELECT
   time,
   (CASE
       WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
       WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
       ELSE "Evening"
       END) AS time_of_day
FROM salesdatawalmart.`walmartsalesdata.csv`;

ALTER TABLE salesdatawalmart.`walmartsalesdata.csv`
ADD COLUMN time_of_day VARCHAR (20);

UPDATE salesdatawalmart.`walmartsalesdata.csv`
SET time_of_day = (
 CASE
       WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
       WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
       ELSE "Evening"
  END
);

#2- day_name
SELECT date ,
    DAYNAME(date) AS day_name
FROM salesdatawalmart.`walmartsalesdata.csv`;

ALTER TABLE salesdatawalmart.`walmartsalesdata.csv`
ADD COLUMN day_name VARCHAR (10);

UPDATE salesdatawalmart.`walmartsalesdata.csv`
SET day_name = DAYNAME(date);

#3- month_name
SELECT date,
    MONTHNAME(date)
FROM salesdatawalmart.`walmartsalesdata.csv`;

ALTER TABLE salesdatawalmart.`walmartsalesdata.csv`
ADD COLUMN month_name VARCHAR (10);

UPDATE salesdatawalmart.`walmartsalesdata.csv`
SET month_name = MONTHNAME(date);

# ----------ANALYSIS-----
# --GENERIC QUESTIONS--
#1. HOW MANY UNIQUE CITIES DOES THE DATA HAVE
SELECT DISTINCT city 
FROM salesdatawalmart.`walmartsalesdata.csv`;
#2.WHICH BRANCHES DO WE HAVE IN EACH CITY
SELECT DISTINCT city,
      branch
FROM salesdatawalmart.`walmartsalesdata.csv`;

# ---PRODUCT ANALYSIS---
#1. HOW MANY UNIQUE PRODUCT LINES DOES THE DATA HAVE 
SELECT DISTINCT `Product line`
FROM salesdatawalmart.`walmartsalesdata.csv`;

#2. WHAT IS THE MOST COMMON PAYMENT METHOD
SELECT
    payment, 
    COUNT(payment) AS count
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY payment
ORDER BY count DESC;

#3. WHAT IS THE MOST SELLING PRODUCT LINE
SELECT `product line`,
    COUNT(`product line`)AS cpl
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `product line`
ORDER BY cpl DESC;

#4. WHAT  IS THE TOTAL REVENUE BY MONTH
SELECT month_name AS month,
    SUM(Total)AS total_revenue
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY month
ORDER BY total_revenue DESC;

#5. WHAT MONTH HAD THE LARGEST COGS
SELECT month_name AS month,
    SUM(cogs)AS cogs
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY month
ORDER BY cogs DESC;

#6.WHAT PRODUCT LINE HAD THE LARGEST REVENUE
SELECT `product line`,
    SUM(total) AS total_revenue
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `product line`
ORDER BY total_revenue DESC;

#7. WHAT IS THE CITY WITH THE LARGEST REVENUE
SELECT
    branch
    city,
    SUM(total) AS total_revenue
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY city,branch
ORDER BY total_revenue DESC;

#8. WHAT PRODUCT LINE HAD THE LARGEST VAT
SELECT `product line`,
     AVG(`Tax 5%`) AS avg_tax
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `product line`
ORDER BY avg_tax;

#9.WHICH BRANCH SOLD MORE PRODUCTS THAN AVERAGE PRODUCT SOLD.
SELECT 
    branch,
    SUM(Quantity)AS br
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY branch
HAVING SUM(Quantity) > (SELECT AVG(QUANTITY) FROM salesdatawalmart.`walmartsalesdata.csv`)
ORDER BY br DESC;

#10. WHAT IS THE MOST COMMON PRODUCT LINE BY GENDER
SELECT gender,
    `product line`,
     COUNT(gender) AS total_cnt
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY gender,`product line`
ORDER BY total_cnt;

#11. WHAT IS THE AVERAGE RATING OF EACH PRODUCT
SELECT 
   ROUND(AVG(rating),2) AS avg_rating,
   `product line`
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `product line`
ORDER BY avg_rating DESC;

#12. FETCH EACH PRODUCT LINE AND ADD TO THOSE PRODUCT LINE SHOWING GOOD OR BAD .GOOD IF ITS GREATER THAN AVERAGE SALES .
SELECT `product line`,
    AVG(Total)AS avg_total,
    (CASE 
        WHEN AVG(Total) > (SELECT AVG(Total)FROM salesdatawalmart.`walmartsalesdata.csv`) THEN "GOOD"
        ELSE
            "BAD"
	END
    ) AS sales_performance
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP  BY `product line`
ORDER BY `product line` DESC;

#---SALES ANALYSIS---
#1. NUMBER OF SALES MADE IN EACH TIME OF THE DAY PER WEEKDAY
SELECT time_of_day,
    COUNT(*)AS total_sales
FROM salesdatawalmart.`walmartsalesdata.csv`
WHERE day_name = "Sunday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

#2. WHAT TYPE OF CUSTOMERS BRINGS THE MOST REVENUE
SELECT `Customer type`,
    SUM(Total)AS total_revenue
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `Customer type`
ORDER BY total_revenue DESC;

#3. WHICH CITY HAS THE LARGEST TAX PERCENT/VAT 
SELECT City,
   SUM(`Tax 5%`)AS total_tax
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY City
ORDER BY total_tax DESC;

#4. WHICH CUSTOMER TYPE PAYS THE MOST IN VAT
SELECT `customer type`,
   SUM(`Tax 5%`)AS total_tax
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `customer type`
ORDER BY total_tax DESC;

#-----CUSTOMER ANALYSIS---
#1.HOW MANY UNIQUE CUSTOMER TYPE DOES THE DATA HAVE
SELECT DISTINCT `customer type`
FROM salesdatawalmart.`walmartsalesdata.csv`;

#2. HOW MANY UNIQUE PAYMENT METHOD ARE THERE
SELECT DISTINCT payment
FROM salesdatawalmart.`walmartsalesdata.csv`;

#3.WHAT IS THE MOST COMMON CUSTOMER TYPE
SELECT 
    DISTINCT `customer type`,
    COUNT(`customer type`) AS total_types_of_customers
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `customer type`
ORDER BY total_types_of_customers DESC;

#4. WHAT CUSTOMER TYPE THAT BUYS THE MOST 
SELECT 
    DISTINCT `customer type`,
    COUNT(*)AS total_amount
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY `customer type`
ORDER BY total_amount DESC;

#5. WHAT IS THE GENDER OF MOST OF THE CUSTOMERS
SELECT gender,
    COUNT(*) AS gender_count
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY gender
order by gender_count DESC;

#6. WHAT IS THE GENDER DISTRIBUTION OF EACH BRANCH
SELECT gender,
    COUNT(*) AS gender_count
FROM salesdatawalmart.`walmartsalesdata.csv`
WHERE branch = "A"
GROUP BY gender
order by gender_count DESC;

#7. WHICH TIME OF THE DAY DO CUSTOMERS GIVE MOST RATINGS
SELECT time_of_day,
   AVG(Rating) AS avg_rating
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY time_of_day
ORDER BY avg_rating DESC;

#8. WHICH TIME OF THE DAY DO CUSTOMERS GIVE MOST RATINGS PER BRANCH
SELECT time_of_day,
   AVG(Rating) AS avg_rating
FROM salesdatawalmart.`walmartsalesdata.csv`
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

#9. WHICH DAY OF THE WEEK HAS THE BEST AVG RATINGS
SELECT day_name,
   AVG(Rating) AS avg_rating
FROM salesdatawalmart.`walmartsalesdata.csv`
GROUP BY day_name
ORDER BY avg_rating DESC;

#10. WHICH DAY OF THE WEEK HAS THE BEST AVERAGE RATINGS PER BRANCH
SELECT day_name,
   AVG(Rating) AS avg_rating
FROM salesdatawalmart.`walmartsalesdata.csv`
WHERE branch = "A"
GROUP BY day_name
ORDER BY avg_rating DESC;












