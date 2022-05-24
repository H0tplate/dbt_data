select 
 count(*)
  from {{ source('segment_web_app', 'order_completed') }}