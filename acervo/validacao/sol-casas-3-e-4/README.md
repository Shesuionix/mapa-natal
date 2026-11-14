# Sol nas casas 3 e 4

Os 24 mapas deste lote foram reproduzidos do [TSV de evidências](../../../docs/evidencias-posicoes.tsv). Cada arquivo exercita a seleção de uma combinação de signo e casa do Sol. Os casos confirmaram 22 textos novos e os dois já cadastrados, Capricórnio na casa 3 e Áries na casa 4.

- [Evidências de origem](casos.tsv) registra a chave, o índice editorial e os parâmetros de cálculo de cada entrada.
- [Resultado da seleção](selecao.tsv) registra o texto selecionado pelo motor para cada uma das 24 entradas.
- [Regressão dos 15 mapas](regressao-15-mapas.tsv) registra o SHA-256 das macros Lua geradas em modo estrito e conferidas contra a [auditoria anterior](../validacao-15-mapas.txt).

A seleção solar foi testada em prévia. Outras combinações presentes nessas entradas podem precisar de textos próprios para geração em modo estrito. Os 15 mapas de referência e do lote sintético anterior passaram em modo estrito.

Os casos de [Áries na casa 3](compilacao/sol-aries-casa-3.log) e [Touro na casa 4](compilacao/sol-taurus-casa-4.log) passaram também pela compilação LuaLaTeX em modo de rascunho.

## Reproduzir

Com a versão da Swiss Ephemeris indicada na [auditoria](../../../docs/validade-posicoes.md), execute a partir da raiz do repositório.

```sh
python acervo/validacao/sol-casas-3-e-4/gerar-casos.py CAMINHO_DAS_EFEMERIDES . CAMINHO_DA_SAIDA
```

Para conferir a seleção de uma entrada gerada, execute o verificador a partir de `motor/`, com `NATAL_ENTRADA` apontando para o arquivo e `NATAL_EXIGIR_TEXTOS_PROPRIOS=0`. Os argumentos são a chave e o índice registrados no TSV.

```sh
texlua ../acervo/validacao/sol-casas-3-e-4/conferir.lua "Sun|Aries|3|false" 248
```
