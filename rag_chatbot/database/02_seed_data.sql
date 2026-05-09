-- ============================================================
-- ChatbotDB - Seed Data Script
-- ============================================================
USE chatbot_db;

-- ============================================================
-- ROLES
-- ============================================================
INSERT INTO Roles (RoleName, Description) VALUES
('admin',     'Full system access including audit logs'),
('sales',     'Sales orders, customers, own region data'),
('inventory', 'Products, stock levels, warehouses'),
('finance',   'Financial transactions, payroll, expenses'),
('hr',        'Employees, attendance, leave management'),
('management','Aggregated KPIs and cross-department summaries');

-- ============================================================
-- DEPARTMENTS
-- ============================================================
INSERT INTO Departments (DeptName, DeptCode, Location, Budget) VALUES
('Sales & Marketing',   'SALES',  'Chennai',   5000000.00),
('Inventory & Stores',  'INV',    'Chennai',   2000000.00),
('Finance & Accounts',  'FIN',    'Chennai',   1500000.00),
('Human Resources',     'HR',     'Chennai',   1000000.00),
('Information Technology','IT',   'Chennai',   2500000.00),
('Operations',          'OPS',    'Mumbai',    3000000.00),
('Procurement',         'PROC',   'Mumbai',    1800000.00),
('Management',          'MGMT',   'Chennai',    500000.00);

-- ============================================================
-- SHIFTS
-- ============================================================
INSERT INTO Shifts (ShiftName, ShiftCode, StartTime, EndTime) VALUES
('General Shift', 'GS', '09:00:00', '18:00:00'),
('Morning Shift',  'MS', '06:00:00', '14:00:00'),
('Night Shift',    'NS', '22:00:00', '06:00:00'),
('Afternoon Shift','AS', '14:00:00', '22:00:00');

-- ============================================================
-- QUALIFICATIONS
-- ============================================================
INSERT INTO Qualifications (QualName) VALUES
('10th Standard'),('12th Standard'),('Diploma'),('B.E / B.Tech'),
('MBA'),('BBA'),('B.Com'),('M.Com'),('MCA'),('BCA');

