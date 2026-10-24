-- DataCo Smart Supply Chain: Queries & Results
-- Course group project (Group 4A). All SQL queries in this file were written by Kexin Yu,
-- plus adjustments to the ER diagram. The queries run against the source table SUPPLYCHAIN
-- (DataCo dataset, 2015-2018, 180,000+ records).
-- Results below are sample outputs from running these queries in MySQL Workbench
-- (October 2026). For queries with many rows, only the first 10 rows are shown.
-- Averages and totals are rounded to 2 decimals for readability.

-- Q1. High-value customers: single orders with sales over 1000
SELECT `Customer Fname`, `Customer Lname`, `Sales`
FROM SUPPLYCHAIN
WHERE `Sales` > 1000;
-- Result (first 10 rows shown):
-- Customer Fname | Customer Lname | Sales
-- Alma Delgado | 1500
-- Alyssa Contreras | 1500
-- Audrey Acosta | 1500
-- Winifred Alexander | 1500
-- Margaret Foreman | 1500
-- Jamalia Ortega | 1500
-- Patience Ellis | 1500
-- Denise Mosley | 1500
-- Reagan Daniels | 1500
-- Gemma Silva | 1500

-- Q2. Top customers by total sales
SELECT `Customer Fname`, `Customer Lname`, SUM(`Sales`) AS Total_Sales
FROM SUPPLYCHAIN
GROUP BY `Customer Fname`, `Customer Lname`
ORDER BY Total_Sales DESC
LIMIT 10;
-- Result (all 10 rows):
-- Customer Fname | Customer Lname | Total_Sales
-- Mary Smith | 4771645.88
-- Robert Smith | 152230.96
-- James Smith | 147924.43
-- David Smith | 145776.80
-- John Smith | 129882.58
-- William Smith | 108523.28
-- Michael Smith | 92843.03
-- Elizabeth Smith | 90516.02
-- Mary Jones | 88860.48
-- Christopher Smith | 85271.05

-- Q3. Regional demand: order count by region
SELECT `Order Region`, COUNT(*) AS Order_Count
FROM SUPPLYCHAIN
GROUP BY `Order Region`
ORDER BY Order_Count DESC;
-- Result (rows shown in full as returned):
-- Order Region | Order_Count
-- Central America | 28341
-- Western Europe | 27108
-- South America | 14935
-- Oceania | 10148
-- Northern Europe | 9791
-- Southeast Asia | 9538
-- Southern Europe | 9431
-- Caribbean | 8318
-- West of USA | 7993
-- South Asia | 7731
-- Eastern Asia | 7280
-- East of USA | 6915
-- West Asia | 6009
-- US Center | 5887
-- South of USA | 4045
-- Eastern Europe | 3920
-- West Africa | 3696
-- North Africa | 3232
-- East Africa | 1852
-- Central Africa | 1677
-- Southern Africa | 1157
-- (plus smaller regions below)

-- Q4. Above-average sales: orders above the overall average sale (subquery)
SELECT `Customer Fname`, `Sales`
FROM SUPPLYCHAIN
WHERE `Sales` > (
    SELECT AVG(`Sales`) FROM SUPPLYCHAIN
);
-- Result (first 10 rows shown):
-- Customer Fname | Sales
-- Cally | 327.75
-- Irene | 327.75
-- Gillian | 327.75
-- Tana | 327.75
-- Orli | 327.75
-- Kimberly | 327.75
-- Constance | 327.75
-- Erica | 327.75
-- Nichole | 327.75
-- Oprah | 327.75

