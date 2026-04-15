# Healthcare Analytics: Hospital Resource Management

## Project Overview
In this project, I analyzed hospital data using SQL to understand patient flow, resource utilization, and overall operational efficiency.

The goal was to use data to identify areas where hospital processes can be improved, especially in terms of patient care and resource allocation.

---

## Objectives

### Patient Flow Analysis
- Calculate average length of stay per department
- Identify peak admission days and times
- Analyze patient readmissions

### Resource Utilization
- Evaluate bed occupancy across departments
- Analyze staff-to-patient ratios

### Operational Efficiency
- Compare treatment costs across departments
- Identify departments with high ER wait times
- Rank departments based on performance metrics

---

## Dataset
The dataset includes multiple tables:

- Patient details (admissions, discharge, ER time)
- Staff information (roles, departments)
- Bed allocation and hospital resources
- Department-level data

---

## Key SQL Concepts Used
- JOINs across multiple tables
- Window Functions (RANK, SUM OVER)
- Aggregations (AVG, COUNT, SUM)
- CTEs and Subqueries

---

## Analysis Performed

Some of the key analysis tasks:

- Calculated average length of stay per department
- Identified peak admission days using date functions
- Found departments with high ER wait times
- Ranked departments by total treatment cost
- Calculated running totals of treatment costs
- Identified patients with repeat visits

---

## Challenges Faced
One challenge was working with multiple tables and ensuring correct joins.

Incorrect joins initially led to duplicated data and incorrect results, so I had to carefully validate relationships between tables.

---

## What I Learned
- How to work with relational datasets in SQL
- Importance of correct joins and data validation
- Applying SQL to real-world healthcare scenarios
- Breaking down business problems into queries

---

## Insights

- Some departments have significantly higher patient loads than others
- Certain departments show longer ER wait times, indicating possible bottlenecks
- Repeat patient visits suggest areas where follow-up care may need improvement
- Resource allocation varies across departments and can impact efficiency

---

## How to Use

1. Import all datasets into SQL Server
2. Run queries from the `/sql` folder
3. Analyze results for each business question
