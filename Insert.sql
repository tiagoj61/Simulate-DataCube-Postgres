CREATE OR REPLACE FUNCTION insert_array() RETURNS TRIGGER AS 
$BODY$
DECLARE

	/* Auxiliares de tabela */
	nome_tabela varchar;
 	nome_tabela_array varchar;
	col_nome varchar;
	col_tipo varchar;
 	coluna varchar;
 	val_insercao_incial varchar;
	
	/* Auxiliares de array */
	cols_novo_string varchar;
	col_novo_string varchar;
 	colunas_array varchar;
 	valor_novo_array varchar;
 	valor_antigo_array varchar;
 	tipo_array varchar;
	
	/* Auxiliadores de tabela array */
 	tab_array_qtd_registros integer;
	
	/* Index */
 	i integer;
BEGIN
	/* Definições */
	tab_nome:=TG_TABLE_NAME::regclass::text;
	tab_nome_array:=tab_nome||'_array';
	val_insercao_incial:='';
	i:=1;
		
	/* Caso seja o primeiro valor inserido */
	EXECUTE 'SELECT COUNT(*) 
	FROM '||tab_nome_array
	INTO tab_array_qtd_registros;
	
	/* Caso não existam valores na tabela array */
	IF tab_array_qtd_registros = 0 THEN 
		
		FOR col_nome,col_tipo IN
			SELECT column_name,data_type FROM information_schema.columns WHERE table_name =tab_nome
		LOOP
		
			/* Adiciona um array vazio para cada coluna */
			val_insercao_incial:=val_insercao_incial||'ARRAY[]::'||col_tipo||'[],';
		
		END LOOP;
		
		/* Remove ultimo index, ',' extra */
		val_insercao_incial:=substr(val_insercao_incial,1, LENGTH(inserval_insercao_incialcao_incial)-1);
		
		/* Inseri os arrays vazios na tabela array */
		EXECUTE 'INSERT INTO '||tab_nome_array||' VALUES('||val_insercao_incial||')';
		
	END IF;
	
	/* Colunas to String e remoção do primeiro e ultimo caracter */
	cols_novo_string:=new::varchar;
	cols_novo_string:=substr(cols_string,2, LENGTH(cols_string)-2);

	/* Varre as colunas da tabela e o tipo */
	FOR col_nome,col_tipo IN
		SELECT column_name,data_type FROM information_schema.columns WHERE table_name =tab_nome
	LOOP

		EXECUTE 'SELECT '||col_nome||
		' FROM '||tab_nome_array
		INTO valor_antigo_array;

		valor_antigo_array:=replace(valor_antigo_array,'{','');
		valor_antigo_array:=replace(valor_antigo_array,'}','');

		valor_novo_array:=split_part(colunas_array,',',i);

		IF LENGTH(valor_antigo_array)<=0 OR valor_antigo_array IS NULL  THEN
		
			EXECUTE 'UPDATE '||tab_nome_array||' SET '||col_nome||'=array['||valor_novo_array||']' ;
		
		ELSE
		
			EXECUTE 'UPDATE '||tab_nome_array||' SET '||col_nome||'=ARRAY['||valor_antigo_array||'] || array['||valor_novo_array||']' ;
		
		END IF;
		
		i:=i+1;

	END LOOP;
	
	RETURN NEW;
END;
$BODY$
language plpgsql;