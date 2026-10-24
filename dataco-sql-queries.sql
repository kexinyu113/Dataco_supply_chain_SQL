-- DataCo Smart Supply Chain: Queries & Results
-- Course group project (Group 4A). All SQL queries in this file were written by Kexin Yu.
-- The queries run against the source table SUPPLYCHAIN (DataCo dataset, 2015-2018, 180,000+ records).
-- Reconstructed from the project presentation deck (Queries & Results, pp. 10-14).

-- Q1. High-value customers: single orders with sales over 1000
SELECT `Customer Fname`, `Customer Lname`, `Sales`
FROM SUPPLYCHAIN
WHERE `Sales` > 1000;

-- Q2. Top customers by total sales
SELECT `Customer Fname`, `Customer Lname`, SUM(`Sales`) AS Total_Sales
FROM SUPPLYCHAIN
GROUP BY `Customer Fname`, `Customer Lname`
ORDER BY Total_Sales DESC
LIMIT 10;

-- Q3. Regional demand: order count by region
SELECT `Order Region`, COUNT(*) AS Order_Count
FROM SUPPLYCHAIN
GROUP BY `Order Region`
ORDER BY Order_Count DESC;

-- Q4. Above-average sales: orders above the overall average sale (subquery)
SELECT `Customer Fname`, `Sales`
FROM SUPPLYCHAIN
WHERE `Sales` > (
    SELECT AVG(`Sales`) FROM SUPPLYCHAIN
);

-- Q5. Profitability: average profit per order by product category
SELECT `Category Name`, AVG(`Order Profit Per Order`) AS Avg_Profit
FROM SUPPLYCHAIN
GROUP BY `Category Name`
ORDER BY Avg_Profit DESC;

-- Q6. Multi-product orders: orders containing more than one product
SELECT `Order Id`, COUNT(*) AS Product_Count
FROM SUPPLYCHAIN
GROUP BY `Order Id`
HAVING COUNT(*) > 1;

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

-- Q9. Late delivery: orders whose delivery status is late
SELECT `Order Id`,
       `Order Region`,
       `Order State`,
       `Delivery Status`,
       `Product Name`,
       `Category Name`
FROM SUPPLYCHAIN
WHERE `Delivery Status` = 'Late delivery';

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
