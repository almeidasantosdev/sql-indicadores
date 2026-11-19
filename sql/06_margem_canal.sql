SELECT
    canal,
    ROUND(SUM(receita_liquida), 2) AS receita,
    ROUND(SUM(margem), 2) AS margem,
    ROUND(SUM(margem) / SUM(receita_liquida), 4) AS margem_pct,
    ROUND(AVG(desconto), 4) AS desconto_medio
FROM itens
WHERE situacao = 'entregue'
GROUP BY canal
ORDER BY margem_pct, canal;
