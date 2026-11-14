# Lua nas casas 9 e 10

Os 24 casos reproduzidos a partir do [TSV de evidências](../../../docs/evidencias-posicoes.tsv) selecionaram a leitura lunar esperada. O lote acrescenta 19 textos e preserva os cinco já cadastrados. As duas casas cobrem os 12 signos.

- [Evidências de origem](casos.tsv) registra a chave, o índice editorial e os parâmetros de cada entrada.
- [Resultado da seleção](selecao.tsv) registra o texto escolhido pelo motor em cada caso.
- [Regressão dos 15 mapas](regressao-15-mapas.tsv) registra os hashes das macros geradas em modo estrito, iguais aos do [lote anterior](../lua-casas-7-e-8/regressao-15-mapas.tsv).

A seleção lunar foi testada em prévia. O modo estrito foi conferido nos 15 mapas já auditados. As amostras de [Sagitário na casa 9](compilacao/lua-sagittarius-casa-9.log) e [Capricórnio na casa 10](compilacao/lua-capricorn-casa-10.log) compilaram em LuaLaTeX em modo de rascunho.

## Reproduzir

Com a versão da Swiss Ephemeris indicada na [auditoria](../../../docs/validade-posicoes.md), execute a partir da raiz do repositório.

```sh
python acervo/validacao/lua-casas-9-e-10/gerar-casos.py CAMINHO_DAS_EFEMERIDES . CAMINHO_DA_SAIDA
```

Para conferir uma entrada, execute o verificador a partir de `motor/`, com `NATAL_ENTRADA` apontando para o arquivo e `NATAL_EXIGIR_TEXTOS_PROPRIOS=0`. Passe a chave e o índice registrados no TSV.

```sh
texlua ../acervo/validacao/lua-casas-9-e-10/conferir.lua "Moon|Taurus|9|false" 430
```
