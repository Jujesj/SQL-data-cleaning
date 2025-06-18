USE jasdb3;
SELECT * FROM NashvilleHouse;
SELECT count(*) FROM NashvilleHouse;

-------------------------------------------------------------------------------------------------------------------------------
/* Check Duplicates */
SELECT *, count(*) As Number FROM NashvilleHouse group by ParcelID,
            LandUse,
            PropertyAddress,
            SaleDate,
            SalePrice,
            LegalReference,
            SoldAsVacant,
            OwnerName,
            OwnerAddress,
            Acreage,
            TaxDistrict,
            LandValue,
            BuildingValue,
            TotalValue,
            YearBuilt,
            Bedrooms,
            FullBath,
            HalfBath HAVING count(*)>1;
            
/* Check duplicates by partition method */
WITH duplicates 
       AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                ParcelID,
                LandUse,
                PropertyAddress,
                SaleDate,
                SalePrice,
                LegalReference,
                SoldAsVacant,
                OwnerName,
                OwnerAddress,
                Acreage,
                TaxDistrict,
                LandValue,
                BuildingValue,
                TotalValue,
                YearBuilt,
                Bedrooms,
                FullBath,
                HalfBath
            ORDER BY 
                UniqueID 
        ) AS rn
    FROM NashvilleHouse
)
SELECT *
FROM duplicates
WHERE rn > 1; -- these are the duplicate rows

/* Check Duplicates by having clause*/
SELECT * FROM NashvilleHouse
GROUP BY 
    ParcelID,
    LandUse,
    PropertyAddress,
    SaleDate,
    SalePrice,
    LegalReference,
    SoldAsVacant,
    OwnerName,
    OwnerAddress,
    Acreage,
    TaxDistrict,
    LandValue,
    BuildingValue,
    TotalValue,
    YearBuilt,
    Bedrooms,
    FullBath,
    HalfBath
HAVING COUNT(*) > 1;

------------------------------------------------------------------------------------------------------------------------------
SELECT count(*) FROM NashvilleHouse;
SELECT length(SoldAsVacant) FROM NashvilleHouse;
SELECT count(SoldAsVacant) FROM NashvilleHouse;

------------------------------------------------------------------------------------------------------------------------------
/* Remove duplicates:*/
 /* First Method */
 
 /* Compare each row to every other row with the same details. 
 If two rows are the same, delete the one with the bigger UniqueID, 
 keeping only the row with the smallest UniqueID. */
 
 DELETE h1
FROM NashvilleHouse h1
JOIN NashvilleHouse h2
  ON 
    h1.ParcelID = h2.ParcelID AND
    h1.LandUse = h2.LandUse AND
    h1.PropertyAddress = h2.PropertyAddress AND
    h1.SaleDate = h2.SaleDate AND
    h1.SalePrice = h2.SalePrice AND
    h1.LegalReference = h2.LegalReference AND
    h1.SoldAsVacant = h2.SoldAsVacant AND
    h1.OwnerName = h2.OwnerName AND
    h1.OwnerAddress = h2.OwnerAddress AND
    h1.Acreage = h2.Acreage AND
    h1.TaxDistrict = h2.TaxDistrict AND
    h1.LandValue = h2.LandValue AND
    h1.BuildingValue = h2.BuildingValue AND
    h1.TotalValue = h2.TotalValue AND
    h1.YearBuilt = h2.YearBuilt AND
    h1.Bedrooms = h2.Bedrooms AND
    h1.FullBath = h2.FullBath AND
    h1.HalfBath = h2.HalfBath
  AND h1.UniqueID > h2.UniqueID;
  
  /* Second method */
  /* Delete with a Subquery. The AS sub is necessary syntax for naming the derived table in a subquery.
Using SELECT * FROM ( ... ) AS sub avoids error in MySQL when the inner query references the same table 
as in the outer DELETE.*/

 DELETE FROM NashvilleHouse
WHERE UniqueID NOT IN (
    SELECT min_id FROM (
        SELECT MIN(UniqueID) AS min_id
        FROM NashvilleHouse
        GROUP BY
            ParcelID,
            LandUse,
            PropertyAddress,
            SaleDate,
            SalePrice,
            LegalReference,
            SoldAsVacant,
            OwnerName,
            OwnerAddress,
            Acreage,
            TaxDistrict,
            LandValue,
            BuildingValue,
            TotalValue,
            YearBuilt,
            Bedrooms,
            FullBath,
            HalfBath
    ) AS sub
)

