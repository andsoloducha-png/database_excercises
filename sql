--ZADANIE 1 29.11:

CREATE TABLE regions(region_id INT PRIMARY KEY,
                     region_name VARCHAR2(50));

CREATE TABLE countries(country_id CHAR(2) PRIMARY KEY,
                       country_name VARCHAR2(40) NOT NULL,
                       region_id INT);

CREATE TABLE locations(location_id INT PRIMARY KEY,
                       street_address VARCHAR2(100),
                       postal_code VARCHAR2(12),
                       city VARCHAR2(50) NOT NULL,
                       state_province VARCHAR2(50),
                       country_id CHAR(2));

CREATE TABLE departments(department_id INT PRIMARY KEY,
                         department_name VARCHAR2(50) NOT NULL,
                         manager_id INT,
                         location_id INT);

CREATE TABLE jobs(job_id VARCHAR2(10) PRIMARY KEY,
                  job_title VARCHAR2(50) NOT NULL,
                  min_salary NUMBER(10,2),
                  max_salary NUMBER(10,2),
                  CHECK (max_salary - min_salary >= 2000));

CREATE TABLE employees(employee_id INT PRIMARY KEY,
                       first_name VARCHAR2(30),
                       last_name VARCHAR2(30) NOT NULL,
                       email VARCHAR2(100),
                       phone_number VARCHAR2(20),
                       hire_date DATE NOT NULL,
                       job_id VARCHAR2(10) NOT NULL,
                       salary NUMBER(10,2),
                       commission_pct NUMBER(5,2),
                       manager_id INT,
                       department_id INT);

CREATE TABLE job_history(employee_id INT NOT NULL,
                         start_date DATE NOT NULL,
                         end_date DATE,
                         job_id VARCHAR2(10) NOT NULL,
                         department_id INT,
                         CONSTRAINT job_hist_pk PRIMARY KEY(employee_id, start_date));
                         
ALTER TABLE countries ADD FOREIGN KEY(region_id) REFERENCES regions(region_id);

ALTER TABLE locations ADD FOREIGN KEY(country_id) REFERENCES countries(country_id);

ALTER TABLE departments ADD FOREIGN KEY(location_id) REFERENCES locations(location_id);

ALTER TABLE employees ADD FOREIGN KEY(department_id) REFERENCES departments(department_id);

ALTER TABLE employees ADD FOREIGN KEY(job_id) REFERENCES jobs(job_id);

ALTER TABLE employees ADD FOREIGN KEY(manager_id) REFERENCES employees(employee_id);

ALTER TABLE departments ADD FOREIGN KEY(manager_id) REFERENCES employees(employee_id);

ALTER TABLE job_history ADD FOREIGN KEY(employee_id) REFERENCES employees(employee_id);

ALTER TABLE job_history ADD FOREIGN KEY(job_id) REFERENCES jobs(job_id);

ALTER TABLE job_history ADD FOREIGN KEY(department_id) REFERENCES departments(department_id);


--ZADANIE 2 29.11:

DROP TABLE employees;
FLASHBACK TABLE employees TO BEFORE DROP


--ZADANIE 1 30.11:

INSERT INTO regions(region_id, region_name) VALUES (1, 'Europa');
INSERT INTO regions(region_id, region_name) VALUES (2, 'Azja');
INSERT INTO regions(region_id, region_name) VALUES (3, 'Afryka');
INSERT INTO regions(region_id, region_name) VALUES (4, 'Ameryka');

--ZADANIE 2 30.11:

INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
VALUES ('J1', 'Programista', 3000, 7000);
INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
VALUES ('J2', 'Administrator', 3500, 8000);
INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
VALUES ('J3', 'Księgowy', 2500, 6000);
INSERT INTO jobs(job_id, job_title, min_salary, max_salary)
VALUES ('J4', 'Kierownik', 5000, 10000);

--ZADANIE 3 30.11:

