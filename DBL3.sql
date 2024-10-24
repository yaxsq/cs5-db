-- c##labtwo 1234

--Q1

CREATE TABLE my_table (
    Name varchar2(255),
    Email varchar2(255),
    Age int,
    Marks NUMBER(3, 1)
);

DESCRIBE my_table;

--Q2

CREATE TABLE products (
    Product_ID int,
    Product_Name varchar2(255),
    Price NUMBER(4, 2),
    Supplier_ID int,
    Category_ID int
); 

DESC products;

--Q3
-- NOT supposed to work

CREATE TABLE IF NOT EXISTS products (
    Product_ID int,
    Product_Name varchar2(255),
    Price NUMBER(4, 2),
    Supplier_ID int,
    Category_ID int
); 

--Q4
-- NOT supposed to work

CREATE TABLE duplicate_Products 
LIKE products;

--Q5

CREATE TABLE dup_data_products AS 
SELECT Product_ID, Product_Name, Price, Supplier_ID, Category_ID
FROM products;

DESC dup_data_products;

--Q6

--DROP TABLE Suppliers;
CREATE TABLE Suppliers (
    Supplier_ID int GENERATED ALWAYS AS IDENTITY NOT NULL, 
    Supplier_Name varchar(255) NOT NULL, 
    Address varchar(255) NOT NULL, 
    City CHAR(3) NOT NULL
);

--Q7

CREATE TABLE Order_Details (
    Order_ID int,
    Product_ID int, 
    Quantity int CHECK (Quantity<=50)
);

DESC Order_Details;

INSERT INTO Order_Details VALUES (1,1,100);     -- Not supposed to be inserted
---- Testing* 
--INSERT INTO Order_Details VALUES (1,1,20);
SELECT * FROM Order_Details;

--Q8

--DROP TABLE Supplier_2;
CREATE TABLE Supplier_2 (
    Supplier_ID int GENERATED ALWAYS AS IDENTITY NOT NULL, 
    Supplier_Name varchar(255) NOT NULL, 
    Address varchar(255) NOT NULL, 
    City CHAR(3) NOT NULL
);

DESC Supplier_2;

INSERT INTO Supplier_2 Values (default, 'MySupplier','MyAddress','LHR');
INSERT INTO Supplier_2 Values (default, 'MySupplier','MyAddress','KHI');
---- Testing
INSERT INTO Supplier_2 Values (default,'MySupplier','MyAddress','BHIII');

SELECT * FROM Supplier_2;

--Q9

--DROP TABLE Orders;
CREATE TABLE Orders (
    Order_ID int,
    Order_Date varchar(10),
    Ship_Address varchar(255)
);

--INSERT INTO Orders VALUES (1,TO_DATE('23/06/2023', 'DD/MM/YYYY'),'Address');
INSERT INTO Orders VALUES (1,'23/05/2023','Address');
--INSERT INTO Orders VALUES (2, '2-5-2023','Address2');       -- Error

SELECT * FROM Orders WHERE order_date LIKE '__/__/____';

ALTER TABLE Orders
MODIFY order_date DATE;         ---------

INSERT INTO Orders VALUES (3, TO_DATE('23/05/2023', 'DD/MM/YYYY'), 'Address3');
INSERT INTO Orders VALUES (4, TO_DATE('2-5-2023', 'DD/MM/YYYY'), 'Address4');       -- Error

--Q10

ALTER TABLE Products
ADD CONSTRAINT PK_PID PRIMARY KEY (PRODUCT_ID);

--Q11

DROP TABLE Suppliers;
CREATE TABLE Suppliers (
    Supplier_ID int GENERATED ALWAYS AS IDENTITY PRIMARY KEY NOT NULL, 
    Supplier_Name varchar(255) NOT NULL, 
    Address varchar(255) NOT NULL, 
    City CHAR(3) NOT NULL
    );
    
--Q12

DROP Table Categories;
CREATE TABLE Categories (
    Category_ID int PRIMARY KEY,
    Category_Name varchar(255),
    Description_C varchar(255)
);

