CREATE FUNCTION posicao_no_array(arr ARRAY[], elemento ANYELEMENT, posicao INTEGER DEFAULT 1) RETURNS INTEGER
LANGUAGE SQL
AS $BODY$
SELECT row_number::INTEGER
FROM (
    SELECT unnest, row_number() over()
    FROM ( SELECT UNNEST(arr) ) AS t0
) AS t1
    WHERE row_number >= greatest(1, pos)
    AND (CASE WHEN elemento IS NULL THEN unnest IS NULL ELSE unnest = elemento END)
LIMIT 1;
$BODY$;
