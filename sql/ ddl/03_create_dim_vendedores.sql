-- public.dim_vendedores definição

-- Drop table

-- DROP TABLE public.dim_vendedores;

CREATE TABLE public.dim_vendedores (
	seller_id text NOT NULL,
	seller_city text NULL,
	seller_state text NULL,
	CONSTRAINT dim_vendedores_pkey PRIMARY KEY (seller_id)
);