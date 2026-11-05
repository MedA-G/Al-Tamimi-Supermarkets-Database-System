-- ============================================================
-- Al-Tamimi Supermarkets Database System (Oracle SQL)
-- Course: DBA307 - Database Management
-- Academic Year: 2025-2026
-- ============================================================

-- ------------------------------------------------------------
-- 1. TABLE CREATION (DDL)
-- ------------------------------------------------------------

CREATE TABLE Branch (
    branchID      NUMBER(3)     CONSTRAINT pk_branch PRIMARY KEY,
    branchName    VARCHAR2(50)  CONSTRAINT nn_branch_name NOT NULL,
    city          VARCHAR2(30)  CONSTRAINT nn_branch_city NOT NULL,
    address       VARCHAR2(100)
);

CREATE TABLE Category (
    categoryID    NUMBER(3)     CONSTRAINT pk_category PRIMARY KEY,
    categoryName  VARCHAR2(50)  CONSTRAINT nn_category_name NOT NULL,
    CONSTRAINT uq_category_name UNIQUE (categoryName)
);

CREATE TABLE Department (
    departmentID    NUMBER(3)     CONSTRAINT pk_department PRIMARY KEY,
    departmentName  VARCHAR2(50)  CONSTRAINT nn_dept_name NOT NULL,
    numEmployees    NUMBER(3)     DEFAULT 0 CONSTRAINT ck_dept_numemp CHECK (numEmployees >= 0),
    branchID        NUMBER(3)     CONSTRAINT nn_dept_branch NOT NULL,
    CONSTRAINT fk_dept_branch FOREIGN KEY (branchID) REFERENCES Branch(branchID),
    CONSTRAINT uq_dept_name_branch UNIQUE (departmentName, branchID)
);

CREATE TABLE Employee (
    eID           NUMBER(4)     CONSTRAINT pk_employee PRIMARY KEY,
    fName         VARCHAR2(30)  CONSTRAINT nn_emp_fname NOT NULL,
    lName         VARCHAR2(30)  CONSTRAINT nn_emp_lname NOT NULL,
    position      VARCHAR2(50)  CONSTRAINT nn_emp_position NOT NULL,
    salary        NUMBER(8,2)   CONSTRAINT nn_emp_salary NOT NULL,
    address       VARCHAR2(100),
    sex           CHAR(1)       CONSTRAINT nn_emp_sex NOT NULL,
    dob           DATE          CONSTRAINT nn_emp_dob NOT NULL,
    hireDate      DATE          CONSTRAINT nn_emp_hire NOT NULL,
    departmentID  NUMBER(3)     CONSTRAINT nn_emp_dept NOT NULL,
    CONSTRAINT fk_emp_dept FOREIGN KEY (departmentID) REFERENCES Department(departmentID),
    CONSTRAINT ck_emp_sex CHECK (sex IN ('M', 'F')),
    CONSTRAINT ck_emp_salary CHECK (salary > 0)
);

CREATE TABLE Customer (
    customerID    NUMBER(4)     CONSTRAINT pk_customer PRIMARY KEY,
    fName         VARCHAR2(30)  CONSTRAINT nn_cust_fname NOT NULL,
    lName         VARCHAR2(30)  CONSTRAINT nn_cust_lname NOT NULL,
    phone         VARCHAR2(20),
    email         VARCHAR2(100),
    CONSTRAINT uq_customer_email UNIQUE (email)
);

CREATE TABLE Supplier (
    supplierID    NUMBER(4)     CONSTRAINT pk_supplier PRIMARY KEY,
    supplierName  VARCHAR2(80)  CONSTRAINT nn_supplier_name NOT NULL,
    phone         VARCHAR2(20),
    city          VARCHAR2(30),
    branchID      NUMBER(3)     CONSTRAINT nn_supplier_branch NOT NULL,
    CONSTRAINT fk_supplier_branch FOREIGN KEY (branchID) REFERENCES Branch(branchID)
);

