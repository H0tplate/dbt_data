select * except (row_number) from (
 select *, row_number() over (partition by anonymous_id order by timestamp desc) as row_number
  from {{ source('segment_web_app', 'order_completed') }}
 )
where row_number = 1