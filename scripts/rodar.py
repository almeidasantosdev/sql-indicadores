"""Carrega os CSV tratados e executa as consultas em SQLite."""

from __future__ import annotations

import csv
import sqlite3
from decimal import Decimal
from pathlib import Path

RAIZ = Path(__file__).resolve().parents[1]
REGRAS_ZERADAS = {"id_duplicado", "sku_sem_cadastro", "entrega_antes_do_pedido"}


def carregar(conexao: sqlite3.Connection) -> None:
    esquema = (RAIZ / "sql" / "01_tabelas.sql").read_text(encoding="utf-8")
    conexao.executescript(esquema)
    for tabela in ("produtos", "itens"):
        with (RAIZ / "dados" / f"{tabela}.csv").open(encoding="utf-8", newline="") as arquivo:
            leitor = csv.DictReader(arquivo)
            colunas = leitor.fieldnames or []
            linhas = []
            for registro in leitor:
                linha = []
                for coluna in colunas:
                    valor = registro[coluna]
                    linha.append(None if valor == "" else valor)
                linhas.append(linha)
        marcas = ", ".join("?" for _ in colunas)
        conexao.executemany(
            f"INSERT INTO {tabela} ({', '.join(colunas)}) VALUES ({marcas})",
            linhas,
        )
    conexao.commit()


def receita_do_csv() -> Decimal:
    total = Decimal("0")
    with (RAIZ / "dados" / "itens.csv").open(encoding="utf-8", newline="") as arquivo:
        for registro in csv.DictReader(arquivo):
            if registro["situacao"] == "entregue":
                total += Decimal(registro["receita_liquida"])
    return total


def executar() -> None:
    conexao = sqlite3.connect(":memory:")
    conexao.row_factory = sqlite3.Row
    carregar(conexao)
    receita_sql = Decimal(str(conexao.execute(
        "SELECT ROUND(SUM(receita_liquida), 2) FROM itens WHERE situacao = 'entregue'"
    ).fetchone()[0]))
    receita_csv = receita_do_csv()
    if receita_sql != receita_csv:
        raise SystemExit(f"Receita divergente: SQL {receita_sql} e CSV {receita_csv}")

    for caminho in sorted((RAIZ / "sql").glob("[0-9][0-9]_*.sql")):
        if caminho.name == "01_tabelas.sql":
            continue
        print(f"\n## {caminho.name}")
        consulta = caminho.read_text(encoding="utf-8")
        for linha in conexao.execute(consulta):
            print(dict(linha))
            if caminho.name == "02_checagens.sql" and linha["regra"] in REGRAS_ZERADAS and linha["ocorrencias"] != 0:
                raise SystemExit(f"Checagem falhou: {linha['regra']} = {linha['ocorrencias']}")
    print(f"\nReceita entregue conferida: {receita_sql}")


if __name__ == "__main__":
    executar()
