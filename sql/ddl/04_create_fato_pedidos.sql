-- ============================================================
-- TABELA FATO: fato_pedidos
-- ============================================================
-- Projeto: Olist Sales Analytics
-- Autor: Rodrigo de Souza Silva
-- Data: Maio 2026
-- ============================================================

-- Drop table (se existir)
DROP TABLE IF EXISTS public.fato_pedidos CASCADE;

-- Criar tabela
CREATE TABLE public.fato_pedidos (
	order_id text NOT NULL,
	customer_id text NOT NULL,
	order_purchase_timestamp timestamp NOT NULL,
	CONSTRAINT fato_pedidos_pkey PRIMARY KEY (order_id)
);

-- ============================================================
-- NOTAS:
-- - Granularidade: 1 linha = 1 pedido
-- - order_purchase_timestamp: Data/hora da compra
-- - FK para dim_clientes será criada em 06_create_constraints.sql
-- ============================================================