DO
$do$
DECLARE 
	nome_tabela varchar;
	descricao_tabela varchar;
	temprow varchar;
	coluna varchar;
	tipo varchar;
BEGIN 
	FOR nome_tabela IN
        SELECT table_name FROM information_schema.tables WHERE table_name NOT LIKE '%array' AND table_schema = 'public' AND table_type <>'VIEW'
    LOOP
	
		PERFORM create_table_with_name(nome_tabela||'_array');
		
		FOR coluna,tipo IN
		SELECT column_name,data_type FROM information_schema.columns WHERE table_name =nome_tabela
		LOOP
	   	
			PERFORM alter_temp_table(nome_tabela||'_array',coluna :: varchar,tipo :: varchar);
		
		END LOOP;
	END LOOP;
END
$do$;
