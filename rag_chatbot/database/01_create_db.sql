-- ============================================================
-- ChatbotDB - On-Premise SLM Chatbot Database
-- MySQL Schema Creation Script
-- ============================================================

DROP DATABASE IF EXISTS chatbot_db;
CREATE DATABASE chatbot_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE chatbot_db;

-- ============================================================
-- LOOKUP / MASTER TABLES
-- ============================================================

CREATE TABLE Departments (
    DeptID      INT AUTO_INCREMENT PRIMARY KEY,
    DeptName    VARCHAR(100) NOT NULL,
    DeptCode    VARCHAR(10) NOT NULL UNIQUE,
    Location    VARCHAR(100),
    ManagerID   INT,
    Budget      DECIMAL(15,2) DEFAULT 0,
    Status      CHAR(1) DEFAULT 'A' COMMENT 'A=Active, I=Inactive',
    CreatedAt   DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Roles (
    RoleID      INT AUTO_INCREMENT PRIMARY KEY,
    RoleName    VARCHAR(50) NOT NULL UNIQUE,
    Description VARCHAR(200)
);

CREATE TABLE Shifts (
    ShiftID     INT AUTO_INCREMENT PRIMARY KEY,
    ShiftName   VARCHAR(50) NOT NULL,
    ShiftCode   CHAR(2) NOT NULL,
    StartTime   TIME NOT NULL,
    EndTime     TIME NOT NULL,
    Status      CHAR(1) DEFAULT 'A'
);

CREATE TABLE Qualifications (
    QualID      INT AUTO_INCREMENT PRIMARY KEY,
    QualName    VARCHAR(100) NOT NULL
);

-- ============================================================
-- HR MODULE
-- ============================================================

CREATE TABLE Employees (
    EmployeeID      INT AUTO_INCREMENT PRIMARY KEY,
    EmpCode         VARCHAR(20) NOT NULL UNIQUE,
    EmpName         VARCHAR(100) NOT NULL,
    Gender          ENUM('Male','Female','Other') NOT NULL,
    DateOfBirth     DATE,
    JoinDate        DATE NOT NULL,
    DeptID          INT,
    ShiftID         INT,
    Designation     VARCHAR(100),
    QualificationID INT,
    BasicSalary     DECIMAL(12,2) NOT NULL DEFAULT 0,
    MobileNo        VARCHAR(15),
    Branch          VARCHAR(50),
    Status          CHAR(1) DEFAULT 'A' COMMENT 'A=Active, I=Inactive, R=Resigned',
    CreatedAt       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID),
    FOREIGN KEY (ShiftID) REFERENCES Shifts(ShiftID),
    FOREIGN KEY (QualificationID) REFERENCES Qualifications(QualID)
);

CREATE TABLE LeaveTypes (
    LeaveTypeID     INT AUTO_INCREMENT PRIMARY KEY,
    LeaveTypeName   VARCHAR(50) NOT NULL,
    TypeCode        CHAR(3) NOT NULL UNIQUE,
    MaxDaysPerYear  INT DEFAULT 0
);

CREATE TABLE LeaveEligibility (
    EligID          INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID      INT NOT NULL,
    LeaveTypeID     INT NOT NULL,
    Year            INT NOT NULL,
    EligibleDays    DECIMAL(6,2) DEFAULT 0,
    AvailedDays     DECIMAL(6,2) DEFAULT 0,
    BalanceDays     DECIMAL(6,2) DEFAULT 0,
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (LeaveTypeID) REFERENCES LeaveTypes(LeaveTypeID)
);

CREATE TABLE LeaveTransactions (
    LeaveID         INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID      INT NOT NULL,
    LeaveTypeID     INT NOT NULL,
    FromDate        DATE NOT NULL,
    ToDate          DATE NOT NULL,
    LeaveDays       DECIMAL(5,2) NOT NULL,
    Reason          VARCHAR(300),
    Status          ENUM('Pending','Approved','Rejected') DEFAULT 'Pending',
    ApprovedBy      VARCHAR(100),
    ApprovedDate    DATE,
    ApplicationDate DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    FOREIGN KEY (LeaveTypeID) REFERENCES LeaveTypes(LeaveTypeID)
);