CREATE TABLE Product (
    productID     NUMBER(4)     CONSTRAINT pk_product PRIMARY KEY,
    pName         VARCHAR2(50)  CONSTRAINT nn_product_name NOT NULL,
    brand         VARCHAR2(50),
    price         NUMBER(8,2)   CONSTRAINT nn_product_price NOT NULL,
    unit          VARCHAR2(20)  CONSTRAINT nn_product_unit NOT NULL,
    categoryID    NUMBER(3)     CONSTRAINT nn_product_cat NOT NULL,
    CONSTRAINT fk_product_cat FOREIGN KEY (categoryID) REFERENCES Category(categoryID),
    CONSTRAINT ck_product_price CHECK (price > 0)
);

CREATE TABLE Project (
    projectID     NUMBER(4)     CONSTRAINT pk_project PRIMARY KEY,
    projectName   VARCHAR2(80)  CONSTRAINT nn_project_name NOT NULL,
    location      VARCHAR2(100),
    departmentID  NUMBER(3)     CONSTRAINT nn_project_dept NOT NULL,
    CONSTRAINT fk_project_dept FOREIGN KEY (departmentID) REFERENCES Department(departmentID)
);

CREATE TABLE Sales_Transaction (
    transactionID   NUMBER(6)     CONSTRAINT pk_sales_trans PRIMARY KEY,
    transactionDate DATE          CONSTRAINT nn_trans_date NOT NULL,
    totalAmount     NUMBER(10,2)  CONSTRAINT nn_trans_total NOT NULL,
    eID             NUMBER(4)     CONSTRAINT nn_trans_emp NOT NULL,
    customerID      NUMBER(4)     CONSTRAINT nn_trans_cust NOT NULL,
    CONSTRAINT fk_sale_emp FOREIGN KEY (eID) REFERENCES Employee(eID),
    CONSTRAINT fk_sale_cust FOREIGN KEY (customerID) REFERENCES Customer(customerID),
    CONSTRAINT ck_trans_total CHECK (totalAmount >= 0)
);

CREATE TABLE Department_Manager_History (
    startDate     DATE          CONSTRAINT nn_dm_start NOT NULL,
    departmentID  NUMBER(3)     CONSTRAINT nn_dm_dept NOT NULL,
    eID           NUMBER(4)     CONSTRAINT nn_dm_emp NOT NULL,
    CONSTRAINT pk_dept_mgr PRIMARY KEY (startDate, departmentID),
    CONSTRAINT fk_dsh_dept FOREIGN KEY (departmentID) REFERENCES Department(departmentID),
    CONSTRAINT fk_dsh_emp FOREIGN KEY (eID) REFERENCES Employee(eID)
);

CREATE TABLE Employee_Project (
    assignmentID  NUMBER(5)     CONSTRAINT pk_empproj PRIMARY KEY,
    startDate     DATE          CONSTRAINT nn_empproj_start NOT NULL,
    endDate       DATE,
    projectID     NUMBER(4)     CONSTRAINT nn_empproj_proj NOT NULL,
    eID           NUMBER(4)     CONSTRAINT nn_empproj_emp NOT NULL,
    CONSTRAINT fk_empproj_proj FOREIGN KEY (projectID) REFERENCES Project(projectID),
    CONSTRAINT fk_empproj_emp FOREIGN KEY (eID) REFERENCES Employee(eID),
    CONSTRAINT ck_empproj_dates CHECK (endDate IS NULL OR endDate >= startDate),
    CONSTRAINT uq_empproj UNIQUE (eID, projectID, startDate)
);

CREATE TABLE Dependent (
    dependentID   NUMBER(4)     CONSTRAINT pk_dependent PRIMARY KEY,
    dependentName VARCHAR2(50)  CONSTRAINT nn_dep_name NOT NULL,
    sex           CHAR(1)       CONSTRAINT nn_dep_sex NOT NULL,
    relationship  VARCHAR2(20)  CONSTRAINT nn_dep_rel NOT NULL,
    dob           DATE          CONSTRAINT nn_dep_dob NOT NULL,
    eID           NUMBER(4)     CONSTRAINT nn_dep_emp NOT NULL,
    CONSTRAINT fk_dep_emp FOREIGN KEY (eID) REFERENCES Employee(eID),
    CONSTRAINT ck_dep_sex CHECK (sex IN ('M', 'F'))
);

