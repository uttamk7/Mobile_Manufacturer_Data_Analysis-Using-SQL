
# Mobile Manufacturer Data Analysis

## Overview

This repository contains an SQL script designed for an advanced case study focused on analyzing data related to mobile manufacturers. The script performs various operations, including database creation, data selection from multiple tables, and analytical queries to derive insights.

## Database Structure

The SQL script works with a database named `db_SQLCaseStudies` and contains the following key tables:

- **DIM_CUSTOMER**: Contains information about customers.
- **DIM_DATE**: Stores date-related information, including years.
- **DIM_LOCATION**: Contains location-related data.
- **DIM_MANUFACTURER**: Details about mobile manufacturers.
- **DIM_MODEL**: Information about different mobile models.
- **FACT_TRANSACTIONS**: Stores transaction details, including customer ID, location ID, and date.

## Queries and Analysis

### 1. Data Selection
The script initially selects data from the following tables:
- `DIM_CUSTOMER`
- `DIM_DATE`
- `DIM_LOCATION`
- `DIM_MANUFACTURER`
- `DIM_MODEL`
- `FACT_TRANSACTIONS`

### 2. Analytical Queries
The script includes analytical queries, such as:
- **Query 1**: Join operations between `FACT_TRANSACTIONS`, `DIM_DATE`, and `DIM_LOCATION` to retrieve customer IDs, state, and year for transactions occurring in or after 2000.
- Additional queries can be added as per the analysis needs.

## How to Use

1. **Create the Database**: Execute the SQL script to create the database `db_SQLCaseStudies`.
2. **Run Queries**: Execute the provided queries to perform analysis on the mobile manufacturer data.
3. **Modify/Add Queries**: Customize or add new queries to perform further analysis.

## Requirements

- SQL Server or any compatible database system.

