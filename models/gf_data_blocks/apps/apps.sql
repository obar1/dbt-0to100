{{ config(materialized="table", schema="data_blocks") }}

select *
fro, {{ ref('apps_latest') }}    