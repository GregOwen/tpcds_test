-- start query 1 in stream 0 using template query19.tpl
select
  count(*)
from
  store_sales
where
  ss_sold_date_sk between 2451484 and 2451513
;
