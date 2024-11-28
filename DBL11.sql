---- Q3 
--
--create user c##lab11 identified by 1234;
--
--
---- Q7
--
---- ORA-01045: user C##LAB11 lacks CREATE SESSION privilege; logon denied
---- This user does not have the privilege to create a session.
--
--
---- Q9a
--
--GRANT CONNECT TO c##lab11;
--
--
---- Q9b
--
---- GRANT UNLIMITIED TABLESPACE TO c##lab11;
--GRANT CREATE TABLE TO c##lab11;
--
--
---- Q10 
--
--CREATE ROLE c##manager;
--
--
---- Q15
--
--CREATE TABLE students (
--    id NUMBER(5),
--    name VARCHAR2(50)
--);
--
--
---- Q16
--
--INSERT INTO students (id, name) VALUES (1, 'Alice');
--INSERT INTO students (id, name) VALUES (2, 'Bob');
--INSERT INTO students (id, name) VALUES (3, 'Charlie');
--INSERT INTO students (id, name) VALUES (4, 'Diana');
--INSERT INTO students (id, name) VALUES (5, 'Evan');
--
--
---- Q17
--
--GRANT SELECT ON students TO c##lab11;
--

-- Q20

REVOKE DELETE ON STUDENTS FROM C##LAB11;


-- Q21

-- A record can not be deleted due to no delete privilege. 

CONN C##LAB11;

DELETE FROM sys.STUDENTS
WHERE ID=5;


-- Q22

CREATE OR REPLACE PACKAGE emp_manager AS
    PROCEDURE update_emp_commission;
    PROCEDURE delete_employee (empID IN NUMBER);
END emp_manager;
/


CREATE OR REPLACE PACKAGE BODY emp_manager AS 
    PROCEDURE update_emp_commission IS
    SALARYY INTEGER;
    COMSN NUMBER;
    HIREDATE DATE;
    BEGIN 
        SELECT SALARY, HIRE_DATE
        INTO SALARYY, HIREDATE
        FROM EMPLOYEES
        WHERE EMPLOYEE_ID = 151;
        
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
        WHERE EMPLOYEE_ID = 151;
        
    END;
    
    PROCEDURE delete_employee (empID IN NUMBER) IS
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

END emp_manager;

-- Testing

BEGIN
    emp_manager.update_emp_commission;
END;

SELECT * FROM EMPLOYEES WHERE EMPLOYEE_ID = 151;


-- Q23

WITH DEPT_SALARIES AS (
    SELECT DEPARTMENT_ID, SUM(SALARY) AS DEPT_TOTAL
    FROM EMPLOYEES
    GROUP BY DEPARTMENT_ID
),
ORG_AVG_SALARY AS (
    SELECT AVG(DEPT_TOTAL) AS AVG_ORG_SALARY
    FROM DEPT_SALARIES
)
SELECT DEPARTMENT_NAME, DEPT_TOTAL
FROM DEPARTMENTS
INNER JOIN DEPT_SALARIES 
ON DEPARTMENTS.DEPARTMENT_ID = DEPT_SALARIES.DEPARTMENT_ID
INNER JOIN ORG_AVG_SALARY 
ON DEPT_SALARIES.DEPT_TOTAL > ORG_AVG_SALARY.AVG_ORG_SALARY;


-- Q24

WITH get_emps AS (
    SELECT * 
    FROM EMPLOYEES
)
SELECT * 
FROM get_emps
ORDER BY SALARY DESC FETCH FIRST 1 ROWS ONLY;


-- Railway Reservation

-- Q1

CREATE TABLE TrainList (
    TrainNumber int PRIMARY KEY,  
    TrainName varchar2(200),
    TRsource varchar2(200),
    TRdestination varchar2(200),
    ACFare number, 
    GeneralFare number, 
    Weekdays varchar2(200)    
);


-- Q2

CREATE TABLE Train_Status (
    TrainNumber int,
    TrainDate DATE,
    AC_Seat_Amount int,
    General_Seat_Amount int, 
    AC_Seats_Booked int,
    General_Seats_Booked int,    
    FOREIGN KEY (TrainNumber) REFERENCES TrainList(TrainNumber),
    CONSTRAINT PK PRIMARY KEY (TrainNumber, TrainDate)
);


-- Q3

