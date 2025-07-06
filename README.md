# Data Engineering Internship Tasks – Celebal Technologies

This repository showcases four key tasks completed during my internship at Celebal Technologies. The tasks demonstrate data extraction, transformation, loading (ETL), automation, and database replication using Azure Data Factory and SQL.

---

## 🔧 Tech Stack

| Task | Technology Used |
|------|------------------|
| Task 1: Data Export (CSV, Parquet, Avro) | Azure Data Factory, Azure Blob Storage |
| Task 2: Pipeline Automation (Schedule & Event Triggers) | Azure Data Factory |
| Task 3: Full Database Replication | MySQL, SQL Workbench |
| Task 4: Selective Table/Column Copy | MySQL, SQL Workbench |

---

## 📁 Tasks Overview

### ✅ Task 1: Copy Data from Database to CSV, Parquet, and Avro

**Objective:**  
Extract data from a relational database and export it into CSV (for compatibility), Parquet (for analytics), and Avro (for compact storage and schema evolution).

**Approach:**
- Source: MySQL Database
- Sink: Azure Blob Storage containers (one for each format)
- Pipeline: Azure Data Factory pipeline with Copy activity and parameterized file format
- Linked Services: Configured for MySQL and Azure Blob Storage
- Output Containers: 
  - `output-csv`
  - `output-parquet`
  - `output-avro`

---

### ✅ Task 2: Configure Schedule Trigger and Event Triggers

**Objective:**  
Automate pipeline execution using:
- **Schedule Trigger**: Executes the pipeline at fixed intervals.
- **Event Trigger**: Responds to new file arrivals in Azure Blob Storage.

**Approach:**
- Schedule Trigger: Created using UTC timing for hourly/daily execution.
- Event Trigger: Configured to monitor a Blob Storage container for `.csv` files.
- Action: Automatically triggers pipeline to process new data.

---

### ✅ Task 3: Copy All Tables from One Database to Another

**Objective:**  
Replicate all tables from one MySQL database (`source_db`) to another (`target_db`) including structure and data.

**Approach:**
- Created a SQL procedure to dynamically read tables from `information_schema`.
- For each table, used `CREATE TABLE` and `INSERT INTO SELECT *` statements.
- No need to manually define table schemas for the destination database.

**Tools:**
- MySQL Workbench  
- SQL Scripts using `INFORMATION_SCHEMA.TABLES`

---

### ✅ Task 4: Copy Selective Tables and Columns Between Databases

**Objective:**  
Transfer only selected tables and specific columns from one MySQL database to another for business-specific data control.

**Approach:**
- Developed a stored procedure that accepts:
  - Source and Destination DB Names
  - A JSON map specifying tables and column lists
- Dynamically generates `INSERT INTO ... SELECT ...` statements

**Example Input Format:**
```json
{
  "departments": ["id", "name"],
  "employees": ["emp_id", "name"]
}
