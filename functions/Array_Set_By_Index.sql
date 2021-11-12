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