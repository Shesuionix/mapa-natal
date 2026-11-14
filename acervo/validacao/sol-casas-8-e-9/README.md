# Sol nas casas 8 e 9

Os 24 casos reproduzidos a partir do [TSV de evidências](../../../docs/evidencias-posicoes.tsv) selecionaram a leitura solar esperada. O lote acrescenta 22 textos e preserva as leituras de Peixes na casa 8 e Aquário na casa 9. Com este lote, a biblioteca cobre as 144 combinações de Sol por signo e casa.

- [Evidências de origem](casos.tsv) registra a chave, o índice editorial e os parâmetros de cada entrada.
- [Resultado da seleção](selecao.tsv) registra o texto escolhido pelo motor em cada caso.
- [Regressão dos 15 mapas](regressao-15-mapas.tsv) registra os hashes das macros geradas em modo estrito, iguais aos do [lote anterior](../sol-casas-6-e-7/regressao-15-mapas.tsv).

A seleção solar dos 24 novos casos foi testada em prévia. O modo estrito também foi conferido nos 15 mapas já auditados. As amostras de [Escorpião na casa 8](compilacao/sol-scorpio-casa-8.log) e [Sagitário na casa 9](compilacao/sol-sagittarius-casa-9.log) compilaram em LuaLaTeX em modo de rascunho.

## Reproduzir

Com a versão da Swiss Ephemeris indicada na [auditoria](../../../docs/validade-posicoes.md), execute a partir da raiz do repositório.

```sh
python acervo/validacao/sol-casas-8-e-9/gerar-casos.py CAMINHO_DAS_EFEMERIDES . CAMINHO_DA_SAIDA
```

Para conferir uma entrada, execute o verificador a partir de `motor/`, com `NATAL_ENTRADA` apontando para o arquivo e `NATAL_EXIGIR_TEXTOS_PROPRIOS=0`. Passe a chave e o índice registrados no TSV.

```sh
texlua ../acervo/validacao/sol-casas-8-e-9/conferir.lua "Sun|Aries|8|false" 317
```
