-- c##lab8 // 1234

-- Q1

SET SERVEROUTPUT ON;
BEGIN
    FOR i IN 1..6 LOOP
        DBMS_OUTPUT.PUT_LINE('i*2 = ' || i*2);
    END LOOP;
END;
/

-- Q2

SET SERVEROUTPUT ON;
BEGIN 
    FOR i IN REVERSE 10..20 LOOP
        DBMS_OUTPUT.PUT_LINE(i);
    END LOOP;
END;    
/

-- Q3

SET SERVEROUTPUT ON;
DECLARE 
    inp INT := &inp;
BEGIN
    IF MOD(inp, 2) = 0 THEN
        DBMS_OUTPUT.PUT_LINE('***EVEN');
    ELSE 
        DBMS_OUTPUT.PUT_LINE('****ODD');
    END IF;    
END;
/

-- Q4

SET SERVEROUTPUT ON; 
DECLARE 
    inp INT := &inp;
    i INT := 1;
    hi INT := 10;
BEGIN 
    WHILE i <= 10 LOOP
        DBMS_OUTPUT.PUT_LINE(inp || '*' || i || ' = ' || inp*i);
        i := i+1;
    END LOOP;
END;    
/

-- Q5

SET SERVEROUTPUT ON;
DECLARE  
    id INT := 100;
    FULLNAME VARCHAR2(255);
BEGIN
    SELECT FIRST_NAME || ' ' || LAST_NAME
    INTO FULLNAME
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = id;        
    DBMS_OUTPUT.PUT_LINE('The first name of the employee with ID = ' || ID ||  ' is ' || FULLNAME);
END;    
/

-- Q6

CREATE OR REPLACE PROCEDURE get_email (empID IN INT) IS     
    outEmail VARCHAR2(255);
        BEGIN
            SELECT EMAIL 
            INTO outEmail
            FROM EMPLOYEES
            WHERE EMPLOYEE_ID = empID;
        
        DBMS_OUTPUT.PUT_LINE('EMPID = ' || empID ||  ': ' || outEmail);
        END;
/

SET SERVEROUTPUT ON;
DECLARE 
    id INT := &id;
BEGIN    
    get_email(id);
END;        
/
    

-- Q7

CREATE OR REPLACE PROCEDURE get_emp_city (empID IN INT) IS     
    outCity VARCHAR2(255);
    BEGIN
        SELECT LOCATIONS.CITY 
        INTO outCity
        FROM EMPLOYEES 
        INNER JOIN DEPARTMENTS ON EMPLOYEES.DEPARTMENT_ID = DEPARTMENTS.DEPARTMENT_ID
        INNER JOIN LOCATIONS ON LOCATIONS.LOCATION_ID = DEPARTMENTS.LOCATION_ID
        WHERE EMPLOYEES.EMPLOYEE_ID = empID;
        
        DBMS_OUTPUT.PUT_LINE('EMPID = ' || empID ||  ' : ' || outCity);
        
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('EMPID HAS NO DATA');
            WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('OTHER ERROR');
    END;
/

SET SERVEROUTPUT ON;
DECLARE 
    id INT := &id;
BEGIN    
    get_emp_city(id);
END;        
/


-- Q8

DECLARE
    EFN VARCHAR2(255);
    JT VARCHAR2(255);
    CURSOR itEmp IS 
        SELECT EMPLOYEES.FIRST_NAME || ' ' || EMPLOYEES.LAST_NAME AS EMPFULLNAME, JOBS.JOB_TITLE
        FROM EMPLOYEES
        INNER JOIN JOBS ON JOBS.JOB_ID = EMPLOYEES.JOB_ID
        INNER JOIN DEPARTMENTS ON DEPARTMENTS.DEPARTMENT_ID = EMPLOYEES.EMPLOYEE_ID;
--        WHERE DEPARTMENTS.DEPARTMENT_NAME LIKE '%IT%';
BEGIN 
    OPEN itEmp;
    LOOP 
        FETCH itEmp 
        INTO EFN, JT;
        EXIT WHEN itEmp %NOTFOUND;
        DBMS_OUTPUT.PUT_LINE(EFN || ', ' || JT);
    END LOOP;
    CLOSE itEmp;
END;        
/


-- Q9 

CREATE OR REPLACE PROCEDURE get_job_history IS
    FNAME EMPLOYEES.FIRST_NAME%TYPE;
    LNAME EMPLOYEES.LAST_NAME%TYPE;
    JID JOB_HISTORY.JOB_ID%TYPE;
    STDATE JOB_HISTORY.START_DATE%TYPE;
    
    CURSOR job_history_cursor IS
        SELECT EMPLOYEES.FIRST_NAME,
               EMPLOYEES.LAST_NAME,
               JOB_HISTORY.JOB_ID,
               JOB_HISTORY.START_DATE
        FROM EMPLOYEES
        JOIN JOB_HISTORY ON EMPLOYEES.EMPLOYEE_ID = JOB_HISTORY.EMPLOYEE_ID
        WHERE EMPLOYEES.DEPARTMENT_ID = 50;

