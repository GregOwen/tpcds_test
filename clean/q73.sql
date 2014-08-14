select
  c_last_name,
  c_first_name,
  c_salutation,
  c_preferred_cust_flag,
  ss_ticket_number,
  cnt
from
  (select
    
    ss_ticket_number,
    ss_customer_sk,
    count(*) cnt
  from
    store_sales
    join household_demographics on (store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk)
    join store on (store_sales.ss_store_sk = store.s_store_sk)
      where
    store.s_county in ('Saginaw County', 'Sumner County', 'Appanoose County', 'Daviess County')
                                                    and (household_demographics.hd_buy_potential = '>10000'
      or household_demographics.hd_buy_potential = 'unknown')
    and household_demographics.hd_vehicle_count > 0
    and case when household_demographics.hd_vehicle_count > 0 then household_demographics.hd_dep_count / household_demographics.hd_vehicle_count else null end > 1
    and ss_sold_date_sk between 2451180 and 2451269   group by
    ss_ticket_number,
    ss_customer_sk
  ) dj
  join customer on (dj.ss_customer_sk = customer.c_customer_sk)
where
  cnt between 1 and 5
order by
  cnt desc
limit 1000;
