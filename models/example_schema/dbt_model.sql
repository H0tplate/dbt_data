{{
    config ({
        "materialized": "table",
        "schema": "schema_name"
    })
}}

with dbt_model as (
    select column_name
    from {{ source('schema_alias','table_name') }}
)

select * from dbt_model