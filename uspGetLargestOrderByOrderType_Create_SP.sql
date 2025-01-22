use customers;
GO
-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE uspGetLargestOrderByOrderType
	@CustomerOrderTypeID int=0
AS
BEGIN


;with CustomerOrderSummaries2 as 
(
Select 
	cust.CustomerName,
	cust.CustomerID,
	op.Quantity * op.CostPerUnit as TotalCostOfProduct,
	ROW_NUMBER() over (order by op.Quantity * op.CostPerUnit desc) as rowNum
from
	Customer cust 
inner join OrderData od 
on cust.CustomerID = od.CustomerID
inner join OrderProduct op 
on od.OrderID = op.OrderID
where
	cust.CustomerTypeID=@CustomerOrderTypeID
) 

select CustomerName, TotalCostOfProduct from CustomerOrderSummaries2 where rowNum=1
END
GO