CREATE TABLE Attendance (
    AttendanceID    INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID      INT NOT NULL,
    AttDate         DATE NOT NULL,
    InTime          TIME,
    OutTime         TIME,
    WorkHours       DECIMAL(4,2),
    Status          ENUM('Present','Absent','Leave','Holiday','HalfDay') DEFAULT 'Present',
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    UNIQUE KEY uq_emp_date (EmployeeID, AttDate)
);

-- ============================================================
-- PRODUCT / INVENTORY MODULE
-- ============================================================

CREATE TABLE Categories (
    CategoryID      INT AUTO_INCREMENT PRIMARY KEY,
    CategoryName    VARCHAR(100) NOT NULL,
    CategoryCode    VARCHAR(10) NOT NULL UNIQUE,
    Description     VARCHAR(300)
);

CREATE TABLE Products (
    ProductID       INT AUTO_INCREMENT PRIMARY KEY,
    ProductCode     VARCHAR(20) NOT NULL UNIQUE,
    ProductName     VARCHAR(200) NOT NULL,
    CategoryID      INT,
    UnitOfMeasure   VARCHAR(20) DEFAULT 'Pcs',
    CostPrice       DECIMAL(12,2) NOT NULL DEFAULT 0,
    SellingPrice    DECIMAL(12,2) NOT NULL DEFAULT 0,
    ReorderLevel    INT DEFAULT 10,
    Status          CHAR(1) DEFAULT 'A',
    CreatedAt       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

CREATE TABLE Warehouses (
    WarehouseID     INT AUTO_INCREMENT PRIMARY KEY,
    WarehouseName   VARCHAR(100) NOT NULL,
    Location        VARCHAR(200),
    ManagerID       INT,
    Capacity        INT DEFAULT 0
);

CREATE TABLE Inventory (
    InventoryID     INT AUTO_INCREMENT PRIMARY KEY,
    ProductID       INT NOT NULL,
    WarehouseID     INT NOT NULL,
    QuantityOnHand  INT NOT NULL DEFAULT 0,
    QuantityReserved INT NOT NULL DEFAULT 0,
    LastUpdated     DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID),
    UNIQUE KEY uq_prod_wh (ProductID, WarehouseID)
);

CREATE TABLE StockMovements (
    MovementID      INT AUTO_INCREMENT PRIMARY KEY,
    ProductID       INT NOT NULL,
    WarehouseID     INT NOT NULL,
    MovementType    ENUM('IN','OUT','TRANSFER','ADJUSTMENT') NOT NULL,
    Quantity        INT NOT NULL,
    ReferenceNo     VARCHAR(50),
    Remarks         VARCHAR(300),
    MovementDate    DATE NOT NULL,
    CreatedAt       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID),
    FOREIGN KEY (WarehouseID) REFERENCES Warehouses(WarehouseID)
);

-- ============================================================
-- SALES MODULE
-- ============================================================

