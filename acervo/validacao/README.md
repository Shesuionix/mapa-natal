# Validação dos 15 mapas

Os 15 arquivos de entrada passaram em modo estrito com textos próprios para todas as seções. O [resultado da conferência](validacao-15-mapas.txt) registra a cobertura e o SHA-256 das macros geradas pelo [verificador](conferir-regressao.lua). O SHA-256 da entrada está no log de compilação correspondente.

| Mapa | Entrada | Relatório e log históricos | Aspectos |
|---|---|---|---:|
| A | [Entrada](../../motor/mapa-editorial-v1.txt) | [PDF](relatorios/mapa-a-cobertura.pdf) · [Log](relatorios/mapa-a-cobertura.log) | 58 |
| B | [Entrada](entradas/mapa-b.txt) | [PDF](relatorios/mapa-b-revisao.pdf) · [Log](relatorios/mapa-b-revisao.log) | 45 |
| C | [Entrada](entradas/mapa-c.txt) | [PDF](relatorios/mapa-c-revisao.pdf) · [Log](relatorios/mapa-c-revisao.log) | 48 |
| D | [Entrada](entradas/mapa-d.txt) | [PDF](relatorios/mapa-d-completo.pdf) · [Log](relatorios/mapa-d-completo.log) | 51 |
| 01 | [Entrada](entradas/teste-01.txt) | [PDF](relatorios/mapa-01-completo.pdf) · [Log](relatorios/mapa-01-completo.log) | 55 |
| 02 | [Entrada](entradas/teste-02.txt) | [PDF](relatorios/mapa-02-completo.pdf) · [Log](relatorios/mapa-02-completo.log) | 54 |
| 03 | [Entrada](entradas/teste-03.txt) | [PDF](relatorios/mapa-03-completo.pdf) · [Log](relatorios/mapa-03-completo.log) | 52 |
| 04 | [Entrada](entradas/teste-04.txt) | [PDF](relatorios/mapa-04-completo.pdf) · [Log](relatorios/mapa-04-completo.log) | 46 |
| 05 | [Entrada](entradas/teste-05.txt) | [PDF](relatorios/mapa-05-completo.pdf) · [Log](relatorios/mapa-05-completo.log) | 59 |
| 06 | [Entrada](entradas/teste-06.txt) | [PDF](relatorios/mapa-06-completo.pdf) · [Log](relatorios/mapa-06-completo.log) | 40 |
| 07 | [Entrada](entradas/teste-07.txt) | [PDF](relatorios/mapa-07-completo.pdf) · [Log](relatorios/mapa-07-completo.log) | 44 |
| Sol em Aquário, casa 12 | [Entrada](../../ferramentas/mapas-validacao/sol-aquarius-casa-12.txt) | [PDF](relatorios/mapa-sintetico-sol-aquario.pdf) · [Log](relatorios/mapa-sintetico-sol-aquario.log) | 29 |
| Sol em Áries, casa 10 | [Entrada](../../ferramentas/mapas-validacao/sol-aries-casa-10.txt) | [PDF](relatorios/mapa-sintetico-sol-aries.pdf) · [Log](relatorios/mapa-sintetico-sol-aries.log) | 34 |
| Sol em Câncer, casa 12 | [Entrada](../../ferramentas/mapas-validacao/sol-cancer-casa-12.txt) | [PDF](relatorios/mapa-sintetico-sol-cancer.pdf) · [Log](relatorios/mapa-sintetico-sol-cancer.log) | 35 |
| Sol em Virgem, casa 10 | [Entrada](../../ferramentas/mapas-validacao/sol-virgo-casa-10.txt) | [PDF](relatorios/mapa-sintetico-sol-virgem.pdf) · [Log](relatorios/mapa-sintetico-sol-virgem.log) | 33 |

Os PDFs foram compilados em etapas distintas do projeto. O teste de seleção usa a biblioteca com 1.110 textos próprios. O [inventário](inventario-cobertura-editorial.txt) inclui as 179 combinações de casas e os 660 aspectos observados, além das posições demonstradas que aguardam texto. Os casos 01, 05, 06 e 07 usam as cópias de comparação documentadas no [registro de descartes](../descartados/).
