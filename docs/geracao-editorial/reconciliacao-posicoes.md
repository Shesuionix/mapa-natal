# Extensão evidenciada da fila — 21/11/2026

Base anterior: b71cb7702458306716323b76e36a092b9c3923ef. Acrescentadas 296 chaves de posições à fila, sem alterar suas linhas anteriores nem publicar novas interpretações.

As 356 leituras retidas do lote 32 foram comparadas com docs/evidencias-posicoes.tsv. Encontradas 296 evidências: 144 de Lilith osculante, 144 de Nodo Norte verdadeiro e 8 de Vertex. As outras 60, todas de Vertex, permanecem em aberto e fora desta extensão.

As 296 foram recalculadas com Swiss Ephemeris 2.10.03, os hashes dos três arquivos de efemérides exigidos pelo gerador foram conferidos e todas reproduziram signo, casa e marcador de movimento após o arredondamento em minutos usado pelo leitor. Variante, parâmetros e resultados estão em reconciliacao-296-posicoes.tsv. O formato histórico da fila não possui coluna de variante; o arquivo de proveniência preserva essa informação indispensável à reprodução.

O diagnóstico anterior de ausência de evidência para todas as 356 estava incorreto. O bloqueio imediato era sua ausência da fila aceita pelo publicador. O módulo cp312 local funciona com o runtime Python 3.12 disponível; não foi necessário instalar outro ambiente.

## Saldo após a extensão

| Indicador | Quantidade |
|---|---:|
| Publicadas | 5.635 |
| Linhas na fila | 21.169 |
| Pendentes na fila | 16.865 |
| União catálogo e fila | 22.500 |
| Cobertura dessa união | 25,04% |

As pendências são 296 posições, 12 estacionárias, 4.939 aspectos e 11.618 casas. O universo histórico anterior continua registrado como 22.204 e 25,38%; a variação do percentual decorre da extensão do denominador. As 296 já têm rascunhos no lote 32: reaproveitá-los e conferir o estado editorial antes de publicar, evitando nova geração.

## Reprodução

Na raiz do repositório, execute:

```sh
python ferramentas/verificar-reconciliacao-posicoes.py DIRETORIO_EFEMERIDES --deps DIRETORIO_MODULO_SWISSEPH
```

O parâmetro --deps é opcional se swisseph já estiver importável. O script usa o mesmo contrato de API do gerador existente e interrompe em caso de versão, hash ou chave divergente. Efemérides e dependências locais não são incorporadas por esta atualização.

Esta mudança estende a fila de trabalho e registra evidência. Não altera a biblioteca LaTeX, não inclui as 60 posições em aberto e não resolve a manutenção editorial pendente do lote 22.
