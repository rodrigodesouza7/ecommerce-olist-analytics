-- public.fato_itens definição

-- Drop table

-- DROP TABLE public.fato_itens;

CREATE TABLE public.fato_itens (
	order_id uuid NOT NULL,
	order_item_id int4 NOT NULL,
	product_id uuid NULL,
	seller_id uuid NULL,
	shipping_limit_date timestamp NULL,
	price numeric(10, 2) NULL,
	freight_value numeric(10, 2) NULL,
	CONSTRAINT fato_itens_pkey PRIMARY KEY (order_id, order_item_id)
);
CREATE INDEX idx_fato_itens_order_id ON public.fato_itens USING btree (order_id);
CREATE INDEX idx_fato_itens_product_id ON public.fato_itens USING btree (product_id);


-- public.fato_itens chaves estrangeiras

ALTER TABLE public.fato_itens ADD CONSTRAINT fato_itens_order_id_fkey FOREIGN KEY (order_id) REFERENCES public.fato_pedidos(order_id);
ALTER TABLE public.fato_itens ADD CONSTRAINT fato_itens_product_id_fkey FOREIGN KEY (product_id) REFERENCES public.dim_produtos(product_id);
ALTER TABLE public.fato_itens ADD CONSTRAINT fato_itens_seller_id_fkey FOREIGN KEY (seller_id) REFERENCES public.dim_vendedores(seller_id);