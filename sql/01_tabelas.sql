CREATE TABLE produtos (
    sku text PRIMARY KEY,
    produto text NOT NULL,
    linha text NOT NULL,
    preco_tabela numeric NOT NULL,
    custo_unitario numeric NOT NULL
);

CREATE TABLE itens (
    id_linha text PRIMARY KEY,
    pedido text NOT NULL,
    data_pedido text NOT NULL,
    centro text NOT NULL,
    canal text NOT NULL,
    sku text NOT NULL,
    quantidade integer NOT NULL,
    preco_tabela numeric NOT NULL,
    desconto numeric NOT NULL,
    custo_unitario numeric NOT NULL,
    data_prometida text NOT NULL,
    data_entrega text,
    situacao text NOT NULL,
    receita_liquida numeric NOT NULL,
    custo_total numeric NOT NULL,
    margem numeric NOT NULL,
    no_prazo integer,
    atraso_dias integer
);
