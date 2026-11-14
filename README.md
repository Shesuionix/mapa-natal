# Mapa Natal

Projeto privado para produzir relatórios natais sob encomenda. O cliente recebe o PDF. O motor e a biblioteca editorial são de uso interno.

## Conteúdo

- `editorial/`: fontes LaTeX e PDFs dos lotes de leitura.
- `demonstrativo/`: versão editorial consolidada, incluindo a edição temática com roda TikZ e tabelas.
- `base/`: código de referência do motor LuaLaTeX. A proveniência e as licenças dos recursos da base precisam ser verificadas antes do uso comercial.
- [Escopo](docs/escopo.md) — decisões de produto, critérios de entrega e pendências.
- [Acervo](acervo/) — relatórios, logs, versões de trabalho e casos descartados.

## Compilar o demonstrativo localmente

Na pasta `demonstrativo`, execute duas vezes:

```sh
lualatex -no-shell-escape -interaction=nonstopmode -halt-on-error mapa-natal-demonstrativo-integrado.tex
```

É necessário ter LuaLaTeX, Latin Modern e os pacotes LaTeX usados no fonte, incluindo TikZ, fontspec, geometry, hyperref, booktabs e longtable.
