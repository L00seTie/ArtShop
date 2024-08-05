/*
Robin Johnson
4/29/24

This script creates all the database's tables
The data dictionary for this DB can be found in the
main folder
*/
USE may2151868;
GO

-- Categories of products being sold
IF OBJECT_ID('dbo.ProductCategories', 'U') IS NOT NULL
    PRINT 'ProductCategories table already exists.';
ELSE
    CREATE TABLE ProductCategories
(
    CategoryName VARCHAR(50) PRIMARY KEY NOT NULL,
    Cost MONEY NOT NULL DEFAULT 0.00
);
GO

-- Digital designs that can be made into products
IF OBJECT_ID('dbo.Designs', 'U') IS NOT NULL
    PRINT 'Designs table already exists.';
ELSE
    CREATE TABLE Designs
(
    DesignName VARCHAR(20) PRIMARY KEY NOT NULL
);
GO

-- Information about products on offer
IF OBJECT_ID('dbo.Products', 'U') IS NOT NULL
    PRINT 'Products table already exists.';
ELSE
    CREATE TABLE Products
(
    ProductName VARCHAR(50) PRIMARY KEY NOT NULL,
    CategoryName VARCHAR(50) FOREIGN KEY 
            REFERENCES ProductCategories NOT NULL,
    -- DesignName will be null for commission products
    DesignName VARCHAR(50) FOREIGN KEY
            REFERENCES Designs,
    Price MONEY NOT NULL,
    -- Stock will be null for commission products
    Stock INTEGER
);
GO

-- Customer contact info
IF OBJECT_ID('dbo.CustomerInfo', 'U') IS NOT NULL
    PRINT 'CustomerInfo table already exists.';
ELSE
    CREATE TABLE CustomerInfo
(
    CustomerID INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    FName NVARCHAR(80) NOT NULL,
    LName NVARCHAR(80),
    -- full name not required
    Email NVARCHAR(100) NOT NULL,
);
GO

-- Customer address info
IF OBJECT_ID('dbo.CustomerAddresses', 'U') IS NOT NULL
    PRINT 'CustomerAddresses table already exists.';
ELSE
    CREATE TABLE CustomerAddresses
(
    CustomerID INTEGER PRIMARY KEY FOREIGN KEY
            REFERENCES CustomerInfo NOT NULL,
    StreetAddress NVARCHAR(100) NOT NULL,
    ZipCode VARCHAR(10) NOT NULL,
    [State] VARCHAR(2) NOT NULL
);
GO

-- Collects and lists incoming orders
IF OBJECT_ID('dbo.OrderItems', 'U') IS NOT NULL
    PRINT 'OrderItems table already exists.';
ELSE
    CREATE TABLE OrderItems
(
    OrderItemID INTEGER PRIMARY KEY IDENTITY(1,1) NOT NULL,
    OrderID INTEGER FOREIGN KEY
        REFERENCES OrderInfo NOT NULL,
    ProductName VARCHAR(50) FOREIGN KEY 
            REFERENCES Products NOT NULL,
    Quantity INTEGER NOT NULL
);
GO

-- Information about orders
IF OBJECT_ID('dbo.OrderInfo', 'U') IS NOT NULL
    PRINT 'OrderInfo table already exists.';
ELSE
    CREATE TABLE OrderInfo
(
    -- OrderID is not an identity column because a value
    -- is inserted by the 7_OrderProcessProc.sql script
    OrderID INTEGER PRIMARY KEY NOT NULL,
    CustomerID INTEGER FOREIGN KEY 
            REFERENCES CustomerInfo NOT NULL,
    OrderMade DATETIME2 NOT NULL,
    -- ExpectedBy may or may not be a strict deadline
    ExpectedBy DATETIME2,
    OrderStatus VARCHAR(10) NOT NULL DEFAULT 'processing',
    -- DeliveredOn will be null until the product is delivered
    DeliveredOn DATETIME2 DEFAULT NULL
);
GO