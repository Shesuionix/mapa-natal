# Validade das combinações de posições

A chave editorial de posição é `corpo|signo|casa|movimento`. O grau e o minuto localizam o ponto no mapa. O leitor confere a casa informada contra o intervalo das cúspides e registra a divergência. Para confirmar uma chave nesta auditoria, a casa precisa corresponder ao intervalo e o signo precisa corresponder à longitude. A escolha de um texto exige a chave completa.

## Regras

| Caso | Tratamento |
|---|---|
| Sol e Lua | A longitude geocêntrica é direta. O leitor rejeita `Retrograde` e `Stationary` na posição. |
| Fortuna e Vertex | O contrato trata ambos como pontos calculados sem estado de movimento editorial. O leitor rejeita `Retrograde` e `Stationary` na posição. |
| Nodo Norte | A fonte pode usar Nodo médio ou verdadeiro. A auditoria admite ocorrências diretas e retrógradas demonstradas para uma dessas variantes. |
| Lilith | A fonte pode usar apogeu médio ou osculante. A auditoria admite ocorrências diretas e retrógradas demonstradas para uma dessas variantes. |
| Demais corpos | A auditoria confirma o estado pelo sinal da velocidade em longitude. |
| Próximo de uma fronteira | As evidências usam margem de 0,02° em relação ao limite de signo e à cúspide. Para corpos e pontos com velocidade, exigem módulo acima de 0,0002°/dia. São margens da auditoria, destinadas a evitar que o arredondamento altere a chave. |

O campo final conserva `true` para `Retrograde` e `false` para posição sem marcador. Uma posição com `Stationary` usa `stationary`, inclusive nas chaves de casas e aspectos. Com delta zero, o painel mostra `Estacionário` se houver marca explícita na posição ou rótulo no bloco de velocidades. Sem essa indicação, mostra `Indefinida`. Um rótulo exclusivo do bloco de velocidades permanece técnico e a chave editorial da posição segue o marcador do bloco de posições.

