-- Cleaning data in sql queries
use [Covid Project]

Select * 
from [dbo].[NationalHousing]

-- standardize date format

select SaleDateConverted , CONVERT (date,SaleDate)

from [dbo].[NationalHousing]

update [dbo].[NationalHousing]
set SaleDate = CONVERT (date,SaleDate)

Alter table [dbo].[NationalHousing]
Add SaleDateConverted Date;

update [dbo].[NationalHousing]
set SaleDateConverted =  Convert (date,SaleDate);

-- Property Address Data
Select *
from [dbo].[NationalHousing]
where PropertyAddress is NULL

Select a.PropertyAddress , b.ParcelID, b.PropertyAddress, a.ParcelID , ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].[NationalHousing] a
join [dbo].[NationalHousing] b
on a.ParcelID = b.ParcelID AND 
a.[UniqueID ] <> b.[UniqueID ]
where a.PropertyAddress is null


update a 
set PropertyAddress =  ISNULL(a.PropertyAddress, b.PropertyAddress)
from [dbo].[NationalHousing] a
join [dbo].[NationalHousing] b
on a.ParcelID = b.ParcelID AND 
a.[UniqueID ] <> b.[UniqueID ]

-- Address, City, States

select PropertyAddress
from [dbo].[NationalHousing]

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [dbo].[NationalHousing]

ALTER TABLE [dbo].[NationalHousing]
Add PropertySplitAddress Nvarchar(255);

Update [dbo].[NationalHousing]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )

ALTER TABLE [dbo].[NationalHousing]
Add PropertySplitCity Nvarchar(255)

Update [dbo].[NationalHousing]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))

Select *
From [dbo].[NationalHousing]

Select OwnerAddress
From [dbo].[NationalHousing]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [dbo].[NationalHousing]



ALTER TABLE [dbo].[NationalHousing]
Add OwnerSplitAddress Nvarchar(255);

Update [dbo].[NationalHousing]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update [dbo].[NationalHousing]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE [dbo].[NationalHousing]
Add OwnerSplitState Nvarchar(255);

Update [dbo].[NationalHousing]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)

select * 
from [dbo].[NationalHousing]

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [dbo].[NationalHousing]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [dbo].[NationalHousing]

Update [dbo].[NationalHousing]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

	   -- Remove Duplicates
WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [dbo].[NationalHousing]
--order by ParcelID
)
select * 
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

select * from 
[dbo].[NationalHousing]

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

select * from 
[dbo].[NationalHousing]

ALTER TABLE [dbo].[NationalHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate









