WITH mensal AS (
    SELECT
        substr(data_pedido, 1, 7) AS mes,
        SUM(CASE WHEN situacao = 'entregue' THEN receita_liquida ELSE 0 END) AS receita,
        SUM(CASE WHEN situacao = 'entregue' THEN margem ELSE 0 END) AS margem,
        SUM(CASE WHEN situacao = 'entregue' AND no_prazo = 1 THEN 1 ELSE 0 END) AS no_prazo,
        SUM(CASE WHEN situacao = 'entregue' THEN 1 ELSE 0 END) AS entregues,
        SUM(CASE WHEN situacao = 'cancelado' THEN 1 ELSE 0 END) AS cancelados,
        COUNT(*) AS linhas
    FROM itens
    GROUP BY substr(data_pedido, 1, 7)
)
SELECT
    mes,
    ROUND(receita, 2) AS receita,
    ROUND(margem, 2) AS margem,
    ROUND(margem / NULLIF(receita, 0), 4) AS margem_pct,
    ROUND(1.0 * no_prazo / NULLIF(entregues, 0), 4) AS pct_no_prazo,
    ROUND(1.0 * cancelados / linhas, 4) AS taxa_cancelamento,
    ROUND(receita - LAG(receita) OVER (ORDER BY mes), 2) AS delta_receita
FROM mensal
ORDER BY mes;
