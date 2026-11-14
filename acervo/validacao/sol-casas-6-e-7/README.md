# Sol nas casas 6 e 7

Cada um dos 24 casos reproduzidos a partir do [TSV de evidências](../../../docs/evidencias-posicoes.tsv) selecionou a leitura solar esperada. O lote cobre os 12 signos nas duas casas, com 23 textos novos e a leitura já cadastrada de Libra na casa 6.

- [Evidências de origem](casos.tsv) registra a chave, o índice editorial e os parâmetros de cálculo de cada entrada.
- [Resultado da seleção](selecao.tsv) registra o texto escolhido pelo motor em cada caso.
- [Regressão dos 15 mapas](regressao-15-mapas.tsv) registra o SHA-256 das macros Lua. As seleções em modo estrito coincidiram com o [lote anterior](../sol-casas-2-e-5/regressao-15-mapas.tsv).

A seleção solar foi testada em prévia. As demais posições, casas e aspectos dessas entradas ainda podem exigir textos próprios para o modo estrito. Os casos de [Virgem na casa 6](compilacao/sol-virgo-casa-6.log) e [Libra na casa 7](compilacao/sol-libra-casa-7.log) também compilaram em LuaLaTeX em modo de rascunho.

## Reproduzir

Com a versão da Swiss Ephemeris indicada na [auditoria](../../../docs/validade-posicoes.md), execute a partir da raiz do repositório.

```sh
python acervo/validacao/sol-casas-6-e-7/gerar-casos.py CAMINHO_DAS_EFEMERIDES . CAMINHO_DA_SAIDA
```

Para conferir uma entrada gerada, execute o verificador a partir de `motor/`, com `NATAL_ENTRADA` apontando para o arquivo e `NATAL_EXIGIR_TEXTOS_PROPRIOS=0`. Passe a chave e o índice registrados no TSV.

```sh
texlua ../acervo/validacao/sol-casas-6-e-7/conferir.lua "Sun|Aries|6|false" 294
```
