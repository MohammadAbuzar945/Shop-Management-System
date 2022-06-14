CREATE DATABASE db_Shop

--EMPLOYEE TABLE
CREATE TABLE EMPLOYEES(
Emp_ID INT PRIMARY KEY IDENTITY(1,1)NOT NULL,
EmpName  VARCHAR(20) NOT NULL ,
SSN VARCHAR(20) NOT NULL ,
Phone VARCHAR(20) NULL ,
StoreRef_ID INT NOT NULL FOREIGN KEY REFERENCES STORE(Store_ID),
"Address" VARCHAR(50) NULL ,
Pay INT NOT NULL ,
Email VARCHAR(120) NOT NULL ,
)

SELECT * FROM EMPLOYEES

INSERT INTO EMPLOYEES (EmpName,SSN,Phone,StoreRef_ID,"Address",Pay,Email)
VALUES                ('Ali', '654269856', '5489659874', '854','Model Town', 50000, 'ali@gmail.com'),
                       ('Hamza', '125651452', '6988532587','952' ,'DHA', 50000, 'omegaman@aol.com'),
					   ('Ahmad', '145969658', '9856984523','224' ,'Pak Arab', 60000, 'ahmad@gmail.com'),
					   ('Rehan', '147589652', '2586521452', '159','Nishtar',70000 ,'rehanstrea2@gmail.com'),
					   ('Sharaiz', '256985698', '5896583541', '674','Bahria Town', 30000, 'drinkerster@gmail.com'),
					   ('Hanan', '352956587', '4736593569', '369', 'Wapda Town', 50000, 'hajiabid@gmail.com')


--Procedure for Inserting Values into EMPLOYEE TABLE
GO
ALTER PROCEDURE InsertIntoEmployees @EmpName nvarchar(40),@SSN nvarchar(40),@Phone nvarchar(40),@StoreId nvarchar(40),@Address nvarchar(40),@Pay int,@Email nvarchar(40)
AS
INSERT INTO EMPLOYEES (EmpName,SSN,Phone,StoreRef_ID,"Address",Pay,Email)
VALUES                (@EmpName,@SSN,@Phone,@StoreId,@Address,@Pay,@Email) 
GO   

EXEC InsertIntoEmployees 'Jhanzaib','58-2-4616','0325784611','973','Lahore','11000','jgd@gmail.com'

-- Report, Extracting all Employees of a Store
GO
ALTER PROCEDURE AllEmployeesofAStore @StoreId AS INT
AS
SELECT STORE.Store_ID,STORE.Address,EMPLOYEES.EmpName AS "Employee Name",EMPLOYEES.Pay
FROM STORE,EMPLOYEES WHERE EMPLOYEES.Emp_ID = @StoreId OR STORE.Store_ID = @StoreId
GO
EXEC AllEmployeesofAStore 973


--Employee History Table
CREATE TABLE EMPLOYEE_HISTORY(
ID INT PRIMARY KEY NOT NULL,
Emp_Name VARCHAR(80) NOT NULL,
Pay INT NOT NULL,
Hiring_Date DATE NOT NULL,
"Status" VARCHAR(40) 
)
SELECT * FROM EMPLOYEE_HISTORY

--Trigger For Updating Employee_History Table
GO
ALTER TRIGGER tr_EmployeeHistory
ON EMPLOYEES
AFTER INSERT
AS
BEGIN
     DECLARE @ID AS INT, @EmpName AS VARCHAR(80), @Pay AS INT
	 SELECT @ID = Emp_ID FROM EMPLOYEES WHERE Emp_ID = @@IDENTITY
	 SELECT @EmpName = EmpName FROM EMPLOYEES WHERE Emp_ID = @@IDENTITY
	 SELECT @Pay = Pay FROM EMPLOYEES WHERE Emp_ID = @@IDENTITY
     INSERT INTO EMPLOYEE_HISTORY (ID,Emp_Name,Pay,Hiring_Date,"Status") 
     VALUES                       (@ID,@EmpName,@Pay,GETDATE(),'Working')
END
GO

