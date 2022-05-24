select * except (row_number) from (
 COUNT *
  from {{ source('segment_web_app', 'order_completed') }}
 )
where row_number = 1