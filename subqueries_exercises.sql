-- Subqueries --
/* Create a file named subqueries_exercises.sql and craft queries to return the results 
for the following criteria: */

Use employees;
/* 1 Find all the current employees with the same hire date as employee 101010 using a 
sub-query. */


SELECT *
FROM employees e1 
JOIN dept_emp de ON e1.emp_no = de.emp_no
	AND de.to_date >CURDATE()
WHERE e1.hire_date =(
						SELECT e.hire_date
						FROM employees e
						WHERE e.emp_no = 101010
					);


/* 2 Find all the titles ever held by all current employees with the first name Aamod. */
 

# Answer with Subquery
SELECT title, COUNT(title)
FROM titles t
JOIN dept_emp de ON t.emp_no = de.emp_no
	AND de.to_date >CURDATE()
WHERE t.emp_no IN (
					SELECT emp_no
					FROM employees
					WHERE first_name = 'Aamod'
				)
		AND t.to_date > CURDATE()
GROUP BY title;		

/* Subquery
SELECT emp_no
FROM employees
WHERE first_name = 'Aamod'; */


/* 3 How many people in the employees table are no longer working for the company? 
Give the answer in a comment in your code. */

# 59,900 employees are no loger working for the company

SELECT count(emp_no)
FROM employees
WHERE emp_no IN (SELECT emp_no
FROM dept_emp
GROUP BY emp_no
HAVING MAX(to_date) < CURDATE());

/* SUBQUERY
SELECT emp_no
FROM dept_emp
GROUP BY emp_no
HAVING MAX(to_date) < CURDATE(); 

SELECT *
FROM dept_emp; */
 
 
 
;
/* 4 Find all the current department managers that are female. List their names in a 
comment in your code. */

# LIST of department manager that are female :Hilary Kambil, Isamu Legleitner, Karsten Sigstam, Leon DasSarma

SELECT e.first_name, e.last_name
FROM dept_manager dm
JOIN employees e
	ON dm.emp_no = e.emp_no
WHERE e.emp_no IN( SELECT emp_no
FROM employees
WHERE gender = 'F') AND to_date > CURDATE();

/* Subquery
SELECT emp_no, gender
FROM employees
WHERE gender = 'F'; */



/* 5 Find all the employees who currently have a higher salary than the companies overall, 
historical average salary. */

#154543 employees curently have a higher salary that the historical average salary

#ANSWER without JOIN TABLE
SELECT count(*)
FROM employees
WHERE emp_no IN (
					SELECT emp_no
					FROM salaries
					WHERE to_date>CURDATE()
						AND salary >(
										SELECT AVG(salary)
										FROM salaries
									)
				);
#ANSWER with JOIN TABLE
SELECT count(*)
FROM employees
JOIN salaries
	ON employees.emp_no = salaries.emp_no
    AND salaries.to_date > CURDATE()
WHERE salary > (
										SELECT AVG(salary)
										FROM salaries
									
				);


SELECT *
FROM salaries
WHERE salaries.to_date>CURDATE();

/* Subquery
SELECT AVG(salary)
FROM salaries; */

/* 6 How many current salaries are within 1 standard deviation of the current highest salary?
 (Hint: you can use a built in function to calculate the standard deviation.) What percentage 
 of all salaries is this?
Hint You will likely use multiple subqueries in a variety of ways
Hint It's a good practice to write out all of the small queries that you can. Add a comment 
above the query showing the number of rows returned. You will use this number (or the query that 
produced it) in other, larger queries. */

# I GOT 83 RETURNED
SELECT count(salary)
FROM salaries
WHERE salary BETWEEN (
						(SELECT MAX(salary)
						FROM salaries
						WHERE to_date > CURDATE()) 
                        - (SELECT STDDEV(salary)
						FROM salaries
						WHERE to_date > CURDATE()) 
                        )
				AND (
						(SELECT MAX(salary)
						FROM salaries
						WHERE to_date > CURDATE())
                        +(SELECT STDDEV(salary)
						FROM salaries
						WHERE to_date > CURDATE()) 
					)
				AND to_date > CURDATE();
                
#  0.0346 % of all salaries are withing one standard deviation of the max salary
SELECT 
(SELECT count(salary)
FROM salaries
WHERE salary BETWEEN (
						(SELECT MAX(salary)
						FROM salaries
						WHERE to_date > CURDATE()) 
                        - (SELECT STDDEV(salary)
						FROM salaries
						WHERE to_date > CURDATE()) 
                        )
				AND (
						(SELECT MAX(salary)
						FROM salaries
						WHERE to_date > CURDATE())
                        +(SELECT STDDEV(salary)
						FROM salaries
						WHERE to_date > CURDATE()) 
					)
				AND to_date > CURDATE()) /

(SELECT count(salary)
FROM salaries
WHERE to_date >CURDATE()) * 100 AS s
FROM salaries
GROUP BY s;

/* SUBQUERIES

SELECT STDDEV(salary)
FROM salaries
WHERE to_date > CURDATE();

SELECT MAX(salary)
FROM salaries
WHERE to_date > CURDATE();
*/

-- BONUS--

/* 1 Find all the department names that currently have female managers.*/

SELECT d.dept_name
FROM dept_manager dm
JOIN departments d ON d.dept_no = dm.dept_no
	AND to_date > CURDATE()
WHERE dm.emp_no IN (
					SELECT emp_no
					FROM employees
					WHERE gender = 'F'
				);
/* Subquery
SELECT *
FROM employees
WHERE gender = 'F'; */

/* 2 Find the first and last name of the employee with the highest salary. */

SELECT *
FROM employees;

SELECT *
FROM salaries
WHERE to_date > CURDATE()
ORDER BY salary DESC;

SELECT *
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
WHERE to_date > CURDATE()
	AND salary =  (
					SELECT MAX(salary)
					FROM salaries
					WHERE to_date > CURDATE()
				)
	;

/* 3 Find the department name that the employee with the highest salary works in. */

SELECT *
FROM departments
WHERE dept_no = (
					SELECT de.dept_no
					FROM dept_emp  de
					JOIN salaries s
					ON de.emp_no = s.emp_no
					AND s.to_date > CURDATE()
					AND salary IN (
									SELECT MAX(salary)
									FROM salaries
									WHERE to_date > CURDATE()
                                    )
					);



    
/* subquery
    
SELECT de.dept_no
FROM dept_emp  de
JOIN salaries s
	ON de.emp_no = s.emp_no
    AND s.to_date > CURDATE()
    AND salary IN (SELECT MAX(salary)
					FROM salaries
                    WHERE to_date > CURDATE());
                    

