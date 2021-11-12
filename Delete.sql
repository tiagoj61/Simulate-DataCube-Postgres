
CREATE OR REPLACE FUNCTION delete_array() RETURNS TRIGGER AS 
$BODY$
DECLARE 
	position_array INTEGER;
	size_array INTEGER;
BEGIN

	SELECT into position_array array_position(valor,old.id) FROM tabela_array WHERE id=1;
		
	SELECT into size_array array_length(valor,1)  FROM tabela_array WHERE id=1;

	IF position_array IS NOT NULL THEN 
		UPDATE tabela_array SET valor = (SELECT array_remove_element_by_index(valor :: bigint[],position_array) FROM tabela_array WHERE id=1) WHERE id=1;
		UPDATE tabela_array SET valor = (SELECT array_remove_element_by_index(valor :: bigint[],position_array) FROM tabela_array WHERE id=2) WHERE id=2;
	END IF;
	
	IF size_array IS NOT NULL THEN 
		IF size_array = 0 THEN 
			DELETE FROM tabela_array;
		END IF;
	ELSE
		DELETE FROM tabela_array;
	END IF;
	
    RETURN new;
END;
$BODY$
language plpgsql;

--DROP TRIGGER delete_array ON tabela_linhas;
CREATE TRIGGER delete_array AFTER
DELETE ON public.tabela_linhas
FOR EACH ROW EXECUTE PROCEDURE delete_array();
