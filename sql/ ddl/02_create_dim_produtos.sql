-- public.dim_produtos definição

-- Drop table

-- DROP TABLE public.dim_produtos;

CREATE TABLE public.dim_produtos (
	product_id text NOT NULL,
	categoria text NULL,
	CONSTRAINT dim_produtos_pkey PRIMARY KEY (product_id)
);