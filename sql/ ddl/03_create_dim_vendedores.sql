-- public.dim_vendedores definição

-- Drop table

-- DROP TABLE public.dim_vendedores;

CREATE TABLE public.dim_vendedores (
	seller_id uuid NOT NULL,
	seller_zip_code_prefix int4 NULL,
	seller_city text NULL,
	seller_state text NULL,
	CONSTRAINT dim_vendedores_pkey PRIMARY KEY (seller_id)
);