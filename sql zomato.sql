SELECT ROUND(SUM(total_amount)/1000000, 2) AS total_sales_in_Millons
FROM orders
WHERE status = 'Delivered';





SELECT DATE_FORMAT(STR_TO_DATE(order_date, '%d-%m-%Y %H:%i'), '%Y-%m') AS month,
       ROUND(SUM(total_amount), 2) AS total_sales
FROM orders
WHERE status = 'Delivered'
GROUP BY month
ORDER BY month;


SELECT r.name, ROUND(SUM(o.total_amount), 2) AS total_sales
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.name
ORDER BY total_sales DESC
LIMIT 10;



SELECT r.cuisine_type, COUNT(o.order_id) AS total_orders, ROUND(SUM(o.total_amount), 2) AS total_sales
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
WHERE o.status = 'Delivered'
GROUP BY r.cuisine_type
ORDER BY total_sales DESC;



SELECT ROUND(
    COUNT(DISTINCT customer_id) / (SELECT COUNT(*) FROM customers) * 100, 2
) AS repeat_customer_percentage
FROM orders
WHERE customer_id IN (
    SELECT customer_id FROM orders GROUP BY customer_id HAVING COUNT(order_id) > 1
);


SELECT ROUND(AVG(total_amount), 2) AS average_order_value
FROM orders
WHERE status = 'Delivered';


SELECT c.customer_id, c.name, ROUND(SUM(o.total_amount), 2) AS lifetime_value
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
WHERE o.status = 'Delivered'
GROUP BY c.customer_id, c.name
ORDER BY lifetime_value DESC
limit 15;



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



SELECT r.name, r.rating, COUNT(o.order_id) AS total_orders
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.name, r.rating
HAVING r.rating < 2 AND total_orders >11;



SELECT payment_mode, COUNT(*) AS order_count, ROUND(SUM(total_amount), 2) AS total_sales
FROM orders
WHERE status = 'Delivered'
GROUP BY payment_mode
ORDER BY total_sales DESC;



SELECT status, COUNT(*) AS total_orders
FROM orders
GROUP BY status
ORDER BY total_orders DESC;



SELECT ROUND(AVG(distance), 2) AS avg_distance_km
FROM deliveries
WHERE delivery_status = 'Delivered';


SELECT dp.name, round(SUM(o.total_amount) ,2)AS total_revenue
FROM deliveries d
JOIN delivery_persons dp ON d.delivery_person_id = dp.delivery_person_id
JOIN orders o ON d.order_id = o.order_id
GROUP BY dp.name
ORDER BY total_revenue DESC
LIMIT 5;




SELECT HOUR(STR_TO_DATE(order_date, '%d-%m-%Y %H:%i')) AS hour_of_day,
       COUNT(*) AS order_count
FROM orders
GROUP BY hour_of_day
ORDER BY order_count DESC
LIMIT 12;



SELECT is_premium, COUNT(*) AS customer_count, ROUND(SUM(o.total_amount), 2) AS total_sales
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY is_premium;




SELECT is_active, COUNT(o.order_id) AS total_orders
FROM restaurants r
JOIN orders o ON r.restaurant_id = o.restaurant_id
GROUP BY is_active;




SELECT r.cuisine_type, ROUND(AVG(o.feedback_rating), 2) AS avg_feedback
FROM orders o
JOIN restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.cuisine_type
ORDER BY avg_feedback DESC;


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






