{{ config(materialized="table", schema="data_blocks", tags="pg") }}

-- some bl
select  upper(id) as id
from {{ ref('alternativeto_historical') }}    