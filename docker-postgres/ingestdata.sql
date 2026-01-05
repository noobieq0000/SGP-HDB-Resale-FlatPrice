create table hdb_resale_prices(
	month text,
	town text,
	flat_type text,
	block text,
	street_name text,
	storey_range text,
	floor_area_sqm numeric,
	flat_model text,
	lease_commence_date int,
	remaining_lease text,
	resale_price numeric
); 

select * from hdb_resale_prices;

-- ingesting data from 1990_1999 csv
copy public.hdb_resale_prices
(
	month, town, flat_type, block, street_name,
	storey_range, floor_area_sqm, flat_model,
	lease_commence_date, resale_price
)
from 
	'/data/resale_1990_1999.csv'
with 
	(format csv, header true);

-- ingesting data from 2000-2012 csv
copy public.hdb_resale_prices
(
	month, town, flat_type, block, street_name,
	storey_range, floor_area_sqm, flat_model,
	lease_commence_date, resale_price
)
from 
	'/data/resale_2000_2012.csv'
with
	(format csv, header true);
	
-- copying data from 2012-2014 csv
copy public.hdb_resale_prices 
(
	month, town, flat_type, block, street_name,
	storey_range, floor_area_sqm, flat_model,
	lease_commence_date, resale_price
)
from
	'/data/resale_2012_2014.csv'
with
	(format csv, header true);

-- copying data from 2015-2016 csv
copy public.hdb_resale_prices 
(
	month, town, flat_type, block, street_name,
	storey_range, floor_area_sqm, flat_model,
	lease_commence_date, remaining_lease, resale_price
)
from
	'/data/resale_2015_2016.csv'
with
	(format csv, header true);

-- copying data from 2017-onwards csv
copy public.hdb_resale_prices 
(
	month, town, flat_type, block, street_name,
	storey_range, floor_area_sqm, flat_model,
	lease_commence_date, remaining_lease, resale_price
)
from
	'/data/resale_2017_onwards.csv'
with
	(format csv, header true);

-- rows ingested
select
	count(*) 
from
	public.hdb_resale_prices;

-- date range 
select
	min(month) as min_month, 
	max(month) as max_month 
from
	public.hdb_resale_prices;

-- total rows and date range 
select 
	count(*) as total_rows,
	min(month) as min_month,
	max(month) as max_month
from
	public.hdb_resale_prices;

-- checking rows per era 
select 
	case 
		when month < '2001-001' then '1990-1999'
		when month < '2012-03' then '2000-Feb 2012'
		when month < '2015-01' then 'Mar2012-Dec2014'
		when month < '2017-01' then 'Jan2015-Dec2016'
		else 'Jan2017-onwards'
	end as period,
	count(*) as rows
from
	public.hdb_resale_prices
group by 1
order by 1;

-- detect duplication
select
	month,
	town,
	flat_type,
	block,
	street_name,
	storey_range,
	floor_area_sqm,
	flat_model,
	lease_commence_date,
	remaining_lease,
	resale_price,
	count(*) as duplicate_count
from
	public.hdb_resale_prices
group by
	month,
	town,
	flat_type,
	block,
	street_name,
	storey_range,
	floor_area_sqm,
	flat_model,
	lease_commence_date,
	remaining_lease,
	resale_price
having 
	count(*) > 1
order by
	duplicate_count DESC
limit 50;

-- duplication measures 
with duplicate AS (
	select
		count(*) as duplicate_count
	from
		public.hdb_resale_prices
	group by 
		month,
		town,
		flat_type,
		block,
		street_name,
		storey_range,
		floor_area_sqm,
		flat_model,
		lease_commence_date,
		remaining_lease,
		resale_price
	having
		count(*) > 1
)
select 
	count(*) as duplicate_groups,
	sum(duplicate_count) as rows_in_duplicate_groups,
	sum(duplicate_count - 1) as extra_rows_to_remove
from
	duplicate;

-- adding id to table
alter table public.hdb_resale_prices
add column hdb_id BIGINT generated always as identity;

alter table public.hdb_resale_prices
add constraint hdb_resale_prices_pkey primary key (hdb_id);

-- check on hdb_id with auto increments
select 
	hdb_id,
	month,
	town,
	resale_price 
from 
	public.hdb_resale_prices
order by
	hdb_id
limit 10;

select 
	max(hdb_id) as max_id,
	count(*) as total_rows
from
	public.hdb_resale_prices;

-- removing duplication 
with ranked as(
	select
	hdb_id,
	row_number() over (
		partition by
		month, town, flat_type, block, street_name,
		storey_range, floor_area_sqm, lease_commence_date,
		remaining_lease, resale_price
	) as row_number
	from public.hdb_resale_prices
)
delete from 
	public.hdb_resale_prices 
where 
	hdb_id in (
	select 
		hdb_id
	from 
		ranked
	where
		row_number > 1
	);

-- to check any existing count of duplicate group 
-- after removing duplication process 
select
	count(*) as duplicate_groups 
from (
	select
		month,
		town,
		flat_type,
		block,
		street_name,
		storey_range,
		floor_area_sqm,
		flat_model,
		lease_commence_date,
		remaining_lease,
		resale_price
	from
	 public.hdb_resale_prices
	group by
		month,
		town,
		flat_type,
		block,
		street_name,
		storey_range,
		floor_area_sqm,
		flat_model,
		lease_commence_date,
		remaining_lease,
		resale_price
	having
		count(*) > 1
);

-- checking on how many rows
select
	count(*) as total_rows
from
	public.hdb_resale_prices;

-- create index preventing duplication 
create unique index if not exists uq_hdb_no_duplicates
on public.hdb_resale_prices(
	month,
	town,
	flat_type,
	block,
	street_name,
	storey_range,
	floor_area_sqm,
	flat_model,
	lease_commence_date,
	remaining_lease,
	resale_price
);

-- confirming index 
select 
	indexname,
	indexdef
from 
	pg_indexes 
where 
	schemaname = 'public'
	and tablename = 'hdb_resale_prices'
	and indexname = 'uq_hdb_no_duplicates';

-- powerbi readiness checks
-- row count
select
	count(*)
from
	public.hdb_resale_prices;
-- date range
select 
	min(month),
	max(month)
from
	public.hdb_resale_prices;
-- duplicate checks 
select 
	count(*) - count(
	distinct(
		month,
		town,
		flat_type,
		block,
		street_name,
		storey_range,
		floor_area_sqm,
		flat_model,
		lease_commence_date,
		remaining_lease,
		resale_price
		)
	) as duplicate_rows
from
	public.hdb_resale_prices;