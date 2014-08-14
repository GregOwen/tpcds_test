-- start query 1 in stream 0 using template query55.tpl
select
  count(*)
from
  store_sales
where
  ss_sold_date_sk between 2452245 and 2452275 -- partition key filter
;
