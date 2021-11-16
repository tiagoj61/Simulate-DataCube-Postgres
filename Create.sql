SELECT table_name FROM information_schema.tables WHERE table_name NOT LIKE '%array' AND table_schema = 'public' AND table_type <>'VIEW'

SELECT column_name FROM information_schema.columns WHERE table_name = (
		SELECT table_name FROM information_schema.tables WHERE table_name NOT LIKE '%array' AND table_schema = 'public' AND table_type <>'VIEW');
		
		
		SELECT column_name,data_type FROM information_schema.columns WHERE table_name =(
		SELECT table_name FROM information_schema.tables WHERE table_name NOT LIKE '%array' AND table_schema = 'public' AND table_type <>'VIEW');


CREATE OR REPLACE FUNCTION create_temp_table(table_name varchar)
  RETURNS void AS
$BODY$
BEGIN
    EXECUTE 'CREATE TABLE ' ||  quote_ident(table_name) || '(); ';
END;
$BODY$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION alter_temp_table(table_name varchar,nome varchar,tipo varchar)
  RETURNS void AS
$BODY$
BEGIN
    EXECUTE 'ALTER TABLE ' ||  quote_ident(table_name) || ' ADD COLUMN '|| nome||' '||tipo||'[]';
END;
$BODY$
LANGUAGE plpgsql;


DO
$do$
DECLARE nome_tabela varchar;
DECLARE descricao_tabela varchar;
DECLARE temprow varchar;
BEGIN 
	FOR nome_tabela IN
        SELECT table_name FROM information_schema.tables WHERE table_name NOT LIKE '%array' AND table_schema = 'public' AND table_type <>'VIEW'
    LOOP
	   	PERFORM create_temp_table(nome_tabela||'_array');
		PERFORM alter_temp_table(nome_tabela||'_array',column_name :: varchar,data_type :: varchar) FROM information_schema.columns WHERE table_name =nome_tabela;
    END LOOP;
END
$do$;