select
  
  d_year,
  i_brand_id,
  i_brand,
  sum(ss_ext_sales_price) ext_price
from
  store_sales
  join item on (store_sales.ss_item_sk = item.i_item_sk)
  join date_dim dt on (store_sales.ss_sold_date_sk = dt.d_date_sk)
where
  i_manager_id = 1
  and d_moy = 12
  and d_year = 1998
    and ss_sold_date_sk between 2451149 and 2451179 group by
  d_year,
  i_brand,
  i_brand_id
order by
  d_year,
  ext_price desc,
  i_brand_id 
limit 100;
