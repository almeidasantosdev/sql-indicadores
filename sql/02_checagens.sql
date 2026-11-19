SELECT 'id_duplicado' AS regra, COUNT(*) - COUNT(DISTINCT id_linha) AS ocorrencias
FROM itens
UNION ALL
SELECT 'sku_sem_cadastro', COUNT(*)
FROM itens AS i
LEFT JOIN produtos AS p ON p.sku = i.sku
WHERE p.sku IS NULL
UNION ALL
SELECT 'entrega_antes_do_pedido', COUNT(*)
FROM itens
WHERE data_entrega IS NOT NULL
  AND data_entrega < data_pedido
UNION ALL
SELECT 'margem_negativa', COUNT(*)
FROM itens
WHERE situacao = 'entregue'
  AND margem < 0;