-- Q5. Profitability: average profit per order by product category
SELECT `Category Name`, AVG(`Order Profit Per Order`) AS Avg_Profit
FROM SUPPLYCHAIN
GROUP BY `Category Name`
ORDER BY Avg_Profit DESC;
-- Result (rows shown in full as returned):
-- Category Name | Avg_Profit
-- Computers | 157.59
-- Garden | 69.10
-- Crafts | 52.75
-- Cameras | 51.17
-- Fishing | 43.65
-- Children's Clothing | 41.66
-- Sporting Goods | 35.07
-- Music | 33.26
-- Camping & Hiking | 31.14
-- Cardio Equipment | 30.67
-- Consumer Electronics | 30.60
-- Golf Bags & Carts | 29.67
-- Women's Clothing | 29.39
-- Soccer | 28.27
-- Women's Golf Clothing | 27.78
-- Basketball | 27.55
-- Health and Beauty | 26.23
-- Golf Shoes | 23.68
-- Kids' Golf Clubs | 23.56
-- Water Sports | 20.92
-- Boxing & MMA | 20.43
-- (plus smaller categories below)

-- Q6. Multi-product orders: orders containing more than one product
SELECT `Order Id`, COUNT(*) AS Product_Count
FROM SUPPLYCHAIN
GROUP BY `Order Id`
HAVING COUNT(*) > 1;
-- Result (first 10 rows shown):
-- Order Id | Product_Count
-- 28744 | 4
-- 45461 | 5
-- 31115 | 5
-- 45766 | 4
-- 47752 | 5
-- 50054 | 4
-- 20365 | 3
-- 32090 | 4
-- 34773 | 2
-- 44046 | 2

-- Q7. Product pairs purchase: products bought together in the same order (self-join)
SELECT A.`Order Id`,
       A.`Customer Id`,
       A.`Customer Fname`,
       A.`Customer Lname`,
       A.`Product Name` AS Product_1,
       B.`Product Name` AS Product_2
FROM SUPPLYCHAIN A
JOIN SUPPLYCHAIN B
  ON A.`Order Id` = B.`Order Id`
 AND A.`Product Card Id` < B.`Product Card Id`;
-- Result (first 10 rows shown):
-- Order Id | Customer Id | Customer Fname | Customer Lname | Product_1 | Product_2
-- 45461 | 4741 | Mary Smith | Nike Men's Dri-FIT Victory Golf Polo | Under Armour Girls' Toddler Spine Surge Runner
-- 31115 | 639 | Elizabeth Pittman | Nike Men's Free 5.0+ Running Shoe | Nike Men's Dri-FIT Victory Golf Polo
-- 47752 | 9114 | Mary Smith | Perfect Fitness Perfect Rip Deck | Nike Men's Dri-FIT Victory Golf Polo
-- 47752 | 9114 | Mary Smith | Perfect Fitness Perfect Rip Deck | Nike Men's Dri-FIT Victory Golf Polo
-- 50054 | 1362 | Dennis Smith | Nike Men's Free 5.0+ Running Shoe | Nike Men's Dri-FIT Victory Golf Polo
-- 32090 | 7864 | Alice Smith | Nike Men's Comfort 2 Slide | Perfect Fitness Perfect Rip Deck
-- 48434 | 9451 | Mary Smith | Nike Men's Dri-FIT Victory Golf Polo | Bridgestone e6 Straight Distance NFL San Diego
-- 63936 | 11329 | Hannah Smith | Nike Men's Free 5.0+ Running Shoe | Nike Men's Dri-FIT Victory Golf Polo
-- 64813 | 10018 | Gregory Rodriguez | Nike Men's Dri-FIT Victory Golf Polo | Under Armour Girls' Toddler Spine Surge Runner
-- 64813 | 10018 | Gregory Rodriguez | Perfect Fitness Perfect Rip Deck | Under Armour Girls' Toddler Spine Surge Runner

-- Q8. Customers with multiple orders: pairs of orders from the same customer (self-join)
SELECT A.`Customer Id`,
       A.`Customer Fname`,
       A.`Customer Lname`,
       A.`Order Id` AS Order_1,
       B.`Order Id` AS Order_2
