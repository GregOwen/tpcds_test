-- start query 1 in stream 0 using template query43.tpl
select
  count(*)
from
  store_sales
where
  ss_sold_date_sk between 2450816 and 2451179  -- partition key filter
;
