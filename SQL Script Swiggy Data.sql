CREATE DATABASE IF NOT EXISTS swiggy_analytics;
USE swiggy_analytics;

USE swiggy_analytics;

DROP TABLE IF EXISTS swiggy_restaurants;

CREATE TABLE swiggy_restaurants (
    restaurant_id INT PRIMARY KEY,
    area VARCHAR(100),
    city VARCHAR(50),
    restaurant_name VARCHAR(150),
    price_for_two DECIMAL(10, 2),
    avg_rating DECIMAL(3, 1),
    total_ratings INT,
    food_type VARCHAR(255),
    address VARCHAR(255),
    delivery_time_mins INT
);






-- Write a query to retrieve all columns and rows from the swiggy_restaurants table
--  (limited to the first 100 rows for performance).


SELECT 
    *
FROM
    swiggy_restaurants
LIMIT 100









-- Find the names, area, and ratings of all restaurants located in "Mumbai".


SELECT 
    restaurant_name, avg_rating, area
FROM
    swiggy_restaurants
WHERE
    city = 'mumbai'





-- List all restaurants where the price_for_two is less than or equal to ₹300.




SELECT 
    restaurant_name, price_for_two
FROM
    swiggy_restaurants
WHERE
    price_for_two <= 300;






-- Find all restaurants that have an avg_rating greater than or equal to 4.5.



SELECT 
    restaurant_name, avg_rating
FROM
    swiggy_restaurants
WHERE
    avg_rating >= 4.5








-- Find all restaurants in "Delhi" that offer "Fast Food" 
-- and have a delivery time under 40 minutes.



SELECT 
    restaurant_name, city, food_type, delivery_time_mins
FROM
    swiggy_restaurants
WHERE
    delivery_time_mins < 40










-- Find the names of all restaurants that contain the word "Cafe"
--  anywhere in their name using the LIKE operator.



SELECT 
    restaurant_name
FROM
    swiggy_restaurants
WHERE
    restaurant_name LIKE 'Cafe%';






-- Retrieve all restaurant details where the city is either 
-- "Bangalore", "Chennai", or "Hyderabad" using IN.



SELECT 
    *
FROM
    swiggy_restaurants
WHERE
    city IN ('Bangalore' , 'Chennai', 'Hyderabad');







-- Find all records where specific fields might be missing or unrated.




SELECT * 
FROM swiggy_restaurants
WHERE restaurant_name IS NULL OR restaurant_name = ''
   OR city IS NULL OR city = ''
   OR area IS NULL OR area = ''
   OR food_type IS NULL OR food_type = ''
   OR price_for_two IS NULL OR price_for_two = 0
   OR avg_rating IS NULL OR avg_rating = 0
   OR total_ratings IS NULL OR total_ratings = 0
   OR delivery_time_mins IS NULL OR delivery_time_mins = 0 ;








-- Create a query that labels restaurants based on price: mark them as 
-- 'Affordable' if price_for_two is under 350, and 'Premium' otherwise.




SELECT 
    restaurant_name,
    price_for_two,
    CASE
        WHEN price_for_two <= 350 THEN 'Affordable'
        ELSE 'Premium'
    END AS Conditional_Categorization
FROM
    swiggy_restaurants






-- Use a CASE statement to categorize delivery times into 'Fast (Under 30m)', 
-- 'Moderate (30-45m)', and 'Slow (45m+)'.




SELECT 
    delivery_time_mins,
    CASE
        WHEN delivery_time_mins <= '30' THEN 'Fast'
        WHEN delivery_time_mins BETWEEN 30 AND 45 THEN 'Moderate'
        WHEN delivery_time_mins >= '45' THEN 'Slow'
    END AS Delivery_Speed_Classification
FROM
    swiggy_restaurants;
            








-- Group the restaurants by city and count 
-- the total number of restaurants operating in each city.




SELECT 
    city, COUNT(*) AS Total_Restaurants
FROM
    swiggy_restaurants
GROUP BY city