FROM SUPPLYCHAIN A
JOIN SUPPLYCHAIN B
  ON A.`Customer Id` = B.`Customer Id`
 AND A.`Order Id` < B.`Order Id`;
-- Result (first 10 rows shown):
-- Customer Id | Customer Fname | Customer Lname | Order_1 | Order_2
-- 9702 | Katherine Tyler | 30305 | 45766
-- 9114 | Mary Smith | 7120 | 47752
-- 3296 | Mary Smith | 25988 | 36146
-- 7864 | Alice Smith | 24529 | 32090
-- 6122 | Johnny Smith | 15915 | 46599
-- 3570 | Mary Nelson | 60689 | 65030
-- 3570 | Mary Nelson | 60689 | 65030
-- 3182 | Frances Smith | 41234 | 67892
-- 9854 | Mary Smith | 44721 | 60807
-- 376 | Grace Sanchez | 20250 | 53413

-- Q9. Late delivery: orders whose delivery status is late
SELECT `Order Id`,
       `Order Region`,
       `Order State`,
       `Delivery Status`,
       `Product Name`,
       `Category Name`
FROM SUPPLYCHAIN
WHERE `Delivery Status` = 'Late delivery';
-- Result (first 10 rows shown):
-- Order Id | Order Region | Order State | Delivery Status | Product Name | Category Name
-- 75939 | South Asia | Rajastan | Late delivery | Smart watch | Sporting Goods
-- 75934 | Eastern Asia | Guangdong | Late delivery | Smart watch | Sporting Goods
-- 75933 | Eastern Asia | Guangdong | Late delivery | Smart watch | Sporting Goods
-- 75932 | Eastern Asia | Guangdong | Late delivery | Smart watch | Sporting Goods
-- 75931 | Eastern Asia | Guangdong | Late delivery | Smart watch | Sporting Goods
-- 75929 | Southeast Asia | Celebes Septentrional | Late delivery | Smart watch | Sporting Goods
-- 75928 | Southeast Asia | Celebes Septentrional | Late delivery | Smart watch | Sporting Goods
-- 75927 | South Asia | Maharashtra | Late delivery | Smart watch | Sporting Goods
-- 75926 | South Asia | Maharashtra | Late delivery | Smart watch | Sporting Goods
-- 75925 | South Asia | Maharashtra | Late delivery | Smart watch | Sporting Goods

-- Q10. High-value product pairs: product pairs from orders above the average sale (self-join + subquery)
SELECT A.`Order Id`,
       A.`Customer Id`,
       A.`Product Name` AS Product_1,
       B.`Product Name` AS Product_2,
       A.`Sales`
FROM SUPPLYCHAIN A
JOIN SUPPLYCHAIN B
  ON A.`Order Id` = B.`Order Id`
 AND A.`Product Card Id` < B.`Product Card Id`
WHERE A.`Sales` > (
    SELECT AVG(`Sales`) FROM SUPPLYCHAIN
);
-- Result (first 10 rows shown):
-- Order Id | Customer Id | Product_1 | Product_2 | Sales
-- 31115 | 639 | Nike Men's Free 5.0+ Running Shoe | Nike Men's Dri-FIT Victory Golf Polo | 499.95
-- 47752 | 9114 | Perfect Fitness Perfect Rip Deck | Nike Men's Dri-FIT Victory Golf Polo | 239.96
-- 50054 | 1362 | Nike Men's Free 5.0+ Running Shoe | Nike Men's Dri-FIT Victory Golf Polo | 299.97
-- 48434 | 9451 | Nike Men's Dri-FIT Victory Golf Polo | Bridgestone e6 Straight Distance NFL San Diego | 250
-- 63936 | 11329 | Nike Men's Free 5.0+ Running Shoe | Nike Men's Dri-FIT Victory Golf Polo | 299.97
-- 64813 | 10018 | Perfect Fitness Perfect Rip Deck | Under Armour Girls' Toddler Spine Surge Runner | 239.96
-- 6783 | 10759 | Nike Men's Free 5.0+ Running Shoe | Under Armour Girls' Toddler Spine Surge Runner | 499.95
-- 56973 | 8541 | Perfect Fitness Perfect Rip Deck | Nike Men's Dri-FIT Victory Golf Polo | 299.95
-- 51298 | 9272 | Nike Men's Dri-FIT Victory Golf Polo | Under Armour Girls' Toddler Spine Surge Runner | 250
-- =====================================================================
-- EXTENSION (added October 2026, NOT part of the original course project)
-- These three queries were written later to extend the analysis with
-- techniques beyond the original coursework: CTEs and window functions
-- (DENSE_RANK, LAG). They are kept separate from Q1-Q10 on purpose so the
-- original course work is not misrepresented.
-- Run them the same way (table: SUPPLYCHAIN) and attach their outputs here.
-- =====================================================================