CREATE TABLE Item_Transaction (
    itemID        NUMBER(5)     CONSTRAINT pk_item_trans PRIMARY KEY,
    quantity      NUMBER(5)     CONSTRAINT nn_item_qty NOT NULL,
    transactionID NUMBER(6)     CONSTRAINT nn_item_transid NOT NULL,
    productID     NUMBER(4)     CONSTRAINT nn_item_prodid NOT NULL,
    CONSTRAINT fk_item_trans FOREIGN KEY (transactionID) REFERENCES Sales_Transaction(transactionID),
    CONSTRAINT fk_item_prod FOREIGN KEY (productID) REFERENCES Product(productID),
    CONSTRAINT ck_item_qty CHECK (quantity > 0),
    CONSTRAINT uq_item_line UNIQUE (transactionID, productID)
);

-- ------------------------------------------------------------
-- 2. DATA INSERTION (DML)
-- ------------------------------------------------------------

-- Branch Inserts
INSERT INTO Branch (branchID, branchName, city, address) VALUES (101, 'Granada Branch', 'Riyadh', 'Granada Mall, Gate 3');
INSERT INTO Branch (branchID, branchName, city, address) VALUES (102, 'Corniche Branch', 'Dammam', 'Corniche Road');
INSERT INTO Branch (branchID, branchName, city, address) VALUES (103, 'Nakheel Branch', 'Riyadh', 'Nakheel Mall, Gate 2');

-- Department Inserts
INSERT INTO Department (departmentID, departmentName, numEmployees, branchID) VALUES (1, 'Store Operations', 12, 101);
INSERT INTO Department (departmentID, departmentName, numEmployees, branchID) VALUES (2, 'Cashiers', 18, 101);
INSERT INTO Department (departmentID, departmentName, numEmployees, branchID) VALUES (3, 'Customer Service', 6, 101);
INSERT INTO Department (departmentID, departmentName, numEmployees, branchID) VALUES (4, 'Store Operations', 10, 102);
INSERT INTO Department (departmentID, departmentName, numEmployees, branchID) VALUES (5, 'Cashiers', 15, 102);
INSERT INTO Department (departmentID, departmentName, numEmployees, branchID) VALUES (6, 'Customer Service', 5, 102);
INSERT INTO Department (departmentID, departmentName, numEmployees, branchID) VALUES (7, 'Store Operations', 11, 103);
INSERT INTO Department (departmentID, departmentName, numEmployees, branchID) VALUES (8, 'Cashiers', 16, 103);
INSERT INTO Department (departmentID, departmentName, numEmployees, branchID) VALUES (9, 'Marketing & Promotions', 6, 103);

