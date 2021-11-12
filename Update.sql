create or replace function array_set(p_input anyarray, p_index int, p_new_value anyelement)
returns anyarray
as
$$
begin
if p_input is not null then
p_input[p_index] := p_new_value;
end if;
return p_input;
end;
$$
language plpgsql;

CREATE OR REPLACE FUNCTION update_array() RETURNS TRIGGER AS 
$BODY$
DECLARE 
	posicao integer;
BEGIN
	raise notice 'Valor: "%" ID: "%"', new.valor, new.id;
	raise notice 'Valor: "%" ID: "%"', old.valor, old.id;
	SELECT into posicao array_position(valor,(SELECT id FROM (SELECT unnest(valor) AS id FROM tabela_array where id=1)AS array_tabela WHERE array_tabela.id=new.id
							)) AS id FROM tabela_array where id=1;
 	UPDATE tabela_array SET valor = array_set((SELECT valor AS id FROM tabela_array where id=2), posicao, new.valor::bigint) where id=2;
 	RETURN new;
END;
$BODY$
language plpgsql;

--DROP TRIGGER update_array ON tabela_linhas;
CREATE TRIGGER update_array AFTER
UPDATE ON public.tabela_linhas
FOR EACH ROW EXECUTE PROCEDURE update_array();