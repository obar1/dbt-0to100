{{ config(materialized="table", schema="data_blocks") }}

-- some bl
select  *
from {{ ref('alternativeto_historical') }}    