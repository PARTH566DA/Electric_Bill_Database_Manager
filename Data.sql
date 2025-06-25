INSERT INTO state (State_Name, Unit_Charge, Subsidy, Rebate_Per_Solar_Unit) VALUES
('Gujarat', 6.00, 100, 3.00),
('Maharashtra', 7.15, 100, 3.00),
('Delhi', 4.50, 150, 3.50);

INSERT INTO users (UserID,Category) VALUES
(1,'Consumer'),  -- 1: Om Patel
(2,'Consumer'),  -- 2: Parth Bhatt
(3,'Consumer'),  -- 3: Tirth Boghani
(4,'Consumer'),  -- 4: Shamit Gandhi
(5,'Consumer'),  -- 5: Kajal Desai
(6,'Consumer');  -- 6: Mehul Shah

INSERT INTO User_State (State_Name, User_ID, Connection_Type) VALUES
('Gujarat', 1, 'Residential'),
('Gujarat', 2, 'Residential'),
('Gujarat', 3, 'Residential'),
('Gujarat', 4, 'Residential'),
('Gujarat', 5, 'Commercial'),
('Gujarat', 6, 'Commercial');

INSERT INTO Consumer (User_ID, Cons_Name, Email, Contact_No, Connection_Type, Has_Solar) VALUES
(1, 'Om Patel', 'om.patel@gmail.com', '9825012345', 'Residential', TRUE),
(2, 'Parth Bhatt', 'parth.bhatt@apple.com', '9898989898', 'Residential', FALSE),
(3, 'Tirth Boghani', 'tirth.boghani@gmail.com', '9723456789', 'Residential', TRUE),
(4, 'Shamit Gandhi', 'shamit.gandhi@gmail.com', '6353123275', 'Residential', FALSE),
(5, 'Kajal Desai', 'kajal.desai@yahoo.com', '9356741289', 'Commercial', TRUE),
(6, 'Mehul Shah', 'mehul.shah@gmail.com', '9999999999', 'Commercial', FALSE);

SELECT 
    il.Inv_No,s.State_Name,us.User_ID,s.Unit_Charge,id.Units_Consumed,id.Subsidy_by_State,id.Solar_Units_Gen
    ,s.Rebate_Per_Solar_Unit,
    (s.Unit_Charge * (id.Units_Consumed - id.Subsidy_by_State) 
    - s.Rebate_Per_Solar_Unit * id.Solar_Units_Gen) AS Calculated_Bill_Amount
FROM Invoice_List il
JOIN Invoice_Details id ON il.Inv_No = id.Inv_No
JOIN User_State us ON il.UserID = us.User_ID
JOIN State s ON us.State_Name = s.State_Name;

UPDATE Invoice_List
SET Bill_Amt = subquery.Calculated_Bill_Amount
FROM (
    SELECT 
        il.Inv_No, s.Unit_Charge * (id.Units_Consumed - id.Subsidy_by_State) 
        - s.Rebate_Per_Solar_Unit * id.Solar_Units_Gen AS Calculated_Bill_Amount
    FROM Invoice_List il
    JOIN Invoice_Details id ON il.Inv_No = id.Inv_No
    JOIN User_State us ON il.UserID = us.User_ID
    JOIN State s ON us.State_Name = s.State_Name
) AS subquery WHERE Invoice_List.Inv_No = subquery.Inv_No;


INSERT INTO Invoice_List (Inv_No, Bill_Amt, Inv_Date, UserID, Payment_ID) VALUES
(1, NULL, '2024-04-01', 1, NULL),  
(2, NULL, '2024-04-01', 2, NULL),  
(3, NULL, '2024-04-01', 3, NULL),  
(4, NULL, '2024-04-01', 4, NULL),  
(5, NULL, '2024-04-01', 5, NULL),  
(6, NULL, '2024-04-01', 6, NULL); 


