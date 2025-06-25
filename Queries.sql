--to give idea of how consumer could get his bill data
SELECT * FROM consumer c JOIN invoice_list il ON c.User_ID = il.UserID
JOIN invoice_details id ON il.Inv_No = id.Inv_No
LEFT JOIN payments p ON il.Payment_ID = p.Payment_ID;

--Count how many users belong to each state
SELECT State_Name, COUNT(User_ID) AS Total_Users
FROM User_State
GROUP BY State_Name
ORDER BY Total_Users DESC;

--Find the most common payment method
SELECT Payment_Method, COUNT(*) AS Payment_Count
FROM Payments
GROUP BY Payment_Method
ORDER BY Payment_Count DESC
LIMIT 1;

--List all consumers along with their state and connection type
SELECT c.Cons_Name, c.Email, us.State_Name, us.Connection_Type
FROM Consumer c
JOIN User_State us ON c.User_ID = us.User_ID;

--Modify and Update Electricity Tariff Rates
UPDATE State SET Unit_Charge = 5, Subsidy = 125, Rebate_Per_Solar_Unit = 3.5
WHERE State_Name = 'Gujarat';

-- Total Electricity Consumption for a Given Time Period
SELECT SUM(id.Units_Consumed) AS Total_Consumption
FROM Invoice_List il
JOIN Invoice_Details id ON il.Inv_No = id.Inv_No
WHERE il.UserID = 1 AND il.Inv_Date BETWEEN '2024-01-01' AND '2024-04-01';

--Retrieve List of Consumers with Solar Power Generation
SELECT  User_ID, Cons_Name, Email, Contact_No
FROM Consumer WHERE Has_Solar = TRUE;

--List all employees along with the department they work in
SELECT e.Emp_Name, e.Emp_Email, e.Contact_No, d.Dept_Name
FROM Employee e
JOIN Department d ON e.Dep_ID = d.Dep_ID;

--Ratio of Consumers Utilizing Solar Rebates to Total Number of Consumers
SELECT 
ROUND(1.0 * (SELECT COUNT(*) FROM Consumer WHERE Has_Solar = TRUE) / (SELECT COUNT(*) FROM Consumer), 2) AS Solar_Rebate_Ratio;

--View and Track Status of Complaints
SELECT  c.Complaint_ID, c.Status, c.Details
FROM Complaints c
JOIN Invoice_Complaints ic ON c.Complaint_ID = ic.Complaint_ID
JOIN Invoice_List il ON ic.Inv_No = il.Inv_No
WHERE il.UserID = 10;

--View Tariff Details Applicable for a Particular Consumer
SELECT s.State_Name, s.Unit_Charge,s.Subsidy,s.Rebate_Per_Solar_Unit
FROM State s
JOIN User_State us ON s.State_Name = us.State_Name
WHERE us.User_ID = 4;

-- Identify Defaulters (Consumers with Overdue Bills)
SELECT c.User_ID,c.Cons_Name,il.Inv_No,il.Bill_Amt, il.Inv_Date
FROM Consumer c
JOIN Invoice_List il ON c.User_ID = il.UserID
LEFT JOIN Payments p ON il.Payment_ID = p.Payment_ID
WHERE p.Payment_ID IS NULL AND il.Inv_Date < CURRENT_DATE - INTERVAL '30 days';

--Generate List of Consumers with Pending Complaints
SELECT c.User_ID,c.Cons_Name,comp.Complaint_ID,comp.Status
FROM Consumer c
JOIN Invoice_List il ON c.User_ID = il.UserID
JOIN Invoice_Complaints ic ON il.Inv_No = ic.Inv_No
JOIN Complaints comp ON ic.Complaint_ID = comp.Complaint_ID
WHERE comp.Status IN ('Pending', 'In Progress');

--Number of Complaints Raised, Resolved, and Pending in a Given Duration
SELECT comp.Status, COUNT(*) AS Complaint_Count
FROM Complaints comp
JOIN Invoice_Complaints ic ON comp.Complaint_ID = ic.Complaint_ID
JOIN Invoice_List il ON ic.Inv_No = il.Inv_No
WHERE il.Inv_Date BETWEEN '2024-04-01' AND '2024-04-01'
GROUP BY comp.Status;

--Generate List of Consumers Having Negative Balance
SELECT c.User_ID,c.Cons_Name,il.Inv_No,il.Bill_Amt,
COALESCE(p.Amount_Paid, 0) AS Amount_Paid,--as amount may be null
(COALESCE(p.Amount_Paid, 0) - il.Bill_Amt) AS Balance--payment too can be null
FROM Consumer c
JOIN Invoice_List il ON c.User_ID = il.UserID
LEFT JOIN Payments p ON il.Payment_ID = p.Payment_ID
WHERE (COALESCE(p.Amount_Paid, 0) - il.Bill_Amt) < 0;

--View Total Electricity Consumption Under Specific Department
SELECT d.Dept_Name, SUM(id.Units_Consumed) AS Total_Consumption
FROM Department d
JOIN Handling_Complaints hc ON d.Dep_ID = hc.Department_ID
JOIN Complaints comp ON hc.Complaint_ID = comp.Complaint_ID
JOIN Invoice_Complaints ic ON comp.Complaint_ID = ic.Complaint_ID
JOIN Invoice_List il ON ic.Inv_No = il.Inv_No
JOIN Invoice_Details id ON il.Inv_No = id.Inv_No
GROUP BY d.Dept_Name;

