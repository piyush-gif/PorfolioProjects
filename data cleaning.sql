-- cleaning data in sql queries


select *
from PorfolioProject..Nashvillehousing


-- standarize data format

select saledateconverted--, convert(date,saledate)
from PorfolioProject..Nashvillehousing

alter table nashvillehousing
add saledateconverted date

update Nashvillehousing
set saledateconverted = convert(date, saledate)

-- populate property address data

select *
from PorfolioProject..Nashvillehousing
--where PropertyAddress is null
order by parcelid


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, isnull(a.propertyaddress, b.PropertyAddress)
from PorfolioProject..Nashvillehousing a
 join PorfolioProject..Nashvillehousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null

 update a
 set propertyaddress = isnull(a.propertyaddress, b.PropertyAddress)
 from PorfolioProject..Nashvillehousing a
 join PorfolioProject..Nashvillehousing b
 on a.ParcelID = b.ParcelID
 and a.[UniqueID ] <> b.[UniqueID ]
 where a.PropertyAddress is null



---breaking out address into individual columns (address, city, state)

select *
from PorfolioProject..Nashvillehousing
--where PropertyAddress is null
--order by parcelid

select  substring ( propertyaddress, 1, CHARINDEX (',',PropertyAddress) -1) as address,
substring ( propertyaddress, CHARINDEX (',',PropertyAddress) +1,len(propertyaddress)) as address
from PorfolioProject..Nashvillehousing

alter table nashvillehousing
add propertysplitaddress nvarchar(255);

update nashvillehousing
set propertysplitaddress = substring ( propertyaddress, 1, CHARINDEX (',',PropertyAddress))

alter table nashvillehousing
add propertysplitcity nvarchar(255);

update Nashvillehousing
set propertysplitcity = substring ( propertyaddress, CHARINDEX (',',PropertyAddress) +1,len(propertyaddress))

select * 
from Nashvillehousing

select OwnerAddress
from Nashvillehousing

select 
parsename (replace (owneraddress,',','.'),3) ,
parsename (replace (owneraddress,',','.'),2),
parsename (replace (owneraddress,',','.'),1)
from Nashvillehousing


alter table nashvillehousing
add ownersplitaddress nvarchar(255);

update nashvillehousing
set ownersplitaddress = parsename (replace (owneraddress,',','.'),3)

alter table nashvillehousing
add ownersplitcity nvarchar(255);

update Nashvillehousing
set ownersplitcity = parsename (replace (owneraddress,',','.'),2)

alter table nashvillehousing
add ownersplitstate nvarchar(255);

update nashvillehousing
set onwersplitstate = parsename (replace (owneraddress,',','.'),1)

select * 
from Nashvillehousing

--- 

-- change y and n to yes and no in " solid as vacant " field

select distinct(soldasvacant), count(soldasvacant)
from Nashvillehousing
group by SoldAsVacant
order by 2


select SoldAsVacant,
case
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
end
from Nashvillehousing

update Nashvillehousing
set  SoldAsVacant = case
	when soldasvacant = 'Y' then 'Yes'
	when soldasvacant = 'N' then 'No'
	else soldasvacant
end


-- remove duplicates
with rownumcte  as (
select  *,
	row_number() over (
	partition by parcelid,
				propertyaddress,
				saleprice,
				saledate,
				legalreference
				order by 
				uniqueid) row_num
from PorfolioProject.dbo.Nashvillehousing
--order by parcelid

)
select *
--delete
from rownumcte
where row_num >1


-- delete unused columns

select  *
from PorfolioProject.dbo.Nashvillehousing

alter table PorfolioProject.dbo.Nashvillehousing
drop column owneraddress, taxdistrict, propertyaddress


alter table PorfolioProject.dbo.Nashvillehousing
drop column saledate