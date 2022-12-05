{{ config(materialized="table", schema="clean") }}

SELECT * 
FROM {{ ref('raw_alternativeto')}}