-- Employee Inserts
INSERT INTO Employee VALUES (201, 'Ahmed', 'Salem', 'Store Operations Manager', 7500, 'Riyadh - Granada', 'M', TO_DATE('12-APR-1995', 'DD-MON-YYYY'), TO_DATE('01-JUN-21', 'DD-MON-YY'), 1);
INSERT INTO Employee VALUES (202, 'Rana', 'Yousif', 'Stock Clerk', 4000, 'Riyadh - Granada', 'F', TO_DATE('29-SEP-1998', 'DD-MON-YYYY'), TO_DATE('15-OCT-22', 'DD-MON-YY'), 1);
INSERT INTO Employee VALUES (203, 'Majed', 'Saleh', 'Floor Staff', 4600, 'Riyadh - Granada', 'M', TO_DATE('05-NOV-1997', 'DD-MON-YYYY'), TO_DATE('10-MAY-22', 'DD-MON-YY'), 1);
INSERT INTO Employee VALUES (204, 'Layla', 'Faris', 'Cashier Supervisor', 6100, 'Riyadh - Granada', 'F', TO_DATE('10-MAY-1996', 'DD-MON-YYYY'), TO_DATE('01-SEP-18', 'DD-MON-YY'), 2);
INSERT INTO Employee VALUES (205, 'Saif', 'Hamad', 'Cashier', 4500, 'Riyadh - Granada', 'M', TO_DATE('22-JUL-2000', 'DD-MON-YYYY'), TO_DATE('14-FEB-21', 'DD-MON-YY'), 2);
INSERT INTO Employee VALUES (206, 'Reem', 'Nasser', 'Cashier', 4450, 'Riyadh - Granada', 'F', TO_DATE('30-MAR-2001', 'DD-MON-YYYY'), TO_DATE('01-APR-22', 'DD-MON-YY'), 2);
INSERT INTO Employee VALUES (207, 'Nora', 'Ali', 'CS Supervisor', 6000, 'Riyadh - Granada', 'F', TO_DATE('15-JAN-1996', 'DD-MON-YYYY'), TO_DATE('02-SEP-19', 'DD-MON-YY'), 3);
INSERT INTO Employee VALUES (208, 'Huda', 'Ibrahim', 'CS Agent', 4700, 'Riyadh - Granada', 'F', TO_DATE('20-MAY-2001', 'DD-MON-YYYY'), TO_DATE('16-JUL-22', 'DD-MON-YY'), 3);
INSERT INTO Employee VALUES (209, 'Sami', 'Kareem', 'CS Agent', 4650, 'Riyadh - Granada', 'M', TO_DATE('11-AUG-1999', 'DD-MON-YYYY'), TO_DATE('10-FEB-22', 'DD-MON-YY'), 3);
INSERT INTO Employee VALUES (210, 'Faisal', 'Omar', 'Store Operations Manager', 7000, 'Dammam - Corniche', 'M', TO_DATE('28-DEC-1994', 'DD-MON-YYYY'), TO_DATE('01-NOV-18', 'DD-MON-YY'), 4);
INSERT INTO Employee VALUES (211, 'Ali', 'Zaid', 'Receiver', 4800, 'Dammam - Corniche', 'M', TO_DATE('05-JUL-1996', 'DD-MON-YYYY'), TO_DATE('05-MAR-20', 'DD-MON-YY'), 4);
INSERT INTO Employee VALUES (212, 'Maha', 'Adel', 'Floor Staff', 4700, 'Dammam - Corniche', 'F', TO_DATE('05-FEB-1998', 'DD-MON-YYYY'), TO_DATE('31-JUL-22', 'DD-MON-YY'), 4);
INSERT INTO Employee VALUES (213, 'Reema', 'Majed', 'Cashier Supervisor', 6100, 'Khobar', 'F', TO_DATE('15-MAR-1997', 'DD-MON-YYYY'), TO_DATE('01-OCT-19', 'DD-MON-YY'), 5);
INSERT INTO Employee VALUES (214, 'Tariq', 'Zayed', 'Cashier', 4550, 'Dammam - Corniche', 'M', TO_DATE('22-AUG-1999', 'DD-MON-YYYY'), TO_DATE('25-NOV-21', 'DD-MON-YY'), 5);
INSERT INTO Employee VALUES (215, 'Lina', 'Saad', 'Cashier', 4400, 'Dammam - Corniche', 'F', TO_DATE('18-JUN-2002', 'DD-MON-YYYY'), TO_DATE('11-DEC-22', 'DD-MON-YY'), 5);
INSERT INTO Employee VALUES (216, 'Abeer', 'Hassan', 'CS Supervisor', 6300, 'Dammam - Corniche', 'F', TO_DATE('05-OCT-1995', 'DD-MON-YYYY'), TO_DATE('10-AUG-18', 'DD-MON-YY'), 6);
INSERT INTO Employee VALUES (217, 'Omar', 'Rashid', 'CS Agent', 4800, 'Dammam - Corniche', 'M', TO_DATE('30-SEP-1998', 'DD-MON-YYYY'), TO_DATE('14-MAY-20', 'DD-MON-YY'), 6);
INSERT INTO Employee VALUES (218, 'Dana', 'Khalil', 'CS Agent', 4650, 'Dammam - Corniche', 'F', TO_DATE('22-NOV-2001', 'DD-MON-YYYY'), TO_DATE('27-SEP-22', 'DD-MON-YY'), 6);
INSERT INTO Employee VALUES (219, 'Sami', 'Nasser', 'Operations Supervisor', 7000, 'Riyadh - Nakheel', 'M', TO_DATE('05-NOV-1993', 'DD-MON-YYYY'), TO_DATE('10-JAN-20', 'DD-MON-YY'), 7);
INSERT INTO Employee VALUES (220, 'Hind', 'Mousa', 'Floor Staff', 4650, 'Riyadh - Nakheel', 'F', TO_DATE('07-APR-1999', 'DD-MON-YYYY'), TO_DATE('15-AUG-21', 'DD-MON-YY'), 7);
INSERT INTO Employee VALUES (221, 'Yara', 'Samir', 'Inventory Clerk', 4900, 'Riyadh - Nakheel', 'F', TO_DATE('14-MAY-1997', 'DD-MON-YYYY'), TO_DATE('15-JAN-22', 'DD-MON-YY'), 7);
INSERT INTO Employee VALUES (222, 'Nabil', 'Saleh', 'Cashier Supervisor', 6150, 'Riyadh - Nakheel', 'M', TO_DATE('20-JUN-1995', 'DD-MON-YYYY'), TO_DATE('16-FEB-21', 'DD-MON-YY'), 8);
INSERT INTO Employee VALUES (223, 'Waleed', 'Anwar', 'Cashier', 4550, 'Riyadh - Nakheel', 'M', TO_DATE('27-JAN-2001', 'DD-MON-YYYY'), TO_DATE('08-SEP-21', 'DD-MON-YY'), 8);
INSERT INTO Employee VALUES (224, 'Sara', 'Jalal', 'Cashier', 4450, 'Riyadh - Nakheel', 'F', TO_DATE('24-DEC-1999', 'DD-MON-YYYY'), TO_DATE('11-OCT-22', 'DD-MON-YY'), 8);
INSERT INTO Employee VALUES (225, 'Aisha', 'Rahman', 'Marketing Coordinator', 6400, 'Riyadh - Nakheel', 'F', TO_DATE('12-FEB-1996', 'DD-MON-YYYY'), TO_DATE('20-FEB-19', 'DD-MON-YY'), 9);
INSERT INTO Employee VALUES (226, 'Hani', 'Yusuf', 'Graphic Designer', 5500, 'Riyadh - Nakheel', 'M', TO_DATE('03-JUL-1998', 'DD-MON-YYYY'), TO_DATE('18-APR-21', 'DD-MON-YY'), 9);
INSERT INTO Employee VALUES (227, 'Lujain', 'Hakim', 'Social Media Specialist', 5300, 'Riyadh - Nakheel', 'F', TO_DATE('29-OCT-2000', 'DD-MON-YYYY'), TO_DATE('05-JAN-23', 'DD-MON-YY'), 9);

