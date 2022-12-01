{{ config(materialized="view", schema="clean") }}


select 'a'  as id , 123 as num
union all
select 'b' , NULL
