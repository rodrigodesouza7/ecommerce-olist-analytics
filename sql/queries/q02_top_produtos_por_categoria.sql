-- ============================================================
-- QUERY 2: Top 3 Produtos Mais Lucrativos por Categoria
-- ============================================================
-- Problema de Negócio:
--   Gerente de produto precisa decidir quais itens manter em 
--   estoque prioritário e quais investir em marketing.
--
-- Técnicas SQL:
--   - Window Function RANK() com PARTITION BY
--   - Subconsulta para filtrar top 5 categorias
--   - QUALIFY (PostgreSQL 14+) para filtrar ranking
-- ============================================================

WITH receita_produtos AS (
  SELECT 
    dp.categoria,
    fi.product_id,
    SUM(fi.price) AS receita_total,
    COUNT(*) AS unidades_vendidas,
    ROUND(AVG(fi.price), 2) AS preco_medio
  FROM fato_itens fi
  JOIN dim_produtos dp ON fi.product_id = dp.product_id
  WHERE dp.categoria IS NOT NULL
  GROUP BY 1, 2
),
top_categorias AS (
  SELECT categoria
  FROM receita_produtos
  GROUP BY categoria
  ORDER BY SUM(receita_total) DESC
  LIMIT 5
)
SELECT 
  rp.categoria,
  rp.product_id,
  ROUND(rp.receita_total, 2) AS receita_total,
  rp.unidades_vendidas,
  rp.preco_medio,
  RANK() OVER (PARTITION BY rp.categoria ORDER BY rp.receita_total DESC) AS rank_categoria
FROM receita_produtos rp
WHERE rp.categoria IN (SELECT categoria FROM top_categorias)
  AND RANK() OVER (PARTITION BY rp.categoria ORDER BY rp.receita_total DESC) <= 3
ORDER BY rp.categoria, rank_categoria;

-- ============================================================
-- Insights Esperados:
-- - Produtos best-sellers por categoria
-- - Oportunidades de cross-sell (categorias complementares)
-- - Identificar produtos de alto giro vs. alto ticket
-- ============================================================