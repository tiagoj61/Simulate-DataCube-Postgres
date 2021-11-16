CREATE OR REPLACE FUNCTION delete_array() RETURNS TRIGGER AS 
$BODY$
DECLARE 
	position_array INTEGER;
	size_array INTEGER;
	nome_tabela varchar;
 nome_tabela_array varchar;
 coluna varchar;
 insercao_incial varchar;
 
 colunas_array varchar;
 valor_novo_array varchar;
 valor_antigo_array varchar;
 tipo_array varchar;
 
 quantidade_existente integer;
 
 i integer;

BEGIN
	nome_tabela:=TG_TABLE_NAME::regclass::text;
	nome_tabela_array:=nome_tabela||'_array';

	EXECUTE 'SELECT array_position(id,$1) FROM '||nome_tabela_array USING old.id into position_array ;
	EXECUTE 'SELECT array_length(id,1) FROM '||nome_tabela_array into size_array ;

	IF position_array IS NOT NULL THEN 
		FOR coluna,tipo_array IN
			SELECT column_name,data_type FROM information_schema.columns WHERE table_name =nome_tabela
		LOOP

			EXECUTE 'SELECT '||coluna||' FROM '||nome_tabela_array INTO valor_antigo_array;
			
			valor_antigo_array:=replace(valor_antigo_array,'{','');
			valor_antigo_array:=replace(valor_antigo_array,'}','');
			
			EXECUTE 'UPDATE '||nome_tabela_array||' SET '||coluna||'=(SELECT f_array_remove_elem(ARRAY['||valor_antigo_array||'],'||position_array||'))' ;
		
		END LOOP;
	END IF;
	
	IF size_array IS NOT NULL THEN 
		IF size_array = 0 THEN 
			EXECUTE 'DELETE FROM '||nome_tabela_array ;
		END IF;
	ELSE
		EXECUTE 'DELETE FROM '||nome_tabela_array ;
	END IF;
	
    RETURN new;
END;
$BODY$
language plpgsql;