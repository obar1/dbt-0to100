{{ config(materialized="table", schema="clean") }}

select upper(id) as id, 
num
FROM {{ source('gf_raw', 'apps')}}