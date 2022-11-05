# Models

## Learning Objectives
Explain what models are in a dbt project.
Build your first dbt model.
Explain how to apply modularity to analytics with dbt.
Modularize your project with the ref function.
Review a brief history of modeling paradigms.
Identify common naming conventions for tables.
Reorganize your project with subfolders.


## What are models?

shaping data from raw up to final form 

source tables -> intermediate table/views -> final tables

models =  sql select statement with some logic


![](2022-11-05-18-54-39.png)

dbt handles ddl/dml for you

focus on bl logic

## Building your first model

![](2022-11-05-18-55-32.png)

use of cte to add logic steps and bl transformation

use models folder to  def the models

![](2022-11-05-18-56-48.png)

use `.sql` extension 

run sql from cloud ide

![](2022-11-05-18-58-11.png)

![](2022-11-05-18-58-17.png)

the models created are created by dbt run in snowflakee

![](2022-11-05-18-58-59.png)

now you can use it 

![](2022-11-05-18-59-30.png)

create as table not as view

add a config block

![](2022-11-05-18-59-56.png)

to rebuild only 1 model

### TODO: 

```sql
with customers as (

    select
        id as customer_id,
        first_name,
        last_name

    from raw.jaffle_shop.customers

),

orders as (

    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from raw.jaffle_shop.orders

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


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select * from final
```

![](2022-11-05-19-04-20.png)
dbt run in dbt ide

![](2022-11-05-19-04-51.png)
in sf

change to table

```
{{ config (
    materialized="table"
)}}
```

![](2022-11-05-19-07-25.png)
as table now

a0e9cf0ffb7d5e21b2e18b309c1e25df81a9dab0

## What is modularity?

we have multiple cte to reshapes customers and orders, then we aggregate and then we join to get the final data

![](2022-11-05-19-08-56.png)
like car
to break up things in modules


##  Modularity and the ref functions

breakup  in models

![](2022-11-05-19-11-38.png)
stg_customers

![](2022-11-05-19-12-18.png)
str_orders 
rename some columns

![](2022-11-05-19-13-21.png)
use ref and ref the models
build dep on models

use compile sql to see what sql will be executed on snowf

![](2022-11-05-19-14-53.png)
actual schemas are replaced
devs can work on separate env even if the code is the same

![](2022-11-05-19-15-53.png)
dbt run -> build models in the right order

### TODO:

Reference: Code Snippets

stg_customers.sql

with customers as (
    
    select 
        id as customer_id,
        first_name,
        last_name

    from raw.jaffle_shop.customers
)

select * from customers
stg_orders.sql

with orders as (
    
    select
        id as order_id,
        user_id as customer_id,
        order_date,
        status

    from raw.jaffle_shop.orders
)

select * from orders
dim_customers.sql

with customers as (

    select * from {{ ref('stg_customers')}}

),

