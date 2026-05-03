-- ============================================================
-- QUERY 5: Análise de Custo de Frete por Categoria
-- ============================================================
-- Problema de Negócio:
--   CFO quer reduzir custos operacionais identificando 
--   categorias com frete desproporcional ao valor do produto.
--
-- Técnicas SQL:
--   - Agregação por categoria
--   - Cálculo de margem (frete/receita)
--   - HAVING para filtrar categorias relevantes
-- ============================================================

SELECT 
  dp.categoria,
  COUNT(DISTINCT fi.product_id) AS total_produtos,
  COUNT(DISTINCT fi.order_id) AS total_pedidos,
  ROUND(SUM(fi.price), 2) AS receita_produtos,
  ROUND(SUM(fi.freight_value), 2) AS custo_frete_total,
  ROUND(AVG(fi.price), 2) AS preco_medio_produto,
  ROUND(AVG(fi.freight_value), 2) AS frete_medio,
  ROUND(
    100.0 * SUM(fi.freight_value) / NULLIF(SUM(fi.price), 0),
    2
  ) AS percentual_frete_sobre_receita
FROM fato_itens fi
JOIN dim_produtos dp ON fi.product_id = dp.product_id
WHERE dp.categoria IS NOT NULL
GROUP BY dp.categoria
HAVING SUM(fi.price) > 5000  -- Apenas categorias com receita significativa
ORDER BY percentual_frete_sobre_receita DESC
LIMIT 20;

-- ============================================================
-- Insights Esperados:
-- - Categorias com frete desproporcional (candidatas a renegociação)
-- - Produtos de baixo valor com frete alto (prejudicam margem)
-- - Oportunidades de otimização logística por categoria
-- ============================================================