{{ config(materialized="table", schema="clean") }}

select * 
FROM {{ source('GW_RAW', 'APPS')}}