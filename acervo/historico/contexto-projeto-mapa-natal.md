# Mapa Natal — contexto consolidado do projeto

Repositório privado: https://github.com/Shesuionix/mapa-natal

## Objetivo e operação prevista

Vender a pessoas físicas um relatório natal interpretado, sob encomenda, em um único PDF com pagamento por relatório. O operador recebe data, horário e local de nascimento, valida os dados antes de aceitar o pedido, calcula o mapa em seu processo existente e entrega o PDF sob sua marca. O motor é interno. A interpretação é indispensável à oferta. A identidade visual pode começar simples. O produto ainda não está liberado para venda.

Horário informado é obrigatório na oferta inicial. Está prevista uma reemissão gratuita por erro nos dados informados pelo cliente, em prazo a definir. Dúvidas sobre a leitura ficam fora da primeira oferta. A meta é menos de 15 minutos para gerar, revisar e enviar o PDF. O tempo de atendimento, validação e cálculo também entra na estimativa de custo.

## Requisitos vigentes

- Usar os recursos de main.tex e natalreport.sty como base. Preservar a roda original em TikZ. Lua cuida da entrada, validação, análise e preparação de dados. LaTeX cuida da apresentação.
- Gerar localmente por linha de comando, com LuaLaTeX e os recursos instalados. Windows, Linux e macOS são plataformas pretendidas. Nenhuma IA ou rede é necessária durante a geração. A IA participa da redação antes da operação, com revisão humana dos textos.
- **Um texto próprio para cada combinação válida dentro do contrato suportado.** Texto composto serve como prévia de desenvolvimento. Cobertura editorial concluída exige os textos próprios e verificação da seleção. A apresentação e o layout vêm depois dessa etapa.
- Entregar ao cliente apenas o PDF. Guardar SHA-256 da entrada, versões aplicáveis e diagnóstico no log interno. O requisito de reprodução byte a byte pressupõe os mesmos insumos e versões de código, biblioteca, compilador, pacotes e fontes.
- Exibir a roda, posições, cúspides, grade e lista de aspectos e painel de velocidades, com os detalhes técnicos no apêndice. Tratar cada aspecto em uma interpretação principal, com orbe e fase como contexto técnico.

## Entrada e limites atuais

O leitor recebe texto UTF-8 no formato inglês dos exemplos, na ordem de posições, cúspides, aspectos e velocidades. Reconhece aspas angulares comuns e tipográficas. O formato cobre Sol, Lua, Mercúrio, Vênus, Marte, Júpiter, Saturno, Urano, Netuno, Plutão, Nodo Norte, Lilith, Quíron, Fortuna e Vertex. Cada posição inclui signo, grau, minuto, casa e marca `Retrograde` ou `Stationary` quando fornecida. Há 12 cúspides. Os ângulos ASC, DSC, MC e IC correspondem às casas 1, 7, 10 e 4 no formato atual.

Os aspectos suportados são conjunção, sextil, quadratura, trígono e oposição. Cada par é listado uma vez e traz orbe e fase aplicativo ou separativo. A grade de glifos mostra os 15 corpos e pontos, com diagonal preta. Os aspectos com ângulos constam na lista completa. O leitor aponta erros por arquivo e linha e pode avisar sobre divergências entre casa e cúspides, orbe e posições, ou sinal da velocidade e retrogradação. A auditoria de texto próprio é uma verificação distinta da validade técnica.

O leitor atual exige ao menos uma velocidade. O sinal do delta dá a direção. O painel preserva o rótulo e a razão originais e pode calcular uma segunda razão com uma tabela em graus por dia. A variável NATAL_VELOCIDADES aponta para um arquivo com cabeçalho versao=IDENTIFICADOR e linhas como Sun=1.0. O log sinaliza diferenças de razão superiores a 0,05. Sem referência, a razão calculada aparece com um traço. A interpretação do delta como graus por dia é uma premissa do motor atual. A fórmula de avg speed da fonte ainda é desconhecida. Valores como 1019x e 115.x são preservados sem correção decimal presumida.

## Linha editorial e estrutura

