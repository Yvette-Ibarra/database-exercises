
/* 1 Create a new file named order_by_exercises.sql and copy in the contents of your exercise 
from the previous lesson.*/
USE employees;

/* 2 Find all employees with first names 'Irena', 'Vidya', or 'Maya', and order your results 
returned by first name. In your comments, answer: What was the first and last name in the first 
row of the results? What was the first and last name of the last person in the table?
USE employees;
	The first and last name of the first row is Irena Reutenauer.
    The first and last name of the last row is Vidya Simmen.	*/
    
SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya','Maya')
	ORDER BY first_name;

/* 3 Find all employees with first names 'Irena', 'Vidya', or 'Maya', and order your results returned 
by first name and then last name. In your comments, answer: What was the first and last name in the 
first row of the results? What was the first and last name of the last person in the table?
	The first and last name of the first row is Irena Acton.
    The first and last name of the last row is Vidya Zweizig.		*/
    
SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya','Maya')
	ORDER BY first_name,last_name;

/* 4 Find all employees with first names 'Irena', 'Vidya', or 'Maya', and order your results returned 
by last name and then first name. In your comments, answer: What was the first and last name in the 
first row of the results? What was the first and last name of the last person in the table?
	The first name and last name of the first row is Irena Acton.
    The first name and last name of the last person is Maya Zyda.		*/

SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya','Maya')
	ORDER BY last_name,first_name;
    
/* 5 Write a query to to find all employees whose last name starts and ends with 'E'. Sort the results 
by their employee number. Enter a comment with the number of employees returned, the first employee 
number and their first and last name, and the last employee number with their first and last name.
	899 employees were returned.
    The first employee is Ramza Erde.
    The last empoyee is Tadahiro Erde		*/

SELECT *
FROM employees
WHERE last_name LIKE 'E%E' 
	ORDER BY emp_no;
    
/* 6 Write a query to to find all employees whose last name starts and ends with 'E'. Sort the results 
by their hire date, so that the newest employees are listed first. Enter a comment with the number of 
employees returned, the name of the newest employee, and the name of the oldest employee.
	The newest employee is Teiji Eldridge hired 1999-11-27.
    The oldest employee is Sergi Erde hired 1985-02-02.		*/
    
SELECT *
FROM employees
WHERE last_name LIKE 'E%E' 
	ORDER BY hire_date DESC;

/* 7 Find all employees hired in the 90s and born on Christmas. Sort the results so that the oldest 
employee who was hired last is the first result. Enter a comment with the number of employees returned,
 the name of the oldest employee who was hired last, and the name of the youngest employee who was 
 hired first.
	362 employees where returned.
    The oldest employee hired last is Khun Bernini.
    The youngest employee hired first is Douadi Pettis.		*/
    
SELECT *
FROM employees
WHERE hire_date LIKE '199%' AND birth_date LIKE '%-12-25'
	ORDER BY birth_date,hire_date DESC;