CREATE TABLE Customers (
    CustomerID      INT AUTO_INCREMENT PRIMARY KEY,
    CustomerCode    VARCHAR(20) NOT NULL UNIQUE,
    CustomerName    VARCHAR(200) NOT NULL,
    Region          VARCHAR(50),
    City            VARCHAR(100),
    ContactPerson   VARCHAR(100),
    Phone           VARCHAR(20),
    Email           VARCHAR(100),
    CreditLimit     DECIMAL(12,2) DEFAULT 0,
    Status          CHAR(1) DEFAULT 'A',
    CreatedAt       DATETIME DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE SalesOrders (
    OrderID         INT AUTO_INCREMENT PRIMARY KEY,
    OrderNo         VARCHAR(30) NOT NULL UNIQUE,
    OrderDate       DATE NOT NULL,
    CustomerID      INT NOT NULL,
    SalesPersonID   INT,
    Region          VARCHAR(50),
    Status          ENUM('Draft','Confirmed','Shipped','Delivered','Cancelled') DEFAULT 'Draft',
    TotalAmount     DECIMAL(15,2) DEFAULT 0,
    DiscountAmount  DECIMAL(12,2) DEFAULT 0,
    TaxAmount       DECIMAL(12,2) DEFAULT 0,
    NetAmount       DECIMAL(15,2) DEFAULT 0,
    DeliveryDate    DATE,
    Remarks         VARCHAR(500),
    CreatedAt       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (SalesPersonID) REFERENCES Employees(EmployeeID)
);

CREATE TABLE SalesOrderItems (
    ItemID          INT AUTO_INCREMENT PRIMARY KEY,
    OrderID         INT NOT NULL,
    ProductID       INT NOT NULL,
    Quantity        INT NOT NULL,
    UnitPrice       DECIMAL(12,2) NOT NULL,
    Discount        DECIMAL(5,2) DEFAULT 0,
    LineTotal       DECIMAL(15,2) NOT NULL,
    FOREIGN KEY (OrderID) REFERENCES SalesOrders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

CREATE TABLE SalesReturns (
    ReturnID        INT AUTO_INCREMENT PRIMARY KEY,
    ReturnNo        VARCHAR(30) NOT NULL UNIQUE,
    ReturnDate      DATE NOT NULL,
    OrderID         INT NOT NULL,
    Reason          VARCHAR(300),
    ReturnAmount    DECIMAL(12,2) NOT NULL,
    Status          ENUM('Pending','Approved','Processed') DEFAULT 'Pending',
    FOREIGN KEY (OrderID) REFERENCES SalesOrders(OrderID)
);

-- ============================================================
-- FINANCE MODULE
-- ============================================================

CREATE TABLE Accounts (
    AccountID       INT AUTO_INCREMENT PRIMARY KEY,
    AccountCode     VARCHAR(20) NOT NULL UNIQUE,
    AccountName     VARCHAR(200) NOT NULL,
    AccountType     ENUM('Asset','Liability','Equity','Revenue','Expense') NOT NULL,
    ParentAccountID INT,
    Status          CHAR(1) DEFAULT 'A',
    FOREIGN KEY (ParentAccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE FinancialTransactions (
    TransactionID   INT AUTO_INCREMENT PRIMARY KEY,
    TransactionNo   VARCHAR(30) NOT NULL UNIQUE,
    TransactionDate DATE NOT NULL,
    AccountID       INT NOT NULL,
    TransactionType ENUM('Debit','Credit') NOT NULL,
    Amount          DECIMAL(15,2) NOT NULL,
    Description     VARCHAR(500),
    ReferenceNo     VARCHAR(50),
    ReferenceType   VARCHAR(50) COMMENT 'SalesOrder, PurchaseOrder, Payroll, etc.',
    CreatedBy       VARCHAR(100),
    CreatedAt       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);

CREATE TABLE Payroll (
    PayrollID       INT AUTO_INCREMENT PRIMARY KEY,
    EmployeeID      INT NOT NULL,
    PayMonth        INT NOT NULL,
    PayYear         INT NOT NULL,
    BasicSalary     DECIMAL(12,2) NOT NULL,
    Allowances      DECIMAL(10,2) DEFAULT 0,
    Deductions      DECIMAL(10,2) DEFAULT 0,
    GrossSalary     DECIMAL(12,2) NOT NULL,
    NetSalary       DECIMAL(12,2) NOT NULL,
    PaymentDate     DATE,
    Status          ENUM('Pending','Processed','Paid') DEFAULT 'Pending',
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    UNIQUE KEY uq_emp_paymonth (EmployeeID, PayMonth, PayYear)
);

CREATE TABLE Expenses (
    ExpenseID       INT AUTO_INCREMENT PRIMARY KEY,
    ExpenseDate     DATE NOT NULL,
    Category        VARCHAR(100) NOT NULL,
    Description     VARCHAR(300),
    Amount          DECIMAL(12,2) NOT NULL,
    DeptID          INT,
    ApprovedBy      VARCHAR(100),
    Status          ENUM('Pending','Approved','Rejected','Paid') DEFAULT 'Pending',
    CreatedAt       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (DeptID) REFERENCES Departments(DeptID)
);

-- ============================================================
-- APP USERS (RBAC)
-- ============================================================

CREATE TABLE AppUsers (
    UserID          INT AUTO_INCREMENT PRIMARY KEY,
    Username        VARCHAR(50) NOT NULL UNIQUE,
    PasswordHash    VARCHAR(256) NOT NULL,
    FullName        VARCHAR(100) NOT NULL,
    RoleID          INT NOT NULL,
    EmployeeID      INT,
    Region          VARCHAR(50) COMMENT 'For RLS — sales user sees only their region',
    DeptID          INT COMMENT 'For RLS — user sees only their dept data',
    IsActive        TINYINT(1) DEFAULT 1,
    LastLogin       DATETIME,
    CreatedAt       DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID),
    FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID)
);

-- ============================================================
-- AUDIT LOG
-- ============================================================

CREATE TABLE AuditLog (
    LogID           INT AUTO_INCREMENT PRIMARY KEY,
    UserID          INT,
    Username        VARCHAR(50),
    UserRole        VARCHAR(50),
    Question        TEXT,
    GeneratedSQL    TEXT,
    ExecutionStatus ENUM('Success','Error','Blocked') NOT NULL,
    ErrorMessage    TEXT,
    RowsReturned    INT DEFAULT 0,
    LoggedAt        DATETIME DEFAULT CURRENT_TIMESTAMP,
    IPAddress       VARCHAR(50)
);

-- ============================================================
-- ROLE-BASED VIEWS (Row-Level Security)
-- ============================================================

-- Sales view (can be filtered by region in application layer)
CREATE VIEW v_SalesOrders AS
SELECT
    o.OrderID, o.OrderNo, o.OrderDate, o.Status,
    o.TotalAmount, o.DiscountAmount, o.TaxAmount, o.NetAmount,
    o.Region, o.DeliveryDate,
    c.CustomerName, c.City,
    CONCAT(e.EmpName) AS SalesPerson
FROM SalesOrders o
JOIN Customers c ON o.CustomerID = c.CustomerID
LEFT JOIN Employees e ON o.SalesPersonID = e.EmployeeID;

-- Inventory summary view
CREATE VIEW v_InventoryStatus AS
SELECT
    p.ProductID, p.ProductCode, p.ProductName,
    cat.CategoryName,
    w.WarehouseName,
    i.QuantityOnHand, i.QuantityReserved,
    (i.QuantityOnHand - i.QuantityReserved) AS AvailableQty,
    p.ReorderLevel,
    CASE WHEN (i.QuantityOnHand - i.QuantityReserved) <= p.ReorderLevel
         THEN 'Low Stock' ELSE 'OK' END AS StockStatus,
    p.CostPrice, p.SellingPrice,
    i.LastUpdated
FROM Inventory i
JOIN Products p ON i.ProductID = p.ProductID
JOIN Categories cat ON p.CategoryID = cat.CategoryID
JOIN Warehouses w ON i.WarehouseID = w.WarehouseID;

-- Finance summary view (no sensitive masking needed for role; handled in app)
CREATE VIEW v_FinancialSummary AS
SELECT
    ft.TransactionID, ft.TransactionNo, ft.TransactionDate,
    ft.TransactionType, ft.Amount, ft.Description,
    ft.ReferenceNo, ft.ReferenceType,
    a.AccountCode, a.AccountName, a.AccountType
FROM FinancialTransactions ft
JOIN Accounts a ON ft.AccountID = a.AccountID;

-- Management KPI view
CREATE VIEW v_ManagementKPI AS
SELECT
    'TotalSales' AS Metric,
    CAST(SUM(NetAmount) AS CHAR) AS Value,
    'Current Month' AS Period
FROM SalesOrders
WHERE MONTH(OrderDate) = MONTH(CURDATE()) AND YEAR(OrderDate) = YEAR(CURDATE())
UNION ALL
SELECT
    'TotalEmployees',
    CAST(COUNT(*) AS CHAR),
    'Active'
FROM Employees WHERE Status = 'A'
UNION ALL
SELECT
    'LowStockItems',
    CAST(COUNT(*) AS CHAR),
    'Current'
FROM v_InventoryStatus WHERE StockStatus = 'Low Stock'
UNION ALL
SELECT
    'PendingLeaves',
    CAST(COUNT(*) AS CHAR),
    'Current'
FROM LeaveTransactions WHERE Status = 'Pending';
