CREATE DATABASE customers;
GO

USE customers;
GO

CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY,
    CustomerName NVARCHAR(100),
    CreatedDate DATE,
    CustomerTypeID INT,
    StateCode CHAR(2)
);
GO

CREATE TABLE OrderData (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);
GO

CREATE TABLE OrderProduct (
    OrderID INT,
    Product NVARCHAR(100),
    Quantity INT,
    CostPerUnit DECIMAL(18, 2),
    FOREIGN KEY (OrderID) REFERENCES OrderData(OrderID)
);
GO

CREATE TABLE CustomerType (
    CustomerTypeID INT PRIMARY KEY,
    CustomerType NVARCHAR(50)
);
GO

INSERT INTO CustomerType (CustomerTypeID, CustomerType) VALUES
(1, 'Wholesale'),
(2, 'Retail');
GO

-- Inserting data into Customer table
INSERT INTO Customer (CustomerID, CustomerName, CreatedDate, CustomerTypeID, StateCode) VALUES
(1, 'Acme Brands', '2023-01-01', 1, 'OR'),
(2, 'Sigma Inc', '2023-07-15', 1, 'CA'),
(3, 'Donuts R Us', '2023-05-17', 2, 'OR'),
(4, 'Omega Corp', '2023-12-01', 1, 'WY');

-- Inserting data into OrderData table
INSERT INTO OrderData (OrderID, OrderDate, CustomerID) VALUES
(1, '2023-12-01', 1),
(2, '2023-12-15', 4),
(3, '2023-12-18', 3),
(4, '2024-01-01', 1),
(5, '2024-01-03', 3);

-- Inserting data into OrderProduct table
INSERT INTO OrderProduct (OrderID, Product, Quantity, CostPerUnit) VALUES
(1, 'Flour', 4, 15.00),
(2, 'Sugar', 50, 400.00),
(3, 'Sugar', 10, 100.00),
(4, 'Cinnamon', 1, 3.00),
(4, 'Allspice', 1, 5.00),
(4, 'Nutmeg', 2, 14.00),
(5, 'Flour', 2, 8.00);
