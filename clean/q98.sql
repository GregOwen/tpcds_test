select
  i_item_desc,
  i_category,
  i_class,
  i_current_price,
  i_item_id,
  itemrevenue
from
(select 
  i_item_desc,
  i_category,
  i_class,
  i_current_price,
  i_item_id,
  sum(ss_ext_sales_price) as itemrevenue
  from
  store_sales
  join item on (store_sales.ss_item_sk = item.i_item_sk)
  join date_dim on (store_sales.ss_sold_date_sk = date_dim.d_date_sk)
where
  i_category in('Jewelry', 'Sports', 'Books')
          and ss_sold_date_sk between 2451911 and 2451941    and d_date between '2001-01-01' and '2001-01-31'
group by
  i_item_id,
  i_item_desc,
  i_category,
  i_class,
  i_current_price
order by
  i_category,
  i_class,
  i_item_id,
  i_item_desc
  limit 1000) tab
where
  tab.i_item_desc is not null and
  tab.i_category is not null and
  tab.i_class is not null and
  tab.i_current_price is not null and
  tab.i_item_id is not null and
  tab.itemrevenue is not null
;