-- ============================================================
-- EMPLOYEES (50 records)
-- ============================================================
INSERT INTO Employees (EmpCode, EmpName, Gender, DateOfBirth, JoinDate, DeptID, ShiftID, Designation, QualificationID, BasicSalary, MobileNo, Branch, Status) VALUES
('EMP001','Arjun Sharma','Male','1988-05-12','2015-01-10',1,1,'Sales Manager',5,75000,'9876543210','Chennai','A'),
('EMP002','Priya Nair','Female','1992-08-22','2016-03-15',1,1,'Sales Executive',7,35000,'9876543211','Chennai','A'),
('EMP003','Karthik Rajan','Male','1990-11-30','2016-06-01',1,1,'Sales Executive',4,38000,'9876543212','Chennai','A'),
('EMP004','Divya Menon','Female','1993-02-14','2017-07-20',1,1,'Sales Coordinator',7,32000,'9876543213','Chennai','A'),
('EMP005','Suresh Kumar','Male','1985-09-05','2014-04-01',1,1,'Regional Sales Head',5,90000,'9876543214','Mumbai','A'),
('EMP006','Anitha Raj','Female','1991-12-18','2018-01-10',1,1,'Sales Executive',7,34000,'9876543215','Mumbai','A'),
('EMP007','Vikram Patel','Male','1989-07-25','2015-09-12',2,1,'Inventory Manager',4,65000,'9876543216','Chennai','A'),
('EMP008','Meena Subramanian','Female','1994-03-08','2019-02-20',2,1,'Store Keeper',3,28000,'9876543217','Chennai','A'),
('EMP009','Rajesh Pillai','Male','1987-06-15','2013-08-01',2,2,'Senior Store Keeper',3,35000,'9876543218','Chennai','A'),
('EMP010','Kavitha Iyer','Female','1995-01-20','2020-06-15',2,1,'Inventory Analyst',4,40000,'9876543219','Chennai','A'),
('EMP011','Ramesh Gupta','Male','1983-04-28','2010-11-05',3,1,'Finance Manager',5,80000,'9876543220','Chennai','A'),
('EMP012','Sunitha Balan','Female','1990-09-14','2017-05-10',3,1,'Accountant',7,45000,'9876543221','Chennai','A'),
('EMP013','Praveen Joshi','Male','1988-12-03','2015-02-28',3,1,'Senior Accountant',8,55000,'9876543222','Chennai','A'),
('EMP014','Lalitha Devi','Female','1992-07-19','2018-09-01',3,1,'Finance Analyst',5,50000,'9876543223','Chennai','A'),
('EMP015','Sathish Reddy','Male','1986-02-11','2012-07-15',3,1,'Chief Accountant',5,85000,'9876543224','Chennai','A'),
('EMP016','Deepa Krishnan','Female','1993-10-07','2019-04-01',4,1,'HR Manager',5,70000,'9876543225','Chennai','A'),
('EMP017','Arun Balaji','Male','1991-05-23','2017-01-20',4,1,'HR Executive',4,42000,'9876543226','Chennai','A'),
('EMP018','Nithya Chandran','Female','1994-08-30','2020-03-15',4,1,'HR Recruiter',4,38000,'9876543227','Chennai','A'),
('EMP019','Manoj Tiwari','Male','1989-11-16','2016-06-10',5,1,'IT Manager',4,85000,'9876543228','Chennai','A'),
('EMP020','Sowmya Prakash','Female','1992-04-05','2018-07-25',5,1,'Software Developer',9,55000,'9876543229','Chennai','A'),
('EMP021','Gopal Krishnamurthy','Male','1987-01-29','2011-09-01',5,1,'Senior Developer',4,70000,'9876543230','Chennai','A'),
('EMP022','Revathi Suresh','Female','1993-06-14','2019-11-10',5,1,'System Administrator',4,48000,'9876543231','Chennai','A'),
('EMP023','Balamurugan S','Male','1984-03-17','2009-02-05',6,1,'Operations Manager',5,90000,'9876543232','Mumbai','A'),
('EMP024','Janaki Ramasamy','Female','1991-09-22','2017-08-14',6,1,'Operations Executive',7,38000,'9876543233','Mumbai','A'),
('EMP025','Harish Venkat','Male','1990-12-04','2016-05-20',6,2,'Production Supervisor',3,45000,'9876543234','Mumbai','A'),
('EMP026','Vasantha Kumar','Male','1988-07-09','2014-01-15',7,1,'Purchase Manager',5,75000,'9876543235','Mumbai','A'),
('EMP027','Indira Muthukrishnan','Female','1992-02-26','2018-04-01',7,1,'Purchase Executive',7,40000,'9876543236','Mumbai','A'),
('EMP028','Senthil Nathan','Male','1986-10-11','2013-06-01',8,1,'General Manager',5,150000,'9876543237','Chennai','A'),
('EMP029','Parkavi Saravanan','Female','1994-05-18','2020-01-10',1,1,'Sales Trainee',7,25000,'9876543238','Chennai','A'),
('EMP030','Muthuvel Pandian','Male','1985-08-24','2011-11-20',2,2,'Warehouse Supervisor',3,42000,'9876543239','Chennai','A'),
('EMP031','Saranya Mohan','Female','1993-03-09','2019-07-15',3,1,'Junior Accountant',7,32000,'9876543240','Chennai','A'),
('EMP032','Dinesh Babu','Male','1990-06-27','2016-10-10',1,1,'Sales Executive',4,36000,'9876543241','Chennai','A'),
('EMP033','Rekha Anand','Female','1988-11-14','2015-12-01',4,1,'Training Coordinator',5,44000,'9876543242','Chennai','A'),
('EMP034','Venkatesh Iyer','Male','1987-04-02','2012-04-15',6,1,'Quality Controller',4,52000,'9876543243','Mumbai','A'),
('EMP035','Geetha Sundaram','Female','1991-08-19','2017-03-22',3,1,'Accounts Executive',7,38000,'9876543244','Chennai','A'),
('EMP036','Thirumurugan K','Male','1984-12-30','2009-08-10',5,1,'Network Admin',4,65000,'9876543245','Chennai','A'),
('EMP037','Asha Ramachandran','Female','1995-02-07','2021-06-01',1,1,'Sales Executive',7,33000,'9876543246','Chennai','A'),
('EMP038','Kalidoss Murugan','Male','1983-09-13','2008-05-01',2,2,'Senior Warehouse Staff',3,40000,'9876543247','Chennai','A'),
('EMP039','Vijaya Lakshmi','Female','1992-07-01','2018-02-14',4,1,'HR Generalist',5,46000,'9876543248','Chennai','A'),
('EMP040','Selvam Perumal','Male','1989-03-25','2014-09-08',7,1,'Purchase Analyst',4,48000,'9876543249','Mumbai','A'),
('EMP041','Bharathi Rajendran','Female','1993-10-17','2019-12-01',1,1,'Marketing Executive',5,42000,'9876543250','Chennai','A'),
('EMP042','Murugesh Pillai','Male','1986-05-29','2013-01-10',6,2,'Production Worker',3,28000,'9876543251','Mumbai','A'),
('EMP043','Suganya Natarajan','Female','1994-01-08','2020-08-20',3,1,'Accounts Payable',7,35000,'9876543252','Chennai','A'),
('EMP044','Anbarasan R','Male','1988-08-15','2015-06-22',5,1,'Database Admin',9,72000,'9876543253','Chennai','A'),
('EMP045','Logeshwari M','Female','1991-04-12','2017-10-05',1,1,'Sales Support',7,36000,'9876543254','Chennai','A'),
('EMP046','Chandran Subramaniam','Male','1985-11-20','2012-03-01',6,1,'Plant Manager',5,95000,'9876543255','Mumbai','A'),
('EMP047','Nandhini Venkatesan','Female','1993-06-28','2019-05-15',4,1,'Payroll Specialist',8,48000,'9876543256','Chennai','A'),
('EMP048','Saravanan Murugesan','Male','1987-09-04','2014-11-01',2,1,'Inventory Controller',4,58000,'9876543257','Chennai','A'),
('EMP049','Kamala Devi','Female','1990-02-16','2016-08-10',3,1,'Tax Analyst',5,62000,'9876543258','Chennai','A'),
('EMP050','Prakash Thiruvenkatam','Male','1982-07-22','2007-06-15',8,1,'CEO',5,250000,'9876543259','Chennai','A');

-- ============================================================
-- LEAVE TYPES
-- ============================================================
INSERT INTO LeaveTypes (LeaveTypeName, TypeCode, MaxDaysPerYear) VALUES
('Casual Leave',  'CL',  12),
('Sick Leave',    'SL',  12),
('Earned Leave',  'EL',  15),
('Maternity Leave','ML', 180),
('Comp Off',      'CO',  5);