INSERT INTO Invoice_Details (Inv_No, Units_Consumed, Subsidy_by_State, Solar_Units_Gen) VALUES
(1, 145.00, 100.00, 45.00),-- Om Patel(residential, solar)
(2, 210.00, 100.00, 0.00),-- Parth Bhatt(residential, no solar)
(3, 190.00, 100.00, 60.00),  
(4, 85.00, 85.00, 0.00),     
(5, 275.00, 0.00, 90.00),-- Kajal Desai(commercial so no subsidy, solar)
(6, 165.00, 0.00, 0.00);     

UPDATE Invoice_List
SET Bill_Amt = subquery.Calculated_Bill_Amount
FROM (
    SELECT 
        il.Inv_No,
        s.Unit_Charge * (id.Units_Consumed - LEAST(id.Units_Consumed, id.Subsidy_by_State)) 
        - s.Rebate_Per_Solar_Unit * id.Solar_Units_Gen AS Calculated_Bill_Amount
    FROM 
        Invoice_List il
    JOIN 
        Invoice_Details id ON il.Inv_No = id.Inv_No
    JOIN 
        User_State us ON il.UserID = us.User_ID
    JOIN 
        State s ON us.State_Name = s.State_Name
) AS subquery
WHERE Invoice_List.Inv_No = subquery.Inv_No;
 
INSERT INTO Payments (Payment_ID, Payment_Date, Amount_Paid, Payment_Method) VALUES
(1, '2024-04-10', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 1), 'Credit Card'),
(2, '2024-04-11', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 2), 'Debit Card'),
(3, '2024-04-12', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 3), 'UPI'),
(4, '2024-04-13', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 4), 'Net Banking'),
(5, '2024-04-14', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 5), 'Credit Card'),
(6, '2024-04-15', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 6), 'Debit Card');

--as initially payment id were null so
UPDATE Invoice_List SET Payment_ID = 1 WHERE Inv_No = 1;
UPDATE Invoice_List SET Payment_ID = 2 WHERE Inv_No = 2;
UPDATE Invoice_List SET Payment_ID = 3 WHERE Inv_No = 3;
UPDATE Invoice_List SET Payment_ID = 4 WHERE Inv_No = 4;
UPDATE Invoice_List SET Payment_ID = 5 WHERE Inv_No = 5;
UPDATE Invoice_List SET Payment_ID = 6 WHERE Inv_No = 6;

INSERT INTO Department (Dep_ID, Dept_Name, Complaints_Managing) VALUES
(1, 'GJVCL', 'All complaints for Gujarat state'),
(2, 'MHVCL', 'All complaints for Maharashtra state'),
(3, 'DDVCL', 'All complaints for Delhi state');

INSERT INTO Users (UserID, Category) VALUES
(7, 'Employee'),  -- GJVCL manager
(8, 'Employee'),  -- MHVCL manager
(9, 'Employee');  -- DDVCL manager

INSERT INTO Employee (UserID, Emp_Name, Emp_Email, Contact_No, Dep_ID) VALUES
(7, 'Gujarat Manager1', 'manager1@gjvcl.com', '1234567890', 1),
(8, 'Maharashtra Manager2', 'manager1@mhvcl.com', '1234567891', 2),
(9, 'Delhi Manager3', 'manager1@ddvcl.com', '1234567892', 3);

INSERT INTO Complaints (Complaint_ID, Status, Details) VALUES
(1, 'Pending', 'Incorrect meter reading for residential connection'),
(2, 'In Progress', 'Solar panel rebate not received');

INSERT INTO Handling_Complaints (Department_ID, Complaint_ID) VALUES
(1, 1),  
(1, 2);  

INSERT INTO Invoice_Complaints (Complaint_ID, Inv_No) VALUES
(1, 2), --complaint by Parth Bhatt
(2, 5);  --complaint by Kajal Desai

INSERT INTO Users (UserID, Category) VALUES
(10, 'Consumer'),  
(11, 'Consumer'),  
(12, 'Consumer');  

INSERT INTO User_State (State_Name, User_ID, Connection_Type) VALUES
('Maharashtra', 10, 'Residential'),
('Maharashtra', 11, 'Commercial'),
('Maharashtra', 12, 'Residential');

