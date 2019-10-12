--#CASE 1
SELECT
	[Customer ID] = CS.customerID,
	[Total Rent] = COUNT(rentID)
FROM
	rentTransaction RT JOIN Customer CS ON RT.customerID = CS.customerID 
WHERE
	customerEmail LIKE '%co.id' AND
	customerGender IN('Male')
GROUP BY CS.customerID
ORDER BY COUNT(rentID) ASC



--#CASE 2
SELECT
	[Boat Supplier Name] = supplierName,
	[Transaction Date] = purchaseTransactionDate,
	[Total Boat Quantity] = SUM(quantity)
FROM
	purchaseTransaction PT JOIN Supplier SR ON PT.supplierID = SR.supplierID
WHERE
	DATENAME(MONTH, purchaseTransactionDate) LIKE 'March'
	
GROUP BY supplierName, purchaseTransactionDate
HAVING SUM(quantity) > 1



--#CASE 3
SELECT TOP 2
	[Rent ID] = rentID,
	[Customer Name] = customerName,
	[StaffName] = staffName,
	[Total Transaction] = COUNT(rentID),
	[Total Rent Duration] = SUM(duration)
FROM
	Customer CS JOIN rentTransaction RT ON CS.customerID = RT.customerID
	JOIN Staff SF ON RT.staffID = SF.staffID
WHERE
	CustomerName LIKE 'Mr.%'
GROUP BY customerName, staffName, rentID
HAVING SUM(duration) > 6



--#CASE 4
SELECT
	[Transaction Date] = rentTransactionDate,
	[Customer Name] = customerName,
	[Staff Name] = staffName,
	[Total Rent Duration] = SUM(duration),
	[Maximum Rent Duration] = MAX(duration)
FROM
	Customer CS JOIN rentTransaction RT ON CS.customerID = RT.customerID
	JOIN Staff SF ON RT.staffID = SF.staffID
WHERE
	CAST(rentTransactionDate AS TIME) BETWEEN '09:00:00' AND '11:00:00'
GROUP BY customerName, staffName, rentTransactionDate
HAVING len(staffName) > 10



--#CASE 5
SELECT
	[Supplier ID] = PT.supplierID,
	[Staff Name] = staffName,
	[Quantity] = COUNT(typeName), 
	[Date] = CONVERT(VARCHAR, purchaseTransactionDate, 106)
FROM
	(
		SELECT AVG(staffSalary) AS avg_price
		FROM Staff
	)AS avgTable, 
	BoatType BT JOIN Boat ON BT.typeID = Boat.typeID
	JOIN purchaseTransactionDetail PTD ON PTD.boatID = Boat.boatID
	JOIN purchaseTransaction PT ON PT.purchaseID = PTD.purchaseID
	JOIN Supplier ON Supplier.supplierID = PT.supplierID
	JOIN Staff ON Staff.staffID = PT.staffID
WHERE
	CHARINDEX(' ', staffName) = 0 AND
	staffSalary < avgTable.avg_price AND 
	BT.typeName LIKE '% boat'
GROUP BY staffName, PT.supplierID, purchaseTransactionDate



--#CASE 6
SELECT 
	rentID, rentTransactionDate, staffName, 
	'Rent Transaction Duration' = CAST(duration as varchar) + ' hour(s)' 
FROM
	(
		SELECT 
		rentID, rentTransactionDate, staffID, duration
		FROM rentTransaction 
	)AS avgTable 
	JOIN Staff ON avgTable.staffID = Staff.staffID,
	(
		SELECT 
			CAST(AVG(DATEDIFF(DAY,rentTransactionDate,GETDATE())) AS int) AS value
		FROM
			rentTransaction
	)AS avgValue
WHERE
	staffGender IN('Male') AND 
	DATEDIFF(DAY, rentTransactionDate, GETDATE()) > avgValue.value



--#CASE 7
CREATE FUNCTION dbo.FirstWord (@value varchar(max))
RETURNS varchar(max)
AS
BEGIN
    RETURN CASE CHARINDEX(' ', @value, 1)
        WHEN 0 THEN @value
        ELSE SUBSTRING(@value, 1, CHARINDEX(' ', @value, 1) - 1) END
END

SELECT
	'Boat Type Name' = UPPER(dbo.FirstWord(typeName)),
	'Total Purchase Quantity' = TotalQty
FROM
	(
		SELECT 
			AVG(PT.quantity) AS avgQty,
			SUM(PT.quantity) AS TotalQty
		FROM 
			purchaseTransaction PT JOIN purchaseTransactionDetail PTD ON PT.purchaseID = PTD.purchaseID
		GROUP BY PT.purchaseID
	)as sumTable,
	Boat JOIN BoatType ON Boat.typeID = BoatType.typeID
WHERE
	sumTable.TotalQty  = 2 AND 
	avgQty < sumTable.TotalQty


 
--#CASE 8
SELECT
	RT.rentID, S.staffName, 
	'Transaction Month' = LEFT(DATENAME(month,RT.rentTransactionDate),3),
	'Total Rent Duration' = CAST(SUM(RT.duration) AS varchar) + ' hour(s)',
	'Average Rent Duration' = CAST(CAST(AVG(RT.duration) AS int) AS varchar) + ' hour(s)'
FROM
(
	SELECT 
	AVG(duration) AS AvgDuration
	FROM rentTransaction
)as avgTable,
	Staff S JOIN rentTransaction RT ON S.staffID=RT.staffID
WHERE
	duration > avgTable.AvgDuration AND
	DATENAME(year,rentTransactionDate) LIKE '2017'
GROUP BY RT.rentID, S.staffName, rentTransactionDate



--#CASE 9
CREATE VIEW
RentTransactionData
AS
	SELECT
	 RT.rentID,
	 'Date' = CONVERT(VARCHAR,rentTransactionDate,109),
	 SUM(duration) AS TotalHours,
	 'Total Rent Transaction' = COUNT(RT.rentID)
	FROM rentTransactionDetail RTD
		JOIN Boat ON RTD.boatID = Boat.boatID
		JOIN rentTransaction RT ON RT.rentID= RTD.rentID
	WHERE boatRentPrice < 20000000
	GROUP BY RT.rentID, rentTransactionDate
	HAVING SUM(duration) > 5



--#CASE 10
CREATE VIEW
PurchaseTransactionData
AS
SELECT
	'TransactionID' = REPLACE(PT.purchaseID, 'TP', 'PUR') ,
	purchaseTransactionDate, supplierName,
	SUM(quantity) AS TotalQty,
	MAX(quantity) AS MaxQty
FROM
	purchaseTransaction PT
	JOIN Supplier ON PT.supplierID=Supplier.supplierID
	GROUP BY PT.purchaseID, PT.purchaseTransactionDate,Supplier.supplierName
	HAVING
	SUM(quantity) < 5 AND
	MAX(quantity) > 1