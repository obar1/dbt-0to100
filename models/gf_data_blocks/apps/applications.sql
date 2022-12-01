{{ config(materialized="table", schema="data_blocks") }}

select *
from {{ ref('apps_latest') }}    