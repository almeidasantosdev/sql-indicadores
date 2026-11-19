# Indicadores em SQL

Consultas sobre a mesma base fictícia de pedidos do repositório [analise-operacional](https://github.com/almeidasantosdev/analise-operacional). Aqui a base já chega tratada. O trabalho é cruzar, agregar e conferir.

Não há cliente, documento, endereço nem nome de pessoa.

## O que as consultas respondem

A receita das linhas entregues fecha em 779.779,75, igual à soma do CSV.

| Consulta | Leitura desta semente |
| --- | --- |
| `04_centros.sql` | Quilha no prazo em 24,10%, atraso médio de 1,56 dia. Leme em 78,39% |
| `06_margem_canal.sql` | Site com desconto médio de 16,46% e margem de 49,21%. Balcão com 4,12% e 55,54% |
| `05_pareto.sql` | O 10º produto passa de 80% da receita. Os três primeiros somam 41,72% |
| `03_kpis_mensais.sql` | Receita, margem, prazo, cancelamento e diferença contra o mês anterior |
| `02_checagens.sql` | Id duplicado, SKU sem cadastro e entrega anterior ao pedido ficam em zero. Margem negativa fica em 2 |

`LAG` mede a variação mensal da receita. `ROW_NUMBER` e a soma acumulada montam o pareto. As datas estão em texto `AAAA-MM-DD`, então o mês sai com `substr`. Essa função existe no SQLite e no PostgreSQL.

## Como rodar

Python 3.12 ou superior, sem pacote externo. O script cria um SQLite em memória, carrega `dados/` e falha se a receita divergir do CSV ou se uma checagem de integridade vier maior que zero.

```powershell
python scripts/rodar.py
```

No PostgreSQL, crie as tabelas com `sql/01_tabelas.sql` e carregue os CSV com cabeçalho. As consultas de `02` a `06` seguem iguais.

## Estrutura

```text
dados/itens.csv            fato tratada
dados/produtos.csv         cadastro fictício
sql/01_tabelas.sql         produtos e itens
sql/02_checagens.sql       integridade e margem negativa
sql/03_kpis_mensais.sql    série e variação
sql/04_centros.sql         prazo e atraso
sql/05_pareto.sql          concentração da receita
sql/06_margem_canal.sql    margem e desconto
scripts/rodar.py           carga, execução e conferência
```

As regras de receita, prazo e cancelamento estão no dicionário do outro repositório. Receita, margem e desconto médio usam só linha entregue. Cancelamento usa todas as linhas.
