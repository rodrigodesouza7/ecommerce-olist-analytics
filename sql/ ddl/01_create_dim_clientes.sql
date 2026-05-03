-- public.dim_clientes definição

-- Drop table

-- DROP TABLE public.dim_clientes;

CREATE TABLE public.dim_clientes (
	customer_id text NOT NULL,
	customer_unique_id text NULL,
	customer_city text NULL,
	customer_state bpchar(2) NOT NULL,
	CONSTRAINT dim_clientes_pkey PRIMARY KEY (customer_id)
);