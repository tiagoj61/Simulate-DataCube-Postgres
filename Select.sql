CREATE VIEW tabela_array_alvo AS 
(select unnest(tb.id) as id ,unnest(tb.valor) as valor from (SELECT (SELECT 
		valor as id
  FROM tabela_array where id=1),(SELECT 
		valor as valor
  FROM tabela_array where id=2)) as tb);