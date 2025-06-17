# Nashville Housing Data Cleaning – SQL Project
This project demonstrates thorough data cleaning and preparation using MySQL on the Nashville housing dataset.

# Objectives

1) Identify and remove duplicate records
2) Standardize missing or inconsistent data
3) Format date and address fields for usability
4) Extract and structure address components into separate columns
5) Normalize categorical values
6) Optimize the dataset for analysis or reporting

# Key Tasks Performed

## Remove Duplicates

1) Used multiple methods (GROUP BY, ROW_NUMBER(), and DELETE with JOIN and subqueries)

2) Ensured one unique entry per property

## Handle Missing Values

1) Identified missing or empty values across key columns

2) Filled missing PropertyAddress values using associated ParcelID data

## Standardize Date Format

1) Converted inconsistent SaleDate entries (e.g., "July 16, 2014") into YYYY-MM-DD format using STR_TO_DATE()

## Split and Clean Address Columns

1) Split PropertyAddress into PropertyHouseNumber and PropertyCity

2) Created and used a custom MySQL function SPLIT_STR() to split OwnerAddress into OwnerHouseNo., OwnerCity, and OwnerState

## Normalize Categorical Values

1) Replaced 'Y' and 'N' with 'Yes' and 'No' in the SoldAsVacant column

## Final Cleanup

1) Rechecked and removed any residual duplicates

2) Dropped unused columns: OwnerAddress, TaxDistrict, PropertyAddress, and SaleDate

# Technologies Used
1) MySQL 8.0+

2) SQL (CTE, Window Functions, Subqueries, Joins, Aggregations)

3) Git for version control