-- ============================================================
-- LEAVE ELIGIBILITY (sample for all employees, current year)
-- ============================================================
INSERT INTO LeaveEligibility (EmployeeID, LeaveTypeID, Year, EligibleDays, AvailedDays, BalanceDays)
SELECT e.EmployeeID, lt.LeaveTypeID, 2026,
  lt.MaxDaysPerYear,
  ROUND(RAND() * (lt.MaxDaysPerYear * 0.5), 1),
  ROUND(lt.MaxDaysPerYear - RAND() * (lt.MaxDaysPerYear * 0.5), 1)
FROM Employees e CROSS JOIN LeaveTypes lt WHERE lt.TypeCode IN ('CL','SL','EL');

-- ============================================================
-- CATEGORIES
-- ============================================================
INSERT INTO Categories (CategoryName, CategoryCode, Description) VALUES
('Electronics',        'ELEC', 'Electronic components and devices'),
('Raw Materials',      'RAW',  'Raw manufacturing inputs'),
('Finished Goods',     'FG',   'Ready-to-sell finished products'),
('Packaging',          'PKG',  'Boxes, covers and packaging materials'),
('Office Supplies',    'OFF',  'Stationery and office consumables'),
('Spare Parts',        'SPA',  'Machine and vehicle spare parts'),
('Safety Equipment',   'SAF',  'PPE and safety gear');

-- ============================================================
-- PRODUCTS (35 products)
-- ============================================================
INSERT INTO Products (ProductCode, ProductName, CategoryID, UnitOfMeasure, CostPrice, SellingPrice, ReorderLevel) VALUES
('PRD001','Industrial Motor 5HP',       6, 'Nos', 12000, 16500, 5),
('PRD002','Control Panel 3Phase',       1, 'Nos',  8500, 11000, 3),
('PRD003','Steel Rod 12mm (per kg)',    2, 'Kg',    85,    110, 500),
('PRD004','Copper Wire 2.5mm (per mtr)',2, 'Mtr',   45,     60, 1000),
('PRD005','Safety Helmet',             7, 'Nos',   250,    400, 50),
('PRD006','Safety Gloves (pair)',       7, 'Pair',   80,    130, 100),
('PRD007','Bearing SKF 6205',          6, 'Nos',   350,    500, 30),
('PRD008','V-Belt A-50',               6, 'Nos',   120,    180, 25),
('PRD009','Lubricant Oil 5L',          6, 'Can',   800,   1100, 20),
('PRD010','Corrugated Box 12x10x8',    4, 'Nos',    18,     28, 200),
('PRD011','Bubble Wrap Roll 50m',      4, 'Roll',  350,    500, 15),
('PRD012','Assembly Unit A-101',       3, 'Nos', 4500,   6200, 10),
('PRD013','Assembly Unit A-102',       3, 'Nos', 5200,   7100, 8),
('PRD014','Welded Frame WF-200',       3, 'Nos', 9800,  13500, 5),
('PRD015','PVC Pipe 2inch (per mtr)',   2, 'Mtr',   55,     80, 200),
('PRD016','GI Sheet 2mm (per kg)',     2, 'Kg',    75,    100, 300),
('PRD017','Circuit Breaker 32A',       1, 'Nos',  620,    900, 15),
('PRD018','Push Button Red',           1, 'Nos',   45,     70, 50),
('PRD019','Push Button Green',         1, 'Nos',   45,     70, 50),
('PRD020','Limit Switch LS-100',       1, 'Nos',  280,    420, 20),
('PRD021','Office Printer Paper A4 Rm',5, 'Ream',  280,    380, 30),
('PRD022','Ballpoint Pen (Box of 10)', 5, 'Box',   60,     90, 20),
('PRD023','Stapler Heavy Duty',        5, 'Nos',  350,    500, 10),
('PRD024','File Folder A4',            5, 'Nos',   25,     40, 50),
('PRD025','Safety Boot Size 8',        7, 'Pair',  850,   1300, 20),
('PRD026','Fire Extinguisher 5kg',     7, 'Nos', 2200,   3000, 10),
('PRD027','Proximity Sensor NPN',      1, 'Nos',  550,    800, 12),
('PRD028','Pneumatic Cylinder 50mm',   6, 'Nos', 1800,   2600, 8),
('PRD029','Hydraulic Jack 3T',         6, 'Nos', 4500,   6500, 5),
('PRD030','Welding Rod Box 5kg',       2, 'Box',  450,    620, 20),
('PRD031','Gasket Set Engine',         6, 'Set', 1200,   1800, 15),
('PRD032','Paint Primer 20L',          2, 'Can', 1600,   2200, 10),
('PRD033','LED Light 40W',             1, 'Nos',  180,    280, 30),
('PRD034','Extension Board 6way',      1, 'Nos',  320,    490, 15),
('PRD035','Digital Multimeter',        1, 'Nos',  750,   1100, 8);

-- ============================================================
-- WAREHOUSES
-- ============================================================
INSERT INTO Warehouses (WarehouseName, Location, ManagerID, Capacity) VALUES
('Main Warehouse Chennai',    'Chennai',  7,  10000),
('Mumbai Warehouse',          'Mumbai',  30,   8000),
('Spare Parts Store',         'Chennai',  9,   3000);

