-- public.dim_produtos definição

-- Drop table

-- DROP TABLE public.dim_produtos;

CREATE TABLE public.dim_produtos (
	product_id uuid NOT NULL,
	product_category_name text NULL,
	product_name_length int4 NULL,
	product_description_length int4 NULL,
	product_photos_qty int4 NULL,
	product_weight_g int4 NULL,
	product_length_cm int4 NULL,
	product_height_cm int4 NULL,
	product_width_cm int4 NULL,
	CONSTRAINT dim_produtos_pkey PRIMARY KEY (product_id)
);