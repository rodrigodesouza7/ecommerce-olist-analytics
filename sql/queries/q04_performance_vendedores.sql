-- ============================================================
-- QUERY 4: Performance de Vendedores (Top 20 Sellers)
-- ============================================================
-- Problema de Negócio:
--   Marketplace precisa identificar top sellers para programas
--   de incentivo e detectar vendedores com baixa performance.
--
-- Técnicas SQL:
--   - Agregação por vendedor
--   - Métricas de volume e valor
--   - Ranking de sellers
-- ============================================================

SELECT 
  dv.seller_id,
  dv.seller_state,
  dv.seller_city,
  COUNT(DISTINCT fi.order_id) AS total_pedidos,
  COUNT(*) AS total_itens_vendidos,
  ROUND(SUM(fi.price), 2) AS receita_total,
  ROUND(AVG(fi.price), 2) AS preco_medio_produto,
  ROUND(SUM(fi.freight_value), 2) AS custo_frete_total,
  ROUND(
    100.0 * SUM(fi.freight_value) / NULLIF(SUM(fi.price), 0),
    2
  ) AS percentual_frete_sobre_receita
FROM fato_itens fi
JOIN dim_vendedores dv ON fi.seller_id = dv.seller_id
GROUP BY dv.seller_id, dv.seller_state, dv.seller_city
HAVING SUM(fi.price) > 1000  -- Filtrar apenas sellers com receita relevante
ORDER BY receita_total DESC
LIMIT 20;

-- ============================================================
-- Insights Esperados:
-- - Top sellers por receita e volume
-- - Vendedores com produtos de alto ticket vs. alto volume
-- - Sellers com custo de frete desproporcional (logística ineficiente)
-- ============================================================