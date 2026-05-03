-- ============================================================
-- VIEW: Análise Final - Receita por Estado, Categoria e Período
-- ============================================================
-- Uso: Dashboard executivo para análise multidimensional
-- Granularidade: Estado + Categoria + Ano + Mês
-- ============================================================

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
-- Exemplo de Uso:
-- SELECT * FROM vw_analise_final 
-- WHERE ano = 2017 AND estado = 'SP' 
-- ORDER BY receita DESC LIMIT 10;
-- ============================================================