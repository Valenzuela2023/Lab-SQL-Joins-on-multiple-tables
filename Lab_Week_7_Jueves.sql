-- Lab | SQL Joins on multiple tables
-- In this lab, you will be using the Sakila database of movie rentals.

-- Instructions
-- Write a query to display for each store its store ID, city, and country.
-- Write a query to display how much business, in dollars, each store brought in.
-- What is the average running time of films by category?
-- Which film categories are longest?
-- Display the most frequently rented movies in descending order.
-- List the top five genres in gross revenue in descending order.
-- Is "Academy Dinosaur" available for rent from Store 1?

use Sakila;

-- 1) Write a query to display for each store its store ID, city, and country.

SELECT s.store_id, ci.city, co.country
FROM store s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- 2)Write a query to display how much business, in dollars, each store brought in.

SELECT s.store_id, SUM(p.amount) AS total_sales
FROM store s
JOIN staff st ON s.manager_staff_id = st.staff_id
JOIN payment p ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- 3) What is the average running time of films by category?

SELECT c.name AS category, AVG(f.length) AS avg_running_time
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

-- 4) Which film categories are longest?
WITH Category_details AS ( 
SELECT c.name AS category, MAX(f.length) AS max_running_time, rank() over (order by max(f.length) DESC) AS RANKING
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY max_running_time DESC)
SELECT * FROM Category_details
WHERE RANKING = 1;

SELECT c.name AS category, MAX(f.length) AS max_running_time, rank() over (order by max(f.length) DESC) AS RANKING
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name;

-- 5) Display the most frequently rented movies in descending order.

SELECT f.title AS film_title, COUNT(*) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC;

-- 6) List the top five genres in gross revenue in descending order.

SELECT c.name AS category, SUM(p.amount) AS total_revenue
FROM payment p
JOIN rental r ON p.rental_id = r.rental_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_revenue DESC
LIMIT 5;

-- 7) Is "Academy Dinosaur" available for rent from Store 1?

SELECT 
    CASE 
        WHEN COUNT(*) > 0 THEN 'Yes'
        ELSE 'No'
    END AS available_for_rent
FROM 
    film f
JOIN 
    inventory i ON f.film_id = i.film_id
JOIN 
    store s ON i.store_id = s.store_id
WHERE 
    f.title = 'Academy Dinosaur' AND s.store_id = 1;
-- CASE ... END AS available_for_rent: Esto es una expresión de caso condicional. Evalúa una condición y devuelve un valor basado en esa condición. 
-- En este caso, la condición es COUNT(*) > 0, lo que significa que cuenta el número de filas que cumplen cierta condición. 
-- Si el conteo es mayor que 0, se devuelve 'Yes'; de lo contrario, se devuelve 'No'. El resultado de esta expresión se asigna a una nueva columna llamada available_for_rent
