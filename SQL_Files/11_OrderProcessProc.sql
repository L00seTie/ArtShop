/*
Robin Johnson
4/29/24

This script creates a stored procedure to process
incoming customer orders
*/

USE may2151868;

-- Table of order details to be used as a parameter in the proc
CREATE TYPE OrderDetailsTable AS TABLE (
    ProductName INT,
    ProductCategory INT,
    Quantity INT
);
GO

/* This proc checks if there's enough stock to
fulfill the order, and if there is, it adds
the order info to the appropriate tables */
CREATE PROCEDURE ProcessCustomerOrder
    @CustomerID INT,
    @OrderDetails OrderDetailsTable READONLY
AS
BEGIN
    -- For iterating through the OrderDetailsTable later
    DECLARE @ProductName INT;
    DECLARE @ProductCategory VARCHAR(50);
    DECLARE @Quantity INT;

    -- Create cursor to go through table
    DECLARE order_cursor CURSOR FOR
    SELECT ProductName, Quantity
    FROM @OrderDetails;

    -- Check stock of each product from the OrderDetailsTable in the Products table
    OPEN order_cursor;
    FETCH NEXT FROM order_cursor INTO @ProductName, @ProductCategory, @Quantity;
    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- If product is a commission, there's no need to check stock
        IF CHARINDEX('Commission', @ProductName) > 0
            CONTINUE;

        -- Check if the product is available
        DECLARE @Stock INT;
        SELECT @Stock = Stock
        FROM Products
        WHERE ProductName = @ProductName;

        -- If the product isn't found, raise an error
        IF @Stock IS NULL
        BEGIN
            RAISERROR('Product %s not found.', 16, 1, @ProductName);
            CLOSE order_cursor;
            DEALLOCATE order_cursor;
            RETURN;
        END;

        -- If there aren't enough items in stock, raise an error
        IF @Stock < @Quantity
        BEGIN
            RAISERROR ('Insufficient stock of %s', 16, 1, @ProductName);
            CLOSE order_cursor;
            DEALLOCATE order_cursor;
            RETURN;
        END;
    END;

    CLOSE order_cursor;
    DEALLOCATE order_cursor;

    -- Create an order ID to go into the order tables
    DECLARE @OrderID INTEGER;
    SET @OrderID = CreateOrderID();

    -- Insert values into the OrderInfo and Orders tables
    INSERT INTO OrderInfo
        (OrderID, CustomerID, OrderMade, ExpectedBy)
    VALUES
        (@OrderID, @CustomerID, GETDATE(), GetExpectedBy());
    INSERT INTO OrderItems
        (OrderID, ProductName, Quantity)
    -- @OrderID is a static value and will be applied
    -- repeatedly to each row
    SELECT @OrderID AS OrderID, ProductName, Quantity
    FROM @OrderDetails;

    -- Update product quantities
    UPDATE Products
    SET Stock = Stock - Quantity
    FROM Products p
        JOIN @OrderDetails od
        ON p.ProductName = od.ProductName
    -- Only update stock of products that aren't commissions
    WHERE CHARINDEX('Commission', ProductName) = 0;

    PRINT 'Order processed successfully.';
END;