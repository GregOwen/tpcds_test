-- start query 1 in stream 0 using template query59.tpl
select
  count(*)
from
  store_sales
where 
  ss_sold_date_sk between 2451088 and 2451452
;
