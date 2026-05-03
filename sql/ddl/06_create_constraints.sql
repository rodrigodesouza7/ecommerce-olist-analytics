-- ============================================================
-- CONSTRAINTS - Integridade Referencial e Chaves Primárias
-- ============================================================
-- Projeto: Olist Sales Analytics
-- Autor: Rodrigo de Souza Silva
-- Data: Maio 2026
-- ============================================================

-- ============================================================
-- 1. LIMPEZA DE DUPLICATAS EM fato_itens
-- ============================================================
-- IMPORTANTE: Executar antes de criar a PK composta
-- Motivo: Dados originais contêm ~240 duplicatas

-- 1.1. Dropar view dependente (será recriada ao final)
DROP VIEW IF EXISTS vw_analise_final CASCADE;

-- 1.2. Criar tabela temporária SEM duplicatas
CREATE TABLE fato_itens_clean AS
SELECT DISTINCT ON (order_id, product_id, seller_id)
    order_id,
    product_id,
    seller_id,
    price,
    freight_value
FROM public.fato_itens
ORDER BY order_id, product_id, seller_id;

-- 1.3. Substituir tabela original pela limpa
DROP TABLE public.fato_itens;
ALTER TABLE fato_itens_clean RENAME TO fato_itens;

-- ============================================================
-- 2. CHAVE PRIMÁRIA COMPOSTA EM fato_itens
-- ============================================================
-- Motivo: Garante unicidade de cada item dentro de um pedido
-- Granularidade: 1 linha = 1 produto vendido em 1 pedido por 1 vendedor

ALTER TABLE public.fato_itens
ADD CONSTRAINT fato_itens_pkey 
PRIMARY KEY (order_id, product_id, seller_id);

-- ============================================================
-- 3. CHAVES ESTRANGEIRAS - fato_pedidos
-- ============================================================
-- Garante que todo pedido pertence a um cliente válido

ALTER TABLE public.fato_pedidos
ADD CONSTRAINT fk_pedidos_clientes 
FOREIGN KEY (customer_id) 
REFERENCES public.dim_clientes(customer_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- ============================================================
-- 4. CHAVES ESTRANGEIRAS - fato_itens
-- ============================================================

-- FK para pedidos (ordem hierárquica: pedido deve existir antes dos itens)
ALTER TABLE public.fato_itens
ADD CONSTRAINT fk_itens_pedidos 
FOREIGN KEY (order_id) 
REFERENCES public.fato_pedidos(order_id)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- FK para produtos
ALTER TABLE public.fato_itens
ADD CONSTRAINT fk_itens_produtos 
FOREIGN KEY (product_id) 
REFERENCES public.dim_produtos(product_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- FK para vendedores
ALTER TABLE public.fato_itens
ADD CONSTRAINT fk_itens_vendedores 
FOREIGN KEY (seller_id) 
REFERENCES public.dim_vendedores(seller_id)
ON DELETE RESTRICT
ON UPDATE CASCADE;

-- ============================================================
-- 5. RECRIAR VIEW DE ANÁLISE
-- ============================================================
-- View dropada no início para permitir limpeza de duplicatas

CREATE OR REPLACE VIEW vw_analise_final AS
SELECT 
    UPPER(dc.customer_state::text) AS estado,
    INITCAP(dp.categoria) AS categoria,
    EXTRACT(year FROM fp.order_purchase_timestamp) AS ano,
    EXTRACT(month FROM fp.order_purchase_timestamp) AS mes,
    TRIM(BOTH FROM TO_CHAR(fp.order_purchase_timestamp, 'Month'::text)) AS mes_nome,
    SUM(fi.price) AS receita
FROM fato_itens fi
JOIN fato_pedidos fp ON fi.order_id = fp.order_id
JOIN dim_clientes dc ON fp.customer_id = dc.customer_id
JOIN dim_produtos dp ON fi.product_id = dp.product_id
GROUP BY 
    UPPER(dc.customer_state::text), 
    INITCAP(dp.categoria), 
    EXTRACT(year FROM fp.order_purchase_timestamp), 
    EXTRACT(month FROM fp.order_purchase_timestamp), 
    TRIM(BOTH FROM TO_CHAR(fp.order_purchase_timestamp, 'Month'::text));

-- ============================================================
-- 6. VALIDAÇÃO DAS CONSTRAINTS
-- ============================================================

-- Verificar constraints criadas
SELECT 
    conname AS constraint_name,
    contype AS constraint_type,
    conrelid::regclass AS table_name
FROM pg_constraint
WHERE conrelid IN (
    'public.fato_pedidos'::regclass,
    'public.fato_itens'::regclass
)
ORDER BY conrelid, contype;

-- ============================================================
-- NOTAS TÉCNICAS:
-- ============================================================
-- contype: p = PRIMARY KEY, f = FOREIGN KEY, n = NOT NULL
-- ON DELETE RESTRICT: Impede exclusão se houver registros dependentes
-- ON DELETE CASCADE: Exclui registros dependentes automaticamente (só em fato_itens → fato_pedidos)
-- ON UPDATE CASCADE: Atualiza FKs automaticamente se PK mudar
-- ============================================================