------------------------------------------------------------------------------------------------------------------------------
SELECT count(*) FROM NashvilleHouse;
SELECT * FROM NashvilleHouse;
----------------------------------------------------- Done with duplicates ---------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------
/* Find Missing values */
-- Null values in a Property Address.
SELECT * 
FROM NashvilleHouse
WHERE PropertyAddress IS NULL
ORDER BY ParcelID;

-- count of a blank strings in a Property Address.
SELECT COUNT(*) FROM NashvilleHouse WHERE PropertyAddress = '';
-- count of total null values and empty string is 18.

-- Check for all null values of Property Address.
SELECT * 
FROM NashvilleHouse
WHERE PropertyAddress IS NULL OR PropertyAddress=''
ORDER BY ParcelID;

-- Check missing values in sale date column.
SELECT * 
FROM NashvilleHouse
WHERE SaleDate IS NULL OR SaleDate=''
ORDER BY SaleDate;

-- Check missing values of all column in a single command.
SELECT
  SUM(CASE WHEN PropertyAddress IS NULL OR TRIM(PropertyAddress) = '' THEN 1 ELSE 0 END) AS PropertyAddress_missing,
  SUM(CASE WHEN ParcelID IS NULL OR TRIM(ParcelID) = '' THEN 1 ELSE 0 END) AS ParcelID_missing,
  SUM(CASE WHEN LandUse IS NULL OR TRIM(LandUse) = '' THEN 1 ELSE 0 END) AS LandUse_missing,
  SUM(CASE WHEN SaleDate IS NULL OR TRIM(SaleDate) = '' THEN 1 ELSE 0 END) AS SaleDate_missing,
  SUM(CASE WHEN SalePrice IS NULL OR TRIM(SalePrice) = '' THEN 1 ELSE 0 END) AS SalePrice_missing,
  SUM(CASE WHEN LegalReference IS NULL OR TRIM(LegalReference) = '' THEN 1 ELSE 0 END) AS LegalReference_missing,
  SUM(CASE WHEN SoldAsVacant IS NULL OR TRIM(SoldAsVacant) = '' THEN 1 ELSE 0 END) AS SoldAsVacant_missing,
  SUM(CASE WHEN OwnerName IS NULL OR TRIM(OwnerName) = '' THEN 1 ELSE 0 END) AS OwnerName_missing,
  SUM(CASE WHEN OwnerAddress IS NULL OR TRIM(OwnerAddress) = '' THEN 1 ELSE 0 END) AS OwnerAddress_missing,
  SUM(CASE WHEN Acreage IS NULL OR TRIM(Acreage) = '' THEN 1 ELSE 0 END) AS Acreage_missing,
  SUM(CASE WHEN TaxDistrict IS NULL OR TRIM(TaxDistrict) = '' THEN 1 ELSE 0 END) AS TaxDistrict_missing,
  SUM(CASE WHEN LandValue IS NULL OR TRIM(LandValue) = '' THEN 1 ELSE 0 END) AS LandValue_missing,
  SUM(CASE WHEN BuildingValue IS NULL OR TRIM(BuildingValue) = '' THEN 1 ELSE 0 END) AS BuildingValue_missing,
  SUM(CASE WHEN TotalValue IS NULL OR TRIM(TotalValue) = '' THEN 1 ELSE 0 END) AS TotalValue_missing,
  SUM(CASE WHEN YearBuilt IS NULL OR TRIM(YearBuilt) = '' THEN 1 ELSE 0 END) AS YearBuilt_missing,
  SUM(CASE WHEN Bedrooms IS NULL OR TRIM(Bedrooms) = '' THEN 1 ELSE 0 END) AS Bedrooms_missing,
  SUM(CASE WHEN FullBath IS NULL OR TRIM(FullBath) = '' THEN 1 ELSE 0 END) AS FullBath_missing,
  SUM(CASE WHEN HalfBath IS NULL OR TRIM(HalfBath) = '' THEN 1 ELSE 0 END) AS HalfBath_missing