No caso 06, o acervo registra instante e unidade do delta como desconhecidos. O ajuste pelas longitudes publicadas de Sol e Lua, conferido nos planetas lentos com resíduo de até 0,95′, indica velocidade de Netuno próxima de +0,79″ por dia na Swiss Ephemeris. O valor é uma estimativa para o instante ajustado. O arquivo exportado registra delta zero e estado `Stationary`. O limiar de velocidade ou regra de arredondamento da fonte continua sem confirmação. [Velocidade em longitude na Swiss Ephemeris](https://www.astro.com/swisseph/swephprg.2.10.pdf)

## Resultado

Das 4.320 chaves da grade sem estado estacionário, **576 são excluídas** pelas regras de retrogradação. A auditoria encontrou uma configuração reproduzível para **3.684 chaves**, incluindo as 382 que já têm texto. Restam **3.302 textos a escrever para as chaves demonstradas**. As outras **60 chaves** são Vertex nas casas 1, 2, 3, 11 e 12, em todos os signos. Permanecem em aberto até a confirmação do sistema de casas, da convenção de Vertex e do tratamento de latitudes da fonte de produção. A falta de exemplo na busca não prova impossibilidade. A grade foi gerada com velocidades afastadas de zero. O lote contextual conta as posições explicitamente estacionárias à parte e já confirmou a chave de Netuno em Escorpião na casa 5, com texto próprio.

O primeiro lote fora dos mapas de referência acrescentou os 24 textos de Sol nas casas 10 e 12, um por signo e casa. As 24 chaves constam do TSV de evidências. As combinações de Sol nessas duas casas têm cobertura integral na biblioteca.

O lote seguinte acrescentou 19 textos para o Sol nas casas 1 e 11 e completou os 12 signos em cada uma. A seleção de cada texto foi conferida em uma entrada reproduzida a partir do TSV. Outras 13 posições receberam texto próprio para completar o mapa sintético de Sol em Aquário na casa 12.

O mapa sintético de Sol em Virgem na casa 10 acrescentou 13 textos de posições. Entre eles está Mercúrio retrógrado em Virgem na casa 10. O Sol e o Vertex selecionaram textos já cadastrados.

O mapa sintético de Sol em Câncer na casa 12 acrescentou 12 textos de posições, incluindo Lua, Mercúrio e Júpiter em Câncer na casa 12. Sol, Marte e Urano selecionaram textos já cadastrados.

O mapa sintético de Sol em Áries na casa 10 acrescentou 14 textos de posições. O Sol selecionou um texto já cadastrado. A biblioteca cobre 53 das 144 posições solares demonstradas.

O lote de Sol nas casas 3 e 4 acrescentou 22 textos e completou os 12 signos em cada uma. Capricórnio na casa 3 e Áries na casa 4 já tinham texto. A seleção solar foi conferida nas 24 entradas reproduzidas a partir do TSV de evidências. Com o lote, a biblioteca cobre 75 das 144 posições solares demonstradas. [Entradas e seleção conferida](../acervo/validacao/sol-casas-3-e-4/)

O lote de Sol nas casas 2 e 5 acrescentou 24 textos, um por signo em cada casa. As 24 entradas reproduzidas a partir do TSV selecionaram a leitura solar esperada. A biblioteca passou a cobrir 99 das 144 posições solares demonstradas. [Entradas e seleção conferida](../acervo/validacao/sol-casas-2-e-5/)

O lote de Sol nas casas 6 e 7 acrescentou 23 textos. Libra na casa 6 já tinha leitura. As 24 entradas reproduzidas selecionaram o texto esperado, completando os 12 signos nas duas casas. A biblioteca passou a cobrir 122 das 144 posições solares demonstradas. [Entradas e seleção conferida](../acervo/validacao/sol-casas-6-e-7/)

O lote de Sol nas casas 8 e 9 acrescentou 22 textos. Peixes na casa 8 e Aquário na casa 9 já tinham leitura. As 24 entradas reproduzidas selecionaram o texto esperado. As 144 posições solares demonstradas agora têm texto próprio, com os 12 signos nas 12 casas. [Entradas e seleção conferida](../acervo/validacao/sol-casas-8-e-9/)

O lote de Lua nas casas 1 e 2 acrescentou 23 textos e confirmou em 24 entradas reproduzíveis a leitura de todos os signos nas duas casas. Virgem na casa 2 já tinha texto. A biblioteca passou a cobrir 37 das 144 posições lunares demonstradas. [Entradas e seleção conferida](../acervo/validacao/lua-casas-1-e-2/)

O lote de Lua nas casas 3 e 4 acrescentou 22 textos. Libra na casa 3 e Peixes na casa 4 já tinham leitura. As 24 entradas reproduzidas selecionaram o texto esperado. A biblioteca passou a cobrir 59 das 144 posições lunares demonstradas. [Entradas e seleção conferida](../acervo/validacao/lua-casas-3-e-4/)

As 84 ocorrências demonstradas de Vertex cobrem as casas 4 a 10 nos 12 signos. As casas 4 a 9 têm 64 exemplos em Placidus e 8 em Campanus. A casa 10 tem 12 exemplos de fronteira em Placidus. Neles, o Vertex fica imediatamente antes do MC e ambos são exportados no mesmo minuto, seja por truncamento ou arredondamento. O intervalo adotado pelo leitor inclui a cúspide de início e, nesse caso, admite o Vertex na casa 10. Uma fonte que atribua a casa antes de arredondar pode exportar a casa 9 para a mesma geometria. A auditoria mantém as duas possibilidades documentadas. [Implementação de casas e Vertex](https://github.com/aloistr/swisseph/blob/master/swehouse.c)

A busca exploratória do Vertex também percorreu latitudes de −89° a 89°, ângulos siderais locais a cada 0,5° e vários sistemas de casas da Swiss Ephemeris, mantendo os resultados compatíveis com a ordem zodiacal e com os quatro ângulos nas cúspides. Os exemplos encontrados fora das casas 4 a 9 eram coincidências com o minuto do MC. A grade exploratória amostra a geometria. A exclusão definitiva de outras casas depende das convenções da fonte. [Convenções e casos polares da Swiss Ephemeris](https://www.astro.com/swisseph/swisseph.htm)

## Convenções observadas nos mapas A a D

Foi ajustado um instante para cada mapa a partir das longitudes publicadas de Sol e Lua, usando Urano, Netuno e Plutão para localizar o ano provável no intervalo de 1800 a 2099. O teste conferiu Sol, Júpiter, Saturno, Urano, Netuno e Plutão com diferença inferior a 1′. Os deltas fornecidos de Nodo Norte e Lilith também são compatíveis com os valores médios calculados. A tabela mostra diferenças absolutas em longitude, em minutos de arco.

| Mapa | Nodo médio | Nodo verdadeiro | Lilith média | Lilith osculante | Lilith interpolada |
|---|---:|---:|---:|---:|---:|
| A | 0,82 | 72,42 | 0,72 | 554,93 | 267,79 |
| B | 0,16 | 76,17 | 0,93 | 358,40 | 50,34 |
| C | 0,78 | 27,81 | 0,20 | 18,17 | 276,37 |
| D | 0,17 | 52,12 | 0,68 | 857,80 | 258,51 |

Os dados sustentam a inferência de Nodo Norte médio e Lilith média nos quatro exemplos. O arquivo de produção ainda não declara essas variantes. As chaves demonstradas para Nodo direto e Lilith retrógrada continuam no inventário geral. Se a fonte de produção for confirmada como exclusivamente média para os dois pontos, serão 288 chaves a menos nessa configuração, 144 por ponto. [Variantes de Nodo e Lilith na Swiss Ephemeris](https://www.astro.com/swisseph/swisseph.htm)

Para a Fortuna, a auditoria usa `ASC + Lua − Sol` no mapa diurno e `ASC + Sol − Lua` no noturno, com o horizonte da roda definido pelo eixo ASC–DSC. As quatro entradas de referência A a D são compatíveis com essa convenção dentro de um minuto de arco. O cálculo serve para produzir evidências e o motor continua lendo a Fortuna informada no arquivo.

## Reprodução

Cada linha de `evidencias-posicoes.tsv` guarda a chave, o dia juliano UT, latitude e longitude geográficas em graus, sistema de casas (`P` Placidus ou `C` Campanus) e variante. A busca usa efeméride geocêntrica tropical, datas a partir de 1800 e até 2099, com passo diário. Para os corpos e a Fortuna usa latitude 0° e longitudes em passos de 15°. Para Vertex usa 1º de janeiro de 2000, latitudes inteiras de −66° a 66° e longitudes inteiras de −180° a 179°. A variante `cuspide-minuto` registra a busca dirigida perto do zênite, com a latitude derivada da declinação do MC e um deslocamento de 0,00005°. O intervalo de busca não limita datas aceitas pelo leitor.

Para regenerar as evidências, use `pysweph==2.10.3.6` em ambiente de desenvolvimento e obtenha `sepl_18.se1`, `semo_18.se1` e `seas_18.se1` do diretório oficial. O script exige Swiss Ephemeris 2.10.03, confere o SHA-256 dos arquivos e interrompe diante de uma substituição de efeméride. Python e os arquivos de efemérides são usados nesta auditoria de desenvolvimento. A geração de relatórios continua local em LuaLaTeX com os quatro blocos fornecidos pelo operador. [Arquivos de efemérides da Astrodienst](https://github.com/aloistr/swisseph/tree/master/ephe) · [Versão do vínculo Python](https://pypi.org/project/pysweph/2.10.3.6/)

```sh
python ferramentas/gerar-evidencias-posicoes.py CAMINHO_DAS_EFEMERIDES docs/evidencias-posicoes.tsv
texlua motor/inventario-editorial.lua
```

Para reproduzir as quatro entradas sintéticas do lote ampliado, use o TSV existente e o mesmo diretório de efemérides. O gerador de auditoria usa as configurações de Placidus registradas no TSV, Nodo e Lilith médios e a convenção diurna ou noturna de Fortuna. Seleciona os cinco tipos de aspecto do contrato com orbe máximo de 6° entre corpos e pontos e 3° para pares que incluem um ângulo. Estima a fase pela variação do orbe em um minuto antes e depois do instante de referência. Para satisfazer o bloco técnico de velocidades, inclui a velocidade do Sol em graus por dia e a razão em relação ao movimento médio adotado de 360° por 365,2422 dias. Essas convenções são da geração de casos de auditoria. [Documentação da Swiss Ephemeris](https://www.astro.com/swisseph/swephprg.htm)

```sh
python ferramentas/gerar-evidencias-posicoes.py CAMINHO_DAS_EFEMERIDES docs/evidencias-posicoes.tsv --mapas-validacao ferramentas/mapas-validacao
```

O inventário separa as posições demonstradas ainda sem texto das que permanecem em aberto. Para casas e aspectos, a [auditoria contextual](validade-casas-aspectos.md) usa os mapas fornecidos na execução.

Referências para o movimento em longitude, as variantes lunares, a geometria do Vertex e a Fortuna. [Movimento geocêntrico do Sol e da Lua](https://tile.loc.gov/storage-services/public/gdcmassbookdig/astronomicallore01grim/astronomicallore01grim.pdf) · [Documentação da Swiss Ephemeris](https://www.astro.com/swisseph/swisseph.htm) · [Implementação de casas e Vertex](https://github.com/aloistr/swisseph/blob/master/swehouse.c) · [Fórmulas da Fortuna](https://www.astro.com/faq/fq_fh_calc_e.htm)
