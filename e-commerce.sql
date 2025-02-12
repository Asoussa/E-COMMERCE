CREATE DATABASE e_comm;

CREATE TABLE transactionn (
    CustomerID INT,
    OrderID INT,
    Product VARCHAR(255),
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    PurchaseDate DATE,
    Country VARCHAR(255)
);

INSERT INTO transactionn (CustomerID, OrderID, Product, Quantity, UnitPrice, PurchaseDate, Country)
VALUES
    (12345, 1001, 'T-shirt', 2, 15.00, '2022-07-15 08:30:00', 'USA'),
    (12346, 1002, 'Bicycle', 1, 200.00, '2022-07-15 09:00:00', 'Canada'),
    (12347, 1003, 'Water bottle', 5, 8.00, '2022-07-16 10:00:00', 'UK'),
    (12348, 1004, 'Backpack', 2, 45.00, '2022-07-16 11:30:00', 'USA'),
    (12349, 1005, 'Sunglasses', 1, 25.00, '2022-07-17 12:45:00', 'Australia'),
    (12350, 1006, 'Notebook', 4, 12.00, '2022-07-18 13:00:00', 'India'),
    (12351, 1007, 'Tablet', 1, 350.00, '2022-07-19 14:25:00', 'Germany'),
    (12352, 1008, 'Smartphone', 1, 700.00, '2022-07-20 15:45:00', 'France'),
    (12353, 1009, 'Camera', 1, 250.00, '2022-07-21 16:00:00', 'Spain'),
    (12354, 1010, 'Headphones', 2, 75.00, '2022-07-22 17:35:00', 'Italy');
    
TRUNCATE TABLE transactionn;


################## solving the null value #################

SET SQL_SAFE_UPDATES = 0;
UPDATE transactionn
SET OrderID = 0
WHERE OrderID IS NULL;
SET SQL_SAFE_UPDATES = 1;
############# to konw if there are dublicate value ############


SELECT OrderID, COUNT(*)
FROM transactionn
GROUP BY OrderID
HAVING COUNT(*) = 1;

######################## filtering #######################
####### 1
SELECT * FROM transactionn WHERE Country = 'USA';

###### 2. Extract orders where the total spend (Quantity * UnitPrice) exceeds $500. ##########
SELECT Product, (Quantity * UnitPrice) AS TotalSales 
FROM transactionn
WHERE (Quantity * UnitPrice) > 500
ORDER BY TotalSales DESC;

########3. Identify customers who purchased more than 3 different products. #######
SELECT CustomerID, COUNT(DISTINCT Product) AS ProductCount
FROM transactionn
GROUP BY CustomerID
HAVING ProductCount > 3;

              ### Time-Based Filters: ####### 
 ###### Filter transactions that occurred in July 2022. ####
SELECT * FROM transactionn
WHERE PurchaseDate BETWEEN '2022-07-01' AND '2022-07-20';

#### Extract orders placed during weekends. ####
SELECT * FROM transactionn
WHERE DAYOFWEEK(PurchaseDate) IN (5,6);


#### Identify transactions during specific sales events, like Black Friday or Cyber Monday. ###
SELECT * FROM transactionn
WHERE DAYOFWEEK(PurchaseDate) = 6;

                  ### Sorting Data ###
 ######### Total spend in descending order ############
SELECT CustomerID, SUM(Quantity * UnitPrice) AS total_spend
FROM transactionn
GROUP BY CustomerID
ORDER BY total_spend DESC
LIMIT 2;

######## Purchase date in ascending order ###########
SELECT DISTINCT PurchaseDate FROM transactionn
ORDER BY PurchaseDate ASC;


######## Product name alphabetically #########
SELECT DISTINCT Product FROM transactionn
ORDER BY Product ASC;

######## Rank customers based on their total spending ######
SELECT CustomerID, RANK() OVER (ORDER BY SUM(Quantity * UnitPrice) DESC) AS Rankk
FROM transactionn
GROUP BY CustomerID;


######## Aggregated Analysis: Extra grad ##########
############# Calculate the total amount spent by each customer and find the top 10 spenders. 
SELECT CustomerID, SUM(Quantity * UnitPrice) AS total_spent
FROM transactionn
GROUP BY CustomerID
ORDER BY total_spent DESC
LIMIT 10;

############2. Group data by Country and analyze the total revenue generated per country###########
SELECT DISTINCT Country, SUM(Quantity * UnitPrice) AS total_spent 
FROM transactionn
GROUP BY Country
ORDER BY total_spent DESC;

############## 3. Identify which country has the highest average transaction value. ##############
SELECT Country, AVG(Quantity * UnitPrice) AS avg_transaction_value 
FROM transactionn
GROUP BY Country
ORDER BY avg_transaction_value DESC
LIMIT 1;

                ##### Product Analysis: ######
######### Find the most purchased product and its total quantity sold.######## 
SELECT Product, SUM(Quantity), UnitPrice, SUM(Quantity * UnitPrice) 
FROM transactionn
GROUP BY Product, UnitPrice
ORDER BY SUM(Quantity) DESC
LIMIT 1;

######### Identify the product that generated the highest revenue. ##########
SELECT Product, SUM(Quantity * UnitPrice) AS thelestsales 
FROM transactionn
GROUP BY Product
ORDER BY thelestsales DESC
LIMIT 1;

##### Determine the top 3 least popular products based on sales quantity. #######
SELECT Product, SUM(Quantity * UnitPrice) AS thelestsales 
FROM transactionn
GROUP BY Product
ORDER BY thelestsales ASC
LIMIT 3;

               ####### Time-Based Insights: ########
########## Analyze the total revenue generated per day in July 2022. #######
SELECT DAY(PurchaseDate), SUM(Quantity * UnitPrice) AS totalsales 
FROM transactionn
WHERE PurchaseDate BETWEEN '2022-07-01' AND '2022-07-20' 
GROUP BY DAY(PurchaseDate)
ORDER BY totalsales DESC;

######## Find the day with the highest total revenue. ##########
SELECT DAY(PurchaseDate), SUM(Quantity * UnitPrice) AS totalsales 
FROM transactionn
GROUP BY DAY(PurchaseDate)
ORDER BY totalsales DESC
LIMIT 1;

            ######### Advanced Insights: Extra grad ###########
########## Create a column for total spend per transaction (Quantity * UnitPrice). ###########
ALTER TABLE transactionn
ADD COLUMN totalspend DECIMAL(10,2);

SET SQL_SAFE_UPDATES = 0;
UPDATE transactionn
SET totalspend = (Quantity * UnitPrice);
SET SQL_SAFE_UPDATES = 1;


########## Use quantites to identify the top 10% of transactions based on total spend. ##########
SELECT ROUND(COUNT(*) * 0.10) FROM transactionn;

SELECT *, (Quantity * UnitPrice) AS TotalSpend
FROM transactionn
ORDER BY TotalSpend DESC
LIMIT 1;

             ## Analyze purchasing trends by country:###
########## - Identify the most popular product in each country. ######
SELECT Country, Product, SUM(Quantity) AS TotalQuantity
FROM transactionn
GROUP BY Country, Product
ORDER BY Country;


##########- Determine the average order value per country. ########
SELECT Country, AVG(totalspend) 
FROM transactionn
GROUP BY Country
ORDER BY AVG(totalspend) DESC;
