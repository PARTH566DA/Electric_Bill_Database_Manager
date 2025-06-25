# **Electric Bill Database Manager**
---

## **Project Overview**
<p align="justify">
The Electric Bill Database Manager is a structured database project designed to simulate and manage electricity billing, payment processing, and complaint handling for a multi-state electricity distribution system. Built using PostgreSQL and managed via the pgAdmin tool, this system ensures organized storage, efficient queries, and insightful analytics through a well-normalized relational schema.
</p>

<p align="justify">
With defined entities like consumers, employees, departments, invoices, and complaints, the system supports functions such as generating bills, tracking solar energy usage, processing payments, and managing customer complaints, making it a versatile backend utility for electric grid administration.
</p>

---

## **Implementation and Execution**

### **1. Schema and ER Diagram**

<p align="justify">
The schema is implemented under the <code>Electricity_Grid</code> namespace and includes interconnected tables such as:
</p>

- <code>State</code>: Stores state-wise electricity charges and subsidies.  
- <code>Users</code>: Base entity for all users—consumers or employees.  
- <code>Consumer</code> and <code>Employee</code>: Extend users with role-specific attributes.  
- <code>Department</code>: Defines internal units handling operations or complaints.  
- <code>Invoice_List</code> and <code>Invoice_Details</code>: Represent billing records and consumption data.  
- <code>Payments</code>: Captures transaction details.  
- <code>Complaints</code>: Records consumer issues linked to invoices and departments.

<p align="justify">
The <code>ddl.sql</code> file defines all necessary tables, keys, and relationships using foreign keys to maintain referential integrity. The ER diagram and relational schema further clarify entity relationships and database structure.
</p>

### **2. Data and Queries**

<p align="justify">
The <code>data.sql</code> file populates the database with sample entries representing different states, users, invoices, and complaint records. This provides a working dataset to run meaningful queries and observe realistic outputs.
</p>

<p align="justify">
The <code>queries.sql</code> file demonstrates important business logic and analytics, including:
</p>

- Computing bills with applicable subsidies and solar rebates  
- Listing all unpaid invoices or late payments  
- Region-wise energy consumption statistics  
- Identifying top solar energy generators  
- Managing complaint status and resolution department

---

## **Key Features**
- **Multi-Entity System:** Covers consumers, employees, departments, and billing data.  
- **Smart Billing Support:** Incorporates solar energy rebates and state subsidies.  
- **Complaint Management:** Handles invoice-related complaints and department responsibilities.  

---

## **Scope for Improvement**
1. **Frontend Dashboard:** Integrate a UI for real-time interaction and visual analytics.  
2. **Automated Alerts:** Add functionality for bill reminders or complaint status notifications.  
3. **Dynamic Rate Calculation:** Include time-of-day pricing or consumption slabs in billing logic.

---

## **How to Run?**
<p align="justify">
Start by launching pgAdmin and creating a new PostgreSQL database. Execute the <code>ddl.sql</code> script to build the schema inside the <code>Electricity_Grid</code> schema. Next, populate the tables using the <code>data.sql</code> file. You can now explore and test functionality by running the <code>queries.sql</code> file to generate bills, analyze solar usage, track unpaid invoices, and handle customer complaints. Additionally, refer to the <code>ER diagram</code> and <code>Relational Schema</code> provided in the repository for detailed structure.
</p>
