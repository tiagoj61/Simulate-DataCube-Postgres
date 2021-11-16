CREATE OR REPLACE FUNCTION create_view_table(table_name varchar)
  RETURNS void AS
$BODY$
DECLARE 
	position_array INTEGER;
	size_array INTEGER;
	posicao integer;
	nome_tabela varchar;
 nome_tabela_array varchar;
 parametros_view varchar;
  parametros_asd_view varchar;
 coluna varchar;
 colunas_array varchar;
 valor_novo_array varchar;
 valor_antigo_array varchar;
 tipo_array varchar;
 quantidade_existente integer;
 i integer;
BEGIN
	parametros_view:='SELECT ';
	parametros_asd_view:='SELECT ';
	i:=1;
	FOR nome_tabela IN
        SELECT information_schema.tables.table_name FROM information_schema.tables WHERE information_schema.tables.table_name NOT LIKE '%array' AND information_schema.tables.table_schema = 'public' AND information_schema.tables.table_type <>'VIEW'
    LOOP
		nome_tabela_array:=nome_tabela||'_array';
		FOR coluna,tipo_array IN
			SELECT column_name,data_type FROM information_schema.columns WHERE information_schema.columns.table_name =nome_tabela
		LOOP
		
			parametros_view:=parametros_view||'(SELECT '||coluna||' as par'||i||' FROM '||nome_tabela_array||'),';
			parametros_asd_view:=parametros_asd_view||'UNNEST(tabela_resultado.par'||i||') AS par'||i||',';
			
			i:=i+1;
		END LOOP;
		parametros_view:=substr(parametros_view,1, LENGTH(parametros_view)-1);
		parametros_asd_view:=substr(parametros_asd_view,1, LENGTH(parametros_asd_view)-1);
		parametros_asd_view:='('||parametros_asd_view||' FROM ('||parametros_view||') AS tabela_resultado)';
		EXECUTE 'CREATE VIEW ' ||  quote_ident(nome_tabela_array||'_view') || ' AS '||parametros_asd_view;
		
	END LOOP;
   
END;
$BODY$
LANGUAGE plpgsql;