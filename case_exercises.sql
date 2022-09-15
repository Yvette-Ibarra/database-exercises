
-- case exercises --
/* Create a file named case_exercises.sql and craft queries to return the results for the following criteria:	*/
USE employees;
/* 1 Write a query that returns all employees, their department number, their start date, their end date, and
 a new column 'is_current_employee' that is a 1 if the employee is still with the company and 0 if not.		*/
 
 SELECT e.first_name, e.last_name, de.dept_no, e.hire_date, MAX(de.to_date),
		CASE 
			WHEN MAX(de.to_date) > CURDATE() THEN 1
            WHEN MAX(de.to_date)<= CURDATE() THEN 0
            END AS is_current_employee
 FROM employees e
 JOIN dept_emp de ON e.emp_no = de.emp_no
 GROUP BY e.first_name, e.last_name, e.hire_date, de.dept_no;
 
 
/* 2 Write a query that returns all employee names (previous and current), and a new column 'alpha_group' that 
returns 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their last name.		*/

SELECT *,
	CASE 
		WHEN last_name BETWEEN 'A%' AND 'HZZ%' THEN 'A-H'
		WHEN last_name BETWEEN 'I%' AND 'QZZ%' THEN 'I-Q'
		WHEN last_name BETWEEN 'R%' AND 'ZZZ%' THEN 'R-Z'
        END AS alpha_group
FROM employees;


/* 3 How many employees (current or previous) were born in each decade?		*/
SELECT count(*),
	CASE 
		WHEN birth_date LIKE '194%' THEN '40\'s'
		WHEN birth_date LIKE'195%' THEN '50\'s'
		WHEN birth_date  LIKE'196%' THEN '60\'s'
        WHEN birth_date LIKE '197%' THEN '70\'s'
		WHEN birth_date LIKE'198%' THEN '80\'s'
		WHEN birth_date  LIKE'199%' THEN '90\'s'
        WHEN birth_date LIKE '200%' THEN '00\'s'
		WHEN birth_date LIKE'201%' THEN '10\'s'
		WHEN birth_date  LIKE'202%' THEN '20\'s'
        END AS Born_decade
FROM employees
group by Born_decade;

/* 4 What is the current average salary for each of the following department groups:
 R&D(research and development), Sales & Marketing, Prod & QM, Finance & HR, Customer Service?		*/
 
 
 SELECT  AVG(s.salary),
	CASE
		WHEN dept_name IN ('research','development') THEN 'R&D'
        WHEN dept_name IN ('sales','marketing')THEN 'Sales & Marketing'
        WHEN dept_name IN ('production','quality management') THEN 'Prod &QM'
        WHEN dept_name IN ('Human Resources','Finance') THEN 'Finance & HR'
        WHEN dept_name IN ('Customer Service') THEN 'Customer Service'
        END AS salary_compare
FROM departments d
JOIN dept_emp de ON de.dept_no = d.dept_no
	AND de.to_date > CURDATE()
JOIN salaries s ON s.emp_no = de.emp_no
	AND s.to_date >CURDATE()
GROUP BY salary_compare;
 




/* first draft

 
SELECT *
FROM departments;

SELECT *
FROM dept_emp;

SELECT d.dept_no,AVG(salary), d.dept_name
FROM salaries s
JOIN dept_emp de ON de.emp_no = s.emp_no
	AND s.to_date > CURDATE()
    AND de.to_date > CURDATE()
JOIN departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no;

SELECT avg_by_dept.AVG(salary)
		
FROM
(SELECT d.dept_no,AVG(salary)
FROM salaries s
JOIN dept_emp de ON de.emp_no = s.emp_no
	AND s.to_date > CURDATE()
    AND de.to_date > CURDATE()
JOIN departments d ON d.dept_no = de.dept_no
GROUP BY d.dept_no);


