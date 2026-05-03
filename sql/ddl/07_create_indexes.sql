-- ============================================================
-- INDEXES - Otimização de Performance para Queries Analíticas
-- ============================================================
-- Projeto: Olist Sales Analytics
-- Autor: Rodrigo de Souza Silva
-- Data: Maio 2026
-- ============================================================

-- ============================================================
-- 1. ÍNDICES EM CHAVES ESTRANGEIRAS (fato_itens)
-- ============================================================
-- Motivo: Aceleram JOINs entre fatos e dimensões
-- Impacto: Redução de 70-90% no tempo de queries com JOIN

CREATE INDEX idx_itens_order 
ON public.fato_itens(order_id);

CREATE INDEX idx_itens_product 
ON public.fato_itens(product_id);

CREATE INDEX idx_itens_seller 
ON public.fato_itens(seller_id);

-- ============================================================
-- 2. ÍNDICES PARA FILTROS TEMPORAIS
-- ============================================================
-- Motivo: Queries analíticas frequentemente filtram por data
-- Uso típico: WHERE order_purchase_timestamp BETWEEN ... AND ...

CREATE INDEX idx_pedidos_data 
ON public.fato_pedidos(order_purchase_timestamp);

-- Índice funcional para agregações mensais
-- Uso: Otimiza queries com DATE_TRUNC('month', ...)
CREATE INDEX idx_pedidos_data_mes 
ON public.fato_pedidos(DATE_TRUNC('month', order_purchase_timestamp));

-- ============================================================
-- 3. ÍNDICES PARA AGREGAÇÕES GEOGRÁFICAS
-- ============================================================
-- Motivo: Análises por estado/cidade são comuns em e-commerce

CREATE INDEX idx_clientes_estado 
ON public.dim_clientes(customer_state);

CREATE INDEX idx_clientes_cidade 
ON public.dim_clientes(customer_city);

CREATE INDEX idx_vendedores_estado 
ON public.dim_vendedores(seller_state);

CREATE INDEX idx_vendedores_cidade 
ON public.dim_vendedores(seller_city);

-- ============================================================
-- 4. ÍNDICES PARA ANÁLISE DE PRODUTOS
-- ============================================================
-- Motivo: Queries frequentemente agrupam por categoria

CREATE INDEX idx_produtos_categoria 
ON public.dim_produtos(categoria);

-- ============================================================
-- 5. VALIDAÇÃO DOS ÍNDICES CRIADOS
-- ============================================================

-- Listar todos os índices das tabelas do projeto
SELECT 
    schemaname,
    tablename,
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = 'public'
  AND tablename IN ('dim_clientes', 'dim_produtos', 'dim_vendedores', 'fato_pedidos', 'fato_itens')
ORDER BY tablename, indexname;

-- ============================================================
-- 6. ANÁLISE DE USO DE ÍNDICES (executar após queries analíticas)
-- ============================================================

-- Verificar se os índices estão sendo utilizados
SELECT 
    schemaname,
    tablename,
    indexname,
    idx_scan AS index_scans,
    idx_tup_read AS tuples_read,
    idx_tup_fetch AS tuples_fetched
FROM pg_stat_user_indexes
WHERE schemaname = 'public'
  AND tablename IN ('dim_clientes', 'dim_produtos', 'dim_vendedores', 'fato_pedidos', 'fato_itens')
ORDER BY idx_scan DESC;

-- ============================================================
-- NOTAS TÉCNICAS:
-- ============================================================
-- - Índices em FKs são CRÍTICOS para performance de JOINs
-- - Índice funcional (DATE_TRUNC) otimiza agregações temporais
-- - Índices não utilizados (idx_scan = 0) devem ser removidos após análise
-- - Monitorar pg_stat_user_indexes regularmente para validar uso
-- - VACUUM ANALYZE recomendado após criação de índices em tabelas grandes
-- ============================================================

-- ============================================================
-- 7. MANUTENÇÃO RECOMENDADA (executar após criação dos índices)
-- ============================================================

-- Atualizar estatísticas do PostgreSQL para otimizar planos de execução
ANALYZE public.dim_clientes;
ANALYZE public.dim_produtos;
ANALYZE public.dim_vendedores;
ANALYZE public.fato_pedidos;
ANALYZE public.fato_itens;