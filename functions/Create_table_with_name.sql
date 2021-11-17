CREATE OR REPLACE FUNCTION create_table_with_name(table_name varchar) RETURNS void AS
$BODY$
BEGIN
    EXECUTE 'CREATE TABLE ' ||  quote_ident(table_name) || '();';
END;
$BODY$
LANGUAGE plpgsql;
