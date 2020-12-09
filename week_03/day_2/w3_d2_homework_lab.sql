/* MVP */

/* Q1 */

/* Get a table of all employees details, together with their local_account_no and local_sort_code, if they have them. */

SELECT
e.*,
pd.local_account_no,
pd.local_sort_code
FROM employees AS e LEFT JOIN pay_details AS pd
ON e.id = pd.id;

/* Q2 */

/* Amend your query from question 1 above to also return the name of the team that each employee belongs to. */

SELECT
e.*,
pd.local_account_no,
pd.local_sort_code,
t.name AS team_name
FROM (employees AS e LEFT JOIN pay_details AS pd
ON e.id = pd.id)
INNER JOIN teams AS t 
ON e.team_id = t.id;

/* Q3 */

/* Find the first name, last name and team name of employees who are members of teams for which the 
 * charge cost is greater than 80. Order the employees alphabetically by last name. */

SELECT
e.first_name,
e.last_name,
t.name AS team_name
FROM employees AS e INNER JOIN teams AS t
ON e.team_id = t.id
WHERE CAST(t.charge_cost AS INT) > 80
ORDER BY e.last_name ASC NULLS LAST;

/* Q4 DOUBLE CHECK BEFORE SUBMITTING!!!!*/

/* Breakdown the number of employees in each of the teams, including any teams without members. 
 * Order the table by increasing size of team. */

SELECT 
t.name AS team_name,
COUNT (e.id) AS number_of_employees
FROM teams as t FULL OUTER JOIN employees AS e
ON t.id = e.team_id
GROUP BY team_name
ORDER BY number_of_employees DESC NULLS LAST;

/* Q5 */

/* The effective_salary of an employee is defined as their fte_hours multiplied by their salary. 
 * Get a table for each employee showing their id, first_name, last_name, fte_hours, salary and 
 * effective_salary, along with a running total of effective_salary with employees placed in 
 * ascending order of effective_salary.*/

WITH effect_table(id, effective_salary) AS (

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
	effective_salary,
SUM(effective_salary) OVER (ORDER BY effective_salary ASC NULLS LAST) AS eff_sal_run_tot
FROM employees as em LEFT JOIN effect_table
ON em.id = effect_table.id;



/* Q6 Needs Work */

/* The total_day_charge of a team is defined as the charge_cost of the team 
 * multiplied by the number of employees in the team. 
 * Calculate the total_day_charge for each team. */

WITH t_nums(id, team_name, number_of_employees) AS (
	SELECT 
		t.id,
		t.name, 
		COUNT (e.id)
	FROM teams AS t FULL OUTER JOIN employees AS e
	ON t.id = e.team_id
	GROUP BY t.id
)
SELECT
	t_nums.team_name AS tm_name,
	tm.charge_cost,
	number_of_employees,
	number_of_employees * CAST(tm.charge_cost AS REAL) AS total_day_charge
	FROM t_nums LEFT JOIN teams AS tm
	ON t_nums.id = tm.id
	ORDER BY tm_name ASC NULLS LAST;
	


/* Q7 */

/* How would you amend your query from question 6 above to show only 
 * those teams with a total_day_charge greater than 5000? */

WITH t_nums(id, team_name, number_of_employees) AS (
	SELECT 
		t.id,
		t.name, 
		COUNT (e.id)
	FROM teams AS t FULL OUTER JOIN employees AS e
	ON t.id = e.team_id
	GROUP BY t.id
),

tot_day_tab(id, total_day_charge) AS (
	SELECT 
	tm.id,
	number_of_employees * CAST(tm.charge_cost AS REAL) 
	FROM t_nums LEFT JOIN teams AS tm
	ON t_nums.id = tm.id
)
		
SELECT
	t_nums.team_name AS tm_name,
	tm.charge_cost,
	number_of_employees,
	t_b_t.total_day_charge AS total_day_charge
	FROM (t_nums INNER JOIN teams AS tm
	ON t_nums.id = tm.id)
	INNER JOIN tot_day_tab AS t_b_t
	ON t_b_t.id = tm.id
	WHERE total_day_charge > 5000
	ORDER BY tm_name ASC NULLS LAST;