CREATE TABLE Passenger(
    TicketID int PRIMARY KEY,
    TrainNumber int,
    Booking_Date DATE,
    FName varchar2(200),
    Age int,
    Sex char(1) CHECK (Sex IN ('M', 'F')),
    Address varchar2(200),
    Status char(1) Check (Status IN ('C', 'W')),
    Seat_Category char(2) CHECK (Seat_Category IN ('AC', 'GR')),
    FOREIGN KEY (TrainNumber) REFERENCES TrainList(TrainNumber)
);


-- Q4

CREATE OR REPLACE TRIGGER tr_TrainList 
    BEFORE INSERT ON TRAINLIST 
    FOR EACH ROW
    DECLARE 
        LastNum int;
    BEGIN 
        SELECT TrainNumber
        INTO LastNum
        FROM TrainList
        ORDER BY TrainNumber DESC FETCH FIRST 1 ROWS ONLY;
        
        IF LastNum IS NOT NULL THEN 
            :new.TrainNumber := LastNum + 10;
        ELSE 
            :new.TrainNumber := 500;
        END IF;
    END;
    
-- TESTING
INSERT INTO TrainList (TrainNumber, TrainName, TRsource, TRdestination, ACFare, GeneralFare, Weekdays)
VALUES (500, 'Express Train', 'CityA', 'CityB', 1500, 800, 'Mon,Tue,Wed');

    
CREATE OR REPLACE TRIGGER tr_TicketID
    BEFORE INSERT ON Passenger  
    FOR EACH ROW
    DECLARE 
        LastTicketID INT;
    BEGIN
        SELECT TicketID
        INTO LastTicketID
        FROM Passenger
        ORDER BY TicketID DESC FETCH FIRST 1 ROWS ONLY;
        
        IF LastTicketID IS NOT NULL THEN 
            :new.TicketID := LastTicketID + 1;
        ELSE 
            :new.TicketID := 1;
        END IF;
    END;

-- TESTING 
INSERT INTO Passenger (TicketID, Booking_Date, FName, Age, Sex, Address, Status, Seat_Category)
VALUES (1, SYSDATE, 'Alice', 28, 'F', '123 Maple St', 'C', 'AC');

INSERT INTO TrainList (TrainName, TRsource, TRdestination, ACFare, GeneralFare, Weekdays)
VALUES ('City Rail', 'CityC', 'CityD', 1200, 600, 'Thu,Fri');

INSERT INTO TrainList (TrainName, TRsource, TRdestination, ACFare, GeneralFare, Weekdays)
VALUES ('Mountain Line', 'CityE', 'CityF', 2000, 1000, 'Sat,Sun');

SELECT * FROM TrainList;


INSERT INTO Passenger (TrainNumber, Booking_Date, FName, Age, Sex, Address, Status, Seat_Category)
VALUES (510, SYSDATE, 'Bob', 35, 'M', '456 Oak St', 'W', 'GR');

INSERT INTO Passenger (TrainNumber, Booking_Date, FName, Age, Sex, Address, Status, Seat_Category)
VALUES (520, SYSDATE, 'Charlie', 42, 'M', '789 Pine St', 'C', 'AC');

SELECT * FROM Passenger;

DROP TRIGGER TR_TRAINLIST;
DROP TRIGGER TR_TicketID;


-- Q5

CREATE OR REPLACE PROCEDURE BOOK_TICKET (
    P_TRAINNUMBER IN INT,
    P_TRAINDATE IN DATE,
    P_CATEGORY IN CHAR,
    P_FNAME IN VARCHAR2,
    P_AGE IN INT,
    P_SEX IN CHAR,
    P_ADDRESS IN VARCHAR2
) IS
    SEATS_BOOKED INT;
    SEAT_LIMIT INT;
