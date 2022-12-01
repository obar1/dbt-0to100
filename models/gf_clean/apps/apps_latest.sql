{{ config(materialized="table", schema="clean") }}

select * 
FROM {{ source('gf_raw', 'apps')}}