DESC Categories;

--Q13

DROP TABLE Products;
CREATE TABLE Products (
    Product_ID INT PRIMARY KEY,
    Product_Name VARCHAR(255) NOT NULL,
    Price Number(5, 2) NOT NULL,
    Supplier_ID INT,
    Category_ID INT,
    CONSTRAINT fk_supplier
        FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id),
    CONSTRAINT fk_category
        FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    CONSTRAINT unique_product
        UNIQUE (product_name, supplier_id, category_id)
);

--Q14

DROP TABLE Orders;
CREATE TABLE Orders (
    Order_ID int GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    Order_Date DATE,
    Ship_Address varchar(255)
); 

INSERT INTO Orders (ship_address) VALUES ('Address');
SELECT * FROM ORDERS;

--Q15

DROP TABLE ORDER_DETAILS; 
CREATE TABLE Order_Details (
    Order_ID int,
    Product_ID int,
    Quantity int CHECK (Quantity <= 50),
    FOREIGN KEY (Order_ID) REFERENCES ORDERS(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES PRODUCTS(Product_ID),
    CONSTRAINT COMP_KEY PRIMARY KEY (Product_ID, Order_ID)
);

--Q16

INSERT INTO Categories (Category_id, Category_Name, Description_C) 
VALUES (1, 'Beverages', 'Soft drinks, coffees, teas');

INSERT INTO Categories (Category_id, Category_Name, Description_C) 
VALUES (2, 'Dairy Products', 'Cheese');

INSERT INTO Categories (Category_id, Category_Name, Description_C) 
VALUES (3, 'Condiments', 'Sweet and savory sauces, spreads and seasonings');

INSERT INTO Categories (Category_id, Category_Name, Description_C) 
VALUES (4, 'Confections', 'Desserts and candies');

--Q17

INSERT INTO Suppliers (Supplier_id, Supplier_name, Address, City) 
VALUES (default, 'Alpha', '205 A, Street 11, Gulshan-e-Iqbal', 'KHI');

INSERT INTO Suppliers (Supplier_id, Supplier_name, Address, City) 
VALUES (default, 'Bravo', '100 B, Street 2, F-6/3', 'ISB');

--Q18

INSERT INTO Products (Product_id, Product_name, Price, Supplier_id, Category_id) 
VALUES (1, 'Chai', 100.00, 1, 1);

INSERT INTO Products (Product_id, Product_name, Price, Supplier_id, Category_id) 
VALUES (2, 'Cheddar Cheese', 950.00, 2, 2);

INSERT INTO Products (Product_id, Product_name, Price, Supplier_id, Category_id) 
VALUES (3, 'BBQ sauce', 500.00, 2, 3);

INSERT INTO Products (Product_id, Product_name, Price, Supplier_id, Category_id) 
VALUES (4, 'Coffee', 200.00, 1, 1);

INSERT INTO Products (Product_id, Product_name, Price, Supplier_id, Category_id) 
VALUES (5, 'Sprite', 80.00, 1, 1);

INSERT INTO Products (Product_id, Product_name, Price, Supplier_id, Category_id) 
VALUES (6, 'Mayo Garlic Sauce', 450.00, 2, 3);


--Q19

SELECT * 
FROM PRODUCTS 
WHERE Category_ID = 1 AND Supplier_ID = 1;

--Q20

SELECT Category_ID, Round(Avg(Price), 2) 
FROM PRODUCTS
GROUP BY Category_ID;

--Q21

SELECT * 
FROM Categories
ORDER BY Category_Name;

--
--DROP TABLE DUP_DATA_PRODUCTS;
--DROP TABLE MY_TABLE;
--DROP TABLE ORDER_DETAILS;
--DROP TABLE ORDERS;
--DROP TABLE PRODUCTS;
--DROP TABLE SUPPLIER_2;
--DROP TABLE SUPPLIERS;
--DROP TABLE CATEGORIES;