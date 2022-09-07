#3. Use the employees database. Write the SQL code necessary to do this.
USE employees;
#4. List all the tables in the database. Write the SQL code necessary to accomplish this.
SHOW tables;
/*5. Explore the employees table. What different data types are present on this table?
		 We have int, date, varchar(14) varchar(16), enum('M',"F")*/
SELECT * FROM employees;
DESCRIBE employees;
/*6. Which table(s) do you think contain a numeric type column? 
	 Salaries(int), employees*/
DESCRIBE salaries;

/*7. Which table(s) do you think contain a string type column? 
	Departments (varchar), employees (varchar,enum), dept_emp (int,char), dept_manager (int char) 
    titles (int,varchar)*/
DESCRIBE departments;
DESCRIBE dept_emp;
DESCRIBE dept_manager;
DESCRIBE titles;

/*  8. Which table(s) do you think contain a date type column? 
	dept_manager (date), dept_emp (date), salary (date), employees (date), title (date)*/

/*9. What is the relationship between the employees and the departments tables?
I dont see a direct relationship between the tables employees and departments but if
we open dept_emp the information is link to show which emp_no goes to what dept_no.*/
SELECT * FROM departments; 
SELECT * FROM employees;
SELECT * FROM dept_emp;
/* 10. Show the SQL that created the dept_manager table. Write the SQL it takes to show this 
as your exercise solution.
		'dept_manager', 'CREATE TABLE `dept_manager` (\n  `emp_no` int NOT NULL,\n  
        `dept_no` char(4) NOT NULL,\n  `from_date` date NOT NULL,\n  `to_date` date NOT NULL,\n  
        PRIMARY KEY (`emp_no`,`dept_no`),\n  KEY `dept_no` (`dept_no`),\n  CONSTRAINT 
        `dept_manager_ibfk_1` FOREIGN KEY (`emp_no`) REFERENCES `employees` (`emp_no`) 
        ON DELETE CASCADE ON UPDATE RESTRICT,\n  CONSTRAINT `dept_manager_ibfk_2` 
        FOREIGN KEY (`dept_no`) REFERENCES `departments` (`dept_no`) 
        ON DELETE CASCADE ON UPDATE RESTRICT\n) ENGINE=InnoDB DEFAULT CHARSET=latin1'
*/
SHOW CREATE TABLE dept_manager;