UPDATE regions
SET region_name = 'Euroazja'
WHERE region_name IN ('Europa', 'Azja')

--ZADANIE 4 30.11:

UPDATE jobs
SET min_salary = min_salary + 1000,
    max_salary = max_salary + 1000
WHERE LOWER(job_title) LIKE '%a%'
   OR LOWER(job_title) LIKE '%o%';
   
--ZADANIE 5 30.11

DELETE FROM jobs
WHERE min_salary > 5000;

--ZADANIE 5 (a-f) (SELECT)
--a
SELECT first_name, last_name
FROM employees;

--b
SELECT first_name ||' '|| last_name AS full_name
FROM employees
WHERE salary > 4000;

--c
SELECT first_name, last_name, salary
FROM employees
WHERE salary BETWEEN 3000 AND 7000
  AND (last_name LIKE '%a%' OR last_name LIKE '%e%');
  
--d
SELECT first_name, last_name, department_id
FROM employees
WHERE department_id IN (10, 20, 50, 70, 80, 100)

--e
SELECT DISTINCT department_id 
FROM employees;

--f
SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date ASC
FETCH FIRST 5 ROWS ONLY;

--g
SELECT COUNT(*) AS liczba_departamentow
FROM departments;

--h
SELECT job_id,
       MIN(salary) AS min_salary,
       MAX(salary) AS max_salary
FROM employees
GROUP BY job_id;

--i
SELECT first_name,
       last_name,
       EXTRACT(YEAR FROM hire_date) AS hire_year
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) BETWEEN 2005 AND 2007
ORDER BY first_name;

--j
SELECT first_name,
       last_name,
       salary + salary * NVL(commission_pct, 0) AS total_salary
FROM employees;

--k
SELECT NVL(TO_CHAR(department_id), 'brak ID') AS department_id,
       AVG(salary) AS avg_salary
FROM employees
WHERE EXTRACT(YEAR FROM hire_date) BETWEEN 2006 AND 2010
GROUP BY department_id;

--l
SELECT department_id,
       COUNT(*) AS liczba_pracownikow
FROM employees
GROUP BY department_id
HAVING COUNT(*) > 2;

--m
SELECT NVL(TO_CHAR(department_id), 'brak ID') AS department_id,
       COUNT(DISTINCT job_id) AS liczba_stanowisk
FROM employees
GROUP BY department_id;

--n
SELECT NVL(TO_CHAR(department_id), 'brak ID') AS department_id,
       SUM(salary) AS suma_zarobkow
FROM employees
GROUP BY department_id
HAVING AVG(salary) > 5000;

-- 1 strona 10
SELECT last_name || ' ' || salary AS wynagrodzenie
FROM employees
WHERE department_id IN (20, 50)
  AND salary BETWEEN 2000 AND 7000
ORDER BY last_name;

--2 stona 10
SELECT e.last_name,
       e.department_id,
       d.department_name,
       e.job_id
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations   l ON d.location_id = l.location_id
WHERE l.city = 'Toronto';

-- 3 strona 10
SELECT d.department_name,
       SUM(e.salary)        AS suma_zarobkow,
       ROUND(AVG(e.salary)) AS srednia_zarobkow
FROM employees e
JOIN departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING MIN(e.salary) > 5000


-- 4 strona 10
SELECT j.first_name  AS imie_jennifer,
       j.last_name   AS nazwisko_jennifer,
       c.first_name  AS imie_wspolpracownika,
       c.last_name   AS nazwisko_wspolpracownika
FROM employees j
JOIN employees c ON j.department_id = c.department_id
AND j.employee_id  <> c.employee_id
WHERE j.first_name = 'Jennifer';

-- 5 strona 10
SELECT department_id, department_name
FROM departments d
WHERE NOT EXISTS (
    SELECT *
    FROM employees e
    WHERE e.department_id = d.department_id
);

-- 6 strona 10
CREATE TABLE job_grades AS
SELECT *
FROM hr.job_grades;

