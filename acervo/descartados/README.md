# Descartados e testes negativos

As entradas com a linha original foram preservadas. Nas cópias de comparação, a única alteração foi retirar o aspecto incompatível.

| Caso | Aspecto rejeitado | Orbe informado | Orbe pelas posições | Registros |
|---|---|---:|---:|---|
| 01 | Fortuna em sextil com Vertex | 2°38′ | 52°36′ | [Entrada que falha](geometria/teste-01/teste-01-original-geometria.txt) · [Alteração original](geometria/teste-01/ALTERACOES.txt) · [Cópia aceita](../validacao/entradas/teste-01.txt) |
| 05 | Fortuna em trígono com Vertex | 2°28′ | 50°10′ | [Entrada que falha](geometria/teste-05/teste-05-original-geometria.txt) · [Alteração original](geometria/teste-05/ALTERACOES.txt) · [Cópia aceita](../validacao/entradas/teste-05.txt) |
| 06 | Fortuna em quadratura com Vertex | 6°22′ | 70°14′ | [Entrada que falha](geometria/teste-06/teste-06-original-geometria.txt) · [Alteração original](geometria/teste-06/ALTERACOES.txt) · [Cópia aceita](../validacao/entradas/teste-06.txt) |
| 07 | Fortuna em quadratura com Vertex | 2°43′ | 72°43′ | [Entrada que falha](geometria/teste-07/teste-07-original-geometria.txt) · [Alteração original](geometria/teste-07/ALTERACOES.txt) · [Cópia aceita](../validacao/entradas/teste-07.txt) |

Cada caso também tem os seis blocos de origem no subdiretório `originais`.

O [resultado dos testes](testes-negativos.txt) registra 15 bloqueios em modo estrito. Os arquivos estão em [entradas de teste](entradas-de-teste/) e na tabela acima. O orbe incompatível, o grau inválido e as marcas de retrogradação de Sol, Lua, Fortuna e Vertex provocam erro de entrada ou geometria. O caso de casa deslocada e as variantes de Mercúrio, Nodo Norte e Lilith foram bloqueados por lacunas de cobertura editorial.

As [entregas históricas](../historico/entregas/) e os [pacotes de trabalho](../historico/pacotes/) incluem alternativas de diagramação e prévias parciais substituídas em revisão.
