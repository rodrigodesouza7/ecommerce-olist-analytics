-- public.fato_itens definição

-- Drop table

-- DROP TABLE public.fato_itens;

CREATE TABLE public.fato_itens (
	order_id text NOT NULL,
	product_id text NOT NULL,
	seller_id text NOT NULL,
	price numeric NOT NULL,
	freight_value numeric NOT NULL
);