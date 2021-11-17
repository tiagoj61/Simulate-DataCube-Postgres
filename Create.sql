DO
$do$
DECLARE nome_tabela varchar;
DECLARE descricao_tabela varchar;
DECLARE temprow varchar;
BEGIN 
	FOR nome_tabela IN
        SELECT table_name FROM information_schema.tables WHERE table_name NOT LIKE '%array' AND table_schema = 'public' AND table_type <>'VIEW'
    LOOP
	   	PERFORM create_table_with_name(nome_tabela||'_array');
		PERFORM alter_temp_table(nome_tabela||'_array',column_name :: varchar,data_type :: varchar) FROM information_schema.columns WHERE table_name =nome_tabela;
    END LOOP;
END
$do$;