INSERT INTO Consumer (User_ID, Cons_Name, Email, Contact_No, Connection_Type, Has_Solar) VALUES
(10, 'A T Bhide', 'atbhide@gmail.com', '9876543210', 'Residential', FALSE),
(11, 'T R Shinde', 'trshinde@yahoo.com', '8765432109', 'Commercial', TRUE),
(12, 'Rajesh Wagle', 'rajeshwagle@hotmail.com', '7654321098', 'Residential', FALSE);

INSERT INTO Invoice_List (Inv_No, Bill_Amt, Inv_Date, UserID, Payment_ID) VALUES
(7, NULL, '2024-04-01', 10, NULL),
(8, NULL, '2024-04-01', 11, NULL),
(9, NULL, '2024-04-01', 12, NULL);

INSERT INTO Invoice_Details (Inv_No, Units_Consumed, Subsidy_by_State, Solar_Units_Gen) VALUES
(7, 180.00, 100.00, 0.00),    
(8, 250.00, 0.00, 80.00),      
(9, 120.00, 100.00, 0.00); 

UPDATE Invoice_List
SET Bill_Amt = subquery.Calculated_Bill_Amount
FROM (
    SELECT 
        il.Inv_No,
        s.Unit_Charge * (id.Units_Consumed - LEAST(id.Units_Consumed, id.Subsidy_by_State)) 
        - s.Rebate_Per_Solar_Unit * id.Solar_Units_Gen AS Calculated_Bill_Amount
    FROM 
        Invoice_List il
    JOIN 
        Invoice_Details id ON il.Inv_No = id.Inv_No
    JOIN 
        User_State us ON il.UserID = us.User_ID
    JOIN 
        State s ON us.State_Name = s.State_Name
    WHERE il.Inv_No IN (7, 8, 9)
) AS subquery
WHERE Invoice_List.Inv_No = subquery.Inv_No;

INSERT INTO Payments (Payment_ID, Payment_Date, Amount_Paid, Payment_Method) VALUES
(7, '2024-04-16', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 7), 'UPI'),
(8, '2024-04-17', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 8), 'Credit Card'),
(9, '2024-04-18', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 9), 'Debit Card');

UPDATE Invoice_List SET Payment_ID = 7 WHERE Inv_No = 7;
UPDATE Invoice_List SET Payment_ID = 8 WHERE Inv_No = 8;
UPDATE Invoice_List SET Payment_ID = 9 WHERE Inv_No = 9;

INSERT INTO Complaints (Complaint_ID, Status, Details) VALUES
(3, 'Pending', 'Frequent Power Cuts without prior notice'),
(4, 'In Progress', 'Solar panel has issues');

INSERT INTO Handling_Complaints (Department_ID, Complaint_ID) VALUES
(2, 3),  -- MHVCL handles complaint for A T Bhide
(2, 4); 

INSERT INTO Invoice_Complaints (Complaint_ID, Inv_No) VALUES
(3, 7),-- complaint by A T Bhide
(4, 8);-- complaint by T R Shinde

-- Gujarat Users (January)
INSERT INTO Invoice_List (Inv_No, Bill_Amt, Inv_Date, UserID, Payment_ID) VALUES
(10, NULL, '2024-01-01', 1, NULL),
(11, NULL, '2024-01-01', 2, NULL),
(12, NULL, '2024-01-01', 3, NULL),
(13, NULL, '2024-01-01', 4, NULL),
(14, NULL, '2024-01-01', 5, NULL),
(15, NULL, '2024-01-01', 6, NULL);

-- Maharashtra Users (January)
INSERT INTO Invoice_List (Inv_No, Bill_Amt, Inv_Date, UserID, Payment_ID) VALUES
(16, NULL, '2024-01-01', 10, NULL),
(17, NULL, '2024-01-01', 11, NULL),
(18, NULL, '2024-01-01', 12, NULL);

