# Validade das combinações de posições

A chave editorial de posição é `corpo|signo|casa|retrograde`. O grau e o minuto localizam o ponto no mapa. O leitor confere a casa informada contra o intervalo das cúspides e registra a divergência. Para confirmar uma chave nesta auditoria, a casa precisa corresponder ao intervalo e o signo precisa corresponder à longitude. A escolha de um texto exige a chave completa.

## Regras

| Caso | Tratamento |
|---|---|
| Sol e Lua | A longitude geocêntrica é direta. O leitor rejeita o marcador `Retrograde`. |
| Fortuna e Vertex | O contrato trata ambos como pontos calculados sem estado de retrogradação. O leitor rejeita o marcador `Retrograde`. |
| Nodo Norte | A fonte pode usar Nodo médio ou verdadeiro. A auditoria admite ocorrências diretas e retrógradas demonstradas para uma dessas variantes. |
| Lilith | A fonte pode usar apogeu médio ou osculante. A auditoria admite ocorrências diretas e retrógradas demonstradas para uma dessas variantes. |
| Demais corpos | A auditoria confirma o estado pelo sinal da velocidade em longitude. |
| Próximo de uma fronteira | As evidências usam margem de 0,02° em relação ao limite de signo e à cúspide. Para corpos e pontos com velocidade, exigem módulo acima de 0,0002°/dia. São margens da auditoria, destinadas a evitar que o arredondamento altere a chave. |

## Resultado

Das 4.320 chaves da grade inicial, **576 são excluídas** pelas regras de retrogradação. A auditoria encontrou uma configuração reproduzível para **3.672 chaves**, incluindo as 60 que já têm texto. Restam **3.612 textos a escrever para as chaves demonstradas**. As outras **72 chaves** são Vertex nas casas 1, 2, 3, 10, 11 e 12, em todos os signos. Permanecem em aberto até a confirmação do sistema de casas, da convenção de Vertex e do tratamento de latitudes da fonte de produção. A falta de exemplo na busca não prova impossibilidade.

As 72 ocorrências demonstradas de Vertex cobrem as casas 4 a 9 nos 12 signos. Destas, 64 têm exemplo em Placidus e 8 têm exemplo em Campanus. Campanus entra aqui como evidência de possibilidade geométrica em uma entrada com ASC e MC nas cúspides 1 e 10. O arquivo atual não declara o sistema usado pelo operador. Também não identifica a variante do Nodo Norte ou da Lilith. Essas escolhas podem alterar a quantidade de chaves aplicáveis à fonte comercial.

Para a Fortuna, a auditoria usa `ASC + Lua − Sol` no mapa diurno e `ASC + Sol − Lua` no noturno, com o horizonte da roda definido pelo eixo ASC–DSC. As quatro entradas de referência A a D são compatíveis com essa convenção dentro de um minuto de arco. O cálculo serve para produzir evidências e o motor continua lendo a Fortuna informada no arquivo.

## Reprodução

Cada linha de `evidencias-posicoes.tsv` guarda a chave, o dia juliano UT, latitude e longitude geográficas em graus, sistema de casas (`P` Placidus ou `C` Campanus) e variante. São configurações de auditoria e usam coordenadas em grade. A busca usa efeméride geocêntrica tropical, datas a partir de 1800 e até 2099, com passo diário. Para os corpos e a Fortuna usa latitude 0° e longitudes em passos de 15°. Para Vertex usa 1º de janeiro de 2000, latitudes inteiras de −66° a 66° e longitudes inteiras de −180° a 179°. O intervalo de busca não limita datas aceitas pelo leitor.

Para regenerar as evidências, use `pysweph==2.10.3.6` em ambiente de desenvolvimento e obtenha `sepl_18.se1`, `semo_18.se1` e `seas_18.se1` do diretório oficial. O script exige Swiss Ephemeris 2.10.03, confere o SHA-256 dos arquivos e interrompe diante de uma substituição de efeméride. Python e os arquivos de efemérides são usados nesta auditoria de desenvolvimento. A geração de relatórios continua local em LuaLaTeX com os quatro blocos fornecidos pelo operador. [Arquivos de efemérides da Astrodienst](https://github.com/aloistr/swisseph/tree/master/ephe) · [Versão do vínculo Python](https://pypi.org/project/pysweph/2.10.3.6/)

```sh
python ferramentas/gerar-evidencias-posicoes.py CAMINHO_DAS_EFEMERIDES docs/evidencias-posicoes.tsv
texlua motor/inventario-editorial.lua
```

O inventário separa as posições demonstradas ainda sem texto das que permanecem em aberto. Casas e aspectos ainda aparecem pelas chaves básicas, pois a validade das combinações contextuais é uma etapa posterior.

Referências para o movimento em longitude, as variantes lunares, a geometria do Vertex e a Fortuna. [Movimento geocêntrico do Sol e da Lua](https://tile.loc.gov/storage-services/public/gdcmassbookdig/astronomicallore01grim/astronomicallore01grim.pdf) · [Documentação da Swiss Ephemeris](https://www.astro.com/swisseph/swisseph.htm) · [Implementação de casas e Vertex](https://github.com/aloistr/swisseph/blob/master/swehouse.c) · [Fórmulas da Fortuna](https://www.astro.com/faq/fq_fh_calc_e.htm)
