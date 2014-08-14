-- start query 1 in stream 0 using template query34.tpl
select
  count(*)
from
  store_sales
where
  ss_sold_date_sk between 2450816 and 2451910 -- partition key filter
;
