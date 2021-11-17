CREATE OR REPLACE FUNCTION delete_array() RETURNS TRIGGER AS 
$BODY$
DECLARE 

	/* Auxiliares de tabela */
	nome_tabela varchar;
	nome_tabela_array varchar;
	col_nome varchar;
	col_tipo varchar;
 
	/* Auxiliares de array */
	index_do_valor INTEGER;
	tamanho_do_array INTEGER;
	array_valor_antigo_tabela varchar;

 
	/* Index */
	i integer;

BEGIN
	
	/* Definições */
	nome_tabela:=TG_TABLE_NAME::regclass::text;
	nome_tabela_array:=nome_tabela||'_array';

	/* Index do valor e tamanho do array */	
	EXECUTE 'SELECT array_position(id,$1) FROM '||nome_tabela_array USING old.id into index_do_valor ;
	EXECUTE 'SELECT array_length(id,1) FROM '||nome_tabela_array into tamanho_do_array ;

	/* Se o valor existir */	
	IF index_do_valor IS NOT NULL THEN 
	
		/* Varre as colunas da tabela e o tipo */
		FOR col_nome,col_tipo IN
			SELECT column_name,data_type FROM information_schema.columns WHERE table_name =nome_tabela
		LOOP

			/* Valor do array na tabela antes do delete */
			EXECUTE 'SELECT '||col_nome||' FROM '||nome_tabela_array INTO array_valor_antigo_tabela;
			
			array_valor_antigo_tabela:=replace(array_valor_antigo_tabela,'{','');
			array_valor_antigo_tabela:=replace(array_valor_antigo_tabela,'}','');
			
			/* Remove o valor daquela posição */
			EXECUTE 'UPDATE '||nome_tabela_array||' SET '||col_nome||'=(SELECT f_array_remove_elem(ARRAY['||array_valor_antigo_tabela||'],'||index_do_valor||'))' ;
		
		END LOOP;
	END IF;
	
	/* Se não tiver mais nada no array */
	IF tamanho_do_array IS NOT NULL THEN 
		IF tamanho_do_array = 0 THEN 
			EXECUTE 'DELETE FROM '||nome_tabela_array ;
		END IF;
	ELSE
		EXECUTE 'DELETE FROM '||nome_tabela_array ;
	END IF;
	
    RETURN new;
END;
$BODY$
language plpgsql;