-- 7 strona 10
SELECT e.first_name,
       e.last_name,
       e.job_id,
       d.department_name,
       e.salary,
       jg.grade
FROM employees e
LEFT JOIN departments d ON e.department_id = d.department_id
LEFT JOIN job_grades jg ON e.salary BETWEEN jg.min_salary AND jg.max_salary;

-- 8 
SELECT first_name,
       last_name,
       salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- 9
SELECT employee_id,
       first_name,
       last_name
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM employees
    WHERE last_name LIKE '%u%'
);
-- 10
SELECT hire_date,
       last_name,
       &podaj_kolumne --salary
FROM employees
WHERE manager_id IS NOT NULL
  AND EXTRACT(YEAR FROM hire_date) = 2005
ORDER BY 3 

-- 11
SELECT first_name || ' ' || last_name AS imie_nazwisko,
       salary,
       phone_number
FROM employees
WHERE SUBSTR(last_name, 3, 1) = 'e'
  AND first_name LIKE '%' || '&imie_fragment' || '%' 
ORDER BY 1 DESC, 2 ASC;

-- 12
SELECT first_name,
       last_name,
       ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS liczba_miesiecy,
       CASE
           WHEN ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) <= 150
                THEN salary * 0.10
           WHEN ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) > 150
            AND ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) <= 200
                THEN salary * 0.20
           ELSE
                salary * 0.30
       END AS wysokosc_dodatku
FROM employees
ORDER BY liczba_miesiecy;


-- strona 12 widoki

-- a
CREATE OR REPLACE VIEW v_emp_sales AS
SELECT e.employee_id,
       e.last_name,
       e.first_name
FROM employees e
JOIN departments d ON e.department_id = d.department_id
WHERE d.department_name = 'Sales';

-- b
CREATE OR REPLACE VIEW v_emp_3k_10k AS
SELECT employee_id,
       last_name,
       first_name,
       salary,
       job_id,
       email,
       hire_date
FROM employees
WHERE salary BETWEEN 3000 AND 10000;

-- c
-- próba dodania 
INSERT INTO v_emp_3k_10k(employee_id, last_name, first_name, salary, job_id, email, hire_date)
VALUES (999, 'Nowak', 'Jan', 5000, 'IT_PROG', 'JAN.NOWAK', DATE '2024-01-01');

-- próba edytowania 
UPDATE v_emp_3k_10k
SET salary = 6000
WHERE employee_id = 999;

-- próba usunięcia
DELETE FROM v_emp_3k_10k
WHERE employee_id = 999;

-- d
CREATE OR REPLACE VIEW v_dept_stats AS
SELECT d.department_name,
       AVG(e.salary) AS avg_salary,
       SUM(e.salary) AS sum_salary
FROM departments d
JOIN employees e ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(*) >= 2;

-- e
INSERT INTO v_dept_stats(department_name, avg_salary, sum_salary)
VALUES ('Test', 5000, 10000);

-- f
CREATE OR REPLACE VIEW v_emp_3k_10k_chk AS
SELECT employee_id,
       last_name,
       first_name,
       salary,
       job_id,
       email,
       hire_date
FROM employees
WHERE salary BETWEEN 3000 AND 10000
WITH CHECK OPTION;

-- próba dodania danych z zarobkami pomiędzy 3000 oraz 10000 - ok
INSERT INTO v_emp_3k_10k_chk(employee_id, last_name, first_name, salary, job_id, email, hire_date)
VALUES (1000, 'Kowalski', 'Adam', 8000, 'IT_PROG', 'ADAM.KOWALSKI', DATE '2024-01-01');

-- próba dodania pracownika zarabiającego powyżej 10000 - błąd ORA-01402: naruszenie klauzuli WHERE dla perspektywy z WITH CHECK OPTION
INSERT INTO v_emp_3k_10k_chk(employee_id, last_name, first_name, salary, job_id, email, hire_date)
VALUES (1001, 'Nowak', 'Piotr', 15000, 'IT_PROG', 'PIOTR.NOWAK', DATE '2024-01-01');


