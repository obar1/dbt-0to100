# Who is an analytics engineer?

## Learning Objectives

- traditional data team
- etl to elt
- analytics eng role
- dbt in modern data stacks
- structure of dbt project

## Traditional Data Teams

data analyst = query data
- close toi biz , build dashboard, xls ,sql 

data eng = build data platform and mantain the data
- sql  python and orch

there is a gap between them

## ETL and ELT

extract data from something, manipulate the data, server the data

tarditional etl = tools dev language and orchestartion 

now use of cloud based dwh instead of on premise 

![](2022-11-05-15-31-09.png)

no E really anymore

![](2022-11-05-15-31-51.png)

cloud based:
- scale compute
- scale storage
- reduction of transfer time

so now we moved from ETL to  ELT 

## Analytics Engineer

new role AE

![](2022-11-05-15-33-57.png)

in charge of T
works closer to data analyst

data eng focus on the E L and devops

![](2022-11-05-15-34-44.png)

https://www.getdbt.com/what-is-analytics-engineering/

![](2022-11-05-15-35-19.png)

## The modern data stack and dbt

we have a lot of data source

then data platform to store all the data

![](2022-11-05-15-39-12.png)

loaders to  extract data from sources (EL) to  platform
bi tools and ml models and op analytics to use the data

![](2022-11-05-15-40-37.png)

dbt fits with the data platform

![](2022-11-05-15-41-19.png)

in dbt easy to develop  T to build models (only select statements)
dbt manages the dep of the models
we have DAG
![](2022-11-05-15-41-53.png)

then run the job to refresh the data in the platform

![](2022-11-05-15-43-20.png)

## Overview of an exemplar project

we build a project during the course

![](2022-11-05-15-43-52.png)

sources =  raw data
staging =  built on top of source

![](2022-11-05-15-45-14.png)

lineage = models dependencies

dbt run = build all the models in the correct order 
it send sql to  the platform to  build them and load data

![](2022-11-05-15-46-12.png)

tests = to  assure data quality
![](2022-11-05-15-46-58.png)

dbt creates and run them on the models

doc = description for the models 
![](2022-11-05-15-47-49.png)

deployment =  take code and merge the code in master

use of env def to  run jobs 

![](2022-11-05-15-49-30.png)






