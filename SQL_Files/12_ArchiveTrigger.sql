/*
Robin Johnson
4/29/24

Script that sets a trigger on the OrderInfo
table that archives orders that have been delivered
*/

USE may2151868;
GO

-- Create archive tables to be used in the next trigger
CREATE TABLE OrderInfoArchive
(
    OrderID INTEGER PRIMARY KEY NOT NULL,
    CustomerID INTEGER NOT NULL,
    OrderMade DATETIME NOT NULL,
    ExpectedBy DATETIME NOT NULL,
    OrderStatus VARCHAR(20) NOT NULL,
    DeliveredOn DATETIME NOT NULL
);
GO
CREATE TABLE OrdersItemsArchive
(
    OrderItemID INTEGER PRIMARY KEY NOT NULL,
    OrderID INTEGER FOREIGN KEY 
        REFERENCES OrderInfoArchive NOT NULL,
    ProductName VARCHAR(50) NOT NULL,
    Quantity INTEGER
);
GO

-- Move delivered orders to their respective archive tables
CREATE TRIGGER ArchiveOrder
ON OrderInfo
AFTER UPDATE
AS
BEGIN
    IF UPDATE(OrderStatus)
    BEGIN
        BEGIN TRY
        BEGIN TRANSACTION;
        
        -- CTE containing all delivered orders
        WITH
            DeliveredOrders
            AS
            (
                SELECT
                    oin.OrderID, oin.CustomerID, oin.OrderMade,
                    oin.ExpectedBy, oin.OrderStatus, oin.DeliveredOn,
                    oit.OrderID, oit.OrderItemID, oit.ProductName, oit.Quantity
                FROM OrderInfo oin
                    JOIN OrderItems oit
                    ON oit.OrderID = oin.OrderID
                WHERE oin.OrderStatus = 'delivered'
            )

        -- Archive delivered orders
        INSERT INTO OrderInfoArchive
            (OrderID, CustomerID, OrderMade, ExpectedBy, OrderStatus, DeliveredOn)
        SELECT oin.OrderID, CustomerID, OrderMade, ExpectedBy, OrderStatus, DeliveredOn
        FROM DeliveredOrders;
        INSERT INTO OrderArchive
            (OrderItemID, OrderID, ProductName, Quantity)
        SELECT oit.OrderItemID, OrderID, ProductName, Quantity
        FROM DeliveredOrders;

        -- Delete delivered orders from the Orders
        -- and OrderInfo tables
        DELETE oit
        FROM OrderItems oit
            JOIN OrderInfo oin
            ON oit.OrderID = oin.OrderID
        WHERE oin.OrderStatus = 'delivered';

        COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            RAISERROR('Error archiving orders',16,1);
        END CATCH;
    END
END;
GO