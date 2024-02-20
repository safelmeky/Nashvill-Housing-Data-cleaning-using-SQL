
/*

Cleaning Data Related to Housing in Nashvill city in the USA, Data source is : Alex The Analyst github.

*/
--Standered inspection:-

select * from NashvillHousing

--------------------------------------------------------------------------------------------------------------

--Standarizing Dates:-

--(Column 5)
--Having a look on the data types  we see that Sales date column is date time ---> Date

Alter table NashvillHousing alter column SaleDate Date

--Populate Address using parcellID:-

	select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress,
	ISNULL(a.PropertyAddress,b.PropertyAddress)
	from NashvillHousing a
	join NashvillHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID] <> b.UniqueID -- means <> not equall
	WHERE  a.PropertyAddress is NULL


	update a
	set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
	from NashvillHousing a
	join NashvillHousing b
	on a.ParcelID=b.ParcelID
	and a.[UniqueID] <> b.UniqueID -- means <> not equall
	WHERE  a.PropertyAddress is NULL



------------------------------------------------------------------------------------------------------------------------
--Breaking Down the adress column into (Adress ,City, State):

select PropertyAddress from NashvillHousing
 
 select 
 SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address
 ,SUBSTRING(PropertyAddress,(CHARINDEX(',',PropertyAddress)+1),LEN(PropertyAddress)) as City
 from NashvillHousing

 -- making 2 new columns (PAdress,city) then filling them  with data using  update 

 Alter table NashvillHousing 
  add PAddress Nvarchar(255)

 update NashvillHousing
 set  PAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

Alter table NashvillHousing 
  add City Nvarchar(255)

 update NashvillHousing
 set City= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)



 -----------------------------------------------------------------------------------------------
 Select OwnerAddress
From NashvillHousing


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From NashvillHousing



ALTER TABLE NashvillHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvillHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


ALTER TABLE NashvillHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvillHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



ALTER TABLE NashvillHousing
Add OwnerSplitState Nvarchar(255);

Update NashvillHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From NashvillHousing

----------------------------------------------------------------------------------------------------------
--Unifing the sold as vacant values to yes or no

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From NashvillHousing
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From NashvillHousing

Update NashvillHousing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
----------------------------------------------------------------------------------------------------------
--Remove Dublicates 

-- ASSIGN A number to each row with unique value and if the row dublicates the number increse by 1. based on cerin columns


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

	From NashvillHousing
	--order by ParcelID
	)

--delete  
--from RownumCTE
--where row_num>1

select * from RownumCTE
where row_num>1
---------------------------------------------------------------------------------------------------------------------------------------


--Done