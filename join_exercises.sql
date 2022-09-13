-- Join Example Database --
USE join_example_db;

# 1 Use the join_example_db. Select all the records from both the users and roles tables.

SELECT *
FROM users;

SELECT *
FROM roles;

/* 2 Use join, left join, and right join to combine results from the users and roles tables 
as we did in the lesson. Before you run each query, guess the expected number of results. */

#	LEFT JOIN may drop/null rows from the right table(roles) and duplicate some rows.
#	It will also keep all the rows in the LEFT table (users). */

SELECT *
FROM users
LEFT JOIN roles ON users.role_id = roles.id;

#	RIGHT JOIN may drop/NULL rows from the left table (users) and keep all the rows 
#	from the right table(roles)
SELECT *
FROM users
RIGHT JOIN roles ON users.role_id = roles.id;

/* 3 Although not explicitly covered in the lesson, aggregate functions like count can be 
used with join queries. Use count and the appropriate join type to get a list of roles along 
with the number of users that has the role. Hint: You will also need to use group by in the query.*/

 #correction should be right join and count(users.name)
 
SELECT roles.name, COUNT(users.name) AS number_or_users
FROM users
RIGHT JOIN roles ON users.role_id = roles.id
GROUP BY roles.name;

-- Employees Database --
/*.1  Use the employees database.*/
USE employees;
/* 2 Using the example in the Associative Table Joins section as a guide, write a query that 
shows each department along with the name of the current manager for that department.	*/

SELECT d.dept_name AS Department_name,
      CONCAT(  e.first_name,
        e.last_name) AS Department_Manager
FROM departments AS d
LEFT JOIN dept_manager AS dm
	ON d.dept_no= dm.dept_no
LEFT JOIN employees AS e
	ON e.emp_no = dm.emp_no
WHERE to_date like '999%'
ORDER BY Department_name;

# different Answer
SELECT d.dept_name AS 'Department Name',
	CONCAT(e.first_name, ' ', e.last_name) AS 'Department MAnager'
FROM employees AS e
JOIN dept_manager AS dm 
	ON e.emp_no = dm.emp_no
    AND dm.to_date > CURDATE() 	# use AND instead of WHERE
JOIN departments AS d 
	USING(dept_no); # using will match only if the column name match, shortcut

/* 3 Find the name of all departments currently managed by women.	*/

SELECT d.dept_name AS Department_name,
        CONCAT(e.first_name, e.last_name) AS Manager_name
FROM departments AS d
LEFT JOIN dept_manager AS dm
	ON d.dept_no= dm.dept_no
LEFT JOIN employees AS e
	ON e.emp_no = dm.emp_no
WHERE to_date like '999%' AND e.gender ='F'
ORDER BY Department_name;

#different way with shortcuts
SELECT d.dept_name AS 'Department Name',
	CONCAT(e.first_name, ' ', e.last_name) AS 'Department MAnager'
FROM employees AS e
JOIN dept_manager AS dm 
	ON e.emp_no = dm.emp_no
    AND dm.to_date > CURDATE()
    AND e.gender = 'F'	#can use AND under JOIN to be used as a WHERE
JOIN departments AS d 
	USING(dept_no);

/* 4 Find the current titles of employees currently working in the Customer Service department.	*/

SELECT t.title,count(t.title)
FROM  titles AS t
JOIN dept_emp AS de
	ON t.emp_no = de.emp_no
WHERE de.dept_no = 'd009' 
	AND de.to_date = '9999-01-01' 
    AND  t.to_date LIKE '999%'
GROUP BY t.title
ORDER by t.title;

# different answer with shorcuts
SELECT t.title,
	COUNT(de.emp_no) AS 'Count'
FROM dept_emp de
JOIN titles t ON de.emp_no = t.emp_no
	AND t.to_date > CURDATE()
    AND de.to_date > CURDATE()
JOIN departments d ON de.dept_no = d.dept_no
	AND d.dept_name = 'Customer SERVICE'
GROUP BY t.title;




/* 5 Find the current salary of all current managers.	 */

SELECT d.dept_name AS Department_name,
      CONCAT(  e.first_name,
        e.last_name) AS Department_Manager, s.salary
FROM departments AS d
LEFT JOIN dept_manager AS dm
	ON d.dept_no= dm.dept_no
LEFT JOIN employees AS e
	ON e.emp_no = dm.emp_no
LEFT JOIN salaries AS s
	ON s.emp_no = e.emp_no
WHERE dm.to_date like '999%'AND s.to_date LIKE '99%'
ORDER BY Department_name;

# different answer
SELECT d.dept_name AS 'Department Name', 
	CONCAT(e.first_name, ' ', e.last_name) AS 'Name',
    s.salary AS 'Salary'
FROM employees e
JOIN salaries s ON e.emp_no = s.emp_no
	AND s.to_date > CURDATE()
JOIN dept_manager dm ON e.emp_no =dm.emp_no	
	AND dm.to_date > CURDATE()
JOIN departments d ON dm.dept_no = d.dept_no
ORDER BY d.dept_name;


/* 6 Find the number of current employees in each department.	*/

SELECT de.dept_no, d.dept_name, COUNT(de.emp_no) AS num_employees
FROM employees AS e 
LEFT JOIN dept_emp AS de
	ON de.emp_no = e.emp_no
LEFT JOIN departments AS d
	ON de.dept_no = d.dept_no
WHERE to_date LIKE '999%'
GROUP BY de.dept_no
ORDER BY dept_no;

# Different Answer
SELECT d.dept_no,
		d.dept_name,
        COUNT(emp_no) AS num_employees
FROM dept_emp de
JOIN departments d ON de.dept_no =d.dept_no
	AND de.to_date > CURDATE()
GROUP BY d.dept_no, d.dept_name
ORDER BY d.dept_no;

/* 7 Which department has the highest average salary? Hint: Use current not historic information.	*/

SELECT d.dept_name,
	AVG(s.salary)AS average_salary
FROM dept_emp AS de
LEFT JOIN salaries AS s
	ON de.emp_no = s.emp_no
LEFT JOIN departments AS d
	ON d.dept_no = de.dept_no
WHERE s.to_date LIKE '999%' 
GROUP BY  d.dept_name
ORDER BY average_salary desc
LIMIT  1;

# Differen Answer
 
 SELECT d.dept_name,
	ROUND(AVG(s.salary), 2) AS average_salary
 FROM dept_emp de
 JOIN salaries s ON de.emp_no = s.emp_no
	AND de.to_date > CURDATE()		# need current employees
	AND s.to_date > CURDATE() 		#need current salary
JOIN departments d 
	ON de.dept_no = d.dept_no
GROUP BY d.dept_name
ORDER BY average_salary DESC
LIMIT 1;
    

/* 8 Who is the highest paid employee in the Marketing department? 	*/

SELECT e.first_name, 
	e.last_name 
FROM employees AS e
LEFT JOIN salaries AS s
	ON e.emp_no = s.emp_no
LEFT JOIN dept_emp AS de
	ON de.emp_no = e.emp_no
WHERE de.to_date LIKE '99%' 
	AND s.to_date LIKE '99%' 
    AND de.dept_no ='d001' 
    AND de.to_date LIKE '99%'
GROUP BY de.dept_no,s.salary, e.emp_no
ORDER BY s.salary desc
LIMIT 1;
	
# different answer

SELECT e.first_name, e.last_name
FROM employees e
JOIN dept_emp de ON e.emp_no = de.emp_no	# JOIN not Left JOIN because we are not consern with employees who dont have an assign dept and viseversa.
	AND de.to_date > CURDATE()
JOIN salaries s ON e.emp_no = s.emp_no
	AND s.to_date > CURDATE()
JOIN departments d ON de.dept_no = d.dept_no
	AND d.dept_name = 'Marketing'
ORDER BY s.salary DESC
LIMIT 1;



/* 9 Which current department manager has the highest salary? 	*/

SELECT e.first_name,
        e.last_name,  s.salary, d.dept_name
FROM departments AS d
LEFT JOIN dept_manager AS dm
	ON d.dept_no= dm.dept_no
LEFT JOIN employees AS e
	ON e.emp_no = dm.emp_no
LEFT JOIN salaries AS s
	ON e.emp_no = s.emp_no
WHERE dm.to_date like '999%' AND s.to_date LIKE '99%'
ORDER BY salary desc
LIMIT 1;

# Different answer

SELECT e.first_name,
	e.last_name, 
	CONCAT ('$',FORMAT((s.salary),2)),
	d.dept_name
FROM employees e
JOIN dept_manager dm
	ON e.emp_no = dm.emp_no
    AND dm.to_date > CURDATE()
JOIN salaries s
	ON e.emp_no = s.emp_no
    AND s.to_date >CURDATE()
JOIN departments d
	ON dm.dept_no =d.dept_no
ORDER BY s.salary DESC
LIMIT 1
    ;



/* 10 Determine the average salary for each department. Use all salary information and round your results. 	*/


SELECT  d.dept_name, ROUND(AVG (s.salary),0) AS average_salary
FROM departments AS d
LEFT JOIN dept_emp AS de
	ON d.dept_no = de.dept_no
LEFT JOIN salaries AS s
	ON de.emp_no = s.emp_no
GROUP BY d.dept_name
ORDER BY average_salary DESC;

# DIfferent answer

SELECT d.dept_name,
	ROUND(AVG(s.salary),0) AS average_salary
From departments d
JOIN dept_emp de ON d.dept_no =de.dept_no
JOIN salaries s ON s.emp_no =de.emp_no
GROUP BY d.dept_name
ORDER BY average_salary DESC;



/* 11 Bonus Find the names of all current employees, their department name, and their current manager's name.

240,124 Rows

Employee Name | Department Name  |  Manager Name
--------------|------------------|-----------------
 Huan Lortz   | Customer Service | Yuchang Weedman*/

USE employees;
SELECT CONCAT(e.first_name,' ', e.last_name) AS Employee_Name,
	d.dept_name,
	CONCAT(e2.first_name, e2.last_name) AS Manager
FROM departments AS d
LEFT JOIN dept_emp AS de
	ON d.dept_no = de.dept_no
LEFT JOIN employees AS e
	ON de.emp_no = e.emp_no
LEFT JOIN dept_manager AS dm
	ON dm.dept_no = d.dept_no
LEFT JOIN employees As e2
	ON e2.emp_no = dm.emp_no
WHERE dm.to_date LIKE '999%'AND de.to_date LIKE '999%';






