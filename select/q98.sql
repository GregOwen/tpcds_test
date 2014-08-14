select 
  count(*)
from
  store_sales
where
  ss_sold_date_sk between 2451911 and 2451941  -- partition key filter (1 calendar month)
;
