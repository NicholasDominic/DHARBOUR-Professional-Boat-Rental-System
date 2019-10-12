CREATE DATABASE DHarbour

USE DHarbour

CREATE TABLE Customer(
	customerID char(5) PRIMARY KEY NOT NULL,
	customerName varchar(50) NOT NULL,
	customerPhoneNumber varchar(13) NOT NULL,
	customerAddress varchar(50) NOT NULL,
	customerGender varchar(6) NOT NULL,
	customerEmail varchar(50) NOT NULL,

	CONSTRAINT customer_id CHECK(customerID LIKE 'CS[0-9][0-9][0-9]'),
	CONSTRAINT customer_Name CHECK(customerName LIKE 'Mr. %' OR customerName LIKE 'Mrs. %'),
	CONSTRAINT customer_Address CHECK(customerAddress LIKE '% Street' OR customerAddress LIKE '% Road'),
	CONSTRAINT customer_Gender CHECK(customerGender LIKE 'Male' OR customerGender LIKE 'Female')
)

CREATE TABLE Staff(
	staffID char(5) PRIMARY KEY NOT NULL,
	staffName varchar(50) NOT NULL,
	staffPhoneNumber varchar(13) NOT NULL,
	staffGender varchar(6) NOT NULL,
	staffEmail varchar(50) NOT NULL,
	staffSalary int NOT NULL,
	staffAddress varchar(50) NOT NULL,

	CONSTRAINT staff_id CHECK(staffID LIKE 'ST[0-9][0-9][0-9]'),
	CONSTRAINT staff_Name CHECK(len(staffName) > 3),
	CONSTRAINT staff_Address CHECK(staffAddress LIKE '% Street' OR staffAddress LIKE '% Road'),
	CONSTRAINT staff_Gender CHECK(staffGender LIKE 'Male' OR staffGender LIKE 'Female')
)

CREATE TABLE Supplier(
	supplierID char(5) PRIMARY KEY NOT NULL,
	supplierName varchar(50) NOT NULL,
	supplierPhoneNumber varchar(13) NOT NULL,
	supplierGender varchar(6) NOT NULL,
	supplierEmail varchar(50) NOT NULL,
	supplierAddress varchar(50) NOT NULL,

	CONSTRAINT supplier_id CHECK(supplierID LIKE 'SP[0-9][0-9][0-9]'),
	CONSTRAINT supplier_Name CHECK(supplierName LIKE 'Mr. %' OR supplierName LIKE 'Mrs. %'),
	CONSTRAINT supplier_Address CHECK(supplierAddress LIKE '% Street' OR supplierAddress LIKE '% Road'),
	CONSTRAINT supplier_Gender CHECK(supplierGender LIKE 'Male' OR supplierGender LIKE 'Female')
)

CREATE TABLE BoatType(
	typeID char(5) PRIMARY KEY NOT NULL,
	typeName varchar(50) NOT NULL,

	CONSTRAINT boatType_id CHECK(typeID LIKE 'BT[0-9][0-9][0-9]'),
	CONSTRAINT boatType_name CHECK(len(typeName) > 5)
)

CREATE TABLE Boat(
	boatID char(5) PRIMARY KEY NOT NULL,
	typeID char(5)
		FOREIGN KEY REFERENCES
		BoatType(typeID),

	boatName varchar(50) NOT NULL,
	boatRentPrice int NOT NULL,
	boatPurchasePrice int NOT NULL,

	CONSTRAINT Boat_id CHECK(boatID LIKE 'BO[0-9][0-9][0-9]')
)

CREATE TABLE rentTransaction(
	rentID char(5) PRIMARY KEY NOT NULL,
	customerID char(5)
		FOREIGN KEY REFERENCES
		Customer(customerID),
	
	staffID char(5)
		FOREIGN KEY REFERENCES
		Staff(staffID),

	rentTransactionDate datetime NOT NULL,
	duration int NOT NULL,

	CONSTRAINT Rent_id CHECK(rentID LIKE 'TR[0-9][0-9][0-9]'),
	CONSTRAINT rentTransaction_date CHECK(CAST(rentTransactionDate AS TIME) BETWEEN '09:00:00' AND '15:00:00')
)

CREATE TABLE purchaseTransaction(
	purchaseID char(5) PRIMARY KEY NOT NULL,
	staffID char(5)
		FOREIGN KEY REFERENCES
		Staff(staffID),

	supplierID char(5)
		FOREIGN KEY REFERENCES
		Supplier(supplierID),

	purchaseTransactionDate datetime NOT NULL,
	quantity int NOT NULL,

	CONSTRAINT purchase_id CHECK(purchaseID LIKE 'TP[0-9][0-9][0-9]'),
	CONSTRAINT purchaseTransaction_date CHECK(CAST(purchasetransactionDate AS TIME) BETWEEN '09:00:00' AND '15:00:00')
)

CREATE TABLE rentTransactionDetail(
	rentID char(5) PRIMARY KEY
		FOREIGN KEY REFERENCES
		rentTransaction(rentID),

	boatID char(5)
		FOREIGN KEY REFERENCES
		Boat(boatID)
)

CREATE TABLE purchaseTransactionDetail(
	purchaseID char(5) PRIMARY KEY
		FOREIGN KEY REFERENCES
		purchaseTransaction(purchaseID),

	boatID char(5)
		FOREIGN KEY REFERENCES
		Boat(boatID),
)