-- ============================================================
-- INVENTORY (stock for each product)
-- ============================================================
INSERT INTO Inventory (ProductID, WarehouseID, QuantityOnHand, QuantityReserved) VALUES
(1,1,18,2),(2,1,7,1),(3,1,2500,200),(4,1,3800,500),(5,1,120,10),
(6,1,200,25),(7,1,85,15),(8,1,60,10),(9,1,45,5),(10,1,800,100),
(11,1,30,5),(12,1,22,4),(13,1,15,3),(14,1,8,2),(15,1,650,50),
(16,1,900,80),(17,1,35,5),(18,1,120,20),(19,1,115,20),(20,1,42,8),
(21,1,75,10),(22,1,40,5),(23,1,18,2),(24,1,130,15),(25,1,35,5),
(26,1,20,2),(27,1,28,5),(28,1,18,3),(29,1,12,1),(30,1,55,8),
(31,1,38,5),(32,1,22,3),(33,1,90,10),(34,1,45,8),(35,1,16,2),
-- Mumbai warehouse stocks
(1,2,10,1),(3,2,1800,150),(5,2,80,8),(6,2,150,20),(14,2,5,1),
(15,2,400,30),(16,2,600,50),(25,2,25,3),(26,2,12,1),(30,2,40,5),
-- Spare parts store
(7,3,200,30),(8,3,180,20),(9,3,80,10),(28,3,45,8),(31,3,90,15);

-- ============================================================
-- CUSTOMERS (20 customers)
-- ============================================================
INSERT INTO Customers (CustomerCode, CustomerName, Region, City, ContactPerson, Phone, Email, CreditLimit) VALUES
('CUST001','Apex Engineering Ltd',         'South','Chennai',    'Ravi Kumar',    '9001110001','ravi@apex.com',       500000),
('CUST002','Prime Industries Pvt Ltd',      'South','Coimbatore', 'Siva Shankar',  '9001110002','siva@prime.com',      300000),
('CUST003','Star Manufacturing Co',        'West', 'Mumbai',     'Ajay Mehta',    '9001110003','ajay@star.com',       750000),
('CUST004','Global Tech Solutions',        'West', 'Pune',       'Preethi Jain',  '9001110004','preethi@global.com',  200000),
('CUST005','Krishna Enterprises',          'South','Bangalore',  'Gopal Rao',     '9001110005','gopal@krishna.com',   400000),
('CUST006','Eastern Electronics',          'East', 'Kolkata',    'Subhash Das',   '9001110006','subhash@eastern.com', 350000),
('CUST007','Northern Parts Hub',           'North','Delhi',      'Rakesh Singh',  '9001110007','rakesh@nph.com',      600000),
('CUST008','Suresh Traders',               'South','Madurai',    'Suresh P',      '9001110008','suresh@traders.com',  150000),
('CUST009','Reliance Machines Ltd',        'West', 'Ahmedabad',  'Dhruv Shah',    '9001110009','dhruv@reliance.com',  800000),
('CUST010','Tech Components India',        'South','Hyderabad',  'Anand Varma',   '9001110010','anand@tci.com',       250000),
('CUST011','Bright Automations',           'South','Chennai',    'Lalitha S',     '9001110011','lalitha@bright.com',  180000),
('CUST012','Pioneer Industries',           'North','Chandigarh', 'Harpreet Kaur', '9001110012','harpreet@pioneer.com',420000),
('CUST013','Sunrise Manufacturing',        'East', 'Bhubaneshwar','Ramesh Patra', '9001110013','ramesh@sunrise.com',  190000),
('CUST014','Delta Systems Ltd',            'West', 'Mumbai',     'Nitin Joshi',   '9001110014','nitin@delta.com',     550000),
('CUST015','Velocity Automation',          'South','Coimbatore', 'Muthu Raja',    '9001110015','muthu@velocity.com',  300000),
('CUST016','Zenith Engineering',           'North','Noida',      'Vikram Sharma', '9001110016','vikram@zenith.com',   450000),
('CUST017','Pacific Trade Links',          'West', 'Surat',      'Kishan Patel',  '9001110017','kishan@pacific.com',  270000),
('CUST018','Sakthi Motors Pvt Ltd',        'South','Ambattur',   'Sekar M',       '9001110018','sekar@sakthi.com',    380000),
('CUST019','BlueStar Equipments',          'South','Chennai',    'Deepika R',     '9001110019','deepika@bluestar.com',220000),
('CUST020','Horizon Controls Ltd',         'West', 'Nagpur',     'Sunil Deshmukh','9001110020','sunil@horizon.com',   310000);