Leitura eclética, psicológica e prática para iniciantes. O texto fala diretamente com o leitor, evita fatalismo e relaciona as configurações do mapa a situações concretas. Cada tema deve desenvolver um raciocínio e chegar a uma resposta aplicável. Os subtítulos expressam a ideia central da leitura. A posição é interpretada como uma combinação integrada de corpo, signo e casa.

O fluxo editorial mais recente começa com a roda, passa pela síntese e por dez aspectos em destaque e remete às leituras detalhadas. A síntese parte de Sol, Lua e Ascendente e trata de expressão e aprendizado, relações e compromissos, trabalho e direção. As conclusões precisam ser rastreáveis. Casas vazias são lidas pelo regente e pelo contexto. A regência tradicional é principal. A moderna entra quando acrescenta informação relevante. Aspectos e regentes citados podem receber referências cruzadas.

## Pipeline de produção

Entrada → Validação → Modelo normalizado → Análise → Plano editorial → Conteúdo → Renderização → PDF → Controle de qualidade.

1. Receber os blocos de dados e validar o contrato. Interromper em caso de erro bloqueante.
2. Usar um modelo normalizado comum para análise, gráfico e tabelas.
3. Aplicar regras versionadas e rastrear destaques aos dados de origem.
4. Ordenar temas e destaques de forma determinística, reduzindo repetições.
5. Selecionar textos próprios e registrar combinações ausentes. Bloquear a geração final diante de qualquer lacuna obrigatória.
6. Compilar localmente, idealmente em pasta isolada, com passagens suficientes para estabilizar as referências.
7. Entregar o PDF, preservar os registros internos e conferir dados, textos, símbolos, links, margens e paginação.

O pipeline está documentado em https://github.com/Shesuionix/mapa-natal/blob/main/docs/escopo.md. Ele descreve requisitos de produção. Alguns passos ainda precisam de validação de ponta a ponta para a versão final.

## Histórico e entregas

