USE [customers]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[uspGetLargestOrderByOrderType]
		@CustomerOrderTypeID = 1

SELECT	'Return Value' = @return_value

GO
