# Fechamento das 288 estacionárias suplementares

Data: 21/11/2026. Base: `1e73a8d3f58d0b95b58579371bfae8b2f06407d7`. Autorização de Samuel para concluir, revisar e publicar as 288 combinações de Nodo Norte verdadeiro e Lilith osculante, nos 12 signos e nas 12 casas, com movimento estacionário.

## Publicação

| Lote | Textos | Escopo | Commit |
|---|---:|---|---|
| 34 | 100 | Lilith estacionária | `bccc1badecc7abcdc5ed879b936b49c482a497a0` |
| 35 | 100 | 44 Lilith e 56 Nodo Norte | `e8c8f3a4308af01187b47c5f5e92152330604fb3` |
| 36 | 88 | Nodo Norte estacionário | `6790691eb726ce8ffb8b1580be04ac09dfc54941` |

Os três commits estão confirmados em `origin/main`, cada um com texto e cadastro no mesmo commit. Foram 288 entradas novas em `motor/catalogo-editorial.lua` (IDs 4981 a 5268) e 288 macros em `motor/leituras-posicoes-v1.tex`. Nenhum ID ou chave foi duplicado.

## Revisão

Cada lote teve três segmentos contíguos (34/33/33 ou 30/29/29), redigidos por três agentes e revisados em cruzado A→B, B→C e C→A. Todos os segmentos fecharam com `revisao_concluida=true`, `correcoes_pendentes=[]` e hash aprovado pelo revisor.

As correções editoriais somam 56 no lote 34, 49 no lote 35 e 42 no lote 36, além de duas passadas de convergência que reduziram o molde sintático “X e pode Y” (20 ocorrências para 2 no bloco de Lilith). O coordenador removeu 9 rótulos sequenciais de signo e corrigiu um subtítulo com repetição no lote 34, com aprovação dos revisores sobre os novos hashes. A evidência de cada segmento está em `rodada/gaia34/lote-34-evidencias.json`, `lote-35-evidencias.json` e `lote-36-evidencias.json`.

Hashes finais por segmento:

| Lote | A | B | C |
|---|---|---|---|
| 34 | `e962f8de…acf3` | `6574c4a8…d2c2` | `e394ec1e…51b4` |
| 35 | `e39bc354…5b56` | `540500f5…e3d4` | `46b0ee03…a06a` |
| 36 | `8907962b…f57b` | `b56eb5f9…e14c` | `2f7d86e3…08e3` |

## Verificações

- **Formato:** 288/288 no `ferramentas/lote-textos-etapa-6.py verificar`, em três execuções.
- **Cadastro:** 288/288 com entrada no catálogo, macro única e prosa idêntica ao JSONL.
- **Seleção pelo motor:** 288/288 descritores passaram por `position_key` e `positions`. O teste usa descritores de posição, não uma captura completa de nascimento.
- **Compilação:** LuaLaTeX em três documentos técnicos, 288 macros instanciadas por `\csname`, 85 páginas e 476.413 bytes, sem erro fatal. Não é um relatório comercial diagramado.
- **Inventário:** executado pelo publicador na simulação e no envio de cada lote; os 288 textos foram integrados e conferidos.
- **Auditoria consolidada:** 0 erros; 0 pares de 5-gramas com sobreposição de 10% ou mais; 0 textos com 20% ou mais de 5-gramas de uma leitura publicada; 6 aberturas de quatro palavras repetidas duas vezes cada; 13 textos sem marcador lexical de estacionariedade, conferidos manualmente e com permanência na cena. Corpo entre 149 e 175 palavras, mediana 157.

## Saldo reconciliado

| Seção | Publicadas | Pendentes |
|---|---:|---:|
| Posições não estacionárias | 3.684 | 0 |
| Estacionárias | 1.584 | 0 |
| Eixos | 24 | 0 |
| Casas contextuais | 179 | 11.618 |
| Aspectos contextuais | 760 | 4.939 |
| **Total** | **6.231** | **16.557** |

A união do catálogo e da fila ampliada contém 22.788 identidades, com cobertura de 27,34%. O conjunto autorizado está fechado: as 1.584 estacionárias admitidas têm texto, e as 288 suplementares foram publicadas. A cobertura de 27,34% mede a fila conhecida, não uma enumeração universal de mapas.

## Consumo medido

| Agente | Passos | Entrada sem cache | Entrada com cache | Saída | Sem cache + saída |
|---|---:|---:|---:|---:|---:|
| Coordenador | 210 | 174.502 | 39.303.424 | 159.243 | 333.745 |
| redator-a | 216 | 119.935 | 41.368.192 | 261.966 | 381.901 |
| redator-b | 163 | 112.652 | 41.975.040 | 365.399 | 478.051 |
| redator-c | 101 | 113.990 | 22.534.144 | 312.969 | 426.959 |
| **Total** | **690** | **521.079** | **145.180.800** | **1.099.577** | **1.620.656** |

Por lote: 769.494 (34), 453.693 (35) e 397.468 (36). A soma arredondada dos três dá 1.620.655; o total medido nos snapshots é 1.620.656, diferença de arredondamento. Como os lotes 35 e 36 se sobrepuseram, a divisão usa atribuição por tarefa e metade do coordenador entre os dois; o total cumulative prevalece.

Estimativa original: 600.000 tokens. Desvio: +170,1%. Consumo por texto: 5.627 tokens sem cache mais saída. Não há custo em USD porque não foram encontradas tarifas verificáveis do provedor para a data; não foram aplicadas tarifas DeepSeek de outro modelo. Raciocínio já incluído na saída não foi somado outra vez.

## Limites

- 13 textos não usam marcador lexical de estacionariedade; a permanência está na cena, conferida manualmente.
- Restam algumas fórmulas de ligação repetidas (“costuma”, fechos aforísticos) que não formam série, mas seriam o primeiro alvo de uma manutenção de estilo.
- O teste de seleção usa descritores; a captura completa de um nascimento não foi simulada.
- A compilação valida a biblioteca em documento técnico, não o produto final.
- Aspectos e casas não foram trabalhados; as 60 exclusões de Vertex e o par de Netuno preservado seguem como estavam.

## Arquivos

- JSONL finais: `rodada/gaia34/lote-34-resposta.jsonl`, `lote-35-resposta.jsonl`, `lote-36-resposta.jsonl`.
- Manifestos: `rodada/gaia34/lote-34-manifesto.json`, `lote-35-manifesto.json`, `lote-36-manifesto.json`.
- Checkpoints: `rodada/gaia34/checkpoint-34.md`, `checkpoint-35.md`, `checkpoint-36.md`.
- Saldo: `rodada/gaia34/saldo-final.json`.