1. entrega-completa.zip forneceu a base histórica. O registro apontava natal-base-revisada 0.4.1 como base corrente, preservando o desenho e o banco original. A compilação da base em MiKTeX local foi confirmada.
2. Foram escritos lotes do demonstrativo original A com 15 posições, dois eixos, 12 casas, 58 aspectos e uma síntese. O texto evoluiu de descrições sequenciais para leituras integradas e, depois, capítulos temáticos. O PDF da Etsy foi usado como referência de estrutura.
3. A roda original do natalreport foi integrada ao demonstrativo. O leitor dos quatro blocos e o PDF técnico passaram a usar o arquivo de entrada. As tabelas foram alinhadas e a grade ganhou glifos, células delimitadas e diagonal preta.
4. O motor passou a registrar SHA-256 e versões no log interno. Duas compilações isoladas da versão técnica da época produziram PDFs idênticos. O painel de velocidades recebeu comparação opcional com uma referência versionada.
5. A seleção de textos foi ampliada de A para B e C, primeiro por posição, depois eixos, casas e aspectos. Foram adicionados 45 textos de aspectos para B e 48 para C. A síntese automática seleciona relações por relevância temática e orbe, com notas específicas para alguns contextos. A síntese de A mantém o texto preparado para seu mapa.
6. O mapa D entrou como teste fora da biblioteca inicial. Foi validado com 15 posições, 12 cúspides, 51 aspectos, 13 velocidades e zero avisos estruturais. Um teste de duas passagens levou 20,8 segundos, exclusivamente para compilação.
7. Você confirmou que cada combinação válida precisa de texto próprio. Foram escritos os 18 eixos restantes, completando 24 textos distintos, e as 15 posições do mapa D. O log passou a contar textos próprios e compostos por seção.
8. fontes-projeto-natal-report.zip trouxe fontes separados do gráfico, versões anteriores, entradas de teste, documentação e um acervo com uma prévia 0.8.0 e distribuições posteriores. A matriz da 0.8.0 documenta três famílias, duas sintéticas, com revisão humana pendente. Suas chaves editoriais diferem das atuais. O acervo inspirou a verificação estrita de lacunas. O pipeline foi acrescentado ao escopo do repositório.
9. Foram completadas as 12 casas e os 51 aspectos de D. O inventário passou a auditar chaves, textos cadastrados e lacunas.
10. A auditoria de posições demonstrou 3.672 chaves por configurações reproduzíveis, excluiu 576 por retrogradação e deixou 72 chaves de Vertex em aberto. As 60 posições que têm texto estão entre as demonstradas.
11. A busca dirigida no minuto do MC confirmou 12 chaves adicionais de Vertex na casa 10. A comparação de A a D sustenta Nodo Norte e Lilith médios nesses quatro exemplos. A auditoria de casas e aspectos passou a usar as chaves do motor e encontrou 72 casas e 310 aspectos sem texto em dez mapas conferidos.
12. A aceitação da posição estacionária incluiu o teste 06 do acervo. Foram escritos um texto para Netuno estacionário em Escorpião na casa 5 e um para a casa 5 desse mapa. A cobertura medida em 11 mapas passou a 82 lacunas de casas e 327 de aspectos. Para novos textos de casa, a chave inclui o aspecto de menor orbe do regente tradicional. O modo estrito passou a bloquear orbes que divergem da geometria da entrada.
13. As 65 leituras restantes do caso 06 foram escritas e cadastradas. A biblioteca passou a 401 textos próprios e o caso 06 passou no modo estrito. As lacunas do lote de 11 mapas passaram a 71 casas e 287 aspectos.
14. O caso 07 entrou em modo estrito com 35 novos textos próprios. A biblioteca chegou a 436 textos. No lote de 11 mapas restam 60 chaves de casas e 266 de aspectos sem texto. A cópia de comparação do acervo tem 44 aspectos e o teste com a quadratura Fortuna–Vertex do original confirmou o bloqueio por geometria.
15. O caso 04 passou em modo estrito após o cadastro de 73 novos textos. A biblioteca chegou a 509 textos. No lote de 11 mapas restam 48 chaves de casas e 220 de aspectos sem texto.
16. O caso 03 passou em modo estrito após o cadastro de 79 textos. A biblioteca chegou a 588 textos. No lote de 11 mapas restam 36 chaves de casas e 168 de aspectos sem texto.
17. Os casos 02 e 01 passaram em modo estrito após o cadastro de 163 textos. A biblioteca chegou a 751 textos. No lote de 11 mapas restam 12 chaves de casas e 59 de aspectos sem texto, todas do caso 05.
18. O caso 05 passou em modo estrito após o cadastro de 85 textos. A biblioteca chegou a 836 textos. Os 11 mapas do lote passaram, com cobertura das 131 chaves de casas e 529 de aspectos observadas. A cópia de comparação do caso 05 tem 59 aspectos e o teste com o trígono Fortuna–Vertex do original confirmou o bloqueio por geometria.
19. O primeiro lote fora dos mapas de referência acrescentou 24 textos para o Sol nas casas 10 e 12, cobrindo os doze signos nas duas casas. A biblioteca chegou a 860 textos. Quatro mapas sintéticos reproduzíveis ampliaram a auditoria para 15 mapas e revelaram 48 chaves de casas e 131 de aspectos sem texto.
20. Foram acrescentados 73 textos próprios. Dezenove completam os doze signos para o Sol nas casas 1 e 11. Os demais completam as lacunas do mapa sintético de Sol em Aquário na casa 12, que passou em modo estrito. A biblioteca chegou a 933 textos próprios.
21. O mapa sintético de Sol em Virgem na casa 10 passou em modo estrito com 58 novos textos. A biblioteca chegou a 991 textos próprios, e os 12 mapas já validados mantiveram a seleção.
22. O mapa sintético de Sol em Câncer na casa 12 passou em modo estrito com 59 novos textos. A biblioteca chegou a 1.050 textos próprios, e os 13 mapas já validados mantiveram a seleção.
23. O mapa sintético de Sol em Áries na casa 10 passou em modo estrito com 60 novos textos. A biblioteca chegou a 1.110 textos próprios. Os 14 mapas anteriores mantiveram a seleção e a auditoria dos 15 mapas ficou com cobertura integral.

## Estado verificado da biblioteca

