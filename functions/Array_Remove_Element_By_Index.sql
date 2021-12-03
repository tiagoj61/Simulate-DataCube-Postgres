CREATE OR REPLACE FUNCTION remover_elemento_no_index(anyarray, int)
  RETURNS anyarray LANGUAGE sql IMMUTABLE AS
'SELECT $1[1:$2-1] || $1[$2+1:2147483647]';
