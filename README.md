# AtliQ-Virtual-Internship-Week-2-2026

Welcome to my AtliQ Technologies Virtual Internship project. This repository features a variance analysis solution built for AtliQ Technologies' order and delivery quantity data, comparing recorded values against benchmark values using DAX measures in Power BI. The project also covers a custom month dimension table built to bridge two unrelated fact tables for reliable reporting.

---

## Table of Contents
- [Introduction](#introduction)
- [Project Description](#project-description)
- [Folder Structure](#Folder-Structure)
- [Key Features](#Key-Features)
- [Installation](#installation)
- [Usage](#usage)
- [License](#license)

## Introduction
---
*Project Title:* AtliQ Technologies Virtual Internship, Week 2  
*Created By:* [Sachin-Analyst](https://github.com/Sachin-Analyst)  
*Tools Used:* Power BI, DAX  
*Focus Areas:* Variance Analysis, Benchmark Comparison, DAX Measures, Dimension Table Modeling

---

## Project Description
This repository contains the Week 2 body of work from my Data Analyst Virtual Internship at AtliQ Technologies.

*Task 1* covers comparing recorded order and delivery quantities against benchmark values using DAX measures built in Power BI calculating absolute difference and percentage variance from benchmark for both metrics. It also covers building a custom `Dim_Month` table to bridge the fact and benchmark tables on a common month key, since they weren't linked on any shared dimension, and solving a circular dependency error encountered while sorting that table chronologically.

*Task 2* covers diagnosing and fixing 9 broken SQL queries against the gdb080 database, identifying the exact syntax bug behind each failure and rewriting the query to run correctly. It also covers documenting the recurring patterns behind those bugs, since most of the 9 failures traced back to a handful of repeatable mistakes (missing keywords, misplaced brackets, mismatched quotes, wrong clause order), and mapping each pattern back to the queries it showed up in.

*Task 3* covers automating a client's manual weekly network status report using Power Query in Power BI, combining two separate data sources, network data and activity data, into a single pivoted summary showing status counts by city. It also covers standardizing mismatched column names between the two sources before merging them, since they tracked different status categories under different headers, and fixing a duplicate-column bug caused by inconsistent spacing in the status values, which required a text trim step before the group and pivot stages to produce a clean, accurate table.

*Task 4* covers measuring the impact of Wavecon Telecom's 5G launch across revenue, ARPU, active users, and low-usage users, using DAX measures built in Power BI to compare a four-month before period against a four-month after period across 15 cities and 13 recharge plans. It also covers handling the three plans retired exactly at launch and the three new plans introduced right after, since a standard before/after percentage change calculation would have thrown errors or misleading results against a missing period, and building conditional DAX logic to flag those plans as newly launched or retired instead of treating them as revenue swings.

---

## Folder Structure
- *Task-1-Report* - Order & Delivery Quantity Variance Analysis: full DAX measures used, Dim_Month table build, business questions answered, and key learnings
- *Task-2* - SQL-Debugging - SQL Query Debugging: 9 broken queries diagnosed and fixed, root cause for each bug, recurring syntax pattern summary, and key learnings
- *Task-3* - Power-Query-Automation - Network Analysis Automation: two raw data sources standardized and merged via Power Query, city-wise status pivot table built, null handling and data type fixes applied, column reordering to match report layout, and key learnings
- *Task-4* - Wavecon Telecom 5G Impact Analysis -  before/after DAX measures across revenue, ARPU, active users, and low-usage users, city and plan-level breakdowns across 15 cities and 13 plans, conditional handling for plans retired or newly launched at the 5G cutoff, and key learnings

## Key Features
- *Variance Analysis* - benchmark vs. recorded quantity comparison for orders and deliveries
- *DAX-Driven Business Answers* - real business questions answered using validated DAX measures
- *Dimension Table Modeling* - custom Dim_Month table built using DISTINCT(UNION(...)) to bridge two fact tables without a shared date key
- *Sort Order Handling* - resolved a circular dependency error by generating the sort-helper column inside the same table expression as the sorted column, using ADDCOLUMNS

## Installation
To explore or modify this project:
1. *Clone the repository:*
```bash
   git clone https://github.com/Sachin-Analyst/AtliQ-Virtual-Internship-Week-2-2026.git
```
   - Open terminal and run the command
2. *Download and Open Power BI Desktop*
   - Task 1 was built using Power BI Desktop with DAX
3. *Explore Resources*
   - Open the Task-1-Report folder to review the full breakdown of DAX measures and business logic used

---

## Usage
### What You Can Explore
- DAX measures for benchmark comparison, absolute difference, and percentage variance
- The reasoning behind counting customer-month instances vs. unique customer_ids when answering a "how many customers" question
- Real results for each business question answered
- The Dim_Month table build and how a circular dependency sort error was resolved

----
### Explore the `Task-1-report` `Task-2-report` `Task-3-report`folder for the full breakdown and business logic behind each requirement.
----

# Note !
The raw datasets used in this project are internal to the AtliQ Technologies internship program and are not included in this repository. All logic and results shown are based on those datasets.

----

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.
