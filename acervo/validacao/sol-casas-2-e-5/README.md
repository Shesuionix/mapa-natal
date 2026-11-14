# Sol nas casas 2 e 5

Os 24 mapas deste lote foram reproduzidos do [TSV de evidências](../../../docs/evidencias-posicoes.tsv). Cada entrada confirmou a seleção de um dos novos textos solares. As duas casas agora cobrem os 12 signos.

- [Evidências de origem](casos.tsv) registra a chave, o índice editorial e os parâmetros de cálculo de cada entrada.
- [Resultado da seleção](selecao.tsv) registra o texto escolhido pelo motor em cada caso.
- [Regressão dos 15 mapas](regressao-15-mapas.tsv) registra o SHA-256 das macros Lua. Os resultados do modo estrito são idênticos aos do [lote anterior](../sol-casas-3-e-4/regressao-15-mapas.tsv).

A seleção solar foi testada em prévia. Outras combinações dessas entradas podem precisar de textos próprios para a geração em modo estrito. Os 15 mapas de referência e do lote sintético anterior passaram em modo estrito.

Os casos de [Aquário na casa 2](compilacao/sol-aquarius-casa-2.log) e [Leão na casa 5](compilacao/sol-leo-casa-5.log) passaram também pela compilação LuaLaTeX em modo de rascunho.

## Reproduzir

Com a versão da Swiss Ephemeris indicada na [auditoria](../../../docs/validade-posicoes.md), execute a partir da raiz do repositório.

```sh
python acervo/validacao/sol-casas-2-e-5/gerar-casos.py CAMINHO_DAS_EFEMERIDES . CAMINHO_DA_SAIDA
```

Para conferir uma entrada gerada, execute o verificador a partir de `motor/`, com `NATAL_ENTRADA` apontando para o arquivo e `NATAL_EXIGIR_TEXTOS_PROPRIOS=0`. Passe a chave e o índice registrados no TSV.

```sh
texlua ../acervo/validacao/sol-casas-2-e-5/conferir.lua "Sun|Aquarius|2|false" 280
```
