-- ============================================================
-- TABELA DIMENSÃO: dim_produtos
-- ============================================================
-- Projeto: Olist Sales Analytics
-- Autor: Rodrigo de Souza Silva
-- Data: Maio 2026
-- ============================================================

-- Drop table (se existir)
DROP TABLE IF EXISTS public.dim_produtos CASCADE;

-- Criar tabela
CREATE TABLE public.dim_produtos (
	product_id text NOT NULL,
	categoria text NULL,
	CONSTRAINT dim_produtos_pkey PRIMARY KEY (product_id)
);

-- ============================================================
-- NOTAS:
-- - product_id: Chave primária única por produto
-- - categoria: Categoria do produto (pode ser NULL)
-- ============================================================