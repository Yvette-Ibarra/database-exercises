-- Temporary_tables.sql Exercises --

# Create a file named temporary_tables.sql to do your work for this exercise.
USE mirzakhani_1931;
/* 1 Using the example from the lesson, create a temporary table called employees_with_departments
 that contains first_name, last_name, and dept_name for employees currently with that department. 
 Be absolutely sure to create this table on your own database. If you see "Access denied for user ...", 
 it means that the query was attempting to write a new table to a database that you can only read. */
 
 CREATE TEMPORARY TABLE employees_with_departments AS(
 SELECT e.first_name, e.last_name, d.dept_name
 FROM employees.employees e
 JOIN employees.dept_emp de ON de.emp_no =e.emp_no
 JOIN employees.departments d ON d.dept_no = de.dept_no);
 
 SELECT *
 FROM employees_with_departments;
 
 
/* a Add a column named full_name to this table. It should be a VARCHAR whose length is the sum of 
the lengths of the first name and last name columns */

ALTER TABLE employees_with_departments ADD full_name VARCHAR(30);


/* b Update the table so that full name column contains the correct data 	*/

UPDATE employees_with_departments
SET full_name = CONCAT(first_name, ' ', last_name);

 SELECT *
 FROM employees_with_departments; 
/* c Remove the first_name and last_name columns from the table.	 */

ALTER TABLE employees_with_departments 
DROP COLUMN first_name, 
DROP COLUMN last_name;

 SELECT *
 FROM employees_with_departments; 
/* d What is another way you could have ended up with this same table?	*/

# WE could have concat the first name and last name at the creation of the temporary table
 
 CREATE TEMPORARY TABLE employees_with_departments AS(
 SELECT  CONCAT(e.first_name, e.last_name), d.dept_name
 FROM employees.employees e
 JOIN employees.dept_emp de ON de.emp_no =e.emp_no
 JOIN employees.departments d ON d.dept_no = de.dept_no);

/* 2 Create a temporary table based on the payment table from the sakila database.
Write the SQL necessary to transform the amount column such that it is stored as an integer
 representing the number of cents of the payment. For example, 1.99 should become 199. */
 CREATE TEMPORARY TABLE payment_table AS(
 SELECT s.payment_id, s.customer_id, s.staff_id, s.rental_Id, ROUND(s.amount*100,0) AS pennies_amount,
 s.payment_date, s.last_update
 FROM sakila.payment s);
 
 SELECT *
 FROM payment_table;

ALTER TABLE  payment_table ADD p_amount INT;

UPDATE payment_table
SET p_amount = pennies_amount;

ALTER TABLE payment_table DROP COLUMN pennies_amount;

/* 3 Find out how the current average pay in each department compares to the overall current pay 
for everyone at the company. In order to make the comparison easier, you should use the Z-score 
for salaries. In terms of salary, what is the best department right now to work for? The worst? */

CREATE TEMPORARY TABLE compare_salary AS (
SELECT d.dept_name, s.salary
FROM employees.salaries s
JOIN employees.dept_emp de ON de.emp_no = s.emp_no
	AND de.to_date < CURDATE()
    AND s.to_date < CURDATE()
JOIN employees.departments d ON d.dept_no = de.dept_no);

SELECT *
FROM compare_salary;

ALTER TABLE compare_salary 
ADD department_current_avg FLOAT(15,5), 
ADD overall_avg FLOAT(15,5),
ADD overall_std FLOAT(15,5),
ADD zscore FLOAT(15,5);

UPDATE compare_salary
SET overall_avg =(
					SELECT AVG(s.salary) 
					FROM employees.salaries s
                    WHERE s.to_date > CURDATE()
);




/* Hint Consider that the following code will produce the z score for current salaries.

-- Returns the historic z-scores for each salary
-- Notice that there are 2 separate scalar subqueries involved
SELECT salary,
    (salary - (SELECT AVG(salary) FROM salaries))
    /
    (SELECT stddev(salary) FROM salaries) AS zscore
FROM salaries;
BONUS To your work with current salary zscores, determine the overall historic average departement
 average salary, the historic overall average, and the historic zscores for salary. Do the zscores 
 for current department average salaries tell a similar or a different story than the historic 
 department salary zscores? */