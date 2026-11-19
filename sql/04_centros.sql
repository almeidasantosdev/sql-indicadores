SELECT
    centro,
    COUNT(*) AS linhas_entregues,
    ROUND(AVG(no_prazo), 4) AS pct_no_prazo,
    ROUND(AVG(atraso_dias), 2) AS atraso_medio
FROM itens
WHERE situacao = 'entregue'
GROUP BY centro
ORDER BY pct_no_prazo, centro;
