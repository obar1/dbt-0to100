{{ config(materialized="view", schema="clean") }}

with cte as (

select 'a'  as id , 123 as num
union all
select 'b' , NULL
)


select *
from cte
union  all
select *
FROM {{ source('gf_raw', 'apps')}}