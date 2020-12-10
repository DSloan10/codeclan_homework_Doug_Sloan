/* Q1 */

/* Are there any pay_details records lacking both a local_account_no and iban number? */

SELECT
 id,
 local_account_no,
 iban
 FROM pay_details
 WHERE local_account_no IS NULL AND iban IS NULL;


/* Q2 */

/* Get a table of employees first_name, last_name and country, ordered 
 * alphabetically first by country and then by last_name (put any NULLs last). */


SELECT
first_name,
last_name,
country
FROM employees
ORDER BY country ASC NULLS LAST, last_name ASC NULLS LAST;

/* Q3 */

/* Find the details of the top ten highest paid employees in the corporation.*/

SELECT *
FROM employees
ORDER BY salary DESC NULLS LAST
LIMIT 10;

/* Q4 */

/* Find the first_name, last_name and salary of the lowest paid employee in Hungary.*/

SELECT
first_name,
last_name,
salary
FROM employees
WHERE country LIKE '%ungary'
ORDER BY salary ASC NULLS LAST
LIMIT 1;


/* Q5 */

/* Find all the details of any employees with a ‘yahoo’ email address? */

SELECT *
FROM employees
WHERE email LIKE '%yahoo%';



/* Q6 */

/* Provide a breakdown of the numbers of employees enrolled, not enrolled, and 
 * with unknown enrollment status in the corporation pension scheme.*/

SELECT
  pension_enrol,
  COUNT(id) AS num_employees
FROM employees
GROUP BY pension_enrol
ORDER BY pension_enrol DESC


/* Q7 */

/* What is the maximum salary among those employees in the ‘Engineering’ department 
 * who work 1.0 full-time equivalent hours (fte_hours)? */

SELECT
  department,
  MAX(salary) AS max_salary 
FROM employees
WHERE department = 'Engineering' AND fte_hours = 1
GROUP BY department;
  

/* Q8 */

/* Get a table of country, number of employees in that country, and the average 
 * salary of employees in that country for any countries in which more than 30 employees are based. 
 * Order the table by average salary descending. */
  
 SELECT
   country,
   COUNT(id) AS num_employees,
   CAST(AVG(salary) AS DECIMAL (10,2)) AS average_salary
 FROM employees
 GROUP BY country
 HAVING COUNT(id) > 30
 ORDER BY AVG(salary) ASC NULLS LAST;


/* Q9 */

/* Return a table containing each employees first_name, last_name, full-time equivalent hours 
 * (fte_hours), salary, and a new column effective_yearly_salary which should contain fte_hours
 * multiplied by salary.*/

WITH effect_table(id, effective_yearly_salary) AS (

	SELECT 
	e.id,
	e.fte_hours * e.salary
	FROM employees AS e
)
SELECT
	em.id,
	em.first_name,
	em.last_name,
	em.fte_hours,
	em.salary,
	effective_yearly_salary
FROM employees as em LEFT JOIN effect_table
ON em.id = effect_table.id;

/* Q10 */

/* Find the first name and last name of all employees who lack a local_tax_code. */

SELECT
	e.first_name,
	e.last_name
FROM employees AS e LEFT JOIN pay_details AS pd
ON e.id = pd.id
WHERE local_tax_code IS NULL;

/* Q11 */

/* The expected_profit of an employee is defined as (48 * 35 * charge_cost - salary) * fte_hours, 
 * where charge_cost depends upon the team to which the employee belongs. Get a table showing 
 * expected_profit for each employee.*/

SELECT
e.*,
t.*,
SUM ((48 * 35 * (CAST(t.charge_cost AS INT)) - e.salary) * e.fte_hours) AS expected_profit
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id
GROUP BY e.id, t.id 
ORDER BY expected_profit DESC NULLS LAST;


/* Q12 */

/* [Bit Tougher] Return a table of those employee first_names shared by more than one employee, 
 * together with a count of the number of times each first_name occurs. Omit employees without 
 * a stored first_name from the table. Order the table descending by count, and then alphabetically by first_name.*/

SELECT
first_name,
COUNT(first_name) AS duplicate_first_name
FROM employees
GROUP BY first_name
HAVING COUNT(first_name) > 1
ORDER BY duplicate_first_name DESC, first_name ASC;



