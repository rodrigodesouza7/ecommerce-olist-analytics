-- ============================================================
-- QUERY 3: Análise Geográfica de Vendas por Estado
-- ============================================================
-- Problema de Negócio:
--   Diretor comercial quer identificar regiões com maior 
--   potencial para abertura de centros de distribuição.
--
-- Técnicas SQL:
--   - Agregação geográfica (GROUP BY estado)
--   - Window Function para calcular % do total
--   - Métricas de concentração (ticket médio, pedidos/cliente)
-- ============================================================

SELECT 
  dc.customer_state AS estado,
  COUNT(DISTINCT fp.order_id) AS total_pedidos,
  COUNT(DISTINCT dc.customer_id) AS total_clientes,
  ROUND(
    1.0 * COUNT(DISTINCT fp.order_id) / NULLIF(COUNT(DISTINCT dc.customer_id), 0),
    2
  ) AS pedidos_por_cliente,
  ROUND(SUM(fi.price + fi.freight_value), 2) AS receita_total,
  ROUND(AVG(fi.price + fi.freight_value), 2) AS ticket_medio,
  ROUND(
    100.0 * SUM(fi.price + fi.freight_value) / SUM(SUM(fi.price + fi.freight_value)) OVER (),
    2
  ) AS percentual_receita_nacional
FROM fato_pedidos fp
JOIN fato_itens fi ON fp.order_id = fi.order_id
JOIN dim_clientes dc ON fp.customer_id = dc.customer_id
WHERE dc.customer_state IS NOT NULL
GROUP BY dc.customer_state
ORDER BY receita_total DESC
LIMIT 15;

-- ============================================================
-- Insights Esperados:
-- - Estados com maior concentração de receita (ex: SP, RJ, MG)
-- - Regiões com alto ticket médio (maior poder aquisitivo)
-- - Oportunidades de expansão em estados subatendidos
-- ============================================================