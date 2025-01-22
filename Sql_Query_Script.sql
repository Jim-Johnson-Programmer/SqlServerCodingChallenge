/*write a query that will tell us which Wholesale Customer spent the most totalacross all of their Orders, and how much they spent. 

This should include the Customer Name and the Total Spent. */


/*The table definitions & data are below:

Table: Customer
=================================================================
CustomerID CustomerName CreatedDate CustomerTypeID StateCode1          
Acme Brands  1/1/2023     1              OR2          
Sigma Inc    7/15/2023    1              CA3          
Donuts R Us  5/17/2023    2              OR4          
Omega Corp   12/1/2023    1              WY
================================================================= 

Table: OrderData
=================================================================
OrderID OrderDate CustomerID
1       12/1/2023       1
2       12/15/2023      4
3       12/18/2023      3
4       1/1/2024        1
5       1/3/2024        3
=================================================================

Table: OrderProduct
=================================================================
OrderID Product Quantity CostPerUnit
1        Flour       4        15.00
2        Sugar      50       400.00
3        Sugar      10       100.00
4        Cinnamon    1         3.00
4        Allspice    1         5.00
4        Nutmeg      2        14.00
5        Flour       2         8.00
=================================================================

Table: CustomerType
=================================================================
CustomerTypeID CustomerType
1                Wholesale
2                Retail
=================================================================*/
/*get all orders*/

use customers;
GO

/*Solution 1*/
Select top 1
	agg.CustomerName,
	max(agg.CustomerTotal) as CustomerSpendingTotal
from 
	(Select
	cust.CustomerName,
	cust.CustomerID,
	sum(op.Quantity * op.CostPerUnit) as CustomerTotal
	from
	Customer cust 
	inner join OrderData od 
	on cust.CustomerID = od.CustomerID
	inner join OrderProduct op 
	on od.OrderID = op.OrderID
	group by cust.CustomerName, cust.CustomerID, cust.CustomerTypeID
	having cust.CustomerTypeID=1) agg 
group by agg.CustomerName, agg.CustomerID
order by CustomerSpendingTotal desc

/*Solution 2*/
;with CustomerOrderSummaries1 as 
(Select
	cust.CustomerName,
	cust.CustomerID,
	sum(op.Quantity * op.CostPerUnit) as CustomerTotal
from
	Customer cust 
inner join OrderData od 
on cust.CustomerID = od.CustomerID
inner join OrderProduct op 
on od.OrderID = op.OrderID
group by cust.CustomerName, cust.CustomerID, cust.CustomerTypeID
having cust.CustomerTypeID=1
)

Select 
	CustomerName, 
	CustomerTotal 
from CustomerOrderSummaries1 
where 
	CustomerTotal=(Select max(CustomerTotal) from CustomerOrderSummaries1)

/*Solution 3*/
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
	cust.CustomerTypeID=1
) 

select CustomerName, TotalCostOfProduct from CustomerOrderSummaries2 where rowNum=1


/*Query to check that totals are correct*/
Select 
	* ,
	(op.Quantity * op.CostPerUnit) as TotalCostOfProduct
from
	Customer cust 
inner join OrderData od 
on cust.CustomerID = od.CustomerID
inner join OrderProduct op 
on od.OrderID = op.OrderID
where
	cust.CustomerTypeID=1