FROM NashvilleHouse;

------------------------------------------------------------------------------------------------------------------------------
/*Populate Property Address Data*/

-- Check for duplicate parcel ID
SELECT `ParcelID`, COUNT(*) 
FROM NashvilleHouse
GROUP BY `ParcelID`
HAVING COUNT(*) > 1;

-- Check duplicate ParcelID values in a table where one row has a NULL PropertyAddress and another has a non-NULL value.
SELECT DISTINCT `ParcelID`
FROM NashvilleHouse
WHERE `PropertyAddress` IS NOT NULL
  AND `ParcelID` IN (
    SELECT `ParcelID`
    FROM NashvilleHouse
    WHERE `PropertyAddress` IS NULL
  );
  
  -- check parcel ID either have a NULL Property Address or an empty string.
  SELECT `ParcelID`
FROM NashvilleHouse
GROUP BY `ParcelID`
HAVING 
    COUNT(*) > 1
    AND SUM(CASE WHEN `PropertyAddress` IS NULL OR 
    TRIM(`PropertyAddress`) = '' THEN 1 ELSE 0 END) > 0;


-- Save a copy of table for backup.
CREATE TABLE nashville_housing_backup 
AS SELECT * FROM nashvillehouse;

-- Test which address to fill a missing values, in a property address.
-- Test this first with a SELECT to see which rows will be affected:
SELECT a.*, b.address_to_fill
FROM NashvilleHouse a
JOIN (
    SELECT `ParcelID`, 
           MIN(`PropertyAddress`) AS address_to_fill
    FROM NashvilleHouse
    WHERE `PropertyAddress` IS NOT NULL AND TRIM(`PropertyAddress`) != ''
    GROUP BY `ParcelID`
) b ON a.`ParcelID` = b.`ParcelID`
WHERE a.`PropertyAddress` IS NULL OR TRIM(a.`PropertyAddress`) = '';


-- To test which address to fill in missing values of property address.
-- Doesn't work
SELECT a.*, b.`PropertyAddress` AS new_address
FROM NashvilleHouse a
JOIN NashvilleHouse b
  ON a.`ParcelID` = b.`ParcelID`
  where a.`PropertyAddress` IS NULL
  AND b.`PropertyAddress` IS NOT NULL;


-- Fill missing value
UPDATE NashvilleHouse a
JOIN (
    SELECT `ParcelID`, 
           MIN(`PropertyAddress`) AS address_to_fill
    FROM NashvilleHouse
    WHERE `PropertyAddress` IS NOT NULL AND TRIM(`PropertyAddress`) != ''
    GROUP BY `ParcelID`
) b ON a.`ParcelID` = b.`ParcelID`
SET a.`PropertyAddress` = b.address_to_fill
WHERE a.`PropertyAddress` IS NULL OR TRIM(a.`PropertyAddress`) = '';

SELECT count(PropertyAddress) FROM NashvilleHouse where PropertyAddress IS NULL OR PropertyAddress=''; -- Output=0
-- It means Address is updated

-------------------------------------------------------------------------------------------------------------------------------
/*Standardize Date Format*/

-- Sale Date
SELECT SaleDate, Str_to_date(SaleDate, '%M %d, %Y' ) FROM NashvilleHouse;
-- Save the copy of original data.
CREATE TABLE Nashvillehouse_backup AS SELECT * FROM NashvilleHouse;
Update NashvilleHouse set SaleDate=str_to_date(SaleDate, '%M %d, %Y');
SELECT count(DISTINCT(SoldAsVacant)) FROM NashvilleHouse;
SELECT TaxDistrict, SoldAsVacant, count(*) As TAXSold FROM NashvilleHouse group by TaxDistrict, SoldAsVacant;

-------------------------------------------------------------------------------------------------------------------------------
/*Breaking out Address into Individual Columns (Address, City, State)*/


select `PropertyAddress` from NashvilleHouse; 

select 
substring(`PropertyAddress` , 1, locate(',', `PropertyAddress`) - 1) as Address ,
substring(`PropertyAddress` , locate(',', `PropertyAddress`) + 1 , length(`PropertyAddress`)) as City
FROM NashvilleHouse; 

