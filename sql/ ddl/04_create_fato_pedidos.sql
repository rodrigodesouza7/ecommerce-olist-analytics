-- public.fato_pedidos definição

-- Drop table

-- DROP TABLE public.fato_pedidos;

CREATE TABLE public.fato_pedidos (
	order_id uuid NOT NULL,
	customer_id uuid NULL,
	order_status text NULL,
	order_purchase_timestamp timestamp NULL,
	order_approved_at timestamp NULL,
	order_delivered_carrier_date timestamp NULL,
	order_delivered_customer_date timestamp NULL,
	order_estimated_delivery_date timestamp NULL,
	CONSTRAINT fato_pedidos_pkey PRIMARY KEY (order_id)
);
CREATE INDEX idx_fato_pedidos_customer_id ON public.fato_pedidos USING btree (customer_id);


-- public.fato_pedidos chaves estrangeiras

ALTER TABLE public.fato_pedidos ADD CONSTRAINT fato_pedidos_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.dim_clientes(customer_id);