-- ============================================================
-- SALES ORDERS (80 orders across last 6 months)
-- ============================================================
INSERT INTO SalesOrders (OrderNo, OrderDate, CustomerID, SalesPersonID, Region, Status, TotalAmount, DiscountAmount, TaxAmount, NetAmount, DeliveryDate) VALUES
-- January 2026
('SO-2026-001','2026-01-05',1,1,'South','Delivered',82500,4125,14107.50,92482.50,'2026-01-12'),
('SO-2026-002','2026-01-08',3,5,'West',  'Delivered',55000,2750,9405,61655,'2026-01-15'),
('SO-2026-003','2026-01-10',5,3,'South','Delivered',33000,0,5940,38940,'2026-01-17'),
('SO-2026-004','2026-01-14',7,5,'North','Delivered',110000,11000,17820,116820,'2026-01-20'),
('SO-2026-005','2026-01-18',2,2,'South','Delivered',26400,1320,4514.40,29594.40,'2026-01-25'),
('SO-2026-006','2026-01-21',9,5,'West', 'Delivered',165000,8250,28215,184965,'2026-01-28'),
('SO-2026-007','2026-01-23',4,5,'West', 'Delivered',22000,0,3960,25960,'2026-01-30'),
('SO-2026-008','2026-01-27',6,2,'East', 'Delivered',44000,2200,7524,49324,'2026-02-03'),
('SO-2026-009','2026-01-29',10,3,'South','Delivered',16500,0,2970,19470,'2026-02-05'),
('SO-2026-010','2026-01-30',12,5,'North','Delivered',88000,4400,15048,98648,'2026-02-06'),
-- February 2026
('SO-2026-011','2026-02-03',1,1,'South','Delivered',49500,2475,8464.50,55489.50,'2026-02-10'),
('SO-2026-012','2026-02-06',14,5,'West','Delivered',121000,6050,20691,135641,'2026-02-13'),
('SO-2026-013','2026-02-09',3,5,'West','Delivered',66000,3300,11286,73986,'2026-02-16'),
('SO-2026-014','2026-02-12',5,3,'South','Delivered',27500,0,4950,32450,'2026-02-19'),
('SO-2026-015','2026-02-14',11,2,'South','Delivered',9900,495,1692.90,11097.90,'2026-02-21'),
('SO-2026-016','2026-02-17',7,5,'North','Delivered',99000,4950,16938,110988,'2026-02-24'),
('SO-2026-017','2026-02-19',8,2,'South','Delivered',13200,0,2376,15576,'2026-02-26'),
('SO-2026-018','2026-02-21',16,5,'North','Delivered',77000,3850,13167,86317,'2026-02-28'),
('SO-2026-019','2026-02-24',2,1,'South','Delivered',38500,1925,6583.50,43158.50,'2026-03-03'),
('SO-2026-020','2026-02-26',9,5,'West','Delivered',143000,7150,24453,160303,'2026-03-05'),
-- March 2026
('SO-2026-021','2026-03-02',1,1,'South','Delivered',55000,2750,9405,61655,'2026-03-09'),
('SO-2026-022','2026-03-04',18,1,'South','Delivered',22000,1100,3762,24662,'2026-03-11'),
('SO-2026-023','2026-03-06',3,5,'West','Delivered',88000,4400,15048,98648,'2026-03-13'),
('SO-2026-024','2026-03-09',12,5,'North','Shipped',132000,6600,22572,147972,'2026-03-16'),
('SO-2026-025','2026-03-11',5,3,'South','Shipped',49500,2475,8464.50,55489.50,'2026-03-18'),
('SO-2026-026','2026-03-13',19,1,'South','Shipped',33000,0,5940,38940,'2026-03-20'),
('SO-2026-027','2026-03-15',9,5,'West','Shipped',176000,8800,30096,197296,'2026-03-22'),
('SO-2026-028','2026-03-17',4,5,'West','Confirmed',44000,2200,7524,49324,'2026-03-24'),
('SO-2026-029','2026-03-19',16,5,'North','Confirmed',110000,5500,18810,123310,'2026-03-26'),
('SO-2026-030','2026-03-21',7,5,'North','Confirmed',66000,3300,11286,73986,'2026-03-28'),
('SO-2026-031','2026-03-23',1,1,'South','Confirmed',82500,4125,14107.50,92482.50,'2026-03-30'),
('SO-2026-032','2026-03-25',10,3,'South','Draft',27500,0,4950,32450,'2026-04-01'),
('SO-2026-033','2026-03-26',2,1,'South','Draft',16500,825,2822.40,18497.40,'2026-04-03'),
('SO-2026-034','2026-03-26',14,5,'West','Draft',99000,4950,16938,110988,'2026-04-03'),
('SO-2026-035','2026-03-27',3,5,'West','Draft',55000,2750,9405,61655,'2026-04-04'),
-- October-December 2025
('SO-2025-180','2025-10-05',1,1,'South','Delivered',77000,3850,13167,86317,'2025-10-12'),
('SO-2025-181','2025-10-10',3,5,'West','Delivered',121000,6050,20691,135641,'2025-10-17'),
('SO-2025-182','2025-10-15',7,5,'North','Delivered',99000,4950,16938,110988,'2025-10-22'),
('SO-2025-183','2025-10-20',9,5,'West','Delivered',165000,8250,28215,184965,'2025-10-27'),
('SO-2025-184','2025-10-25',5,3,'South','Delivered',44000,2200,7524,49324,'2025-11-01'),
('SO-2025-185','2025-11-01',2,2,'South','Delivered',38500,1925,6583.50,43158.50,'2025-11-08'),
('SO-2025-186','2025-11-06',12,5,'North','Delivered',88000,4400,15048,98648,'2025-11-13'),
('SO-2025-187','2025-11-12',14,5,'West','Delivered',143000,7150,24453,160303,'2025-11-19'),
('SO-2025-188','2025-11-18',1,1,'South','Delivered',66000,3300,11286,73986,'2025-11-25'),
('SO-2025-189','2025-11-23',6,2,'East','Delivered',33000,1650,5643,36993,'2025-11-30'),
('SO-2025-190','2025-11-28',9,5,'West','Delivered',198000,9900,33858,221958,'2025-12-05'),
('SO-2025-191','2025-12-03',7,5,'North','Delivered',110000,5500,18810,123310,'2025-12-10'),
('SO-2025-192','2025-12-08',3,5,'West','Delivered',77000,3850,13167,86317,'2025-12-15'),
('SO-2025-193','2025-12-13',5,3,'South','Delivered',55000,2750,9405,61655,'2025-12-20'),
('SO-2025-194','2025-12-18',1,1,'South','Delivered',99000,4950,16938,110988,'2025-12-25'),
('SO-2025-195','2025-12-22',16,5,'North','Delivered',132000,6600,22572,147972,'2025-12-29'),
('SO-2025-196','2025-12-27',9,5,'West','Delivered',220000,11000,37674,246674,'2026-01-03'),
('SO-2025-197','2025-12-29',2,1,'South','Delivered',27500,1375,4702.50,30827.50,'2026-01-05'),
('SO-2025-198','2025-12-30',18,1,'South','Delivered',49500,2475,8464.50,55489.50,'2026-01-06');