-- E1. Top 3 customers per region by total sales (CTE + DENSE_RANK)
WITH regional_sales AS (
    SELECT `Order Region`,
           `Customer Fname`,
           `Customer Lname`,
           SUM(`Sales`) AS total_sales
    FROM SUPPLYCHAIN
    GROUP BY `Order Region`, `Customer Fname`, `Customer Lname`
),
ranked AS (
    SELECT `Order Region`,
           `Customer Fname`,
           `Customer Lname`,
           total_sales,
           DENSE_RANK() OVER (
               PARTITION BY `Order Region`
               ORDER BY total_sales DESC
           ) AS rnk
    FROM regional_sales
)
SELECT `Order Region`, `Customer Fname`, `Customer Lname`, total_sales
FROM ranked
WHERE rnk <= 3
ORDER BY `Order Region`, rnk;
-- Result (first 10 rows shown):
-- Order Region | Customer Fname | Customer Lname | total_sales
-- Canada | Mary Smith | 35288.18
-- Canada | Karen Smith | 2374.65
-- Canada | Pamela Smith | 2199.74
-- Caribbean | Mary Smith | 207031.42
-- Caribbean | James Smith | 7575.00
-- Caribbean | William Smith | 6689.39
-- Central Africa | Mary Smith | 42007.94
-- Central Africa | Adam Smith | 3419.64
-- Central Africa | Heather Smith | 3219.73
-- Central America | Mary Smith | 785334.36

-- E2. Monthly sales trend with month-over-month change (CTE + LAG)
-- Note: the source dates are in M/D/YYYY form (e.g. 1/10/2015), so the month is
-- extracted with STR_TO_DATE + DATE_FORMAT, not by chopping the string.
-- Note: the first row's prev_month_sales and mom_change are NULL by design:
-- LAG has no previous row to compare against for the first month.
WITH monthly AS (
    SELECT DATE_FORMAT(STR_TO_DATE(`order date (DateOrders)`, '%c/%e/%Y'), '%Y-%m') AS order_month,
           SUM(`Sales`) AS month_sales
    FROM SUPPLYCHAIN
    WHERE `order date (DateOrders)` IS NOT NULL
      AND `order date (DateOrders)` <> ''
    GROUP BY order_month
)
SELECT order_month,
       month_sales,
       LAG(month_sales) OVER (ORDER BY order_month) AS prev_month_sales,
       month_sales - LAG(month_sales) OVER (ORDER BY order_month) AS mom_change
