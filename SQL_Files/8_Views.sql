/*
Robin Johnson
4/29/24

Script that creates three views:
1. A view of all orders that haven't shipped yet
2. A view of all products that are low in stock
3. A view showing the profit made on each product 
*/

USE may2151868;
GO

-- See all unshipped orders
CREATE VIEW ProcessingOrdersView
AS
    SELECT OrderID, ProductName, OrderMade, ExpectedBy, FName, LName, Email, StreetAddress, ZipCode, [State]
    FROM OrderInfo oin
        JOIN OrderItems oit
        ON oit.OrderID = oin.OrderID
        JOIN CustomerInfo cin
        ON cin.CustomerID = oin.CustomerID
    WHERE OrderStatus = 'processing';
GO

-- See all products whose stock is less than 10 and not NULL
CREATE VIEW LowStockView
AS
    SELECT ProductName, CategoryName, DesignName, Stock, Cost
    FROM Products p
        JOIN ProductCategories pc
        ON p.CategoryID = pc.CategoryID
    WHERE p.Stock < 10 AND p.Stock IS NOT NULL;
GO

-- See how much of a profit I make on all my products
CREATE VIEW ProfitView
AS
    SELECT ProductName, (Price - Cost) AS Profit, Cost, Price
    FROM Products p
        JOIN ProductCategories pc
        ON pc.CategoryName = p.CategoryName
GO