--Procedure for Deleting Employee
GO
CREATE PROCEDURE DeleteEMP @EmpID AS INT
AS
DELETE FROM EMPLOYEES WHERE Emp_ID = @EmpID
UPDATE EMPLOYEE_HISTORY
	 SET "Status" = 'Left'
	 WHERE ID = @EmpID
GO
EXEC DeleteEMP  233




--STORE TABLE
CREATE TABLE STORE (	
Store_ID INT PRIMARY KEY NOT NULL ,
"Address" VARCHAR(50) NOT NULL,
Phone VARCHAR(50) NOT NULL
)

SELECT * FROM STORE 

INSERT INTO STORE VALUES ('854', 'Lahore','5664622');
INSERT INTO STORE VALUES ('952', 'Lahore','5451615');
INSERT INTO STORE VALUES ('224', 'Islamabad','5455515');
INSERT INTO STORE VALUES ('159', 'Lahore','5646566');
INSERT INTO STORE VALUES ('674', 'Multan','4545455');
INSERT INTO STORE VALUES ('369', 'Islamabad','45486666');

--Procedure for Insering a New Store
GO
CREATE PROCEDURE AddNewStore @StoreId INT, @Address nvarchar(40), @Phone nvarchar(20)
AS
INSERT INTO STORE (Store_ID,"Address",Phone)
VALUES            (@StoreId,@Address,@Phone)
GO

EXEC AddNewStore 345,'Karachi','545445545'


--ITEMS TABLE
CREATE TABLE SALE_ITEMS ( 
SALE_ItemID INT PRIMARY KEY NOT NULL,
Purchase_ItemID INT FOREIGN KEY REFERENCES Purchase_Items(Purchase_ItemID) ON DELETE CASCADE ON UPDATE CASCADE,
Sale_Price INT NOT NULL
)
SELECT * FROM SALE_ITEMS


INSERT INTO SALE_ITEMS VALUES (300,1, 18)
INSERT INTO SALE_ITEMS VALUES (301,2, 25)
INSERT INTO SALE_ITEMS VALUES (302,3, 60)
INSERT INTO SALE_ITEMS VALUES (303,4, 110) 
INSERT INTO SALE_ITEMS VALUES (304,5, 30)
INSERT INTO SALE_ITEMS VALUES (305,6, 30)
INSERT INTO SALE_ITEMS VALUES (306,7, 350)
INSERT INTO SALE_ITEMS VALUES (307,8, 380)

-- Procedure for Inserting Values into Sale_Item Table
GO
CREATE PROCEDURE INSERTintoSaleItem @SaleItem_Id INT, @PurchaseItem_Id INT, @Sale_Price INT
AS
INSERT INTO SALE_ITEMS (SALE_ItemID,Purchase_ItemID,Sale_Price)
VALUES                 (@SaleItem_Id,@PurchaseItem_Id,@Sale_Price)
EXEC InsertSalesHistory
GO

EXEC INSERTintoSaleItem 602,12,50



--PROCEDURE FOR UPDATING PRICE OF AN ITEM
GO
Create PROCEDURE UpdateSalePrice @Sale_ItemId INT, @Sale_Price int
AS
UPDATE SALE_ITEMS
SET Sale_Price = @Sale_Price
WHERE SALE_ItemID = @Sale_ItemId
GO

EXEC UpdateSalePrice 300,19

--Table Sale_Items_History
CREATE TABLE SALE_ITEMS_HISTORY(
ID INT PRIMARY KEY FOREIGN KEY REFERENCES SALE_ITEMS(SALE_ItemID),
PRICE INT,
UPDATED_PRICE INT,
Update_Time Date
)
SELECT * FROM SALE_ITEMS_HISTORY
GO

CREATE Procedure InsertSalesHistory
AS
     DECLARE @supID AS INT, @supNAME AS VARCHAR(80),@Price AS INT
	 SELECT @supID = MAX(SALE_ItemID) FROM SALE_ITEMS
	 SELECT @Price = Sale_Price FROM SALE_ITEMS WHERE SALE_ItemID = @supID
	 INSERT INTO SALE_ITEMS_HISTORY (ID,PRICE,UPDATED_PRICE,Update_Time)
	 VALUES                          (@supID,@Price,0,GETDATE())  
