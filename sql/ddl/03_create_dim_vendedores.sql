-- ============================================================
-- TABELA DIMENSÃO: dim_vendedores
-- ============================================================
-- Projeto: Olist Sales Analytics
-- Autor: Rodrigo de Souza Silva
-- Data: Maio 2026
-- ============================================================

-- Drop table (se existir)
DROP TABLE IF EXISTS public.dim_vendedores CASCADE;

-- Criar tabela
CREATE TABLE public.dim_vendedores (
	seller_id text NOT NULL,
	seller_city text NULL,
	seller_state text NULL,
	CONSTRAINT dim_vendedores_pkey PRIMARY KEY (seller_id)
);

-- ============================================================
-- NOTAS:
-- - seller_id: Chave primária única por vendedor
-- - seller_city/seller_state: Localização do vendedor
-- ============================================================