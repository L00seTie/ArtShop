/*
Robin Johnson
Capstone Project
4/29/24

Script that creates stored procedures that takes a year and month
as parameters and create reports for how well each product sold
*/
USE may2151868;
GO

-- Monthly Report
CREATE PROCEDURE MakeMonthlyReport
    @Year INT,
    @Month INT
AS
BEGIN
    -- Suppress "rows affected" message
    SET NOCOUNT ON;

    -- For restricting the range or rows returned later
    DECLARE @StartDate DATE = DATEFROMPARTS(@Year, @Month, 1);
    DECLARE @EndDate DATE = DATEADD(MONTH, 1, @StartDate);

    PRINT 'Monthly Report for ' + DATEPART(MONTH, OrderMade) + ' ' + DATEPART(YEAR, OrderMade) + ':';

    -- Shows which products sold the best and the most
    SELECT
        ProductName,
        SUM(Profit) AS TotalProfit,
        SUM(Price) AS TotalSales,
        SUM(Quantity) AS TotalSold,
        OrderMade
    FROM
        Products p
        -- Uses the ProfitView created in 4_Views.sql
        JOIN ProfitView pv
        ON pv.ProductName = p.ProductName
        JOIN OrderItems oit
        ON oit.ProductName = p.ProductName
        JOIN OrderInfo oin
        ON oin.OrderID = oit.OrderID
    WHERE 
        OrderMade >= @StartDate AND OrderMade < @EndDate
    GROUP BY 
        ProductName
    ORDER BY 
        TotalProfit, TotalSold;
END;
GO

-- Annual Report
CREATE PROCEDURE MakeAnnual
    @Year INT
AS
BEGIN
    -- Suppress "rows affected" message
    SET NOCOUNT ON;

    -- For restricting the range or rows returned later
    DECLARE @StartDate DATE = DATEFROMPARTS(@Year, 1);
    DECLARE @EndDate DATE = DATEADD(YEAR, 1, @StartDate);

    PRINT 'Monthly Report for ' + DATEPART(MONTH, OrderMade) + ' ' + DATEPART(YEAR, OrderMade) + ':';

    -- Shows which products sold the best and the most
    SELECT
        ProductName,
        SUM(Profit) AS TotalProfit,
        SUM(Price) AS TotalSales,
        SUM(Quantity) AS TotalSold,
        OrderMade
    FROM
        Products p
        -- Uses the ProfitView created in 4_Views.sql
        JOIN ProfitView pv
        ON pv.ProductName = p.ProductName
        JOIN OrderItems oit
        ON oit.ProductName = p.ProductName
        JOIN OrderInfo oin
        ON oin.OrderID = oit.OrderID
    WHERE 
        OrderMade >= @StartDate AND OrderMade < @EndDate
    GROUP BY 
        ProductName
    ORDER BY 
        TotalProfit, TotalSold;
END;
GO