GO


--Suppliers Table
CREATE TABLE SUPPLIERS(  
Supplier_ID INT PRIMARY KEY NOT NULL,
Supplier_Name VARCHAR(80) NOT NULL,
Phone VARCHAR(80) NOT NULL,
Supplier_Company VARCHAR(80) NOT NULL
)
SELECT * FROM SUPPLIERS

INSERT INTO SUPPLIERS VALUES (321,'ALi Raza','45454652','Peak Freans')
INSERT INTO SUPPLIERS VALUES (850,'Sikandar','45425130','Bisconi')
INSERT INTO SUPPLIERS VALUES (352,'Nauman','54231666','Pepsi')
INSERT INTO SUPPLIERS VALUES (478,'Jamil','7756566','Ferrero SpA')
INSERT INTO SUPPLIERS VALUES (358,'Nasir','54545454','Cadbury')
INSERT INTO SUPPLIERS VALUES (474,'Jamil','7756566','Ferrero SpA')

--Procedure For Inserting a New Supplier
GO
ALTER PROCEDURE InsertNewSupplier @SupplierId INT, @Name nvarchar(40),@Phone nvarchar(40), @Company nvarchar(40)
AS
INSERT INTO SUPPLIERS (Supplier_ID,Supplier_Name,Phone,Supplier_Company)
VALUES                (@SupplierId,@Name,@Phone,@Company)
EXEC InsertSupplierHistory
GO

EXEC InsertNewSupplier 1056,'Shazeb','845464646','Cocomo'

CREATE TABLE SUPPLIER_HISTORY(
ID INT PRIMARY KEY IDENTITY (1,1)NOT NULL,
Supplier_ID INT FOREIGN KEY REFERENCES SUPPLIERS(Supplier_ID),
Supplier_Name VARCHAR(80),
"Status" VARCHAR(40),
"Date" DATE
)
SELECT * FROM SUPPLIER_HISTORY

--PROCEDURE FOR ADDING RECORDS IN SUPPLIERS HISTORY TABLE
GO
CREATE Procedure InsertSupplierHistory
AS
     DECLARE @supID AS INT, @supNAME AS VARCHAR(80),@id AS INT
	 SELECT @supID = MAX(Supplier_ID) FROM SUPPLIERS
	 SELECT @id = Supplier_ID FROM SUPPLIERS WHERE Supplier_ID = @supID
	 SELECT @supNAME = Supplier_Name FROM SUPPLIERS WHERE Supplier_ID = @supID
     INSERT INTO SUPPLIER_HISTORY (Supplier_ID,Supplier_Name,"Status","Date")
	 VALUES                       (@supID,@supNAME,'Active',GETDATE())
GO

--Table Purchase
CREATE TABLE Purchase(
Purchase_Id INT PRIMARY KEY NOT NULL,
"Date" DATE NOT NULL,
Supplier_ID INT FOREIGN KEY REFERENCES SUPPLIERS(Supplier_ID)
)
SELECT * FROM Purchase

INSERT INTO Purchase VALUES (1,'2012-02-21',321)
INSERT INTO Purchase VALUES (2,'2020-08-22',352)
INSERT INTO Purchase VALUES (3,'2020-08-23',358)
INSERT INTO Purchase VALUES (4,'2020-08-24',474)
INSERT INTO Purchase VALUES (5,'2020-08-25',321)
INSERT INTO Purchase VALUES (6,'2020-08-25',352)
INSERT INTO Purchase VALUES (7,'2020-08-25',358)
INSERT INTO Purchase VALUES (8,'2020-08-26',474)


--Table Purchase Items
CREATE TABLE Purchase_Items(
Purchase_ItemID INT IDENTITY (1,1) PRIMARY KEY,
Item_Name VARCHAR(80) NOT NULL,
Quantity INT NOT NULL,
Purchase_Price INT NOT NULL,
Purchase_Id INT FOREIGN KEY REFERENCES Purchase(Purchase_Id) ON DELETE CASCADE ON UPDATE CASCADE
)
SELECT *  FROM Purchase_Items 