-- ============================================================
-- SALES ORDER ITEMS
-- ============================================================
INSERT INTO SalesOrderItems (OrderID, ProductID, Quantity, UnitPrice, Discount, LineTotal) VALUES
(1,1,3,16500,5,46987.50),(1,7,20,500,0,10000),(1,33,50,280,0,14000),(1,34,25,490,0,12250),
(2,12,5,6200,5,29450),(2,7,30,500,0,15000),(2,17,6,900,0,5400),
(3,5,50,400,0,20000),(3,6,50,130,0,6500),(3,25,5,1300,0,6500),
(4,1,5,16500,10,74250),(4,2,3,11000,0,33000),(4,33,10,280,0,2800),
(5,10,500,28,5,13300),(5,11,5,500,0,2500),(5,24,200,40,0,8000),
(6,14,8,13500,5,102600),(6,1,3,16500,0,49500),(6,28,5,2600,0,13000),
(7,13,3,7100,0,21300),
(8,3,3000,110,5,313500),(8,16,200,100,0,20000),
(9,21,30,380,0,11400),(9,22,15,90,0,1350),(9,24,60,40,0,2400),
(10,1,5,16500,10,74250),(10,2,2,11000,0,22000);

-- ============================================================
-- ACCOUNTS (Chart of Accounts)
-- ============================================================
INSERT INTO Accounts (AccountCode, AccountName, AccountType) VALUES
('1000','Cash & Bank',               'Asset'),
('1100','Accounts Receivable',       'Asset'),
('1200','Inventory Asset',           'Asset'),
('1300','Prepaid Expenses',          'Asset'),
('2000','Accounts Payable',          'Liability'),
('2100','Salaries Payable',          'Liability'),
('2200','Tax Payable',               'Liability'),
('3000','Share Capital',             'Equity'),
('3100','Retained Earnings',         'Equity'),
('4000','Sales Revenue',             'Revenue'),
('4100','Other Income',              'Revenue'),
('5000','Cost of Goods Sold',        'Expense'),
('5100','Salaries & Wages',          'Expense'),
('5200','Rent & Utilities',          'Expense'),
('5300','Administrative Expenses',   'Expense'),
('5400','Marketing & Sales Exp',     'Expense'),
('5500','Depreciation',              'Expense'),
('5600','Miscellaneous Expense',     'Expense');

