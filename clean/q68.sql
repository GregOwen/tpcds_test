select
  c_last_name,
  c_first_name,
  ca_city,
  bought_city,
  ss_ticket_number,
  extended_price,
  extended_tax,
  list_price
from
(select
  c_last_name,
  c_first_name,
  ca_city,
  bought_city,
  ss_ticket_number,
  extended_price,
  extended_tax,
  list_price
from
  (select
    ss_ticket_number,
    ss_customer_sk,
    ca_city bought_city,
    sum(ss_ext_sales_price) extended_price,
    sum(ss_ext_list_price) list_price,
    sum(ss_ext_tax) extended_tax
  from
    store_sales
    join store on (store_sales.ss_store_sk = store.s_store_sk)
    join household_demographics on (store_sales.ss_hdemo_sk = household_demographics.hd_demo_sk)
    join date_dim on (store_sales.ss_sold_date_sk = date_dim.d_date_sk)
    join customer_address on (store_sales.ss_addr_sk = customer_address.ca_address_sk)
  where
    store.s_city in('Midway', 'Fairview')
                                                    and (household_demographics.hd_dep_count = 5
      or household_demographics.hd_vehicle_count = 3)
    and d_date between '1999-01-01' and '1999-03-31'
    and ss_sold_date_sk between 2451180 and 2451269   group by
    ss_ticket_number,
    ss_customer_sk,
    ss_addr_sk,
    ca_city
  ) dn
  join customer on (dn.ss_customer_sk = customer.c_customer_sk)
  join customer_address current_addr on (customer.c_current_addr_sk = current_addr.ca_address_sk)
where
  current_addr.ca_city <> bought_city
order by
  c_last_name,
  ss_ticket_number 
limit 100) tab
where  
  tab.c_last_name is not null and
  tab.c_first_name is not null and
  tab.ca_city is not null and
  tab.bought_city is not null and
  tab.ss_ticket_number is not null and
  tab.extended_price is not null and
  tab.extended_tax is not null and
  tab.list_price is not null
;
