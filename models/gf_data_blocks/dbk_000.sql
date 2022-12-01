{{ config(materialized="table", schema="data_blocks") }}

-- some bl
select  upper(id) as id, num*100 as num 
from {{ ref('apps_latest') }}    