-- ============================================================
-- FINANCIAL TRANSACTIONS (100 records)
-- ============================================================
INSERT INTO FinancialTransactions (TransactionNo, TransactionDate, AccountID, TransactionType, Amount, Description, ReferenceType) VALUES
-- Sales Revenue entries
('FT-2026-001','2026-01-05', 10,'Credit',92482.50, 'Sales revenue SO-2026-001','SalesOrder'),
('FT-2026-002','2026-01-05',  1,'Debit', 92482.50, 'Receipt from Apex Engineering','SalesOrder'),
('FT-2026-003','2026-01-08', 10,'Credit',61655,    'Sales revenue SO-2026-002','SalesOrder'),
('FT-2026-004','2026-01-08',  1,'Debit', 61655,    'Receipt from Star Manufacturing','SalesOrder'),
('FT-2026-005','2026-01-10', 10,'Credit',38940,    'Sales revenue SO-2026-003','SalesOrder'),
('FT-2026-006','2026-01-10',  2,'Debit', 38940,    'AR Krishna Enterprises','SalesOrder'),
('FT-2026-007','2026-01-14', 10,'Credit',116820,   'Sales revenue SO-2026-004','SalesOrder'),
('FT-2026-008','2026-01-14',  2,'Debit', 116820,   'AR Northern Parts Hub','SalesOrder'),
('FT-2026-009','2026-01-21', 10,'Credit',184965,   'Sales revenue SO-2026-006','SalesOrder'),
('FT-2026-010','2026-01-21',  1,'Debit', 184965,   'Receipt from Reliance Machines','SalesOrder'),
-- Salary payments Jan
('FT-2026-011','2026-01-31', 13,'Debit', 2850000, 'Salary payment January 2026','Payroll'),
('FT-2026-012','2026-01-31',  1,'Credit',2850000, 'Bank payment salaries Jan 2026','Payroll'),
-- Rent
('FT-2026-013','2026-01-31', 14,'Debit', 180000,  'Office & warehouse rent Jan 2026','Expense'),
('FT-2026-014','2026-01-31',  1,'Credit',180000,  'Rent payment Jan 2026','Expense'),
-- Feb Sales
('FT-2026-015','2026-02-03', 10,'Credit',55489.50,'Sales revenue SO-2026-011','SalesOrder'),
('FT-2026-016','2026-02-03',  1,'Debit', 55489.50,'Receipt Apex Engineering','SalesOrder'),
('FT-2026-017','2026-02-06', 10,'Credit',135641,  'Sales revenue SO-2026-012','SalesOrder'),
('FT-2026-018','2026-02-06',  2,'Debit', 135641,  'AR Delta Systems','SalesOrder'),
('FT-2026-019','2026-02-09', 10,'Credit',73986,   'Sales revenue SO-2026-013','SalesOrder'),
('FT-2026-020','2026-02-09',  1,'Debit', 73986,   'Receipt Star Manufacturing','SalesOrder'),
-- Salary Feb
('FT-2026-021','2026-02-28', 13,'Debit', 2850000, 'Salary payment February 2026','Payroll'),
('FT-2026-022','2026-02-28',  1,'Credit',2850000, 'Bank payment salaries Feb 2026','Payroll'),
-- Rent Feb
('FT-2026-023','2026-02-28', 14,'Debit', 180000,  'Office & warehouse rent Feb 2026','Expense'),
('FT-2026-024','2026-02-28',  1,'Credit',180000,  'Rent payment Feb 2026','Expense'),
-- March Sales
('FT-2026-025','2026-03-02', 10,'Credit',61655,   'Sales revenue SO-2026-021','SalesOrder'),
('FT-2026-026','2026-03-02',  2,'Debit', 61655,   'AR Apex Engineering','SalesOrder'),
('FT-2026-027','2026-03-04', 10,'Credit',24662,   'Sales revenue SO-2026-022','SalesOrder'),
('FT-2026-028','2026-03-04',  1,'Debit', 24662,   'Receipt Sakthi Motors','SalesOrder'),
-- Utilities
('FT-2026-029','2026-03-10', 14,'Debit', 45000,   'Electricity bill March','Expense'),
('FT-2026-030','2026-03-10',  1,'Credit',45000,   'Electricity payment','Expense'),
('FT-2026-031','2026-03-15', 16,'Debit', 125000,  'Digital marketing campaign Q1 2026','Expense'),
('FT-2026-032','2026-03-15',  1,'Credit',125000,  'Marketing payment','Expense'),
-- COGS entries
('FT-2026-033','2026-01-31', 12,'Debit', 1250000, 'Cost of goods sold Jan 2026','COGS'),
('FT-2026-034','2026-01-31',  3,'Credit',1250000, 'Inventory reduction Jan 2026','COGS'),
('FT-2026-035','2026-02-28', 12,'Debit', 1380000, 'Cost of goods sold Feb 2026','COGS'),
('FT-2026-036','2026-02-28',  3,'Credit',1380000, 'Inventory reduction Feb 2026','COGS'),
-- Tax payable
('FT-2026-037','2026-01-31',  7,'Credit',180000,  'GST payable Jan 2026','Tax'),
('FT-2026-038','2026-02-28',  7,'Credit',195000,  'GST payable Feb 2026','Tax'),
('FT-2026-039','2026-02-10',  7,'Debit', 150000,  'GST payment Dec 2025','Tax'),
('FT-2026-040','2026-03-10',  7,'Debit', 180000,  'GST payment Jan 2026','Tax'),
-- Misc expenses
('FT-2026-041','2026-01-15', 15,'Debit', 28000,   'Office supplies procurement','Expense'),
('FT-2026-042','2026-01-15',  1,'Credit',28000,   'Office supplies payment','Expense'),
('FT-2026-043','2026-02-12', 15,'Debit', 35000,   'Admin expenses February','Expense'),
('FT-2026-044','2026-02-12',  1,'Credit',35000,   'Admin expenses payment','Expense'),
('FT-2026-045','2026-03-20', 18,'Debit', 15000,   'Miscellaneous expense March','Expense'),
('FT-2026-046','2026-03-20',  1,'Credit',15000,   'Misc payment','Expense');

-- ============================================================
-- PAYROLL (Jan - Mar 2026, sample employees)
-- ============================================================
INSERT INTO Payroll (EmployeeID, PayMonth, PayYear, BasicSalary, Allowances, Deductions, GrossSalary, NetSalary, PaymentDate, Status) VALUES
(1,  1,2026,75000,  15000,8500, 90000,  81500,  '2026-01-31','Paid'),
(2,  1,2026,35000,  7000, 4200, 42000,  37800,  '2026-01-31','Paid'),
(3,  1,2026,38000,  7600, 4560, 45600,  41040,  '2026-01-31','Paid'),
(11, 1,2026,80000,  16000,9600, 96000,  86400,  '2026-01-31','Paid'),
(12, 1,2026,45000,  9000, 5400, 54000,  48600,  '2026-01-31','Paid'),
(16, 1,2026,70000,  14000,8400, 84000,  75600,  '2026-01-31','Paid'),
(19, 1,2026,85000,  17000,10200,102000, 91800,  '2026-01-31','Paid'),
(28, 1,2026,150000, 30000,18000,180000, 162000, '2026-01-31','Paid'),
(50, 1,2026,250000, 50000,30000,300000, 270000, '2026-01-31','Paid'),
(7,  1,2026,65000,  13000,7800, 78000,  70200,  '2026-01-31','Paid'),
(1,  2,2026,75000,  15000,8500, 90000,  81500,  '2026-02-28','Paid'),
(2,  2,2026,35000,  7000, 4200, 42000,  37800,  '2026-02-28','Paid'),
(11, 2,2026,80000,  16000,9600, 96000,  86400,  '2026-02-28','Paid'),
(16, 2,2026,70000,  14000,8400, 84000,  75600,  '2026-02-28','Paid'),
(28, 2,2026,150000, 30000,18000,180000, 162000, '2026-02-28','Paid'),
(50, 2,2026,250000, 50000,30000,300000, 270000, '2026-02-28','Paid'),
(1,  3,2026,75000,  15000,8500, 90000,  81500,  '2026-03-31','Pending'),
(11, 3,2026,80000,  16000,9600, 96000,  86400,  '2026-03-31','Pending'),
(28, 3,2026,150000, 30000,18000,180000, 162000, '2026-03-31','Pending'),
(50, 3,2026,250000, 50000,30000,300000, 270000, '2026-03-31','Pending');