--Get the top 2 states with the highest average monthly consumption
SELECT s.State_Name,ROUND(AVG(id.Units_Consumed), 2) AS Avg_Monthly_Consumption
FROM State s
JOIN User_State us ON s.State_Name = us.State_Name
JOIN Invoice_List il ON us.User_ID = il.UserID
JOIN Invoice_Details id ON il.Inv_No = id.Inv_No
WHERE il.Inv_Date >= '2024-01-01' AND il.Inv_Date < '2025-01-01'
GROUP BY s.State_Name
ORDER BY Avg_Monthly_Consumption DESC
LIMIT 2;

--Find users who generated more solar energy than they consumed in any invoice
SELECT il.UserID,il.Inv_No,id.Solar_Units_Gen,id.Units_Consumed
FROM Invoice_List il
JOIN Invoice_Details id ON il.Inv_No = id.Inv_No
WHERE id.Solar_Units_Gen > id.Units_Consumed;

--Find the total number of complaints filed by each user
SELECT c.User_ID,c.Cons_Name, COUNT(ic.Complaint_ID) AS Total_Complaints
FROM Invoice_Complaints ic
JOIN Invoice_List il ON ic.Inv_No = il.Inv_No
JOIN Consumer c ON il.UserID = c.User_ID
GROUP BY c.User_ID, c.Cons_Name
ORDER BY Total_Complaints DESC;

--Find the top 3 users with the highest difference between electricity consumed and  solar units generated  over all their invoices
SELECT c.User_ID,c.Cons_Name,SUM(id.Solar_Units_Gen) AS Total_Solar_Generated,SUM(id.Units_Consumed) AS Total_Consumed,
SUM(id.Units_Consumed - id.Solar_Units_Gen) AS Net_Generation
FROM Invoice_List il
JOIN Invoice_Details id ON il.Inv_No = id.Inv_No
JOIN Consumer c ON il.UserID = c.User_ID  -- Properly joining to get consumer name
GROUP BY c.User_ID, c.Cons_Name  -- Including all non-aggregated columns
HAVING SUM(id.Units_Consumed) > SUM(id.Solar_Units_Gen)  -- More readable condition
ORDER BY Net_Generation DESC
LIMIT 3;

--Users with total consumption above overall user average(correlated subquery)
SELECT u.User_ID, u.Cons_Name
FROM Consumer u
WHERE (
    SELECT SUM(id.Units_Consumed)
    FROM Invoice_List il
    JOIN Invoice_Details id ON il.Inv_No = id.Inv_No
    WHERE il.UserID = u.User_ID) >(
    SELECT AVG(sub.total)
    FROM (
        SELECT SUM(id.Units_Consumed) AS total
        FROM Invoice_List il
        JOIN Invoice_Details id ON il.Inv_No = id.Inv_No
        GROUP BY il.UserID)sub);

-- Optimized query for Users with total consumption above overall user average(to reduce complexity)
WITH UserConsumption AS (
    SELECT il.UserID, SUM(id.Units_Consumed) AS total
    FROM Invoice_List il
    JOIN Invoice_Details id ON il.Inv_No = id.Inv_No
    GROUP BY il.UserID
),
Average AS (SELECT AVG(total) AS avg_total FROM UserConsumption)
SELECT u.User_ID, u.Cons_Name
FROM Consumer u
JOIN UserConsumption uc ON u.User_ID = uc.UserID
JOIN Average a ON TRUE
WHERE uc.total > a.avg_total;

--Consumers who have the highest single bill (correlated)
SELECT c.User_ID, c.Cons_Name
FROM Consumer c
WHERE EXISTS (
    SELECT 1
    FROM Invoice_List il
    WHERE il.UserID = c.User_ID
    AND il.Bill_Amt = (
        SELECT MAX(il2.Bill_Amt)
        FROM Invoice_List il2
        WHERE il2.UserID = c.User_ID)
);

--Optimized query for Consumers who have the highest single bill (to reduce complexity)
WITH MaxBills AS (
    SELECT UserID, MAX(Bill_Amt) AS Max_Bill
    FROM Invoice_List
    GROUP BY UserID)
SELECT DISTINCT c.User_ID, c.Cons_Name
FROM Consumer c
JOIN Invoice_List il ON c.User_ID = il.UserID
JOIN MaxBills mb ON il.UserID = mb.UserID AND il.Bill_Amt = mb.Max_Bill;

--States where average bill is above national average(correlated)
SELECT DISTINCT s.State_Name
FROM State s
WHERE (
    SELECT AVG(il.Bill_Amt)
    FROM User_State us
    JOIN Invoice_List il ON us.User_ID = il.UserID
    WHERE us.State_Name = s.State_Name
) > (SELECT AVG(Bill_Amt)
    FROM Invoice_List);

--Optimized query for States where average bill is above national average(to reduce complexity)
WITH StateAvgs AS (
    SELECT us.State_Name, AVG(il.Bill_Amt) AS Avg_State_Bill
    FROM User_State us
    JOIN Invoice_List il ON us.User_ID = il.UserID
    GROUP BY us.State_Name
),NationalAvg AS (SELECT AVG(Bill_Amt) AS National_Avg FROM Invoice_List)
SELECT sa.State_Name
FROM StateAvgs sa, NationalAvg na
WHERE sa.Avg_State_Bill > na.National_Avg;
