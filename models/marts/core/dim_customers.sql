with customers as (

    select * from {{ ref('stg_customers')}}

),

orders as (

    select * from {{ ref('stg_orders') }}

),

payments as (

    select * from {{ ref('stg_payments') }}

),


customer_orders as (

    select
        customer_id,

        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders

    from orders

    group by 1

),

customer_payments as (

    select
        customer_id,

        sum(AMOUNT) as lifetime_value

    from {{ ref('fct_orders') }}

    group by 1

),


final as (

    select
        *

    from customers

    left join customer_orders using (customer_id)
    left join customer_payments using (customer_id)

)

select * from final


