/* MVP */

/* Q1 */

/* Find all the employees who work in the ‘Human Resources’ department. */

SELECT *
FROM employees
WHERE department = 'Human Resources';

/* Q2 */

/* Get the first_name, last_name, and country of the employees who work in the ‘Legal’ department. */

SELECT
	first_name,
	last_name,
	country,
FROM employees
WHERE department = 'Legal';

/* Q3 */

/* Count the number of employees based in Portugal. */

SELECT 
COUNT(*) AS num_of_employees_in_portugal
FROM employees
WHERE country = 'Portugal';

/* Q4 */

/* Count the number of employees based in either Portugal or Spain. */

SELECT
COUNT(*) AS num_of_employees_in_port_or_spain
FROM employees
WHERE country IN ('Portugal', 'Spain');

/* Q5 */

/* Count the number of pay_details records lacking a local_account_no. */

SELECT *
FROM pay_details
LIMIT 10; 

SELECT
COUNT(*) AS num_of_missing_loc_acc_nos
FROM pay_details
WHERE local_account_no IS NULL;

/* Q6 */

/* Get a table with employees first_name and last_name ordered alphabetically by last_name (put any NULLs last). */

SELECT
	first_name,
	last_name
FROM employees
ORDER BY last_name NULLS LAST;

/* Q7 */

/* How many employees have a first_name beginning with ‘F’? */

SELECT 
COUNT (*) AS first_names_beginning_f
FROM employees
WHERE first_name LIKE 'F%';

/* Q8 */

/* Count the number of pension enrolled employees not based in either France or Germany. */

SELECT
COUNT (*) AS pension_enrols_less_france_and_germ
FROM employees
WHERE pension_enrol = TRUE AND country NOT IN ('France', 'Germany');

/* Q9 */

/* Obtain a count by department of the employees who started work with the corporation in 2003. */

SELECT
department,
COUNT (*) AS employees_pre_2003_start
FROM employees
WHERE start_date <= '2002-12-31'
GROUP BY department;

/* Q10 */

/* Obtain a table showing department, fte_hours and the number of employees in each department 
 * who work each fte_hours pattern. Order the table alphabetically by department
 * , and then in ascending order of fte_hours. */

SELECT
department,
fte_hours,
COUNT (*) AS employees_on_diff_hours 
FROM employees
GROUP BY department, fte_hours
ORDER BY department, fte_hours ASC;



/* Q11 */

/* Obtain a table showing any departments in which there are two or more employees
 * lacking a stored first name. Order the table in descending order of the number of 
 * employees lacking a first name, and then in alphabetical order by department. */

SELECT
department,
COUNT(*) AS two_or_more_missing
FROM employees
WHERE first_name IS NULL
GROUP BY department
HAVING COUNT (*) >= 2
ORDER BY two_or_more_missing DESC, department;

/* Q12 */

/* [Tough!] Find the proportion of employees in each department who are grade 1. */

/* DIDN'T FINISH!! */

SELECT
department,
COUNT(*) * 100.0/(SELECT COUNT (*) FROM employees WHERE grade = 1) AS g1s_by_department_percent
FROM employees
GROUP BY department;

