# 1 Create a file named where_exercises.sql. Make sure to use the employees database.
USE employees;
/* 2 Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya' 
using IN. Enter a comment with the number of records returned.*/
SELECT first_name
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya' );

/* 3 Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', 
as in Q2, but use OR instead of IN. Enter a comment with the number of records returned. 
Does it match number of rows from Q2?
	The number of records returned was 709 which is the same as question 2 using IN. 
SELECT first_name
FROM employees
WHERE first_name = 'Irena' 
	OR first_name = 'Vidya' 
	OR first_name = 'Maya' ; 	(enter each function)	*/
SELECT first_name
FROM employees
WHERE first_name = 'Irena' OR first_name = 'Vidya' OR first_name = 'Maya' ;

/* 4 Find all current or previous employees with first names 'Irena', 'Vidya', or 'Maya', 
using OR, and who is male. Enter a comment with the number of records returned.
	441 record where returned	
SELECT first_name
FROM employees	
WHERE (first_name = 'Irena' 
	OR first_name = 'Vidya' 
	OR first_name = 'Maya') 
	AND gender = 'm'; 			(enter each function) */
SELECT first_name
FROM employees	
WHERE (first_name = 'Irena' OR first_name = 'Vidya' OR first_name = 'Maya') 
	AND gender = 'm';
/* 5 Find all current or previous employees whose last name starts with 'E'. Enter a comment 
with the number of employees whose last name starts with E.
	7,330 employess name were returned that start with E*/
SELECT *
FROM employees
WHERE last_name like 'E%';
/* 6 Find all current or previous employees whose last name starts or ends with 'E'. Enter a 
comment with the number of employees whose last name starts or ends with E. How many employees 
have a last name that ends with E, but does not start with E?
	30,723 employees have a last name that starts or ends with E.
    23393 have a last name that ends with E but does not start with E.	
SELECT *
FROM employees
WHERE last_name like 'E%' 
	OR last_name like '%E'			(enter each function);  
    
SELECT *
FROM employees
WHERE last_name not like 'E%' 
	AND last_name like '%E';
    */
SELECT *
FROM employees
WHERE last_name like 'E%' or last_name like '%E';

SELECT *
FROM employees
WHERE last_name not like 'E%' AND last_name like '%E';

/* 7 Find all current or previous employees employees whose last name starts and ends with 'E'. 
Enter a comment with the number of employees whose last name starts and ends with E. How many 
employees' last names end with E, regardless of whether they start with E?
	Correction Should be (899) not 30,723 employess last names start or end with E. (
	24,292 employees last names ends with E regardless of their start letter. 
SELECT *
FROM employees
WHERE last_name like 'E%' 
	AND last_name like '%E'		(correction should be AND not OR can use 'E%E';
    */
SELECT *
FROM employees
WHERE last_name like 'E%' or last_name like '%E';

SELECT *
FROM employees
WHERE last_name like '%E'; 
/* 8 Find all current or previous employees hired in the 90s. Enter a comment with the number 
of employees returned. 
	135,214 employees were hired in the 90'	*/
SELECT count(*)
FROM employees
WHERE hire_date LIKE '199%';
/* 9 Find all current or previous employees born on Christmas. Enter a comment with the number 
of employees returned.
	842 employees where born on Christmas.	*/
SELECT *
FROM employees
WHERE birth_date LIKE '%12-25';
/* 10 Find all current or previous employees hired in the 90s and born on Christmas. Enter a 
comment with the number of employees returned.
	362 employees where born on Christmas and hired in the 90s */
SELECT *
FROM employees
WHERE birth_date LIKE '%12-25' 
	AND hire_date LIKE '199%';
/* 11 Find all current or previous employees with a 'q' in their last name. Enter a comment with 
the number of records returned.
	1873 employees contain the letter q in thier last name */
SELECT *
FROM employees
WHERE last_name LIKE '%q%';
/* 12 Find all current or previous employees with a 'q' in their last name but not 'qu'. How 
many employees are found?
	547 employees have a last name with a 'q' but not contain 'qu'	*/
SELECT *
FROM employees
WHERE last_name like '%q%' AND last_name NOT LIKE '%qu%'