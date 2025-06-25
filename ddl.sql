CREATE SCHEMA Electricity_Grid;
SET search_path TO Electricity_Grid;

CREATE TABLE State (
State_Name VARCHAR(255) PRIMARY KEY,
Unit_Charge DECIMAL(10,2),
Subsidy DECIMAL(10,2),
Rebate_Per_Solar_Unit DECIMAL(10,2)
);

CREATE TABLE Users (
UserID SERIAL PRIMARY KEY,
Category VARCHAR(50)
);

CREATE TABLE User_State (
State_Name VARCHAR(255),
User_ID INT,
Connection_Type VARCHAR(50),
PRIMARY KEY (State_Name, User_ID),
FOREIGN KEY (State_Name) REFERENCES State(State_Name),
FOREIGN KEY (User_ID) REFERENCES Users(UserID)
);

CREATE TABLE Department (
Dep_ID SERIAL PRIMARY KEY,
Dept_Name VARCHAR(255),
Complaints_Managing VARCHAR(255)
);

CREATE TABLE Employee (
UserID INT PRIMARY KEY,
Emp_Name VARCHAR(255),
Emp_Email VARCHAR(255),
Contact_No VARCHAR(10),
Dep_ID INT,
FOREIGN KEY (UserID) REFERENCES Users(UserID),
FOREIGN KEY (Dep_ID) REFERENCES Department(Dep_ID)
);

CREATE TABLE Consumer (
User_ID INT PRIMARY KEY,
Cons_Name VARCHAR(255),
Email VARCHAR(255),
Contact_No VARCHAR(10),
Connection_Type VARCHAR(50),
Has_Solar BOOLEAN,
FOREIGN KEY (User_ID) REFERENCES Users(UserID)
);

CREATE TABLE Payments (
Payment_ID SERIAL PRIMARY KEY,
Payment_Date DATE,
Amount_Paid DECIMAL(10,2),
Payment_Method VARCHAR(50)
);

CREATE TABLE Invoice_List (
Inv_No SERIAL PRIMARY KEY,
Bill_Amt DECIMAL(10,2),
Inv_Date DATE,
UserID INT,
Payment_ID INT,
FOREIGN KEY (UserID) REFERENCES Users(UserID),
FOREIGN KEY (Payment_ID) REFERENCES Payments(Payment_ID)
);

CREATE TABLE Invoice_Details (
Inv_No INT PRIMARY KEY,
Units_Consumed DECIMAL(10,2),
Subsidy_by_State DECIMAL(10,2),
Solar_Units_Gen DECIMAL(10,2),
FOREIGN KEY (Inv_No) REFERENCES Invoice_List(Inv_No)
);

CREATE TABLE Complaints (
Complaint_ID SERIAL PRIMARY KEY,
Status VARCHAR(50),
Details TEXT
);

CREATE TABLE Invoice_Complaints (
Complaint_ID INT,
Inv_No INT,
PRIMARY KEY (Complaint_ID, Inv_No),
FOREIGN KEY (Complaint_ID) REFERENCES Complaints(Complaint_ID),
FOREIGN KEY (Inv_No) REFERENCES Invoice_List(Inv_No)
);

CREATE TABLE Handling_Complaints (
Department_ID INT,
Complaint_ID INT,
PRIMARY KEY (Department_ID, Complaint_ID),
FOREIGN KEY (Department_ID) REFERENCES Department(Dep_ID),
FOREIGN KEY (Complaint_ID) REFERENCES Complaints(Complaint_ID)
);