-- Customer Inserts
INSERT INTO Customer (customerID, fName, lName, phone, email) VALUES (801, 'Khalid', 'Omar', '0551122334', 'khalid.o@example.com');
INSERT INTO Customer (customerID, fName, lName, phone, email) VALUES (802, 'Mariam', 'Hassan', '0569988776', 'mariam.h@example.com');
INSERT INTO Customer (customerID, fName, lName, phone, email) VALUES (803, 'Saad', 'Fahad', '0547766554', 'saad.f@example.com');

-- Supplier Inserts
INSERT INTO Supplier (supplierID, supplierName, phone, city, branchID) VALUES (501, 'FreshFarms Co.', '0501234567', 'Riyadh', 101);
INSERT INTO Supplier (supplierID, supplierName, phone, city, branchID) VALUES (502, 'Gulf Packaging Ltd.', '0543342211', 'Dammam', 102);
INSERT INTO Supplier (supplierID, supplierName, phone, city, branchID) VALUES (503, 'CleanHome Products', '0558899772', 'Riyadh', 103);

-- Category Inserts
INSERT INTO Category (categoryID, categoryName) VALUES (1, 'Produce');
INSERT INTO Category (categoryID, categoryName) VALUES (2, 'Bakery');
INSERT INTO Category (categoryID, categoryName) VALUES (3, 'Dairy & Beverages');
INSERT INTO Category (categoryID, categoryName) VALUES (4, 'Household & Cleaning');

