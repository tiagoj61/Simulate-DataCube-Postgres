CREATE DATABASE TCC;

CREATE SEQUENCE table_array_seq START 1;
CREATE TABLE table_linha(
	id bigint PRIMARY KEY DEFAULT nextval('table_array_seq');
	valor bigint;
);

CREATE TABLE table_array(
	id bigint ;
	valor bigint;
);