--10.01.2026

-- zad 2
SELECT e.last_name,
       p.product_name,
       s.price,
       s.quantity * s.price AS suma_dnia,
       LAG(s.price)  OVER (PARTITION BY s.product_id ORDER BY s.sale_date) AS poprzednia_cena,
       LEAD(s.price) OVER (PARTITION BY s.product_id ORDER BY s.sale_date) AS kolejna_cena
FROM sales s
JOIN employees e ON e.employee_id = s.employee_id
JOIN products  p ON p.product_id = s.product_id;

-- zad 3
SELECT p.product_name,
       s.price,
       SUM(s.quantity * s.price) OVER (
           PARTITION BY s.product_id, TRUNC(s.sale_date, 'MM')
       ) AS suma_miesiac,
       SUM(s.quantity * s.price) OVER (
           PARTITION BY s.product_id, TRUNC(s.sale_date, 'MM')
           ORDER BY s.sale_date
       ) AS suma_narastajaco
FROM sales s
JOIN products p ON p.product_id = s.product_id;

-- zad 4
WITH prices_2022 AS (
    SELECT product_id, price, sale_date
    FROM sales
    WHERE EXTRACT(YEAR FROM sale_date) = 2022
),
prices_2023 AS (
    SELECT product_id, price, sale_date
    FROM sales
    WHERE EXTRACT(YEAR FROM sale_date) = 2023
)
SELECT p2.product_id,
       p2.price AS price_2022,
       p3.price AS price_2023,
       p2.sale_date,
       p3.sale_date
FROM prices_2022 p2
JOIN prices_2023 p3
  ON p2.product_id = p3.product_id
 AND EXTRACT(MONTH FROM p2.sale_date) = EXTRACT(MONTH FROM p3.sale_date)
 AND EXTRACT(DAY   FROM p2.sale_date) = EXTRACT(DAY   FROM p3.sale_date);
 
 --zad 5
 SELECT p.product_category,
       p.product_name,
       s.price,
       ROUND (AVG(s.price) OVER (PARTITION BY p.product_category), 2) AS avg_kategoria,
       ROUND (AVG(s.price) OVER (
           PARTITION BY p.product_category
           ORDER BY p.product_name, s.sale_date
       ), 2) AS avg_narastajaca
FROM sales s
JOIN products p ON p.product_id = s.product_id;

--zad 6
SELECT p.product_name,
       s.sale_date,
       s.price,
       ROUND (AVG(s.price) OVER (
           PARTITION BY s.product_id
           ORDER BY s.sale_date
           ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING
       ), 2) AS srednia_kroczaca
FROM sales s
JOIN products p ON p.product_id = s.product_id;

-- zad 7
SELECT p.product_name,
       p.product_category,
       s.price,
       RANK()       OVER (PARTITION BY p.product_category ORDER BY s.price) AS rank_price_category,
       ROW_NUMBER() OVER (PARTITION BY p.product_category ORDER BY s.price) AS order_price_category,
       DENSE_RANK() OVER (PARTITION BY p.product_category ORDER BY s.price) AS dense_rank_price_category
FROM sales s
JOIN products p ON s.product_id = p.product_id;

--zad 8

SELECT e.last_name,
       p.product_name,
       s.sale_date,
       s.quantity * s.price AS wartosc,
       SUM(s.quantity * s.price) OVER (
           PARTITION BY s.employee_id
           ORDER BY s.sale_date
       ) AS wartosc_narastajaco,
       RANK() OVER (ORDER BY s.quantity * s.price DESC) AS ranking
FROM sales s
JOIN employees e ON e.employee_id = s.employee_id
JOIN products  p ON p.product_id = s.product_id;

--zad 9
SELECT DISTINCT e.first_name,
                e.last_name,
                e.job_id
FROM employees e
JOIN sales s ON s.employee_id = e.employee_id;






