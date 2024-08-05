/*
Robin Johnson
4/30/24

This script creates two functions that assist the order processing
stored procedure: one to return a shipping date and one to create
a new order ID.
*/
USE may2151868;
GO

/* Function that will return an approximate date to try and ship the product to
the customer by. For now it's just two weeks from when it's ordered. */
CREATE FUNCTION GetExpectedBy()
RETURNS DATETIME2
AS
BEGIN
    RETURN DATEADD(WEEK, 2, GETDATE())
END
GO

-- Creates a new OrderID to be used in the order processing proc
CREATE FUNCTION CreateOrderID()
RETURNS INTEGER
AS
BEGIN
    DECLARE @LatestID INTEGER;

    -- Find the most recent ID in the table;
    -- if there are no IDs yet, start with 0
    SELECT @LatestID = ISNULL(MAX(OrderID), 0)
    FROM OrderInfo;

    -- Increment it for the new ID
    RETURN @LatestID + 1;
END
GO