select
substring_index(PropertyAddress, ',', 1) as Address, 
substring_index(substring_index(PropertyAddress, ',',2 ),',',-1) as city, 
substring_index(PropertyAddress,',',-1) as Another_way_to_fetch
FROM NashvilleHouse;

/*SET
    Property_Address = TRIM(SUBSTRING_INDEX(`Property Address`, ',', 1)),
    Property_City = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(`Property Address`, ',', 2), ',', -1)),
    Property_State = TRIM(SUBSTRING_INDEX(`Property Address`, ',', -1));*/


ALTER TABLE NashvilleHouse 
ADD COLUMN `PropertyHouseNumber` varchar(225);
select * from NashvilleHouse;


-- Disable SAFE_UPDATES mode temporarily.
SET SQL_SAFE_UPDATES = 0;
update NashvilleHouse 
set `PropertyHouseNumber` = substring(`PropertyAddress` , 1, locate(',', `PropertyAddress`) - 1);
select * from NashvilleHouse;


alter table NashvilleHouse 
ADD Column `PropertyCity` varchar(255);
select * from NashvilleHouse;


update NashvilleHouse 
set `PropertyCity` = substring(`PropertyAddress` , locate(',', `PropertyAddress`) + 1 , length(`PropertyAddress`)) 
select * from NashvilleHouse;

------------------------------------------------------------------------------------------------------------------------------
/*CREATING A SPLIT STRING FUNCTION TO SPLIT THE OWNER ADDRESS*/

select `OwnerAddress` from NashvilleHouse; 

SHOW GRANTS FOR 'root'@'localhost';
-- CREATE ROUTINE and ALTER ROUTINE both were there.

-- if it doesn't there then run this command.
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;

SET GLOBAL sql_mode='';

SELECT @@sql_mode;

SHOW CREATE FUNCTION test_simple;
DROP FUNCTION IF EXISTS test_simple;

-- check test sample function works or not.
DELIMITER $

CREATE FUNCTION test_simple() RETURNS INT DETERMINISTIC
BEGIN
  RETURN 1;
END$

DELIMITER ; -- it works

-- check if split_str function already existed
SHOW FUNCTION STATUS LIKE 'split_str';
SHOW CREATE FUNCTION split_str;
DROP FUNCTION IF EXISTS SPLIT_STR;

-- Verify strict security modes
SHOW VARIABLES LIKE 'log_bin_trust_function_creators'; -- value is off so
SET GLOBAL log_bin_trust_function_creators = 1;

-- split_str function
DELIMITER $

CREATE FUNCTION SPLIT_STR(
  x VARCHAR(255),
  del VARCHAR(12),
  pos INT
)
RETURNS VARCHAR(255)
BEGIN
  RETURN TRIM(
    SUBSTRING(
      SUBSTRING_INDEX(x, del, pos),
      LENGTH(SUBSTRING_INDEX(x, del, pos - 1)) + 2
    )
  );
END$

DELIMITER ;


select * FROM NashvilleHouse;
select
SPLIT_STR(`OwnerAddress`, ',', 1),
SPLIT_STR(`OwnerAddress`, ',', 2),
SPLIT_STR(`OwnerAddress`, ',', 3)
from NashvilleHouse; 


alter table NashvilleHouse 
ADD COLUMN `OwnerHouseNo.` varchar(255);


-- Disable SAFE_UPDATES mode temporarily.
SET SQL_SAFE_UPDATES = 0;


update NashvilleHouse 
set `OwnerHouseNo.` = SPLIT_STR(`OwnerAddress`, ',', 1)
select * FROM NashvilleHouse;


alter table NashvilleHouse 
ADD COLUMN `OwnerCity` varchar(255);


update NashvilleHouse 
set `OwnerCity` = SPLIT_STR(`OwnerAddress`, ',', 2)
select * FROM NashvilleHouse;


alter table NashvilleHouse 
ADD COLUMN `OwnerState` varchar(255);


update NashvilleHouse 
set `OwnerState` = SPLIT_STR(`OwnerAddress`, ',', 3)

