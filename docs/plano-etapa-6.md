# Plano de execução da etapa 6

A etapa 6 prepara e valida um texto próprio para cada combinação válida no contrato de produção. O motor seleciona as leituras de forma determinística, com rastreabilidade para a posição, a casa ou o aspecto que sustenta cada texto. A composição serve às prévias de desenvolvimento. A revisão de apresentação e layout começa após o fechamento editorial.

## Linha de base

Referência do catálogo e das entradas em 14 de novembro de 2026. [Versão usada no levantamento](https://github.com/Shesuionix/mapa-natal/commit/e9f233cd5e3a4fa33f47fb699f75ccbf64beef85)

| Seção | Chaves demonstradas ou observadas | Com texto próprio | Sem texto próprio |
|---|---:|---:|---:|
| Posições sem marca estacionária | 3.684 | 467 | 3.217 |
| Posições estacionárias observadas | 1 | 1 | 0 |
| Eixos | 24 | 24 | 0 |
| Casas na amostra ampliada | 2.679 | 179 | 2.500 |
| Aspectos na amostra ampliada | 5.653 | 660 | 4.993 |
| Total neste inventário | **12.041** | **1.331** | **10.710** |

O inventário ampliado reúne 247 entradas distintas. São 15 mapas de referência e 232 entradas distintas de 240 casos solares e lunares publicados no acervo. Os 15 mapas passaram em modo estrito. Os casos solares e lunares selecionaram o texto da posição-alvo em prévia e, no inventário ampliado, forneceram evidências de geometria para as casas e os aspectos.

O percentual é **11,1% no inventário ampliado**, com 1.331 textos para 12.041 chaves. As 10.710 lacunas são o volume conhecido com as chaves atuais e as regras das amostras. Parte das chaves pode ficar fora do perfil de produção se a regra definitiva excluir o exemplo que a demonstra. Outras chaves podem ser descobertas. O total da etapa será apurado para o perfil de produção versionado. Sol e Lua já cobrem as 144 posições demonstradas de cada um.

O inventário registra a lista de lacunas e os maiores orbes observados por par e tipo. Os 60 casos em aberto de Vertex e as posições estacionárias ainda sem busca própria ficam fora do total demonstrado. [Inventário ampliado](inventario-etapa-6.txt) · [Validade das posições](validade-posicoes.md) · [Validade de casas e aspectos](validade-casas-aspectos.md)

## Unidade de trabalho e contagem

| Seção | Dados que distinguem a leitura |
|---|---|
| Posições | Corpo ou ponto, signo, casa e movimento editorial. O grau localiza a ocorrência. O movimento estacionário depende da marca no bloco de posições. |
| Eixos | Eixo e par ordenado de signos opostos. A biblioteca já cobre os 12 pares de cada eixo. |
| Casas | Número, signo da cúspide, ocupantes com as respectivas posições e posição do regente tradicional. Para textos novos, a chave inclui o aspecto do regente com menor orbe e as posições de seus extremos, ou a ausência de aspecto. O empate segue a ordem canônica implementada no motor. As leituras antigas conservam as dependências já revisadas. |
| Aspectos | Par em ordem canônica, tipo e posição de cada extremo. Para corpos e pontos, entram signo, casa e movimento editorial. Para ângulos, entra o signo. Orbe e fase são contexto da ocorrência. |

Uma combinação ganha texto próprio quando muda algum dado da chave. Cada leitura de aspecto aparece uma vez no relatório e pode receber referências cruzadas. Se a leitura mencionar um regente moderno ou outro dado adicional, a dependência precisa ser verificável no momento da seleção. Uma mudança nas chaves que altere a granularidade exige comparar o efeito na biblioteca e registrar a decisão antes de expandi-la.

Use o mesmo catálogo para contar e selecionar. Para cada chave, registre o estado de validade, a evidência e o estado editorial. Uma combinação demonstrada deve apontar para uma entrada reproduzível ou uma prova compatível com o perfil. Uma exclusão deve indicar a regra que a torna impossível ou que a deixa fora do contrato. Uma busca sem ocorrência deixa a combinação em aberto. Dentro das combinações demonstradas, separe texto ausente, texto selecionado pelo motor e texto revisado pelo operador.

## Fechar o perfil de produção

O cálculo de origem fornece as posições e as relações ao motor. O perfil descreve quais combinações podem chegar por esse cálculo. Revise cada decisão abaixo e publique a versão junto do inventário.

| Decisão | Evidência atual | Resultado necessário |
|---|---|---|
| Sistema de casas, faixa de datas e latitudes | Há evidências com Placidus e Campanus. As faixas de busca documentadas servem à auditoria. | Identificar os sistemas usados na operação e como a fonte trata limites geográficos e cúspides. Definir o domínio que a cobertura deve garantir. |
| Vertex e Fortuna | O Vertex tem ocorrências na casa 10 quando coincide com o MC no minuto exportado. Os quatro mapas A a D sustentam a fórmula diurna e noturna de Fortuna usada na auditoria. | Registrar a fórmula, a regra de atribuição de casa e a ordem de arredondamento. Resolver as 60 chaves em aberto por evidência ou por uma regra do perfil. |
| Nodo Norte e Lilith | Os deltas de A a D são compatíveis com as variantes médias. A auditoria de posições também reúne evidências das variantes alternativas. | Confirmar a variante usada pela fonte ou declarar as variantes aceitas e refazer a contagem. |
| Movimento estacionário | O caso 06 tem marca explícita em Netuno. A busca de posições diretas e retrógradas evita velocidades próximas de zero. | Registrar o critério de exportação de `Stationary` e verificar que signos e casas são atingíveis para cada corpo elegível. |
| Orbes máximos | As entradas de teste usam 6° entre corpos ou pontos e 3° em pares com ângulos. Os mapas de referência têm orbes maiores. O motor verifica divergência geométrica com tolerância de 1,5′. | Recuperar as configurações de orbe por par e tipo na fonte. A tolerância geométrica e os maiores orbes já observados têm funções distintas do limite de seleção. |
| Política dos aspectos que entram na leitura de uma casa | O motor escolhe o aspecto fornecido de menor orbe que envolve o regente tradicional, com as exceções revisadas no catálogo. | Confirmar quais aspectos a fonte exporta, incluindo os ângulos, e conservar a mesma regra de seleção entre a auditoria e a geração. |

Se a fonte tiver um perfil exportável, use-o como referência. Se faltar uma definição verificável, documente a lacuna e apresente um perfil próprio para decisão, indicando como a escolha afetaria os mapas já aceitos e os textos já escritos. As convenções dos casos sintéticos continuam identificadas como regras da auditoria.

## Ordem de execução

1. **Perfil.** Identificar a configuração real de exportação e registrar as regras acima. Conferir que cada entrada de referência continua classificada de forma explícita sob o perfil.
2. **Inventário.** Gerar chaves candidatas dentro do perfil e aplicar os filtros geométricos. Reaproveitar as 247 entradas e ampliar a busca por pontos de fronteira, latitudes, sistemas, movimentos e orbes. Para cada chave, registrar uma ocorrência, uma exclusão justificada ou a pendência. Uma amostra cuja contagem estabilizou ainda é uma amostra. Para declarar cobertura universal, é necessária enumeração exaustiva no domínio aceito ou uma prova que resolva as chaves restantes.
3. **Produção.** Seguir com as posições demonstradas em paralelo à auditoria das chaves contextuais. O próximo lote é Mercúrio na casa 1, com 24 combinações demonstradas de signo e movimento. A cada lote, conferir a seleção em prévia, compilar amostras e reexecutar os mapas de referência em modo estrito. Para casas e aspectos, priorizar lotes de entradas que acrescentem chaves demonstradas do perfil e verificar o relatório inteiro em modo estrito quando o mapa estiver coberto.
4. **Revisão e aceite.** O operador revisa o texto e a adequação ao dado que o seleciona. Registrar cobertura por seção e por chave, testar fronteiras e executar o conjunto de validação em modo estrito. O critério de conclusão é zero chave válida sem texto próprio revisado, com o domínio coberto demonstrado. Os relatórios devem conservar a cobertura completa e bloquear lacunas de texto em modo estrito. Depois desse aceite, começar a revisão de apresentação e layout.

## Cronograma de referência

A referência de capacidade é de 22 textos por lote e seis minutos de execução por lote, baseada no ritmo recente de posições. O cenário usa cinco lotes por dia de produção. O esforço de revisão humana fica fora das projeções. Casas e aspectos podem ter um ritmo diferente e devem ter o primeiro lote cronometrado antes de usar essa referência para marcar uma entrega.

| Volume | Textos faltantes | Lotes de 22 | Execução a seis minutos por lote | Dias a cinco lotes |
|---|---:|---:|---:|---:|
| Posições já demonstradas | 3.217 | 147 | 14 h 42 min | 30 |
| Inventário ampliado inteiro | 10.710 | 487 | 48 h 42 min | 98 |

O cronograma de fechamento depende do perfil, da contagem final de chaves e do tempo de revisão do operador. O cenário de 98 dias dimensiona o inventário conhecido com a capacidade atual. Ele serve para planejar a produção e reestimar o prazo quando o perfil e o ritmo dos textos contextuais forem medidos. O próximo marco de planejamento é publicar as regras de exportação, ou a proposta de perfil próprio acompanhada da comparação com os mapas de referência.

## Reproduzir a contagem

Na raiz do repositório, com Python 3.10 ou superior e `texlua` disponíveis:

```sh
python ferramentas/auditar-cobertura-etapa-6.py > inventario-etapa-6.txt
```

A ferramenta abre os mapas de referência e as entradas descritas pelos arquivos `casos.tsv` do acervo, desduplica o conteúdo após normalizar as quebras de linha e chama o inventário Lua. O inventário valida a geometria dos exemplos e imprime as chaves sem texto próprio. Para reproduzir a linha de base, use a versão de catálogo e entradas indicada acima, junto da ferramenta publicada com este plano. Em um catálogo mais recente, a mesma execução mede a cobertura atual do acervo.