-- ============================================================
-- EXPENSES
-- ============================================================
INSERT INTO Expenses (ExpenseDate, Category, Description, Amount, DeptID, ApprovedBy, Status) VALUES
('2026-01-10','Office Supplies',    'Stationery for Q1',           15000, 4,'Deepa Krishnan','Paid'),
('2026-01-15','Travel',             'Sales team travel Chennai-Mumbai',35000,1,'Senthil Nathan', 'Paid'),
('2026-01-20','IT Maintenance',     'Server AMC payment Q1',       48000, 5,'Manoj Tiwari',  'Paid'),
('2026-02-05','Training',           'HR training workshop',        22000, 4,'Deepa Krishnan','Paid'),
('2026-02-12','Marketing',          'Exhibition participation fee', 75000, 1,'Senthil Nathan', 'Paid'),
('2026-02-18','Repairs',            'Generator repair warehouse',   18000, 2,'Vikram Patel',  'Paid'),
('2026-02-25','Vehicle Fuel',       'Company vehicles Feb fuel',   12500, 6,'Balamurugan S', 'Paid'),
('2026-03-05','Office Supplies',    'Printer cartridges',           8500, 5,'Manoj Tiwari',  'Approved'),
('2026-03-10','Travel',             'Sales team South zone travel', 28000, 1,'Senthil Nathan', 'Approved'),
('2026-03-15','Safety Equipment',   'New PPE stock procurement',   45000, 2,'Vikram Patel',  'Pending'),
('2026-03-18','Legal',              'Company legal retainer Mar',   30000, 8,'Senthil Nathan', 'Approved'),
('2026-03-22','Utilities',          'Water & electricity deposit',  60000, 6,'Balamurugan S', 'Pending');

-- ============================================================
-- APP USERS (demo login accounts, passwords are hashed SHA256 of shown value)
-- ============================================================
-- Passwords (plain text for reference): admin=Admin@123, sales=Sales@123,
-- inventory=Inv@123, finance=Fin@123, hr=HR@123, manager=Mgr@123
INSERT INTO AppUsers (Username, PasswordHash, FullName, RoleID, EmployeeID, Region, DeptID, IsActive) VALUES
('admin',     SHA2('Admin@123',256),    'System Administrator', 1, NULL,      NULL,   NULL,'1'),
('sales_south',SHA2('Sales@123',256),   'Arjun Sharma',         2, 1,         'South',1,   '1'),
('sales_west', SHA2('Sales@123',256),   'Suresh Kumar',         2, 5,         'West', 1,   '1'),
('inventory',  SHA2('Inv@123',256),     'Vikram Patel',         3, 7,         NULL,   2,   '1'),
('finance',    SHA2('Fin@123',256),     'Ramesh Gupta',         4, 11,        NULL,   3,   '1'),
('hr',         SHA2('HR@123',256),      'Deepa Krishnan',       5, 16,        NULL,   4,   '1'),
('manager',    SHA2('Mgr@123',256),     'Senthil Nathan',       6, 28,        NULL,   NULL,'1');

-- ============================================================
-- LEAVE TRANSACTIONS (sample)
-- ============================================================
INSERT INTO LeaveTransactions (EmployeeID, LeaveTypeID, FromDate, ToDate, LeaveDays, Reason, Status, ApprovedBy, ApprovedDate, ApplicationDate) VALUES
(2, 1,'2026-01-13','2026-01-14',2,'Personal work','Approved','Deepa Krishnan','2026-01-11','2026-01-10'),
(3, 2,'2026-01-20','2026-01-21',2,'Fever','Approved','Deepa Krishnan','2026-01-19','2026-01-18'),
(10,1,'2026-02-03','2026-02-03',1,'Family function','Approved','Arun Balaji','2026-02-01','2026-02-01'),
(17,2,'2026-02-10','2026-02-12',3,'Medical','Approved','Deepa Krishnan','2026-02-09','2026-02-08'),
(5, 3,'2026-02-18','2026-02-21',4,'Vacation','Approved','Senthil Nathan','2026-02-15','2026-02-13'),
(12,1,'2026-03-05','2026-03-05',1,'Personal','Pending',NULL,NULL,'2026-03-04'),
(20,2,'2026-03-10','2026-03-11',2,'Sick','Pending',NULL,NULL,'2026-03-09'),
(35,1,'2026-03-17','2026-03-18',2,'Function','Pending',NULL,NULL,'2026-03-15');