SELECT * FROM SALE_ITEMS
SELECT * FROM Purchase
SELECT * FROM SUPPLIERS
SELECT * FROM Purchase_Items


INSERT INTO Purchase_Items VALUES ('Prince Biscuit',50,15,1)
INSERT INTO Purchase_Items VALUES ('Choclate Chips',80,480,2)
INSERT INTO Purchase_Items VALUES ('Lays-Frencheese',90,375,3)
INSERT INTO Purchase_Items VALUES ('Dairy Milk Choclate',50,97,4)
INSERT INTO Purchase_Items VALUES ('Lays-Salted',100,53,5)
INSERT INTO Purchase_Items VALUES ('Lays-Masla',100,53,6)
INSERT INTO Purchase_Items VALUES ('Nutella',120,18,7)


--Customer Table
CREATE TABLE CUSTOMER(
Cust_ID INT PRIMARY KEY IDENTITY (1,1)NOT NULL ,
CustName VARCHAR(20) NOT NULL ,
Phone VARCHAR(40) NULL ,
Email VARCHAR(120) NULL,
)

SELECT * FROM CUSTOMER

INSERT INTO CUSTOMER VALUES ('Umair', '6615552485', 'umair@gmail.com')
INSERT INTO CUSTOMER VALUES ('Raza', '4589854588','raza@hotmail.com')
INSERT INTO CUSTOMER VALUES ('Nauman', '4176521425', 'nauman@yahoo.com')
INSERT INTO CUSTOMER VALUES ('Sajid', '551515', 'sajid@gmail.com')
INSERT INTO CUSTOMER VALUES ('Yasir','656666', 'yasir@gmail.com')
INSERT INTO CUSTOMER VALUES ('Majid', '6619755896', NULL)

--Procedure for Adding a new Customer
GO
CREATE PROCEDURE AddCustomer @CustName nvarchar(40),@Phone nvarchar(40), @Email nvarchar(40)
AS
INSERT INTO CUSTOMER (CustName,Phone,Email)
VALUES               (@CustName,@Phone,@Email)
GO

EXEC AddCustomer 'Khan','55154646','khan@gmail.com'
--Procedure for Searching Customer's information
GO
CREATE PROCEDURE SearchCustomerInfo @CustName nvarchar(40)
AS
SELECT * FROM CUSTOMER WHERE CustName = @CustName
GO

EXEC SearchCustomerInfo 'Sajid' 

--INVOICE TABLE
CREATE TABLE INVOICE(
Invoice_Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Cust_Id INT FOREIGN KEY REFERENCES CUSTOMER(Cust_Id) NOT NULL,
Emp_Id INT FOREIGN KEY REFERENCES EMPLOYEES(Emp_ID) NOT NULL,
Total_Bill INT NOT NULL,
)


SELECT * FROM INVOICE
--Procedure to generate bill
GO
CREATE PROCEDURE GenerateBill @Cust_Id INT, @Emp_Id INT
AS
       DECLARE @Item_Id AS INT, @Item_Name AS nvarchar(40),@count AS INT,@Qty AS INT,@Price AS INT,@Total AS INT,@NumQty AS INT
	   SELECT @count =  Id FROM INVOICE_ITEMS WHERE Id = @@IDENTITY
	   PRINT '-----------INVOICE-----------'
	   PRINT 'ITEM NAME|QTY|PRICE'
	   WHILE(@count > 0)
	   BEGIN
	   SELECT @Item_Id = SaleItems_Id FROM INVOICE_ITEMS WHERE ID = @count
	   SELECT @Item_Name = Item_Name FROM Purchase_Items WHERE Purchase_ItemID = @Item_Id
	   SELECT @Qty = Quantity FROM INVOICE_ITEMS WHERE ID = @count
	   SELECT @Price = Price FROM INVOICE_ITEMS WHERE ID = @count
	   PRINT @Item_Name + ' | ' + CAST (@Qty AS VARCHAR(10))+ ' | ' + CAST (@Price AS VARCHAR(10))
	   SET @count = @count - 1
	   END
	   PRINT ''
	   SELECT @NumQty = SUM(Quantity) From INVOICE_ITEMS
	   PRINT 'Total Items = ' + CAST (@NumQty AS VARCHAR(10))
	   SELECT @Total = SUM(Price) From INVOICE_ITEMS
	   PRINT 'Total = ' + CAST (@Total AS VARCHAR(10))
	   
	   IF(@count = 0)
	   BEGIN
	   INSERT INTO INVOICE (Cust_Id,Emp_Id,Total_Bill)
       VALUES              (@Cust_Id,@Emp_Id,(SELECT SUM(Price)FROM INVOICE_ITEMS))

	   END