FROM monthly
WHERE order_month IS NOT NULL
ORDER BY order_month;
-- Result (first 12 months shown, rounded to 2 decimals; 37 months total, 2015-01 to 2018-01):
-- order_month | month_sales | prev_month_sales | mom_change
-- 2015-01 | 1051590.08 | NULL | NULL
-- 2015-02 | 927009.90 | 1051590.08 | -124580.18
-- 2015-03 | 1051253.69 | 927009.90 | 124243.79
-- 2015-04 | 1014463.28 | 1051253.69 | -36790.41
-- 2015-05 | 1050478.44 | 1014463.28 | 36015.16
-- 2015-06 | 1024006.17 | 1050478.44 | -26472.27
-- 2015-07 | 1038081.19 | 1024006.17 | 14075.02
-- 2015-08 | 1029494.69 | 1038081.19 | -8586.50
-- 2015-09 | 1018338.60 | 1029494.69 | -11156.09
-- 2015-10 | 1049154.27 | 1018338.60 | 30815.67
-- 2015-11 | 1029120.24 | 1049154.27 | -20034.03
-- 2015-12 | 1057840.88 | 1029120.24 | 28720.64

-- E3. Late delivery rate by region (CTE + conditional aggregation)
WITH regional AS (
    SELECT `Order Region`,
           COUNT(*) AS total_orders,
           SUM(CASE WHEN `Delivery Status` = 'Late delivery' THEN 1 ELSE 0 END) AS late_orders
    FROM SUPPLYCHAIN
    GROUP BY `Order Region`
)
SELECT `Order Region`,
       total_orders,
       late_orders,
       late_orders / total_orders AS late_rate
FROM regional
ORDER BY late_rate DESC;
-- Result (rows shown in full as returned, rounded to 4 decimals):
-- Order Region | total_orders | late_orders | late_rate
-- Central Africa | 1677 | 972 | 0.5796
-- South Asia | 7731 | 4350 | 0.5627
-- East Africa | 1852 | 1036 | 0.5594
-- Western Europe | 27108 | 15139 | 0.5585
-- South of USA | 4045 | 2256 | 0.5577
-- East of USA | 6915 | 3849 | 0.5566
-- Eastern Europe | 3920 | 2182 | 0.5566
-- Southeast Asia | 9538 | 5297 | 0.5554
-- Central Asia | 553 | 306 | 0.5533
-- West Asia | 6009 | 3322 | 0.5528
-- US Center | 5887 | 3252 | 0.5524
-- Central America | 28341 | 15518 | 0.5475
-- North Africa | 3232 | 1762 | 0.5452
-- Southern Europe | 9431 | 5129 | 0.5438
-- Eastern Asia | 7280 | 3955 | 0.5433
-- South America | 14935 | 8111 | 0.5431
-- Northern Europe | 9791 | 5292 | 0.5405
-- (plus smaller regions below)

-- E4. Above-average customers: customers spending more than the average customer (CTE + subquery + aggregation)
-- Note: grouped by Customer Id, not just by name, so different customers who share a name are not merged.
WITH customer_totals AS (
    SELECT `Customer Id`,
           `Customer Fname`,
           `Customer Lname`,
           SUM(`Sales`) AS total_sales
    FROM SUPPLYCHAIN
    GROUP BY `Customer Id`, `Customer Fname`, `Customer Lname`
)
SELECT `Customer Fname`, `Customer Lname`, total_sales
FROM customer_totals
WHERE total_sales > (
    SELECT AVG(total_sales) FROM customer_totals
)
ORDER BY total_sales DESC
LIMIT 20;
-- Result (all 20 rows, rounded to 2 decimals):
-- Customer Fname | Customer Lname | total_sales
-- Mary Smith | 10524.17
-- Mary Patterson | 9299.03
-- Mary Duncan | 9296.14
-- Betty Phillips | 9223.71
-- Betty Spears | 9130.92
-- Evelyn Thompson | 9019.11
-- Ashley Smith | 9019.10
-- Mary Butler | 8918.85
-- Jerry Smith | 8904.95
-- Mary Mata | 8761.98
-- Kelly Smith | 8595.13
-- Amber Dixon | 8409.22
-- Joseph Singh | 8404.22
-- Bobby Jimenez | 8394.26
-- Teresa Gray | 8339.26
-- Ashley Smith | 8293.04
-- Paul Smith | 8279.89
-- Judy Miller | 8275.09
-- (plus 2 more rows below, 20 total)

