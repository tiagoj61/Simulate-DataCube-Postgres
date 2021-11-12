create function array_position(arr BIGINT[], elem ANYELEMENT, pos INTEGER default 1) returns INTEGER
language sql
as $BODY$
select row_number::INTEGER
from (
    select unnest, row_number() over ()
    from ( select unnest(arr) ) t0
) t1
    where row_number >= greatest(1, pos)
    and (case when elem is null then unnest is null else unnest = elem end)
limit 1;
$BODY$;