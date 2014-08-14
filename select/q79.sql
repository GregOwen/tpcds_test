-- start query 1 in stream 0 using template query79.tpl
select
  count(*)
from
  store_sales
where
  ss_sold_date_sk between 2451180 and 2451269  -- partition key filter
;
