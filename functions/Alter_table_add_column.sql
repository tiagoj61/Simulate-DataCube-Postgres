CREATE OR REPLACE FUNCTION alter_table_add_column(table_name varchar,nome varchar,tipo varchar)
  RETURNS void AS
$BODY$
BEGIN
    EXECUTE 'ALTER TABLE ' ||  quote_ident(table_name) || ' ADD COLUMN '|| nome||' '||tipo||'[]';
END;
$BODY$
LANGUAGE plpgsql;