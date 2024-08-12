--SQL Advance Case Study

create database db_SQLCaseStudies

select * from [dbo].[DIM_CUSTOMER]
select * from [dbo].[DIM_DATE]
select * from [dbo].[DIM_LOCATION]
select * from [dbo].[DIM_MANUFACTURER]
select * from [dbo].[DIM_MODEL]
select * from [dbo].[FACT_TRANSACTIONS]

--Q1--BEGIN 
    select 	[IDCustomer],[State],[YEAR] from [dbo].[FACT_TRANSACTIONS] t
    right join [dbo].[DIM_DATE] d on d.DATE=t.Date
    right join [dbo].[DIM_LOCATION] l on l.IDLocation=t.IDLocation
    where [YEAR] >=2005
    order by [YEAR]
--Q1--END

--Q2--BEGIN
	select top 1 [State],[Manufacturer_Name],sum([Quantity]) as Quantity from [dbo].[FACT_TRANSACTIONS] t
	join [dbo].[DIM_LOCATION] l on l.IDLocation=t.IDLocation
	right join [dbo].[DIM_MODEL] m on m.IDModel=t.IDModel
	right join [dbo].[DIM_MANUFACTURER] m1 on m1.IDManufacturer=m.IDManufacturer
	where [Manufacturer_Name] = 'Samsung' and Country = 'US'
	group by [State],[Manufacturer_Name]
	order by [Quantity] desc
--Q2--END

--Q3--BEGIN      
	select count(concat(m.IDModel,IDCustomer)) as number_of_transaction,m.IDModel,[State] ,[ZipCode] from [dbo].[FACT_TRANSACTIONS] t
	inner join [dbo].[DIM_LOCATION] l on l.IDLocation=t.IDLocation
	inner join [dbo].[DIM_MODEL] m on m.IDModel=t.IDModel
	group by m.IDModel,l.[State],l.[ZipCode]

--Q3--END

--Q4--BEGIN
    select top 1 [Model_Name],[Unit_price] from [dbo].[DIM_MODEL]
	order by [Unit_price]
--Q4--END

--Q5--BEGIN
   select top 5 Manufacturer_Name,sum([Quantity]) as sales_quantity,m.Model_Name,avg ([Unit_price]) as unit_price from [dbo].[FACT_TRANSACTIONS] t
	 join [dbo].[DIM_MODEL]m on m.IDModel = t.IDModel
	 join [dbo].[DIM_MANUFACTURER] mf on mf.IDManufacturer = m.IDManufacturer
	 group by mf.Manufacturer_Name,m.Model_Name
	 order by avg([Unit_price]) desc
	 
--Q5--END

--Q6--BEGIN
     select [Customer_Name],[YEAR],avg([TotalPrice]) as avg_amount  from [dbo].[FACT_TRANSACTIONS] t
	 inner join [dbo].[DIM_CUSTOMER] c on c.[IDCustomer]=t.[IDCustomer]
	 join [dbo].[DIM_DATE] d on d.DATE=t.Date
	 where year = 2009  
	 group by c.[Customer_Name],d.YEAR
	 having avg([TotalPrice]) > 500
--Q6--END
	
--Q7--BEGIN  
	select [IDModel] from (select [IDModel],year(date) as order_year,rank()
	over(partition by year(date) order by sum([Quantity]) desc) as quantity_rank
	from [dbo].[FACT_TRANSACTIONS] 
	where year(date) in ('2008','2009','2010')
	group by [IDModel],year(date)) temp
	where quantity_rank<=5
	group by [IDModel]
	having count(distinct order_year)=3;

--Q7--END	

--Q8--BEGIN
    with rank as (select [Manufacturer_Name],[YEAR],sum([Quantity]) as Total_Qty,
	row_number() over (partition by [YEAR] order by sum([Quantity]) desc) as rank
	from [dbo].[DIM_MANUFACTURER] dm
	inner join [dbo].[DIM_MODEL] m on m.IDManufacturer=dm.IDManufacturer
	join [dbo].[FACT_TRANSACTIONS] t  on t.IDModel=m.IDModel
	join [dbo].[DIM_DATE] d on d.DATE=t.Date
	where [YEAR] in ('2009','2010')
	group by [Manufacturer_Name],[YEAR])
	select [Manufacturer_Name],[YEAR], Total_Qty
	from rank
	where rank =2
--Q8--END
--Q9--BEGIN
	 select distinct [Manufacturer_Name] from  [dbo].[FACT_TRANSACTIONS] t
	 inner join [dbo].[DIM_MODEL] m1 on m1.IDModel=t.IDModel
	 right join [dbo].[DIM_MANUFACTURER] m2 on m2.IDManufacturer=m1.IDManufacturer
	 where   year(date) = 2010 and   [Manufacturer_Name] not in (select distinct [Manufacturer_Name] from  [dbo].[FACT_TRANSACTIONS] t
	 inner join [dbo].[DIM_MODEL] m1 on m1.IDModel=t.IDModel
	 right join [dbo].[DIM_MANUFACTURER] m2 on m2.IDManufacturer=m1.IDManufacturer
	 where   year(date) = 2009)
--Q9--END

--Q10--BEGIN
	 select top 10 [IDCustomer],year(date) as years ,avg([TotalPrice]) as avg_spend,avg([Quantity]) as avg_quantity,
	 (avg([TotalPrice])-lag(avg([TotalPrice])) over(partition by [IDCustomer] order by year(date)))/ nullif(lag(avg([TotalPrice]))
	 over (partition by  [IDCustomer] order by year(date)),0)*100 as per_spend
	 from [dbo].[FACT_TRANSACTIONS] t
	 where [IDCustomer] in
	 (select [IDCustomer] from (select top 10 [IDCustomer],sum([TotalPrice]) as total_spend
	 from [dbo].[FACT_TRANSACTIONS] 
	 group by [IDCustomer]
	 order by sum([TotalPrice]) desc)a)
	 group by [IDCustomer],year(date)
--Q10--END
