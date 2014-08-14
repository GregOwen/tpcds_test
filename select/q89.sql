-- start query 1 in stream 0 using template query89.tpl
select
  count(*)
from
    store_sales
where
    ss_sold_date_sk between 2451545 and 2451910  -- partition key filter
exit;
