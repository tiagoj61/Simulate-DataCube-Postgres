CREATE OR REPLACE FUNCTION update_array() RETURNS TRIGGER AS 
$BODY$
DECLARE 

	/* Auxiliadores de colunas */
	json_valores_inseridos text := to_json(NEW);
	att_identificado text;
 	att_identificado_valor bigint;
	
	/* Auxiliares de manipulação da tabela */
	index_do_valor INTEGER;
	tab_nome varchar
	tab_nome_array varchar
 	col_nome varchar;
	col_tipo varchar;
	col_valor_antigo_string varchar;
 	
	/* Auxiliares de array */
	cols_novo_string varchar;
	col_novo_string varchar;
 	array_valor_antigo_tabela varchar;
	array_valor_novo_tabela varchar;
 	
	/* Index */
 	i integer;

BEGIN

	/* Definições */
	tab_nome:=TG_TABLE_NAME::regclass::text;
	tab_nome_array:=tab_nome||'_array';
	i:=1;

	/* Nome do atributo identificador */	
	EXECUTE 'SELECT pg_attribute.attname 
	FROM pg_index 
	JOIN pg_attribute ON pg_attribute.attrelid = pg_index.indrelid
	     AND pg_attribute.attnum = ANY(pg_index.indkey)
	WHERE pg_index.indrelid = '||quote_literal(tab_nome) ||'::regclass
	AND pg_index.indisprimary' INTO att_identificado;

	/* Valor do atributo identificador */	
	EXECUTE 'SELECT ('||quote_literal(json_valores_inseridos)||'::JSONB -> '||quote_literal(att_identificado)||')' INTO att_identificado_valor;

	/* Index do valor do update */	
	EXECUTE 'SELECT array_position('||att_identificado||',$1) 
	FROM '||tab_nome_array 
	USING att_identificado_valor 
	INTO index_do_valor ;
	
	/* Colunas to String e remoção do primeiro e ultimo caracter */
	cols_novo_string:=new::varchar;
	cols_novo_string:=substr(cols_string,2, LENGTH(cols_string)-2);

	/* Varre as colunas da tabela e o tipo */
	FOR col_nome,col_tipo IN
		SELECT column_name,data_type FROM information_schema.columns WHERE table_name =tab_nome
	LOOP

		/* Valor do array na tabela antes do update */
		EXECUTE 'SELECT '||coluna||
		' FROM '||tab_nome_array 
		INTO array_valor_antigo_tabela;
		
		array_valor_antigo_tabela:=replace(array_valor_antigo_tabela,'{','');
		array_valor_antigo_tabela:=replace(array_valor_antigo_tabela,'}','');

		/* Pega novo valor baseado no index */
		col_novo_string:=split_part(cols_novo_string,',',i);

		/* Se tiver um valor novo */
		IF LENGTH(col_novo_string)>0 OR col_novo_string IS NOT NULL THEN
				
				/* Colona o novo valor na posição */
				EXECUTE 'UPDATE '||tab_nome_array||
				' SET '||coluna||'=array_set(ARRAY['||array_valor_antigo_tabela||'],'||index_do_valor||','||col_novo_string||')';
		
		END IF;
	
		i:=i+1;
		
	END LOOP;
		
 	RETURN new;
END;
$BODY$
LANGUAGE plpgsql;