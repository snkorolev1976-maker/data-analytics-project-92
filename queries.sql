/*запрос возвращает общее количество покупателей из таблицы customers*/

SELECT
    COUNT(customer_id) AS customers_count
FROM customers;


/* отчет о десятке лучших продаж. Смущают большие числа income */

SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS seller,
    COUNT(s.sales_id) AS operations,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM sales AS s
JOIN employees AS e
    ON e.employee_id = s.sales_person_id
JOIN products AS p
    ON p.product_id = s.product_id
GROUP BY
    seller
ORDER BY
    income DESC
LIMIT 10;


/*отчет содержит информацию о продавцах, чья средняя выручка за сделку меньше средней выручки за сделку по всем продавцам*/

SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS seller,
    FLOOR(AVG(s.quantity * p.price)) AS average_income
FROM sales AS s
JOIN employees AS e
    ON e.employee_id = s.sales_person_id
JOIN products AS p
    ON p.product_id = s.product_id
GROUP BY
    seller
HAVING
    AVG(s.quantity * p.price) < (
        SELECT
            AVG(s2.quantity * p2.price)
        FROM sales AS s2
        JOIN products AS p2
            ON p2.product_id = s2.product_id
    )
ORDER BY
    average_income DESC;


/* Информация о выручке по дням недели*/

SELECT
    CONCAT(e.first_name, ' ', e.last_name) AS seller,
    TRIM(TO_CHAR(s.sale_date, 'day')) AS day_of_week,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM sales AS s
JOIN employees AS e
    ON e.employee_id = s.sales_person_id
JOIN products AS p
    ON p.product_id = s.product_id
GROUP BY
    seller,
    day_of_week
ORDER BY
    day_of_week,
    seller;


/* Запрос возвращает количество покупателей в различных возврастных группах*/

SELECT
    CASE
        WHEN age BETWEEN 16 AND 25 THEN '16-25'
        WHEN age BETWEEN 26 AND 40 THEN '26-40'
        WHEN age > 40 THEN '40+'
    END AS age_category,
    COUNT(c.customer_id) AS age_count
FROM customers AS c
GROUP BY
    1
ORDER by
1;


/*Данные по количеству уникальных покупателей и выручке, которую они принесли*/

SELECT
    TO_CHAR(s.sale_date, 'YYYY-MM') AS selling_month,
    COUNT(DISTINCT s.customer_id) AS total_customers,
    FLOOR(SUM(s.quantity * p.price)) AS income
FROM customers AS c
JOIN sales AS s
    ON c.customer_id = s.customer_id
JOIN products AS p
    ON s.product_id = p.product_id
GROUP BY
    1
ORDER BY
    1;


/* отчет о покупателях, первая покупка которых была в ходе проведения акций*/

WITH rn_sales AS (
    SELECT
        customer_id,
        sale_date,
        product_id,
        sales_person_id,
        ROW_NUMBER() OVER (
            PARTITION BY customer_id
            ORDER BY sale_date, sales_id
        ) AS rn
    FROM sales
)
SELECT
    CONCAT(c.first_name, ' ', c.last_name) AS customer,
    rnc.sale_date AS sale_date,
    CONCAT(e.first_name, ' ', e.last_name) AS seller
FROM rn_sales AS rnc
JOIN customers AS c
    ON c.customer_id = rnc.customer_id
JOIN products AS p
    ON p.product_id = rnc.product_id
JOIN employees AS e
    ON e.employee_id = rnc.sales_person_id
WHERE
    p.price = 0
    AND rnc.rn = 1
ORDER BY
    1;















