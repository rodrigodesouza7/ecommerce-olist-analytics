-- ============================================================
-- TABELA DIMENSÃO: dim_clientes
-- ============================================================
-- Projeto: Olist Sales Analytics
-- Autor: Rodrigo de Souza Silva
-- Data: Maio 2026
-- ============================================================

-- Drop table (se existir)
DROP TABLE IF EXISTS public.dim_clientes CASCADE;

-- Criar tabela
CREATE TABLE public.dim_clientes (
	customer_id text NOT NULL,
	customer_unique_id text NULL,
	customer_city text NULL,
	customer_state bpchar(2) NOT NULL,
	CONSTRAINT dim_clientes_pkey PRIMARY KEY (customer_id)
);

-- ============================================================
-- NOTAS:
-- - customer_id: Chave primária única por cliente
-- - customer_state: UF com 2 caracteres (ex: SP, RJ, MG)
-- - customer_unique_id: ID original do dataset Olist
-- ============================================================