INSERT INTO Invoice_Details (Inv_No, Units_Consumed, Subsidy_by_State, Solar_Units_Gen) VALUES
(10, 120.00, 100.00, 35.00),  
(11, 180.00, 100.00, 0.00),  
(12, 160.00, 100.00, 50.00),  
(13, 70.00, 70.00, 0.00),     
(14, 220.00, 0.00, 75.00),    
(15, 140.00, 0.00, 0.00),     
(16, 150.00, 100.00, 0.00),   
(17, 230.00, 0.00, 80.00),   
(18, 100.00, 100.00, 0.00);   

INSERT INTO Invoice_List (Inv_No, Bill_Amt, Inv_Date, UserID, Payment_ID) VALUES
(19, NULL, '2024-02-01', 1, NULL),
(20, NULL, '2024-02-01', 2, NULL),
(21, NULL, '2024-02-01', 3, NULL),
(22, NULL, '2024-02-01', 4, NULL),
(23, NULL, '2024-02-01', 5, NULL),
(24, NULL, '2024-02-01', 6, NULL),
(25, NULL, '2024-02-01', 10, NULL),
(26, NULL, '2024-02-01', 11, NULL),
(27, NULL, '2024-02-01', 12, NULL);

INSERT INTO Invoice_Details (Inv_No, Units_Consumed, Subsidy_by_State, Solar_Units_Gen) VALUES
(19, 140.00, 100.00, 45.00),  
(20, 210.00, 100.00, 0.00),  
(21, 190.00, 100.00, 60.00),  
(22, 85.00, 85.00, 0.00),     
(23, 260.00, 0.00, 90.00),   
(24, 165.00, 0.00, 0.00),     
(25, 170.00, 100.00, 0.00),   
(26, 250.00, 0.00, 85.00),    
(27, 120.00, 100.00, 0.00);   

INSERT INTO Invoice_List (Inv_No, Bill_Amt, Inv_Date, UserID, Payment_ID) VALUES
(28, NULL, '2024-03-01', 1, NULL),
(29, NULL, '2024-03-01', 2, NULL),
(30, NULL, '2024-03-01', 3, NULL),
(31, NULL, '2024-03-01', 4, NULL),
(32, NULL, '2024-03-01', 5, NULL),
(33, NULL, '2024-03-01', 6, NULL),
(34, NULL, '2024-03-01', 10, NULL),
(35, NULL, '2024-03-01', 11, NULL),
(36, NULL, '2024-03-01', 12, NULL);

INSERT INTO Invoice_Details (Inv_No, Units_Consumed, Subsidy_by_State, Solar_Units_Gen) VALUES
(28, 160.00, 100.00, 55.00), 
(29, 240.00, 100.00, 0.00),   
(30, 220.00, 100.00, 70.00),  
(31, 100.00, 100.00, 0.00),   
(32, 300.00, 0.00, 100.00),   
(33, 190.00, 0.00, 0.00),     
(34, 200.00, 100.00, 0.00),   
(35, 280.00, 0.00, 90.00),    
(36, 150.00, 100.00, 0.00);

UPDATE Invoice_List
SET Bill_Amt = subquery.Calculated_Bill_Amount
FROM (
    SELECT 
        il.Inv_No,
        s.Unit_Charge * (id.Units_Consumed - LEAST(id.Units_Consumed, id.Subsidy_by_State)) 
        - s.Rebate_Per_Solar_Unit * id.Solar_Units_Gen AS Calculated_Bill_Amount
    FROM 
        Invoice_List il
    JOIN 
        Invoice_Details id ON il.Inv_No = id.Inv_No
    JOIN 
        User_State us ON il.UserID = us.User_ID
    JOIN 
        State s ON us.State_Name = s.State_Name
    WHERE il.Inv_No BETWEEN 10 AND 36
) AS subquery
WHERE Invoice_List.Inv_No = subquery.Inv_No;

