#1. Total Sales Revenue

SELECT ROUND(SUM(total_amount)/1000000, 2) AS total_sales_in_Millons
FROM orders
WHERE status = 'Delivered';



#2. Monthly Sales Trend

SELECT DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y %H:%i'), '%Y-%m') AS month,
       ROUND(SUM(total_amount), 2) AS total_sales
FROM orders
WHERE status = 'Delivered'
GROUP BY month
ORDER BY month;



#3. Top 10 Restaurants by Sales

SELECT r.name, ROUND(SUM(o.total_amount), 2) AS total_sales
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.name
ORDER BY total_sales DESC
LIMIT 10;



#4. Top Selling Cuisine Types

SELECT r.cuisine_type, COUNT(o.order_id) AS total_orders, ROUND(SUM(o.total_amount), 2) AS total_sales
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.cuisine_type
ORDER BY total_sales DESC;



#5.	Repeat Customer Rate

SELECT ROUND(
    COUNT(DISTINCT customer_id) / (SELECT COUNT(*) FROM customers) * 100, 2
) AS repeat_customer_percentage
FROM orders
WHERE customer_id IN (
    SELECT customer_id FROM orders GROUP BY customer_id HAVING COUNT(order_id) > 1
);



#6. Average Order Value (AOV)

SELECT ROUND(AVG(total_amount), 2) AS average_order_value
FROM orders
WHERE status = 'Delivered';



#7. Customer Lifetime Value (CLV)

SELECT c.customer_id, c.name, ROUND(SUM(o.total_amount), 2) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC
limit 15;



#8. Delivery Speed Impact on Ratings

SELECT delivery_status, 
       ROUND(AVG(feedback_rating), 2) AS avg_rating
FROM (
    SELECT 
        CASE 
            WHEN d.delivery_time <= d.estimated_time THEN 'On Time'
            ELSE 'Late'
        END AS delivery_status,
        o.feedback_rating
    FROM deliveries d
    JOIN orders o 
        ON d.order_id = o.order_id
) AS sub
GROUP BY delivery_status;



#9. Restaurants with Low Ratings but High Orders

SELECT r.name, r.rating, COUNT(o.order_id) AS total_orders
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.name, r.rating
HAVING r.rating < 2 AND total_orders >11;



#10. Most Profitable Payment Method

SELECT payment_mode, COUNT(*) AS order_count, ROUND(SUM(total_amount), 2) AS total_sales
FROM orders
WHERE status = 'Delivered'
GROUP BY payment_mode
ORDER BY total_sales DESC;



#11. Cancellation Reasons Analysis

SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;



#12. Average Delivery Distance

SELECT ROUND(AVG(distance), 2) AS avg_distance_km
FROM deliveries
WHERE delivery_status = 'Delivered';



#13. Top Delivery Persons by Revenue Generated

SELECT dp.name, round(SUM(o.total_amount) ,2)AS total_revenue
FROM deliveries d
JOIN delivery_persons dp ON d.delivery_person_id = dp.delivery_person_id
JOIN orders o ON d.order_id = o.order_id
GROUP BY dp.name
ORDER BY total_revenue DESC
LIMIT 5;



#14. Time of Day with Most Orders(TOP 12 HOURS)

SELECT HOUR(STR_TO_DATE(order_date, '%d-%m-%Y %H:%i')) AS hour_of_day,
       COUNT(*) AS order_count
FROM orders
GROUP BY hour_of_day
ORDER BY order_count DESC
LIMIT 12;



#15. Premium vs Non-Premium Customer Revenue

SELECT is_premium, COUNT(*) AS customer_count, ROUND(SUM(o.total_amount), 2) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY is_premium;



#16. Orders per Active vs Inactive Restaurant

SELECT is_active, COUNT(o.order_id) AS total_orders
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY is_active;



#17. Feedback Ratings by Cuisine Type

SELECT r.cuisine_type, ROUND(AVG(o.feedback_rating), 2) AS avg_feedback
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.cuisine_type
ORDER BY avg_feedback DESC;



#18. Delivery Time Efficiency vs Sales

SELECT 
    r.name AS restaurant_name,
    ROUND(AVG(d.delivery_time), 2) AS avg_delivery_time,
    ROUND(SUM(o.total_amount), 2) AS total_sales
FROM deliveries d
JOIN orders o ON d.order_id = o.order_id
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.name
ORDER BY total_sales DESC
limit 20;






