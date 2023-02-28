-- SQL WINDOW FUNCTION| How to write SQL using PRATITION BY, RANK,DENSE RANK, LEAD, LAG--
/* Queries are from youtube tutorial from techTFQ Using Codeup Employees Database*/

USE employees;

# table with all information needed
SELECT emp_no, CONCAT(first_name," ", last_name),dept_name, s.salary
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate();

# max salary over all
SELECT  MAX(s.salary)
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate();

# max salary by department
SELECT dept_name, MAX(s.salary)
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate()
group by dept_name;

# max salary  with employee details
/* When OVER() is used it creates one window and gives the same one overall max salary */
SELECT emp_no, CONCAT(first_name," ", last_name),dept_name, s.salary, 
				MAX(s.salary) OVER() as max_salary
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate();

# max salary by department with employee details
/* When OVER() (PARTITION.. is Used a window per department is created and max salary per department are displayed */
SELECT emp_no, CONCAT(first_name," ", last_name),dept_name, s.salary, 
				MAX(s.salary) OVER(PARTITION BY dept_name) as max_salary
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate();

# Assign row number to query
/* When OVER() is used row numbers are created. Only one window is created */
SELECT emp_no, CONCAT(first_name," ", last_name),dept_name, s.salary, 
				ROW_NUMBER() OVER() as rn
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate();

# Assign row number to query by department name
/* When OVER() is used row numbers are created per department name. Only one window is created 
*For some reason dept_name did not work and I replace with dept_no for the Function to work*/
SELECT emp_no, CONCAT(first_name," ", last_name),d.dept_name, s.salary, 
				ROW_NUMBER() OVER(PARTITION by d.dept_no) as rn
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments d USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate();

# Fetch the first 2 current employees from each department to join the company 
/* create a subquery and use where clause on row_number*/
SELECT * from(
	SELECT emp_no, CONCAT(first_name," ", last_name),d.dept_name, s.salary, 
				ROW_NUMBER() OVER(PARTITION by d.dept_no order by emp_no)  as rn
	FROM employees
	JOIN dept_emp USING (emp_no)
	JOIN departments d USING (dept_no)
	JOIN salaries s USING (emp_no)
	WHERE s.to_date>curdate())x
WHERE x.rn <3;

# Fetch the top 3 current employees in each department earning the max salary.
/* RANK orders in asc or desc, will skip a ranking value when duplicates appear */
SELECT * FROM(	
    SELECT emp_no, CONCAT(first_name," ", last_name),d.dept_name, s.salary, 
					RANK() OVER(PARTITION BY dept_name ORDER BY s.salary desc) as rnk
	FROM employees
	JOIN dept_emp USING (emp_no)
	JOIN departments d USING (dept_no)
	JOIN salaries s USING (emp_no)
	WHERE s.to_date>curdate()) x
WHERE x.rnk <4;

# Using DENSE Rank, Dense rank will not skip a ranking value if duplicate values have the same rank (RANK will skip a value)
SELECT * FROM(	
    SELECT emp_no, CONCAT(first_name," ", last_name),d.dept_name, s.salary, 
					DENSE_RANK() OVER(PARTITION BY dept_name ORDER BY s.salary desc) as dense_rnk
	FROM employees
	JOIN dept_emp USING (emp_no)
	JOIN departments d USING (dept_no)
	JOIN salaries s USING (emp_no)
	WHERE s.to_date>curdate()) x
WHERE x.rnk <4;

# Fetch a query to display the salary of previous employee
/* LAG is the record from the  previous row */
SELECT emp_no, CONCAT(first_name," ", last_name),d.dept_name, s.salary, 
				LAG(salary) OVER(PARTITION by d.dept_no ORDER BY emp_no) as prev_emp_salary
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments d USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate();

# Fetch a query to display the salary with a LAG of 2 and a defaul value for null.
/* LAG(name_of_columne, How many rows back, default null value)*/
SELECT emp_no, CONCAT(first_name," ", last_name),d.dept_name, s.salary, 
				LAG(salary,2,0) OVER(PARTITION by d.dept_no ORDER BY emp_no) as prev_emp_salary
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments d USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate();

# Fetch a query to display the value of salary in the next record
/* LEAD show the next record */
SELECT emp_no, CONCAT(first_name," ", last_name),d.dept_name, s.salary, 
				LEAD(salary) OVER(PARTITION by d.dept_no ORDER BY emp_no) as next_emp_salary
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments d USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate();

# Fetch  a query to diaplay if the salary of an employee is higher, lower or equal to the previous employee.
SELECT emp_no, CONCAT(first_name," ", last_name),d.dept_name, s.salary, 
				LAG(salary) OVER(PARTITION by d.dept_no ORDER BY emp_no) as prev_emp_salary,
                CASE when s.salary > lag(salary) OVER (PARTITION by d.dept_name ORDER BY emp_no)
							THEN 'Higher than previous employee'
					 when s.salary < lag(salary) OVER (PARTITION by d.dept_name ORDER BY emp_no)
							THEN 'Lower than previous employee'
					 when s.salary = lag(salary) OVER (PARTITION by d.dept_name ORDER BY emp_no)
							THEN 'Equal than previous employee' 
				END salary_range
                            
FROM employees
JOIN dept_emp USING (emp_no)
JOIN departments d USING (dept_no)
JOIN salaries s USING (emp_no)
WHERE s.to_date>curdate();