INSERT INTO Payments (Payment_ID, Payment_Date, Amount_Paid, Payment_Method) VALUES
(10, '2024-01-03', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 10), 'Credit Card'),
(11, '2024-01-05', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 11), 'Debit Card'),
(12, '2024-01-07', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 12), 'UPI'),
(13, '2024-01-02', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 13), 'Net Banking'),
(14, '2024-01-09', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 14), 'Credit Card'),
(15, '2024-01-04', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 15), 'Debit Card'),
(16, '2024-01-06', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 16), 'UPI'),
(18, '2024-01-08', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 18), 'Net Banking');

UPDATE Invoice_List SET Payment_ID = 10 WHERE Inv_No = 10;
UPDATE Invoice_List SET Payment_ID = 11 WHERE Inv_No = 11;
UPDATE Invoice_List SET Payment_ID = 12 WHERE Inv_No = 12;
UPDATE Invoice_List SET Payment_ID = 13 WHERE Inv_No = 13;
UPDATE Invoice_List SET Payment_ID = 14 WHERE Inv_No = 14;
UPDATE Invoice_List SET Payment_ID = 15 WHERE Inv_No = 15;
UPDATE Invoice_List SET Payment_ID = 16 WHERE Inv_No = 16;
UPDATE Invoice_List SET Payment_ID = 18 WHERE Inv_No = 18;

INSERT INTO Payments (Payment_ID, Payment_Date, Amount_Paid, Payment_Method) VALUES
(19, '2024-02-04', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 19), 'Credit Card'),
(20, '2024-02-07', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 20), 'Debit Card'),
(21, '2024-02-03', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 21), 'UPI'),
(22, '2024-02-09', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 22), 'Net Banking'),
(23, '2024-02-05', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 23), 'Credit Card'),
(24, '2024-02-02', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 24), 'Debit Card'),
(25, '2024-02-08', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 25), 'UPI'),
(27, '2024-02-06', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 27), 'Net Banking');

UPDATE Invoice_List SET Payment_ID = 19 WHERE Inv_No = 19;
UPDATE Invoice_List SET Payment_ID = 20 WHERE Inv_No = 20;
UPDATE Invoice_List SET Payment_ID = 21 WHERE Inv_No = 21;
UPDATE Invoice_List SET Payment_ID = 22 WHERE Inv_No = 22;
UPDATE Invoice_List SET Payment_ID = 23 WHERE Inv_No = 23;
UPDATE Invoice_List SET Payment_ID = 24 WHERE Inv_No = 24;
UPDATE Invoice_List SET Payment_ID = 25 WHERE Inv_No = 25;
UPDATE Invoice_List SET Payment_ID = 27 WHERE Inv_No = 27;

INSERT INTO Payments (Payment_ID, Payment_Date, Amount_Paid, Payment_Method) VALUES
(28, '2024-03-05', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 28), 'Credit Card'),
(29, '2024-03-02', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 29), 'Debit Card'),
(30, '2024-03-08', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 30), 'UPI'),
(31, '2024-03-04', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 31), 'Net Banking'),
(32, '2024-03-09', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 32), 'Credit Card'),
(33, '2024-03-03', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 33), 'Debit Card'),
(34, '2024-03-07', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 34), 'UPI'),
(36, '2024-03-06', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 36), 'Net Banking');

UPDATE Invoice_List SET Payment_ID = 28 WHERE Inv_No = 28;
UPDATE Invoice_List SET Payment_ID = 29 WHERE Inv_No = 29;
UPDATE Invoice_List SET Payment_ID = 30 WHERE Inv_No = 30;
UPDATE Invoice_List SET Payment_ID = 31 WHERE Inv_No = 31;
UPDATE Invoice_List SET Payment_ID = 32 WHERE Inv_No = 32;
UPDATE Invoice_List SET Payment_ID = 33 WHERE Inv_No = 33;
UPDATE Invoice_List SET Payment_ID = 34 WHERE Inv_No = 34;
UPDATE Invoice_List SET Payment_ID = 36 WHERE Inv_No = 36;

UPDATE Invoice_List SET Payment_ID = NULL WHERE Inv_No = 8;
--shinde no payment
DELETE FROM Payments WHERE Payment_ID = 8;

