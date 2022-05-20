{{
    config ({
        "materialized": "incremental",
        "schema": "schema_name"
    })
}}

with dbt_model_2 as (
    select date, column_name_1, column_name_2
    from {{ ref('dbt_model') }}
    {% if is_incremental() %}
        where date >= (SELECT MAX(timestamp::date) FROM {{ this }})
    {% endif %}
)

select * from dbt_model_2