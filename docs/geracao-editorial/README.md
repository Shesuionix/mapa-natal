# Fila de redação da etapa 6

A [lista de chaves faltantes](textos-faltantes.tsv) reúne **20.873 combinações demonstradas** que ainda precisam de texto próprio.

| Seção | Textos faltantes |
|---|---:|
| Posições diretas e retrógradas | 2.921 |
| Posições estacionárias | 1.295 |
| Casas | 11.618 |
| Aspectos | 5.039 |
| Eixos | 0 |
| **Total** | **20.873** |

A lista inclui 9.110 novos contextos de casas verificados com recortes dos aspectos recebidos. A validade das combinações ainda em investigação, incluindo 68 posições do Vertex, precisa ser estabelecida antes de incluí-las na fila.

Use as [instruções de redação](instrucoes-modelo.md) com um lote de chaves da mesma seção. O modelo entrega uma linha JSONL por chave, com subtítulo e dois parágrafos em português do Brasil. A coluna de evidência da lista serve à auditoria.

Na raiz do projeto, o [script de lotes](../../ferramentas/lote-textos-etapa-6.py) pode preparar a entrada e conferir o formato da resposta.

```sh
python ferramentas/lote-textos-etapa-6.py preparar docs/geracao-editorial/textos-faltantes.tsv posicoes 1 12 lote.jsonl
python ferramentas/lote-textos-etapa-6.py verificar lote.jsonl resposta.jsonl
```