INSERT INTO Users (UserID, Category) VALUES
(15, 'Consumer'),
(16, 'Consumer'),
(17, 'Consumer'),
(18, 'Consumer'),
(19, 'Consumer'),
(20, 'Consumer');

INSERT INTO User_State (State_Name, User_ID, Connection_Type) VALUES
('Delhi', 15, 'Residential'),
('Delhi', 16, 'Commercial'),
('Delhi', 17, 'Residential'),
('Delhi', 18, 'Commercial'),
('Delhi', 19, 'Residential'),  -- Unpaid
('Delhi', 20, 'Residential');  -- Unpaid

INSERT INTO Consumer (User_ID, Cons_Name, Email, Contact_No, Connection_Type, Has_Solar) VALUES
(15, 'Dinesh Patel', 'dineshp@gmail.com', '9100112233', 'Residential', TRUE),
(16, 'Shreya Shah', 'shreyas@company.com', '9100112244', 'Commercial', FALSE),
(17, 'Manpreet Kaur', 'manpreetk@yahoo.com', '9100112255', 'Residential', TRUE),
(18, 'Harbhajan Singh', 'harbhajan@biz.in', '9100112266', 'Commercial', FALSE),
(19, 'Anita Rathi', 'anitarathi@zmail.com', '9100112277', 'Residential', TRUE),
(20, 'Ravi Jadhav', 'ravi.jadhav@ymail.com', '9100112288', 'Residential', TRUE);

INSERT INTO Invoice_List (Inv_No, Bill_Amt, Inv_Date, UserID, Payment_ID) VALUES
(37, NULL, '2024-01-01', 15, NULL),
(38, NULL, '2024-01-01', 16, NULL),
(39, NULL, '2024-01-01', 17, NULL),
(40, NULL, '2024-01-01', 18, NULL),
(41, NULL, '2024-01-01', 19, NULL),
(42, NULL, '2024-01-01', 20, NULL),
(43, NULL, '2024-02-01', 15, NULL),
(44, NULL, '2024-02-01', 16, NULL),
(45, NULL, '2024-02-01', 17, NULL),
(46, NULL, '2024-02-01', 18, NULL),
(47, NULL, '2024-02-01', 19, NULL),
(48, NULL, '2024-02-01', 20, NULL),
(49, NULL, '2024-03-01', 15, NULL),
(50, NULL, '2024-03-01', 16, NULL),
(51, NULL, '2024-03-01', 17, NULL),
(52, NULL, '2024-03-01', 18, NULL),
(53, NULL, '2024-03-01', 19, NULL),
(54, NULL, '2024-03-01', 20, NULL),
(55, NULL, '2024-04-01', 15, NULL),
(56, NULL, '2024-04-01', 16, NULL),
(57, NULL, '2024-04-01', 17, NULL),
(58, NULL, '2024-04-01', 18, NULL),
(59, NULL, '2024-04-01', 19, NULL),
(60, NULL, '2024-04-01', 20, NULL);

INSERT INTO Invoice_Details (Inv_No, Units_Consumed, Subsidy_by_State, Solar_Units_Gen) 
VALUES 
(37, 110.00, 100.00, 30.00),
(38, 200.00, 0.00, 0.00),
(39, 95.00, 95.00, 25.00),
(40, 180.00, 0.00, 0.00),
(41, 120.00, 100.00, 35.00),
(42, 85.00, 85.00, 20.00),
(43, 130.00, 100.00, 40.00),
(44, 220.00, 0.00, 0.00),
(45, 105.00, 100.00, 30.00),
(46, 190.00, 0.00, 0.00),
(47, 140.00, 100.00, 45.00),
(48, 95.00, 95.00, 25.00),
(49, 150.00, 100.00, 50.00),
(50, 240.00, 0.00, 0.00),
(51, 115.00, 100.00, 35.00),
(52, 200.00, 0.00, 0.00),
(53, 160.00, 100.00, 55.00),
(54, 105.00, 100.00, 30.00),
(55, 170.00, 100.00, 60.00),
(56, 260.00, 0.00, 0.00),
(57, 125.00, 100.00, 40.00),
(58, 210.00, 0.00, 0.00),
(59, 180.00, 100.00, 65.00),
(60, 115.00, 100.00, 35.00);