GO

EXEC GenerateBill 11,3

EXEC AddItemToInvoice 2,350,4


INSERT INTO INVOICE VALUES (2,1,500) 
INSERT INTO INVOICE VALUES (3,1,1500) 
INSERT INTO INVOICE VALUES (2,2,400) 
INSERT INTO INVOICE VALUES (4,5,50) 
INSERT INTO INVOICE VALUES (5,1,35) 
INSERT INTO INVOICE VALUES (6,5,1000) 



--Procedure to  Print Sum of Sales
GO
CREATE PROCEDURE SumOfSales 
AS
DECLARE @TOTAL AS INT
SELECT @TOTAL = SUM(Total_Bill) FROM INVOICE
PRINT 'Total Sales = '+ CAST(@TOTAL AS VARCHAR(10))
GO

EXEC SumOfSales

--Procedure to  Print Average of Sales
GO
CREATE PROCEDURE AvgOfSales 
AS
DECLARE @TOTAL AS FLOAT
SELECT @TOTAL = AVG(Total_Bill) FROM INVOICE
PRINT 'Average Sales = '+ CAST(@TOTAL AS VARCHAR(10))
GO

EXEC AvgOfSales

--Procedure for Inserting Items into Invoice_Items Table
CREATE TABLE INVOICE_ITEMS(
Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Invoice_Id INT FOREIGN KEY REFERENCES INVOICE(Invoice_Id) ON DELETE CASCADE ON UPDATE CASCADE,
SaleItems_Id  INT FOREIGN KEY REFERENCES SALE_ITEMS(SALE_ItemID) ON DELETE CASCADE ON UPDATE CASCADE,
Quantity INT NOT NULL,
Price INT NOT NULL
)

SELECT * FROM INVOICE_ITEMS
--Procedure for Inserting Invoice Items
GO
ALTER PROCEDURE AddItemToInvoice @Invoice_Id INT, @Items_Id INT , @Quantity INT
AS
INSERT INTO INVOICE_ITEMS(Invoice_Id,SaleItems_Id,Quantity,Price)
VALUES             (@Invoice_Id,@Items_Id,@Quantity,(SELECT Sale_PRICE FROM SALE_ITEMS WHERE Purchase_ItemID = @Items_Id)*@Quantity)
GO

EXEC AddItemToInvoice 2,301,3
Select * FROM Purchase_Items Where Purchase_ItemID = 1

SELECT * FROM INVOICE_ITEMS

SELECT * FROM CUSTOMER
SELECT * FROM EMPLOYEES
SELECT * FROM INVOICE
SELECT * FROM INVOICE_ITEMS
SELECT * FROM SUPPLIERS
SELECT * FROM Purchase
SELECT * FROM Purchase_Items 
SELECT * FROM SALE_ITEMS
SELECT * FROM INVOICE_HISTORY

--VIEW FOR ITEMS (Data from Purchase_Items Table and SALE_ITEMS Table)
CREATE VIEW ITEMS AS
SELECT Purchase_Items.Item_Name, Purchase_Items.Quantity,SALE_ITEMS.Sale_Price
FROM Purchase_Items
INNER JOIN SALE_ITEMS
ON Purchase_Items.Purchase_ItemID = SALE_ITEMS.Purchase_ItemID

SELECT * FROM ITEMS



