-- Q1

WITH Alexis_Salary AS (
    SELECT SALARY
    FROM EMPLOYEES
    WHERE FIRST_NAME = 'Alexis' AND LAST_NAME = 'Bull'
)
SELECT CONCAT(CONCAT(EMPLOYEES.FIRST_NAME, ' '), EMPLOYEES.LAST_NAME) AS FULL_NAME, EMPLOYEES.SALARY
FROM EMPLOYEES
WHERE SALARY > (SELECT SALARY FROM Alexis_Salary);


-- Q2

WITH IT_DEP_ID AS (
    SELECT DEPARTMENT_ID
    FROM DEPARTMENTS
    WHERE DEPARTMENT_NAME = 'IT'
)
SELECT *
FROM EMPLOYEES
WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM IT_DEP_ID);


-- Q3

SELECT CONCAT(CONCAT(EMPLOYEES.FIRST_NAME, ' '), EMPLOYEES.LAST_NAME) AS FULL_NAME
FROM EMPLOYEES
WHERE MANAGER_ID IS NOT NULL AND DEPARTMENT_ID IN (
    SELECT DEPARTMENT_ID 
    FROM DEPARTMENTS
    WHERE LOCATION_ID IN (
        SELECT LOCATION_ID
        FROM LOCATIONS
        WHERE COUNTRY_ID = 'US'
    )
);


-- Q4

WITH AVG_SALARY AS (
    SELECT AVG(SALARY) AS SALARY
    FROM EMPLOYEES
)
SELECT * 
FROM EMPLOYEES
WHERE SALARY > (SELECT SALARY FROM AVG_SALARY);

--SELECT AVG(SALARY) FROM EMPLOYEES;


-- Q5

SELECT EMPLOYEES.FIRST_NAME, EMPLOYEES.LAST_NAME, SALARY 
FROM EMPLOYEES 
WHERE SALARY > (
    SELECT SALARY 
    FROM EMPLOYEES
    WHERE JOB_ID = 'SA_REP'
    ORDER BY SALARY ASC
    FETCH FIRST ROW ONLY
);

--SELECT SALARY 
--    FROM EMPLOYEES
--    WHERE JOB_ID = 'SA_REP'
--    ORDER BY SALARY ASC
--    FETCH FIRST ROW ONLY;

-- Q6

SELECT *
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (
    SELECT DISTINCT MANAGER_ID
    FROM EMPLOYEES
);


-- Q7

SELECT EMPLOYEE_ID, FIRST_NAME, LAST_NAME, SALARY 
FROM EMPLOYEES E
WHERE SALARY > (
    SELECT AVG(SALARY)
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = E.DEPARTMENT_ID
);


-- Q8

SELECT DEPARTMENT_ID, DEPARTMENT_NAME
FROM DEPARTMENTS D
WHERE NOT EXISTS (
    SELECT *
    FROM EMPLOYEES
    WHERE DEPARTMENT_ID = D.DEPARTMENT_ID
);


-- Q9

DROP VIEW JonathonTaylor_JobHistory;
DELETE VIEW JonathonTaylor_JobHistory;

CREATE VIEW JonathonTaylor_JobHistory AS
SELECT JOB_HISTORY.START_DATE, JOB_HISTORY.END_DATE, JOBS.JOB_TITLE, DEPARTMENTS.DEPARTMENT_NAME
FROM JOB_HISTORY 
INNER JOIN EMPLOYEES ON JOB_HISTORY.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
INNER JOIN JOBS ON JOB_HISTORY.JOB_ID = JOBS.JOB_ID
INNER JOIN DEPARTMENTS ON JOB_HISTORY.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
WHERE EMPLOYEES.FIRST_NAME = 'Jonathon' AND EMPLOYEES.LAST_NAME = 'Taylor'
ORDER BY JOB_HISTORY.END_DATE DESC;

SELECT * 
FROM JonathonTaylor_JobHistory;

-- Q10 ----- CHECK OUTPUT

SELECT EMPLOYEES.EMPLOYEE_ID 
FROM EMPLOYEES
MINUS (
    SELECT EMPLOYEES.EMPLOYEE_ID
    FROM EMPLOYEES
    INTERSECT 
    SELECT JOB_HISTORY.EMPLOYEE_ID
    FROM JOB_HISTORY
);

-- Q11