UPDATE Invoice_List
SET Bill_Amt = subquery.Calculated_Bill_Amount
FROM (
    SELECT 
        il.Inv_No,
        s.Unit_Charge * (id.Units_Consumed - LEAST(id.Units_Consumed, id.Subsidy_by_State)) 
        - s.Rebate_Per_Solar_Unit * id.Solar_Units_Gen AS Calculated_Bill_Amount
    FROM 
        Invoice_List il
    JOIN 
        Invoice_Details id ON il.Inv_No = id.Inv_No
    JOIN 
        User_State us ON il.UserID = us.User_ID
    JOIN 
        State s ON us.State_Name = s.State_Name
    WHERE il.Inv_No BETWEEN 37 AND 60
) AS subquery
WHERE Invoice_List.Inv_No = subquery.Inv_No;

INSERT INTO Payments (Payment_ID, Payment_Date, Amount_Paid, Payment_Method) VALUES
(37, '2024-01-05', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 37), 'Credit Card'),
(38, '2024-01-07', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 38), 'Debit Card'),
(39, '2024-01-03', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 39), 'UPI'),
(40, '2024-01-09', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 40), 'Net Banking'),
(43, '2024-02-05', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 43), 'Credit Card'),
(44, '2024-02-07', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 44), 'Debit Card'),
(45, '2024-02-03', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 45), 'UPI'),
(46, '2024-02-09', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 46), 'Net Banking'),
(49, '2024-03-05', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 49), 'Credit Card'),
(50, '2024-03-07', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 50), 'Debit Card'),
(51, '2024-03-03', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 51), 'UPI'),
(52, '2024-03-09', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 52), 'Net Banking'),
(55, '2024-04-05', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 55), 'Credit Card'),
(56, '2024-04-07', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 56), 'Debit Card'),
(57, '2024-04-03', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 57), 'UPI'),
(58, '2024-04-09', (SELECT Bill_Amt FROM Invoice_List WHERE Inv_No = 58), 'Net Banking');   

--bill amount negative so no upi or stuff as no payment from user side so:
UPDATE Payments
SET Payment_Method = 'Transfered to user registered bank account'
WHERE Payment_ID IN (
    SELECT p.Payment_ID
    FROM Payments p
    JOIN Invoice_List il ON p.Payment_ID = il.Payment_ID
    WHERE il.Bill_Amt < 0
	AND il.Payment_ID IS NOT NULL
);

--also for future to prevent this mistake
INSERT INTO Payments (Payment_ID, Payment_Date, Amount_Paid, Payment_Method)
SELECT (SELECT COALESCE(MAX(Payment_ID), 0) FROM Payments) + ROW_NUMBER() OVER (),CURRENT_DATE, 
il.Bill_Amt, 'Transfer to user registered bank account'
FROM Invoice_List il
WHERE il.Bill_Amt < 0 AND il.Payment_ID IS NULL;

--update invoice_list to point to these new payments
UPDATE Invoice_List
SET Payment_ID = Inv_No
WHERE Bill_Amt < 0 AND Payment_ID IS NULL 
AND Inv_No IN (SELECT Payment_ID FROM Payments WHERE Payment_Method = 'transfer to user registered bank acct');

INSERT INTO Complaints (Complaint_ID, Status, Details) VALUES
(5, 'Pending', 'Incorrect subsidy calculation for residential connection'),
(6, 'In Progress', 'Solar panel rebate not credited to account'),
(7, 'Resolved', 'Meter reading discrepancy'),
(8, 'Pending', 'Frequent voltage fluctuations');

INSERT INTO Handling_Complaints (Department_ID, Complaint_ID) VALUES
(3, 5),  
(3, 6), 
(3, 7),  
(3, 8);  
INSERT INTO Invoice_Complaints (Complaint_ID, Inv_No) VALUES
(5, 37), 
(6, 39),  
(7, 38),  
(8, 41); 