orders as (

    select * from {{ ref('stg_orders') }}

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


final as (

    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders

    from customers

    left join customer_orders using (customer_id)

)

select * from final


![](2022-11-05-19-24-36.png)
![](2022-11-05-19-24-47.png)
![](2022-11-05-19-25-58.png)

![](2022-11-05-19-26-14.png)
![](2022-11-05-19-26-46.png)


3a24ad1b29dac3d99804b816ccfefea4865e3179


## Quick history of data modeling

![](2022-11-05-19-29-14.png)
opt for space

opt for human or fast delivery

![](2022-11-05-19-29-46.png)
use denormalized viewpoint


## Naming conventions

sources -> ref to  raw data
load data via some 3rd party tool

staging -> 1 to  1 with source table
just rename and quick conversion

intermediate -> somewhere between staging and final model
no ref to  source 
fact model -> things happening over time
dim model -> thing that are

![](2022-11-05-19-32-31.png)
dag we are going to use

![](2022-11-05-19-33-41.png)

## Reorganize your project

new folder `staging`
new folder `marts`

in staging we read fromm source
jaffleshop name of  raw data


modify the dbt_project.yml
ref the folder structure we created

![](2022-11-05-19-37-16.png)

![](2022-11-05-19-38-04.png)

![](2022-11-05-19-38-38.png)

### TODO:

![](2022-11-05-19-39-03.png)

![](2022-11-05-19-45-00.png)
![](2022-11-05-19-44-41.png)

staging where data loaded
marts where data is T with biz loaded

41dc2a4b33d2332a180c089be4521c366620ad00

## Practice

![](2022-11-05-19-49-12.png)

![](2022-11-05-19-49-49.png)
stripe

![](2022-11-05-20-01-27.png)

![](2022-11-05-20-02-33.png)

961104971140385fd330d624fbd1212336e1ff16

## Exemplar

Self-check stg_payments, orders, customers
Use this page to check your work on these three models.

staging/stripe/stg_payments.sql

select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,

    -- amount is stored in cents, convert it to dollars
    amount / 100 as amount,
    created as created_at

from raw.stripe.payment 
marts/core/fct_orders.sql

with orders as  (
    select * from {{ ref('stg_orders' )}}
),

payments as (
    select * from {{ ref('stg_payments') }}
),

order_payments as (
    select
        order_id,
        sum(case when status = 'success' then amount end) as amount

    from payments
    group by 1
),

final as (

    select
        orders.order_id,
        orders.customer_id,
        orders.order_date,
        coalesce(order_payments.amount, 0) as amount

    from orders
    left join order_payments using (order_id)
)

select * from final
marts/core/dim_customers.sql 

*Note: This is different from the original dim_customers.sql - you may refactor fct_orders in the process.

with customers as (
    select * from {{ ref('stg_customers')}}
),
orders as (
    select * from {{ ref('fct_orders')}}
),
customer_orders as (
    select
        customer_id,
        min(order_date) as first_order_date,
        max(order_date) as most_recent_order_date,
        count(order_id) as number_of_orders,
        sum(amount) as lifetime_value
    from orders
    group by 1
),
final as (
    select
        customers.customer_id,
        customers.first_name,
        customers.last_name,
        customer_orders.first_order_date,
        customer_orders.most_recent_order_date,
        coalesce(customer_orders.number_of_orders, 0) as number_of_orders,
        customer_orders.lifetime_value
    from customers
    left join customer_orders using (customer_id)
)
select * from final

e828d318519f5336f4d3f0d309b6b339cf97ee5e

## Review

Naming Conventions 
In working on this project, we established some conventions for naming our models.

Sources (src) refer to the raw table data that have been built in the warehouse through a loading process. (We will cover configuring Sources in the Sources module)
Staging (stg) refers to models that are built directly on top of sources. These have a one-to-one relationship with sources tables. These are used for very light transformations that shape the data into what you want it to be. These models are used to clean and standardize the data before transforming data downstream. Note: These are typically materialized as views.
Intermediate (int) refers to any models that exist between final fact and dimension tables. These should be built on staging models rather than directly on sources to leverage the data cleaning that was done in staging.
Fact (fct) refers to any data that represents something that occurred or is occurring. Examples include sessions, transactions, orders, stories, votes. These are typically skinny, long tables.
Dimension (dim) refers to data that represents a person, place or thing. Examples include customers, products, candidates, buildings, employees.
Note: The Fact and Dimension convention is based on previous normalized modeling techniques.

Reorganize Project
When dbt run is executed, dbt will automatically run every model in the models directory.
The subfolder structure within the models directory can be leveraged for organizing the project as the data team sees fit.
This can then be leveraged to select certain folders with dbt run and the model selector.
Example: If dbt run -s staging will run all models that exist in models/staging. (Note: This can also be applied for dbt test as well which will be covered later.)
The following framework can be a starting part for designing your own model organization:
Marts folder: All intermediate, fact, and dimension models can be stored here. Further subfolders can be used to separate data by business function (e.g. marketing, finance)
Staging folder: All staging models and source configurations can be stored here. Further subfolders can be used to separate data by data source (e.g. Stripe, Segment, Salesforce). (We will cover configuring Sources in the Sources module)

![](2022-11-05-20-06-54.png)