-- Calculate the average price_for_two for each unique
 -- food_type, ordered from most expensive to cheapest.



SELECT 
    food_type, AVG(price_for_two) AS Average_Price
FROM
    swiggy_restaurants
GROUP BY food_type
ORDER BY Average_Price DESC;






-- Find the maximum delivery_time_mins recorded for each city.



SELECT 
    city, MAX(delivery_time_mins) AS Maximum_Delivery_Time
FROM
    swiggy_restaurants
GROUP BY city







-- Find food types where the average price for two is greater than ₹500.



SELECT 
    food_type, AVG(price_for_two) AS Average_Price
FROM
    swiggy_restaurants
GROUP BY food_type
HAVING Average_Price > '500'








-- Group by avg_rating to find the total count of restaurants
-- and the sum of total_ratings for each score, keeping only scores with 
-- over 100 restaurants.





SELECT 
    avg_rating, 
    COUNT(restaurant_name) AS total_restaurants, 
    SUM(total_ratings) AS Total_Rating
FROM 
    swiggy_restaurants
GROUP BY 
    avg_rating
HAVING 
    COUNT(restaurant_name) > 100;










-- Find all details for restaurants whose price_for_two 
-- is strictly higher than the overall average price of the entire dataset.






SELECT 
    price_for_two, restaurant_name
FROM
    swiggy_restaurants
WHERE
    price_for_two > (SELECT 
            AVG(price_for_two) AS avg_price
        FROM
            swiggy_restaurants)













-- Find restaurants that match the minimum delivery
-- time recorded in their respective cities.





SELECT 
    city, MIN(delivery_time_mins) AS Minimum_Delivery_Time
FROM
    swiggy_restaurants
GROUP BY city
ORDER BY Minimum_Delivery_Time ASC;











-- Use a Common Table Expression (CTE) with ROW_NUMBER() to select the 
-- top 2 most expensive restaurants in every city.



WITH RankedRestaurants AS (
    SELECT 
        city,
        restaurant_name,
        price_for_two,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY price_for_two DESC) AS rn
    FROM 
        swiggy_restaurants
)
SELECT 
    city,
    restaurant_name,
    price_for_two
FROM 
    RankedRestaurants
WHERE 
    rn <= 2;











-- Write a query using RANK() to rank all restaurants within each city from 
-- the most expensive to the least expensive based on price_for_two. 
-- Select city, restaurant_name, price_for_two, and your rank column.



select price_for_two, restaurant_name, city ,
rank() over ( partition by city order by price_for_two desc ) as price_rank
from swiggy_restaurants;










-- Rank restaurants within each food_type based on their avg_rating from highest to lowest. 
-- Include the food_type, 
-- restaurant_name, avg_rating, and the rank in your output.



SELECT 
    restaurant_name, 
    avg_rating, 
    food_type, 
    RANK() OVER (PARTITION BY food_type ORDER BY avg_rating DESC) AS Average_Rank
FROM 
    swiggy_restaurants;





-- Use a Common Table Expression (CTE) with ROW_NUMBER() to select the 
-- top 2 most expensive restaurants in every city.



WITH RankedRestaurants AS (
    SELECT 
        city,
        restaurant_name,
        price_for_two,
        ROW_NUMBER() OVER (PARTITION BY city ORDER BY price_for_two DESC) AS rn
    FROM 
        swiggy_restaurants
)
SELECT 
    city,
    restaurant_name,
    price_for_two
FROM 
    RankedRestaurants
WHERE 
    rn <= 2;



-- Assign a rank to restaurants inside each city based on their delivery_time_mins in 
-- ascending order (fastest deliveries getting rank 1). 
-- Select city, restaurant_name, delivery_time_mins, and the rank.


SELECT 
    city, 
    restaurant_name, 
    delivery_time_mins, 
    RANK() OVER (PARTITION BY city ORDER BY delivery_time_mins ASC) AS Delivery_Time_Rank
FROM 
    swiggy_restaurants;






