-------------------------------------------------------------------------------------------------------------------------------
/*Change Y and N to Yes and No in `Sold as Vacant`*/
SELECT DISTINCT SoldAsVacant, count(SoldasVacant)
FROM Nashvillehouse 
group by SoldAsVacant 
order by SoldAsVacant;


select `SoldAsVacant` ,
case  when `SoldAsVacant` = 'Y' then 'Yes' end as YUpdate,
case when `SoldAsVacant` = 'N' then 'No' end as NUpdate 
from Nashvillehouse; 


-- Take backup
CREATE TABLE NashvilleHouse_Secondbackup AS SELECT * FROM nashvillehouse;


-- Now Update
Update NashvilleHouse
set SoldAsVacant = 
case 
when SoldAsVacant ='N' Then 'No'
when SoldAsVacant='Y' Then 'Yes' 
ELSE SoldAsVacant -- optional
end;
select * FROM NashvilleHouse;


-- Now check
SELECT DISTINCT SoldAsVacant, count(SoldasVacant)
FROM Nashvillehouse 
group by SoldAsVacant 
order by SoldAsVacant; -- It's Working

-------------------------------------------------------------------------------------------------------------------------------
/* In the end, again check and remove duplicates */

/*Remove Duplicate*/
/* Check with SELECT clauss */
with RowNumCTE 
as 
(
select *, 
	row_number() OVER(
	partition by
				ParcelID,
            LandUse,
            PropertyAddress,
            SaleDate,
            SalePrice,
            LegalReference,
            SoldAsVacant,
            OwnerName,
            OwnerAddress,
            Acreage,
            TaxDistrict,
            LandValue,
            BuildingValue,
            TotalValue,
            YearBuilt,
            Bedrooms,
            FullBath,
            HalfBath
				order by 
					UniqueId
					) as row_num
from NashvilleHouse  	
)
select * from RowNumCTE where row_num>1;

/* Now apply DELETE */
with RowNumCTE 
as 
(
select *, 
	row_number() OVER(
	partition by
				ParcelID,
            LandUse,
            PropertyAddress,
            SaleDate,
            SalePrice,
            LegalReference,
            SoldAsVacant,
            OwnerName,
            OwnerAddress,
            Acreage,
            TaxDistrict,
            LandValue,
            BuildingValue,
            TotalValue,
            YearBuilt,
            Bedrooms,
            FullBath,
            HalfBath
				order by 
					UniqueId
					) as row_num
from NashvilleHouse  	
)
delete from RowNumCTE
where row_num > 1; -- doesn't work
/* Not working because, In MySQL, you cannot perform DELETE directly using a CTE as the target table.
Unlike some databases like SQL Server, MySQL doesn't support deleting from a CTE directly.*/


-- Try another method 
DELETE FROM NashvilleHouse 
WHERE UniqueId NOT IN (
                   Select min_id from
                           (SELECT MIN(UniqueId) as min_id FROM NashvilleHouse group by ParcelID,
            LandUse,
            PropertyAddress,
            SaleDate,
            SalePrice,
            LegalReference,
            SoldAsVacant,
            OwnerName,
            OwnerAddress,
            Acreage,
            TaxDistrict,
            LandValue,
            BuildingValue,
            TotalValue,
            YearBuilt,
            Bedrooms,
            FullBath,
            HalfBath
	                   ) as sub
		) -- It works


-- check once
select * from nashvillehouse group by ParcelID,
            LandUse,
            PropertyAddress,
            SaleDate,
            SalePrice,
            LegalReference,
            SoldAsVacant,
            OwnerName,
            OwnerAddress,
            Acreage,
            TaxDistrict,
            LandValue,
            BuildingValue,
            TotalValue,
            YearBuilt,
            Bedrooms,
            FullBath,
            HalfBath
            having count(*)>1; -- no duplicate values found

select count(*) from NashvilleHouse;
select * from NashvilleHouse;

------------------------------------------------------------------------------------------------------------------------------
/*Delete Unused Column*/

ALTER TABLE NashvilleHouse DROP COLUMN `OwnerAddress`;
ALTER TABLE NashvilleHouse DROP COLUMN `TaxDistrict`;
ALTER TABLE NashvilleHouse DROP COLUMN `PropertyAddress`;

SELECT * FROM NashvilleHouse;
