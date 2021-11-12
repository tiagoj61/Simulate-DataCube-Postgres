CREATE OR REPLACE FUNCTION insert_array() RETURNS TRIGGER AS 
$BODY$
BEGIN
		RAISE NOTICE 'ID: "%" VALOR: "%"', new.id, new.valor;

		IF (SELECT COUNT(*) FROM tabela_array) <> 0 THEN
			UPDATE tabela_array SET valor = (SELECT valor FROM tabela_array WHERE id=1) || ARRAY[new.id] :: bigint[] WHERE id=1;
			UPDATE tabela_array SET valor = (SELECT valor FROM tabela_array WHERE id=2) || ARRAY[new.valor] :: bigint[] WHERE id=2;
		ELSE	
			INSERT INTO tabela_array(id,valor) values (1,array[new.id]);
			INSERT INTO tabela_array(id,valor) values (2,array[new.valor]);
		END IF;
		
	RETURN NEW;
END;
$BODY$
language plpgsql;

--DROP TRIGGER insert_array ON tabela_linhas;
CREATE TRIGGER insert_array AFTER
INSERT ON public.tabela_linhas
FOR EACH ROW EXECUTE PROCEDURE insert_array();