-- Product Inserts
INSERT INTO Product (productID, pName, brand, price, unit, categoryID) VALUES (701, 'Tomatoes', 'FreshFarms', 4.50, 'Kg', 1);
INSERT INTO Product (productID, pName, brand, price, unit, categoryID) VALUES (702, 'White Bread Loaf', 'SunBake', 7.50, 'Piece', 2);
INSERT INTO Product (productID, pName, brand, price, unit, categoryID) VALUES (703, 'Milk 2L', 'DairyPure', 8.75, 'Liter', 3);
INSERT INTO Product (productID, pName, brand, price, unit, categoryID) VALUES (704, 'Floor Cleaner', 'CleanHome', 12.00, 'Bottle', 4);

-- Project Inserts
INSERT INTO Project (projectID, projectName, location, departmentID) VALUES (301, 'Aisle Reorganization', 'Granada Branch - Operations', 1);
INSERT INTO Project (projectID, projectName, location, departmentID) VALUES (302, 'Cashier Queue Optimization', 'Granada Branch - Checkout', 2);
INSERT INTO Project (projectID, projectName, location, departmentID) VALUES (303, 'Customer Feedback Kiosk Setup', 'Granada Branch - Entry Area', 3);
INSERT INTO Project (projectID, projectName, location, departmentID) VALUES (304, 'Inventory Layout Improvement', 'Corniche Branch - Warehouse', 4);
INSERT INTO Project (projectID, projectName, location, departmentID) VALUES (305, 'Express Cashier Lane Setup', 'Corniche Branch - Front End', 5);
INSERT INTO Project (projectID, projectName, location, departmentID) VALUES (306, 'Customer Inquiry System Upgrade', 'Corniche Branch - CS Desk', 6);
INSERT INTO Project (projectID, projectName, location, departmentID) VALUES (307, 'Storage Area Redesign', 'Nakheel Branch - Backroom', 7);
INSERT INTO Project (projectID, projectName, location, departmentID) VALUES (308, 'Cashier Scheduling Automation', 'Nakheel Branch - Cash Office', 8);
INSERT INTO Project (projectID, projectName, location, departmentID) VALUES (309, 'Weekend Deals Ad Campaign', 'Riyadh Region', 9);

-- Department_Manager_History Inserts
INSERT INTO Department_Manager_History (startDate, departmentID, eID) VALUES (TO_DATE('01-MAR-19', 'DD-MON-YY'), 1, 201);
INSERT INTO Department_Manager_History (startDate, departmentID, eID) VALUES (TO_DATE('01-SEP-18', 'DD-MON-YY'), 2, 204);
INSERT INTO Department_Manager_History (startDate, departmentID, eID) VALUES (TO_DATE('15-JAN-19', 'DD-MON-YY'), 3, 207);
INSERT INTO Department_Manager_History (startDate, departmentID, eID) VALUES (TO_DATE('01-NOV-18', 'DD-MON-YY'), 4, 210);
INSERT INTO Department_Manager_History (startDate, departmentID, eID) VALUES (TO_DATE('01-OCT-19', 'DD-MON-YY'), 5, 213);
INSERT INTO Department_Manager_History (startDate, departmentID, eID) VALUES (TO_DATE('10-AUG-18', 'DD-MON-YY'), 6, 216);
INSERT INTO Department_Manager_History (startDate, departmentID, eID) VALUES (TO_DATE('10-JAN-20', 'DD-MON-YY'), 7, 219);
INSERT INTO Department_Manager_History (startDate, departmentID, eID) VALUES (TO_DATE('20-JUN-19', 'DD-MON-YY'), 8, 222);
INSERT INTO Department_Manager_History (startDate, departmentID, eID) VALUES (TO_DATE('20-FEB-19', 'DD-MON-YY'), 9, 225);

