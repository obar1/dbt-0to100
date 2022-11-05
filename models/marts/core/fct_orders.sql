select 
ID as customer_id,ORDERID , AMOUNT

from  {{ ref('stg_payments') }}