# World-Layoffs-Data-Cleaning-Project-SQL-
This project involves a comprehensive data cleaning process using MySQL
# World Layoffs Data Cleaning Project (SQL)

## Project Overview
This project involves a comprehensive data cleaning process using MySQL. The goal was to take a raw dataset of global tech layoffs and transform it into a structured, reliable format for further analysis.

## Dataset
The raw data included information on company names, locations, industries, total employees laid off, percentage of layoffs, dates, funding stages, and countries.

## Key SQL Techniques Used
* **Creating Replica Tables:** To ensure data integrity by keeping the raw data untouched.
* **Removing Duplicates:** Utilized **CTEs** and the `ROW_NUMBER()` window function to identify and delete redundant records.
* **Standardizing Data:** * `TRIM()` functions to fix formatting issues in company names.
    * Standardized inconsistent naming conventions (e.g., consolidating various "Crypto" labels).
    * Fixed trailing punctuation in country names.
* **Date Conversion:** Converted string date formats into proper SQL `DATE` objects using `STR_TO_DATE` and `ALTER TABLE`.
* **Handling Null Values:** * Used **Self-Joins** to populate missing `industry` data based on existing records for the same company.
    * Removed rows where critical data (like `total_laid_off`) was missing and could not be recovered.
* **Schema Optimization:** Dropped unnecessary helper columns (like the row number index used for deduplication) once cleaning was complete.

## Cleaning Steps Summary
1.  **Staging:** Create a copy of the raw data (`layoff2`).
2.  **Deduplicate:** Identify records with identical values across all columns and delete them.
3.  **Standardize:** Fix typos, inconsistent naming, and whitespace.
4.  **Format:** Cast data types correctly (especially the `date` column).
5.  **Impute/Remove:** Fill in missing industry information where possible and delete unusable null rows.

## Tools Used
* **Database:** MySQL
* **SQL Concepts:** CTEs, Joins, Window Functions, DDL/DML Commands
