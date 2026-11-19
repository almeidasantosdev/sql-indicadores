WITH por_sku AS (
    SELECT
        i.sku,
        p.produto,
        p.linha,
        SUM(i.receita_liquida) AS receita
    FROM itens AS i
    JOIN produtos AS p ON p.sku = i.sku
    WHERE i.situacao = 'entregue'
    GROUP BY i.sku, p.produto, p.linha
),
ordenado AS (
    SELECT
        sku,
        produto,
        linha,
        receita,
        SUM(receita) OVER (ORDER BY receita DESC, sku) AS acumulado,
        SUM(receita) OVER () AS total,
        ROW_NUMBER() OVER (ORDER BY receita DESC, sku) AS posicao
    FROM por_sku
)
SELECT
    posicao,
    sku,
    produto,
    linha,
    ROUND(receita, 2) AS receita,
    ROUND(acumulado / total, 4) AS participacao_acumulada
FROM ordenado
ORDER BY posicao;
