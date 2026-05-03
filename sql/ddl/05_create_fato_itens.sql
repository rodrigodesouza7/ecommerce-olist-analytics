-- ============================================================
-- TABELA FATO: fato_itens
-- ============================================================
-- Projeto: Olist Sales Analytics
-- Autor: Rodrigo de Souza Silva
-- Data: Maio 2026
-- ============================================================

-- Drop table (se existir)
DROP TABLE IF EXISTS public.fato_itens CASCADE;

-- Criar tabela
CREATE TABLE public.fato_itens (
	order_id text NOT NULL,
	product_id text NOT NULL,
	seller_id text NOT NULL,
	price numeric NOT NULL,
	freight_value numeric NOT NULL
);

-- ============================================================
-- NOTAS:
-- - Granularidade: 1 linha = 1 produto vendido em 1 pedido por 1 vendedor
-- - PK composta (order_id, product_id, seller_id) criada em 06_create_constraints.sql
-- - FKs para fato_pedidos, dim_produtos, dim_vendedores criadas em 06_create_constraints.sql
-- ============================================================