BEGIN
    FOR employee_record IN job_history_cursor LOOP
        FNAME := employee_record.FIRST_NAME;
        LNAME := employee_record.LAST_NAME;
        JID := employee_record.JOB_ID;
        STDATE := employee_record.START_DATE;
        DBMS_OUTPUT.PUT_LINE('Employee Name: ' || FNAME || ' ' || LNAME || ', Job ID: ' || JID || ', Start Date: ' || STDATE);
    END LOOP;
END;
/

SET SERVEROUTPUT ON;
BEGIN
    get_job_history();
END;
/


-- Q10

DECLARE 
    TEMPINT INT; 
    S120 INT;
    S122 INT;
BEGIN
    SELECT SALARY
    INTO S120
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 120;
    
    SELECT SALARY
    INTO S122
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 122;
    
    TEMPINT := S122;
    
    UPDATE EMPLOYEES
    SET SALARY = S120
    WHERE EMPLOYEE_ID = 122;
    
    UPDATE EMPLOYEES 
    SET SALARY = TEMPINT
    WHERE EMPLOYEE_ID = 120;
END;    
/

-- TESTING
SELECT *
FROM EMPLOYEES
WHERE EMPLOYEE_ID IN (120, 122);
/


-- Q11

SET SERVEROUTPUT ON;
DECLARE 
    SALARYY NUMBER;
    NEWSALARY NUMBER;
    PERIODD NUMBER;
    increase NUMBER;
BEGIN
    SELECT SALARY, (SYSDATE - HIRE_DATE)/365
    INTO SALARYY, PERIODD
    FROM EMPLOYEES
    WHERE EMPLOYEE_ID = 115;
    
    DBMS_OUTPUT.PUT_LINE('Salary: ' || SALARYY || ', PERIOD: ' || PERIODD);
    
    increase := 
        CASE
            WHEN PERIODD > 10.0 THEN 0.2
            WHEN PERIODD > 5.0 THEN 0.1
            WHEN PERIODD <= 5.0 THEN 0.05
        END;
        
    NEWSALARY := SALARYY + (SALARYY*increase);    
    
    UPDATE EMPLOYEES
    SET SALARY = NEWSALARY
    WHERE EMPLOYEE_ID = 115;
    
    DBMS_OUTPUT.PUT_LINE('Rows Modified: ' || SQL%ROWCOUNT);    
END;
/


-- Q12

CREATE OR REPLACE PROCEDURE update_emp_commission IS
    SALARYY INTEGER;
    COMSN NUMBER;
    HIREDATE DATE;
    BEGIN 
        SELECT SALARY, HIRE_DATE
        INTO SALARYY, HIREDATE
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = 152;
        
        IF SALARYY > 10000 THEN
            COMSN := 0.4;
        ELSIF SALARYY <= 10000 AND MONTHS_BETWEEN(SYSDATE, HIREDATE) > 120 THEN 
            COMSN := 0.35;
        ELSIF SALARYY < 3000 THEN
            COMSN := 0.25;
        ELSE 
            COMSN := 0.15;
        END IF;
        
        UPDATE EMPLOYEES
        SET COMMISSION_PCT = COMSN
        WHERE EMPLOYEE_ID = 152;
        
    END;
/

-- Testing
SELECT *
FROM EMPLOYEES
WHERE EMPLOYEE_ID = 152;
/

SET SERVEROUTPUT ON;
BEGIN    
    update_emp_commission();
END;        
/


-- Q13

CREATE OR REPLACE PROCEDURE delete_employee (empID IN NUMBER) IS
    MAN_ID NUMBER;
BEGIN
    SELECT MANAGER_ID 
    INTO MAN_ID 
    FROM EMPLOYEES 
    WHERE EMPLOYEE_ID = empID;

    UPDATE EMPLOYEES 
    SET MANAGER_ID = MAN_ID 
    WHERE MANAGER_ID = empID;

    UPDATE DEPARTMENTS 
    SET MANAGER_ID = MAN_ID 
    WHERE MANAGER_ID = empID;

    DELETE FROM EMPLOYEES 
    WHERE EMPLOYEE_ID = empID;

    DBMS_OUTPUT.PUT_LINE('Employee ' || empID || ' has been deleted');
END;
/

SET SERVEROUTPUT ON;
DECLARE
    empID INT := 152;
BEGIN    
    delete_employee(empID);
END;
/