| Seção | Textos próprios cadastrados | Estado |
|---|---:|---|
| Posições | 247 | Inclui uma posição estacionária e o Sol nos 12 signos nas casas 1, 10, 11 e 12 |
| Eixos | 24 | Cobertura dos 12 pares orientados de signos opostos para cada eixo |
| Casas | 179 | Cobertura das 179 combinações observadas |
| Aspectos | 660 | Cobertura das 660 combinações observadas |

O modo estrito é ativado com `NATAL_EXIGIR_TEXTOS_PROPRIOS=1`. Os mapas A a D, os casos 01 a 07 e os quatro mapas sintéticos passaram com textos próprios em todas as seções. A aprovação editorial humana continua sendo uma etapa própria.

Das 4.320 chaves iniciais de posições sem marca estacionária, 3.684 foram demonstradas. Faltam 3.438 textos para essas chaves. As 179 chaves de casas e as 660 de aspectos observadas nos 15 mapas têm texto próprio. As 144 chaves básicas de casas e as 855 de aspectos omitem contexto. O total de combinações completas ainda está em aberto.

## Continuação prioritária

1. Confirmar as convenções do cálculo de origem para Vertex, Nodo Norte e Lilith e obter os orbes máximos por par e tipo. Levantar as posições estacionárias possíveis segundo o critério da fonte.
2. Ampliar o catálogo contextual com o aspecto de menor orbe do regente tradicional e declarar dependências adicionais quando um novo texto tratar de regente moderno. Orbe e fase continuam fora da chave de aspecto, e o orbe determina qual aspecto do regente orienta a casa.
3. Ampliar a biblioteca em lotes até cobrir todas as chaves válidas. Testar seleção, bloqueio, reprodutibilidade e coerência temática com mapas diversos e casos de fronteira.
4. Só então concentrar o trabalho em apresentação, layout e verificação visual. Depois, executar o piloto completo e medir o tempo total por pedido.

## Lacunas de informação

- Total de combinações realmente válidas, tratamento das 60 chaves de Vertex em aberto, convenção de estacionariedade da fonte e orbes máximos por par e tipo de aspecto.
- Fórmula da razão média usada pela exportação e unidade temporal confirmada para seus deltas. A Swiss Ephemeris fornece velocidades geocêntricas por instante e pode servir para derivar uma referência própria. A média, o período, a amostragem e as convenções do Nodo Norte e da Lilith ainda precisam ser definidos.
- Origem e licença de natalreport.sty. A Symbola instalada foi identificada como versão 9.00 de George Douros. A licença GUST da Latin Modern está documentada no CTAN.
- Identidade binária e portabilidade da versão final em todos os ambientes pretendidos. A verificação anterior ocorreu no ambiente técnico de referência.
- Aprovação final dos textos e do PDF, preço, valor-hora, prazo de entrega, janela de reemissão, canal de venda e tempo de uma encomenda completa.

## Arquivos e referências para retomar

- docs/escopo.md — escopo vigente e pipeline.
- docs/validade-posicoes.md e docs/evidencias-posicoes.tsv — critérios e dados de reprodução da auditoria de posições.
- docs/validade-casas-aspectos.md — critérios e resultado do lote da auditoria contextual.
- motor/entrada.lua e motor/validar.lua — importação e validação.
- motor/dados-relatorio.lua e motor/relatorio-tecnico.tex — seleção e geração.
- motor/leituras-posicoes-v1.tex, motor/leituras-casas-v1.tex e motor/leituras-aspectos-v1.tex — textos próprios. Os eixos estão no primeiro arquivo.
- motor/leitura-composta.lua — composição usada nas prévias quando falta texto próprio.
- base/natalreport.sty — roda e base técnica.
- Última atualização do escopo e da biblioteca. [Commit no repositório privado](https://github.com/Shesuionix/mapa-natal/commit/5aa7a8a96c29707f09db56df02e80e4ec2df36c9)
- Documentação de velocidades: https://www.astro.com/swisseph-download/doc/swephprg.pdf
- Referência de comparação: https://ssd.jpl.nasa.gov/horizons/manual.html
