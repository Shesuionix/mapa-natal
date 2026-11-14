# Lua nas casas 11 e 12

Os 24 casos reproduzidos a partir do [TSV de evidências](../../../docs/evidencias-posicoes.tsv) selecionaram a leitura lunar esperada. O lote acrescenta 20 textos e preserva os quatro já cadastrados. A biblioteca passa a cobrir as 144 combinações da Lua.

- [Evidências de origem](casos.tsv) registra a chave, o índice editorial e os parâmetros de cada entrada.
- [Resultado da seleção](selecao.tsv) registra o texto escolhido pelo motor.
- [Regressão dos 15 mapas](regressao-15-mapas.tsv) registra os hashes das macros geradas em modo estrito, iguais aos do [lote anterior](../lua-casas-9-e-10/regressao-15-mapas.tsv).

A seleção lunar foi testada em prévia. O modo estrito foi conferido nos 15 mapas já auditados. As amostras de [Touro na casa 11](compilacao/lua-taurus-casa-11.log) e [Gêmeos na casa 12](compilacao/lua-gemini-casa-12.log) compilaram em LuaLaTeX em modo de rascunho.

## Reproduzir

Com a versão da Swiss Ephemeris indicada na [auditoria](../../../docs/validade-posicoes.md), execute a partir da raiz do repositório.

```sh
python acervo/validacao/lua-casas-11-e-12/gerar-casos.py CAMINHO_DAS_EFEMERIDES . CAMINHO_DA_SAIDA
```

Para conferir uma entrada, execute o verificador a partir de `motor/`, com `NATAL_ENTRADA` apontando para o arquivo e `NATAL_EXIGIR_TEXTOS_PROPRIOS=0`. Passe a chave e o índice registrados no TSV.

```sh
texlua ../acervo/validacao/lua-casas-11-e-12/conferir.lua "Moon|Aries|11|false" 449
```
