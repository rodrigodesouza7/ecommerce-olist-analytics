-- public.fato_pedidos definição

-- Drop table

-- DROP TABLE public.fato_pedidos;

CREATE TABLE public.fato_pedidos (
	order_id text NOT NULL,
	customer_id text NOT NULL,
	order_purchase_timestamp timestamp NOT NULL,
	CONSTRAINT fato_pedidos_pkey PRIMARY KEY (order_id)
);