BEGIN

    IF P_CATEGORY = 'AC' THEN
        SELECT AC_Seats_Booked, AC_Seat_Amount
        INTO SEATS_BOOKED, SEAT_LIMIT
        FROM Train_Status
        WHERE TrainNumber = P_TRAINNUMBER AND TrainDate = P_TRAINDATE;
    ELSIF P_CATEGORY = 'GR' THEN
        SELECT General_Seats_Booked, General_Seat_Amount
        INTO SEATS_BOOKED, SEAT_LIMIT
        FROM Train_Status
        WHERE TrainNumber = P_TRAINNUMBER AND TrainDate = P_TRAINDATE;
    ELSE
        RAISE_APPLICATION_ERROR(-20001, 'Invalid seat category.');
    END IF;

    IF SEATS_BOOKED < SEAT_LIMIT THEN
        INSERT INTO Passenger (TrainNumber, Booking_Date, FName, Age, Sex, Address, Status, Seat_Category)
        VALUES (P_TRAINNUMBER, P_TRAINDATE, P_FNAME, P_AGE, P_SEX, P_ADDRESS, 'C', P_CATEGORY);

        IF P_CATEGORY = 'AC' THEN
            UPDATE Train_Status
            SET AC_Seats_Booked = AC_Seats_Booked + 1
            WHERE TrainNumber = P_TRAINNUMBER AND TrainDate = P_TRAINDATE;
        ELSE
            UPDATE Train_Status
            SET General_Seats_Booked = General_Seats_Booked + 1
            WHERE TrainNumber = P_TRAINNUMBER AND TrainDate = P_TRAINDATE;
        END IF;
    ELSE
        IF SEATS_BOOKED < SEAT_LIMIT + 2 THEN
            INSERT INTO Passenger (TrainNumber, Booking_Date, FName, Age, Sex, Address, Status, Seat_Category)
            VALUES (P_TRAINNUMBER, P_TRAINDATE, P_FNAME, P_AGE, P_SEX, P_ADDRESS, 'W', P_CATEGORY);
        ELSE
            DBMS_OUTPUT.PUT_LINE('No seat ' || P_CATEGORY || ' category for ' || P_TRAINNUMBER || ' on ' || P_TRAINDATE);
        END IF;
    END IF;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No record ' || P_TRAINNUMBER || ' on ' || P_TRAINDATE);
END;


-- Q6

CREATE OR REPLACE PROCEDURE CANCEL_TICKET (
    P_TICKETID IN INT
) IS
    TRAINNUMBER INT;
    BOOKING_DATE DATE;
    SEAT_CATEGORY CHAR(2);
BEGIN
    SELECT TRAINNUMBER, BOOKING_DATE, SEAT_CATEGORY
    INTO TRAINNUMBER, BOOKING_DATE, SEAT_CATEGORY
    FROM PASSENGER
    WHERE TICKETID = P_TICKETID;

    DELETE FROM PASSENGER WHERE TICKETID = P_TICKETID;

    IF SEAT_CATEGORY = 'AC' THEN
        UPDATE TRAIN_STATUS
        SET AC_SEATS_BOOKED = AC_SEATS_BOOKED - 1
        WHERE TRAINNUMBER = TRAINNUMBER AND TRAINDATE = BOOKING_DATE;

        UPDATE PASSENGER
        SET STATUS = 'C'
        WHERE TRAINNUMBER = TRAINNUMBER AND BOOKING_DATE = BOOKING_DATE AND SEAT_CATEGORY = 'AC' AND STATUS = 'W'
        AND ROWNUM = 1;
    ELSIF SEAT_CATEGORY = 'GR' THEN
        UPDATE TRAIN_STATUS
        SET GENERAL_SEATS_BOOKED = GENERAL_SEATS_BOOKED - 1
        WHERE TRAINNUMBER = TRAINNUMBER AND TRAINDATE = BOOKING_DATE;

        UPDATE PASSENGER
        SET STATUS = 'C'
        WHERE TRAINNUMBER = TRAINNUMBER AND BOOKING_DATE = BOOKING_DATE AND SEAT_CATEGORY = 'GR' AND STATUS = 'W'
        AND ROWNUM = 1;
    END IF;

    DBMS_OUTPUT.PUT_LINE('TICKET CANCELLED SUCCESSFULLY.');
END;


-- Q7

BEGIN
    BOOK_TICKET(500, SYSDATE, 'AC', 'Alice', 30, 'F', '123 Maple St');
    BOOK_TICKET(500, SYSDATE, 'GR', 'Bob', 40, 'M', '456 Oak St');
    BOOK_TICKET(500, SYSDATE, 'AC', 'Charlie', 25, 'M', '789 Pine St');
END;

SELECT * FROM PASSENGER;
SELECT * FROM TRAIN_STATUS;
SELECT * FROM TRAINLIST;

BEGIN
    CANCEL_TICKET(520);
END;

--DROP TABLE PASSENGER;
--DROP TABLE TRAIN_STATUS;
--DROP TABLE TRAINLIST;
