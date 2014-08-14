select
  *
from
  (select
    
    i_category,
    i_class,
    i_brand,
    s_store_name,
    s_company_name,
    d_moy,
    sum(ss_sales_price) sum_sales
      from
    store_sales
    join item on (store_sales.ss_item_sk = item.i_item_sk)
    join store on (store_sales.ss_store_sk = store.s_store_sk)
    join date_dim on (store_sales.ss_sold_date_sk = date_dim.d_date_sk)
  where
        ss_sold_date_sk between 2451545 and 2451910      and d_year in (2000)
    and ((i_category in('Home', 'Books', 'Electronics')
          and i_class in('wallpaper', 'parenting', 'musical'))
        or (i_category in('Shoes', 'Jewelry', 'Men')
            and i_class in('womens', 'birdal', 'pants'))
        )
  group by
    i_category,
    i_class,
    i_brand,
    s_store_name,
    s_company_name,
    d_moy
  ) tmp1
order by
    sum_sales,
  s_store_name
limit 100;
