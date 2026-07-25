# Week 2 - Task 3: Network Analysis Automation

**AtliQ Technologies | Data Analyst Virtual Internship**
**Intern:** Vishnu Ram Sachin D
**Date:** 25.07.2026

---

## Overview

A telecom client was manually preparing a weekly network status report by combining two separate data exports. This task automates that process using Power Query in Power BI, so the report refreshes in seconds instead of being rebuilt by hand every week.

## Objective

Combine two raw data sources, `network_data.csv` and `activity_data.csv`, into a single summary table showing the count of each network/activity status per city.

## Tools Used

- Power BI Desktop
- Power Query Editor (M language)

## Data Sources

| File | Columns |
|---|---|
| `network_data.csv` | city, network_id, network_status |
| `activity_data.csv` | city, network_id, activity_status |

Both files cover the same 10 cities but track different status categories, so they needed to be standardized before combining.

## Step-by-Step Process

**Step 1: Connect the data**
Home tab > Get Data > Text/CSV. Loaded `network_data.csv` and `activity_data.csv` as two separate queries.

**Step 2: Open the query editor**
Home tab > Transform Data, to enter the Power Query Editor for cleaning and shaping.

**Step 3: Reference the queries**
Right-clicked each source query and selected Reference. This creates working copies (`network_data_clean`, `activity_data_clean`) while keeping the original raw queries untouched.

**Step 4: Promote headers**
Home > Use First Row as Headers, on both referenced queries, so the first data row becomes proper column names instead of Column1/Column2/Column3.

**Step 5: Standardize the status column**
Renamed `network_status` to `status` in one query and `activity_status` to `status` in the other. This gives both tables identical column structures: city, network_id, status.

**Step 6: Append the queries**
Home > Append Queries, combining both tables into a single long list of every status entry across both sources.

**Step 7: Remove unnecessary column**
Deleted `network_id`, since it isn't needed for the status counts.

**Step 8: Trim text**
Applied Trim to the city and status columns to remove stray leading or trailing spaces. This step matters because hidden spaces make Power Query treat identical-looking values as different categories, which would otherwise create duplicate columns later at the pivot step.

**Step 9: Group by city and status**
Home > Group By, grouping on city and status, with aggregation set to Count Rows. This produces one row per city-status combination with a count.

**Step 10: Pivot the status column**
Transform > Pivot Column, using status as the column to pivot and Count as the values column. Each unique status becomes its own column, and each city becomes a single row.

**Step 11: Replace nulls with 0**
Home > Replace Values, changing null to 0 across all status columns. Cities with zero occurrences of a status showed blank cells after pivoting, so this fills them in properly.

**Step 12: Fix data types**
Changed all status columns (except city) to Whole Number, so counts display as clean integers instead of decimals.

**Step 13: Reorder columns**
Rearranged the columns to match the required report layout.

**Step 14: Visualize as a table**
Loaded the final query into the report view as a table visual, titled Network Analysis.

## Applied Steps (Power Query)

1. Source
2. Used First Row as Headers
3. Changed Type
4. Renamed Column: network_status/activity_status to status
5. Appended Query: network_data_clean + activity_data_clean
6. Removed Column: network_id
7. Trimmed Text: city and status columns
8. Grouped Rows: by city and status
9. Pivoted Column: status, values from Count
10. Replaced Value: null to 0
11. Changed Type: all columns except city to Whole Number
12. Reordered Columns

## Final Output

| city | Connected | Issue Reported | Maintenance Work | Network Auditing | Network Expansion | New Installation | Outage | Pending Activation | Shifting | Suspended |
|---|---|---|---|---|---|---|---|---|---|---|
| Ahmedabad | 4 | 5 | 6 | 4 | 4 | 6 | 7 | 5 | 11 | 3 |
| Bangalore | 5 | 4 | 4 | 5 | 5 | 6 | 4 | 0 | 5 | 3 |
| Chennai | 7 | 3 | 5 | 3 | 8 | 2 | 8 | 3 | 6 | 5 |
| Delhi | 4 | 5 | 5 | 3 | 3 | 6 | 5 | 5 | 4 | 1 |
| Hyderabad | 6 | 6 | 4 | 8 | 6 | 6 | 3 | 4 | 6 | 3 |
| Jaipur | 3 | 6 | 6 | 3 | 5 | 6 | 3 | 9 | 3 | 2 |
| Kolkata | 5 | 4 | 5 | 5 | 8 | 7 | 3 | 3 | 6 | 5 |
| Lucknow | 6 | 2 | 2 | 7 | 5 | 3 | 5 | 8 | 5 | 8 |
| Mumbai | 4 | 8 | 4 | 13 | 10 | 3 | 3 | 6 | 3 | 3 |
| Pune | 7 | 5 | 6 | 7 | 4 | 8 | 6 | 8 | 4 | 4 |

## Key Learning

The Trim step was the most important fix in this pipeline. Inconsistent spacing in the source status values caused Power Query to treat the same status as multiple distinct categories, which showed up as duplicate columns after pivoting. Trimming the text before grouping resolved it and kept the final table clean.

## Files in This Folder

- `README.md` - this documentation
- `network_data.csv` - raw network status data
- `activity_data.csv` - raw activity status data
- Power BI file with the full query pipeline

---

*On Meaning · Creativity Clicks - Growing 1% every day.*
