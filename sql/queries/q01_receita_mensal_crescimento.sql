-- ============================================================
-- QUERY 1: Evolução da Receita Mensal com Crescimento
-- ============================================================
-- Problema de Negócio: 
--   CEO precisa monitorar crescimento mensal da receita para 
--   identificar tendências e sazonalidades.
--
-- Técnicas SQL:
--   - DATE_TRUNC para agregação mensal
--   - Window Function LAG() para comparar com mês anterior
--   - Cálculo de percentual de crescimento
-- ============================================================

WITH receita_mensal AS (
  SELECT 
    DATE_TRUNC('month', fp.order_purchase_timestamp) AS mes,
    COUNT(DISTINCT fp.order_id) AS total_pedidos,
    SUM(fi.price + fi.freight_value) AS receita_total,
    ROUND(AVG(fi.price + fi.freight_value), 2) AS ticket_medio
  FROM fato_pedidos fp
  JOIN fato_itens fi ON fp.order_id = fi.order_id
  GROUP BY 1
)
SELECT 
  TO_CHAR(mes, 'YYYY-MM') AS mes,
  total_pedidos,
  ROUND(receita_total, 2) AS receita_total,
  ticket_medio,
  LAG(receita_total) OVER (ORDER BY mes) AS receita_mes_anterior,
  ROUND(
    100.0 * (receita_total - LAG(receita_total) OVER (ORDER BY mes)) 
    / NULLIF(LAG(receita_total) OVER (ORDER BY mes), 0),
    2
  ) AS crescimento_percentual
FROM receita_mensal
ORDER BY mes;

-- ============================================================
-- Insights Esperados:
-- - Identificar meses de pico de vendas (ex: Black Friday, Natal)
-- - Detectar quedas sazonais ou problemas operacionais
-- - Calcular CAGR (taxa de crescimento anual composta)
-- ============================================================