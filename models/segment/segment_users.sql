select * except (row_number) from (
 select *, row_number() over (partition by user_id order by timestamp desc) as row_number
  from {{ source('segment_web_app', 'users') }}
 )
where row_number = 1