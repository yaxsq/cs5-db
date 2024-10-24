-- 1
SELECT * FROM hr.EMPLOYEES WHERE DEPARTMENT_ID=40;

-- 2
SELECT LAST_NAME, SALARY FROM hr.EMPLOYEES WHERE JOB_ID='IT_PROG';

-- 3
SELECT LAST_NAME, EMAIL FROM hr.EMPLOYEES WHERE HIRE_DATE='07-JUN-02';

-- 4
SELECT * FROM hr.EMPLOYEES WHERE HIRE_DATE>'07-JUN-02' AND DEPARTMENT_ID>60;

-- 5
SELECT * FROM hr.EMPLOYEES WHERE HIRE_DATE BETWEEN '01-JUN-07' AND '01-DEC-07';

-- 6
SELECT * FROM hr.EMPLOYEES WHERE SALARY<5000;

-- 7
SELECT Count(*) FROM hr.EMPLOYEES WHERE SALARY<5000;

-- 8
SELECT * FROM hr.EMPLOYEES WHERE SALARY > 10000 AND SALARY < 15000;

-- 9
SELECT * FROM hr.EMPLOYEES WHERE MANAGER_ID = 100 OR MANAGER_ID = 101 OR MANAGER_ID = 201;

-- 10
SELECT * FROM hr.EMPLOYEES WHERE MANAGER_ID IN (100, 102, 201);

-- 11
SELECT * FROM hr.EMPLOYEES WHERE JOB_ID NOT IN ('IT_PROG', 'SA_REP', 'FI_ACCOUNT');

-- 12
SELECT * FROM hr.EMPLOYEES WHERE LAST_NAME LIKE 'A%';

-- 13
SELECT * FROM hr.EMPLOYEES WHERE FIRST_NAME LIKE '%r';

-- 14
SELECT LAST_NAME, EMAIL, PHONE_NUMBER FROM hr.EMPLOYEES WHERE FIRST_NAME LIKE 'S%' OR FIRST_NAME LIKE 'J%';

-- 15
SELECT * FROM hr.EMPLOYEES WHERE FIRST_NAME LIKE '_o%';

-- 16
SELECT * FROM hr.EMPLOYEES WHERE DEPARTMENT_ID IS NULL;

-- 17
SELECT Count(*) FROM hr.EMPLOYEES WHERE MANAGER_ID IS NULL;

-- 18
SELECT * FROM hr.EMPLOYEES WHERE COMMISSION_PCT IS NULL;

-- 19
SELECT * FROM hr.EMPLOYEES WHERE JOB_ID='SA_REP' AND SALARY>10000;

-- 20
SELECT * FROM hr.EMPLOYEES WHERE JOB_ID='SA_REP' OR SALARY<11000;

-- 21
SELECT * FROM hr.EMPLOYEES WHERE JOB_ID='SA_REP' OR (JOB_ID='AD_PRES' AND SALARY>15000);

-- 22
SELECT * FROM hr.EMPLOYEES WHERE (JOB_ID='SA_REP' OR JOB_ID='AD_PRES') AND SALARY>15000;

-- 23
SELECT * FROM hr.EMPLOYEES ORDER BY EMAIL DESC;

-- 24
SELECT * FROM hr.EMPLOYEES ORDER BY EMPLOYEE_ID;

-- 25
SELECT * FROM hr.EMPLOYEES ORDER BY EMPLOYEE_ID DESC;

-- 26
SELECT JOB_ID, FIRST_NAME, HIRE_DATE FROM hr.EMPLOYEES ORDER BY JOB_ID DESC, FIRST_NAME ASC;

-- 27
SELECT * FROM hr.EMPLOYEES ORDER BY 6;