CREATE TABLE INVOICE_HISTORY(
Id INT PRIMARY KEY IDENTITY(1,1) NOT NULL,
Invoice_Id INT NOT NULL FOREIGN KEY REFERENCES INVOICE(Invoice_Id),
Total_Bill INT NOT NULL,
"Date" VARCHAR(80) 
)

SELECT * FROM INVOICE_HISTORY
--Trigger For Invoice History
GO
CREATE TRIGGER TR_INSERTInvoiceHistory
ON INVOICE
AFTER INSERT
AS
BEGIN
     DECLARE @ID AS INT, @Total AS INT
	 Select @ID = Invoice_Id FROM INVOICE Where Invoice_Id = @@IDENTITY
	 Select @Total = Total_Bill FROM INVOICE Where Invoice_Id = @@IDENTITY
	
     INSERT INTO INVOICE_HISTORY (Invoice_Id,Total_Bill,"Date")
	 VALUES                      (@ID,@Total,GETDATE())
END
GO

-- Report, All time Employee Total Sales 
GO
ALTER PROCEDURE EmployeeTotalSales @Emp_Id int
AS
SELECT INVOICE.Emp_Id, INVOICE.Total_Bill
From INVOICE Where Emp_Id = @Emp_Id
DECLARE @Emp_Name varchar(80), @Sum Int
SELECT @Sum = SUM(Total_Bill) From INVOICE WHERE Emp_Id = @Emp_Id
SELECT @Emp_Name = EmpName FROM EMPLOYEES WHERE Emp_ID = @Emp_Id 
PRINT 'Employee Id: ' + CAST (@Emp_Id AS VARCHAR(80))
PRINT 'Employee Name: ' + @Emp_Name
PRINT 'Total Sales: ' + CAST(@Sum AS Varchar(80))
GO

EXEC EmployeeTotalSales 2 

--Trigger for trucating the Invoice Items Table
CREATE TRIGGER tr_clearInvoiceItemsTable
ON INVOICE
AFTER INSERT 
AS
BEGIN 
	 TRUNCATE TABLE INVOICE_ITEMS
END
GO

--Trigger For Decrementing Stock Quantity From Purchase Items Table
GO
ALTER TRIGGER tr_DECQuanatityFromSTOCK
ON INVOICE_ITEMS
AFTER INSERT
AS
BEGIN
DECLARE @Quantity AS INT
SELECT @Quantity = Quantity FROM  INVOICE_ITEMS WHERE ID=@@IDENTITY
UPDATE Purchase_Items
SET Quantity = Quantity - @Quantity WHERE Item_ID = (SELECT Items_Id FROM INVOICE_ITEMS WHERE ID=@@IDENTITY )
END
GO


--Trigger, New Employee Added
GO
ALTER TRIGGER tr_NewEmployeeAdded
ON EMPLOYEES
AFTER INSERT
AS
BEGIN
DECLARE @Emp_Name AS VARCHAR(80)
SELECT @Emp_Name =  EmpName FROM EMPLOYEES WHERE Emp_ID = @@IDENTITY
PRINT 'NEW EMPLOYEE ADDED'
PRINT 'EMPLOYEE NAME:' + @Emp_Name
END
GO

--Procedure For Checking Maximum Sale Price
GO
ALTER PROCEDURE MAXSalePrice
AS
DECLARE @MAXSalePrice AS INT, @ID AS INT, @ItemName AS VARCHAR(80), @QTY AS INT
SELECT @MAXSalePrice = MAX(Sale_Price) FROM SALE_ITEMS
SELECT @ID = Purchase_ItemID FROM SALE_ITEMS WHERE Sale_Price = @MAXSalePrice
SELECT @ItemName = Item_Name, @QTY = Quantity  From Purchase_Items Where Purchase_ItemID =  @ID
PRINT 'Max Sale Price:' + CAST (@MAXSalePrice AS VARCHAR(10)) 
PRINT 'Item Name: ' + @ItemName
PRINT 'Quantity Left: ' + CAST(@QTY AS VARCHAR(10)) 
GO


EXEC MAXSalePrice



EXEC GenerateBill 11,3

EXEC AddItemToInvoice 2,350,4