-- Employee_Project Inserts
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (901, TO_DATE('05-JAN-24', 'DD-MON-YY'), TO_DATE('10-FEB-24', 'DD-MON-YY'), 301, 201);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (902, TO_DATE('05-JAN-24', 'DD-MON-YY'), TO_DATE('10-FEB-24', 'DD-MON-YY'), 301, 202);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (903, TO_DATE('05-JAN-24', 'DD-MON-YY'), TO_DATE('10-FEB-24', 'DD-MON-YY'), 301, 203);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (904, TO_DATE('12-FEB-24', 'DD-MON-YY'), TO_DATE('05-MAR-24', 'DD-MON-YY'), 302, 204);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (905, TO_DATE('12-FEB-24', 'DD-MON-YY'), TO_DATE('05-MAR-24', 'DD-MON-YY'), 302, 205);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (906, TO_DATE('08-MAR-24', 'DD-MON-YY'), TO_DATE('30-MAR-24', 'DD-MON-YY'), 303, 207);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (907, TO_DATE('08-MAR-24', 'DD-MON-YY'), TO_DATE('30-MAR-24', 'DD-MON-YY'), 303, 208);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (908, TO_DATE('15-JAN-24', 'DD-MON-YY'), TO_DATE('20-FEB-24', 'DD-MON-YY'), 304, 210);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (909, TO_DATE('22-FEB-24', 'DD-MON-YY'), TO_DATE('18-MAR-24', 'DD-MON-YY'), 305, 213);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (910, TO_DATE('18-MAR-24', 'DD-MON-YY'), TO_DATE('02-APR-24', 'DD-MON-YY'), 306, 216);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (911, TO_DATE('20-JAN-24', 'DD-MON-YY'), TO_DATE('25-FEB-24', 'DD-MON-YY'), 307, 219);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (912, TO_DATE('27-FEB-24', 'DD-MON-YY'), TO_DATE('22-MAR-24', 'DD-MON-YY'), 308, 222);
INSERT INTO Employee_Project (assignmentID, startDate, endDate, projectID, eID) VALUES (913, TO_DATE('01-FEB-24', 'DD-MON-YY'), TO_DATE('28-FEB-24', 'DD-MON-YY'), 309, 225);

-- Sales_Transaction Inserts
INSERT INTO Sales_Transaction (transactionID, transactionDate, totalAmount, eID, customerID) VALUES (1001, TO_DATE('15-FEB-24', 'DD-MON-YY'), 64.50, 205, 801);
INSERT INTO Sales_Transaction (transactionID, transactionDate, totalAmount, eID, customerID) VALUES (1002, TO_DATE('17-FEB-24', 'DD-MON-YY'), 22.00, 214, 802);
INSERT INTO Sales_Transaction (transactionID, transactionDate, totalAmount, eID, customerID) VALUES (1003, TO_DATE('17-FEB-24', 'DD-MON-YY'), 45.75, 223, 803);

-- Item_Transaction Inserts
INSERT INTO Item_Transaction (itemID, quantity, transactionID, productID) VALUES (1, 2, 1001, 702);
INSERT INTO Item_Transaction (itemID, quantity, transactionID, productID) VALUES (2, 1, 1001, 703);
INSERT INTO Item_Transaction (itemID, quantity, transactionID, productID) VALUES (3, 3, 1002, 704);
INSERT INTO Item_Transaction (itemID, quantity, transactionID, productID) VALUES (4, 1, 1003, 701);
INSERT INTO Item_Transaction (itemID, quantity, transactionID, productID) VALUES (5, 2, 1003, 702);

-- Dependent Inserts
INSERT INTO Dependent (dependentID, dependentName, sex, relationship, dob, eID) VALUES (1, 'Sara Ahmed', 'F', 'Daughter', TO_DATE('14-AUG-20', 'DD-MON-YY'), 201);
INSERT INTO Dependent (dependentID, dependentName, sex, relationship, dob, eID) VALUES (2, 'Mohammed Faisal', 'M', 'Son', TO_DATE('01-MAR-15', 'DD-MON-YY'), 210);
INSERT INTO Dependent (dependentID, dependentName, sex, relationship, dob, eID) VALUES (3, 'Layan Aisha', 'F', 'Daughter', TO_DATE('22-NOV-17', 'DD-MON-YY'), 225);

COMMIT;

-- ------------------------------------------------------------
-- 3. VERIFICATION QUERIES (DQL)
-- ------------------------------------------------------------
SELECT * FROM Branch;
SELECT * FROM Department;
SELECT * FROM Employee;
SELECT * FROM Customer;
SELECT * FROM Category;
SELECT * FROM Product;
SELECT * FROM Supplier;
SELECT * FROM Project;
SELECT * FROM Department_Manager_History;
SELECT * FROM Employee_Project;
SELECT * FROM Sales_Transaction;
SELECT * FROM Item_Transaction;
SELECT * FROM Dependent;