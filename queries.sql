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