SELECT CONCAT(CONCAT(EMPLOYEES.FIRST_NAME, ' '), EMPLOYEES.LAST_NAME) AS FULL_NAME, EMPLOYEES.DEPARTMENT_ID
FROM EMPLOYEES
UNION ALL
SELECT DEPARTMENTS.DEPARTMENT_NAME, DEPARTMENT_ID
FROM DEPARTMENTS;


-- Q12

SELECT CONCAT(CONCAT(EMPLOYEES.FIRST_NAME, ' '), EMPLOYEES.LAST_NAME) AS FULL_NAME
FROM EMPLOYEES 
WHERE EMPLOYEES.EMPLOYEE_ID IN (
    SELECT MANAGER_ID 
    FROM DEPARTMENTS
    INTERSECT 
    SELECT EMPLOYEE_ID 
    FROM EMPLOYEES
);


-- Q13

SELECT DEPARTMENTS.DEPARTMENT_NAME, ROUND(AVG(EMPLOYEES.SALARY), 0) AS AVG_SALARY,
CASE
    WHEN AVG(EMPLOYEES.SALARY) > 10000 THEN 'HIGH'
    WHEN AVG(EMPLOYEES.SALARY) > 5000 AND AVG(EMPLOYEES.SALARY) <= 10000 THEN 'MEDIUM'
    WHEN AVG(EMPLOYEES.SALARY) <= 5000 THEN 'LOW'
    END 
    AS SALARY_CATEGORY
FROM EMPLOYEES
INNER JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
GROUP BY DEPARTMENTS.DEPARTMENT_NAME;


-- Q14a

UPDATE EMPLOYEES
SET COMMISSION_PCT = 0.5
WHERE FIRST_NAME = 'Steven' AND LAST_NAME = 'King';

SELECT *
FROM EMPLOYEES
WHERE FIRST_NAME = 'Steven' AND LAST_NAME = 'King';


-- Q14b

--WITH ALEX_ID AS (
--    SELECT EMPLOYEE_ID
--    FROM EMPLOYEES
--    WHERE FIRST_NAME = 'Alexander'; AND LAST_NAME = 'Hunold';
--)

UPDATE EMPLOYEES
SET 
    EMPLOYEES.MANAGER_ID = (SELECT MANAGER_ID FROM EMPLOYEES WHERE EMPLOYEES.FIRST_NAME = 'Alexander' AND EMPLOYEES.LAST_NAME = 'Hunold')
WHERE 
    EMPLOYEES.MANAGER_ID = (SELECT EMPLOYEE_ID FROM EMPLOYEES WHERE EMPLOYEES.FIRST_NAME = 'Alexander' AND EMPLOYEES.LAST_NAME = 'Hunold');

SELECT *
FROM EMPLOYEES
WHERE FIRST_NAME = 'Alexander' AND LAST_NAME = 'Hunold';


-- Q14c

DELETE FROM EMPLOYEES 
WHERE FIRST_NAME = 'Alexander' AND LAST_NAME = 'Hunold';


-- Q15

-- Selecting employee details including full name, email, hire date, and years of service
SELECT 
    e.first_name || ' ' || e.last_name AS employee_name,  -- Full name of the employee
    e.email AS employee_email,                            -- Employee's email address
    d.department_name,                                    -- Employee's department
    ROUND( (SYSDATE - e.hire_date) / 365 ) AS years_of_service,    -- Calculating years of service
    -- Subquery to get the manager's email from the department
    (SELECT m.email 
     FROM employees m 
     WHERE m.employee_id = d.manager_id) AS manager_email -- Email address of the department manager
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
WHERE 
    (SYSDATE - e.hire_date) / 365 > 10                   -- Employees with more than 10 years of service
ORDER BY 
    d.department_name, e.first_name;


-- Q16

SELECT 
    distinct d.department_name AS department,
    AVG(e.salary) AS avg_salary,
    MIN(e.salary) AS min_salary,
    MAX(e.salary) AS max_salary,
    COUNT(e.employee_id) AS num_employees,
    (SELECT m.first_name || ' ' || m.last_name 
     FROM employees m 
     WHERE m.employee_id = d.manager_id) AS manager_name,
    MAX(e.hire_date) AS latest_hiring_date
FROM 
    employees e
JOIN 
    departments d ON e.department_id = d.department_id
GROUP BY 
    d.department_name, d.manager_id;