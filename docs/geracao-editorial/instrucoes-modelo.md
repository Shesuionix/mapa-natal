# Instruções para o modelo de redação do Natal Report

Escreva um texto próprio em português do Brasil para cada linha do arquivo JSONL recebido. A leitura é astrológica, eclética, psicológica e prática, voltada a quem lê o próprio mapa pela primeira vez. Escreva no singular e trate o leitor por “você”. O texto deve soar próximo e seguro, como a leitura de alguém que conhece bem o padrão descrito. Descreva tendências da configuração e situações plausíveis. Evite pressupor profissão, gênero, renda, orientação, história familiar, trauma, diagnóstico, acontecimentos ou futuro do leitor.

Use somente os fatos codificados na chave. Preserve a chave literalmente. O arquivo de evidências serve à auditoria e não fornece detalhes biográficos para a redação. Cada chave precisa de uma leitura que mudaria de forma substantiva se um de seus elementos mudasse.

## Entrada e resposta

Cada linha de entrada tem `secao` e `chave`. Produza um objeto JSON por linha, em UTF-8, na mesma ordem, com exatamente `secao`, `chave`, `subtitulo` e `paragrafos`. Copie os dois primeiros campos. O campo `paragrafos` contém duas strings, uma por parágrafo. Envie apenas JSONL, sem cerca de código, introdução, listas, Markdown, HTML ou comandos LaTeX. Use texto simples em cada string. A etapa de integração faz o escape para LaTeX.

| Seção | Palavras no corpo, somados os dois parágrafos |
|---|---:|
| `posicoes` e `estacionarias` | 130 a 190 |
| `casas` | 145 a 220 |
| `aspectos` | 85 a 130 |

O subtítulo tem 6 a 20 palavras, sem pontuação final, e funciona como a primeira frase que você teria escrito para a leitura. Faça dele uma afirmação concreta, própria daquela chave. Comece o corpo desenvolvendo essa ideia, sem repetir o subtítulo. Use linguagem natural, sem enumeração dos fatores em sequência, perguntas retóricas, jargão sem explicação, dois-pontos ou ponto e vírgula.

No primeiro parágrafo, mostre a dinâmica da combinação inteira em uma situação que o leitor possa reconhecer. No segundo, desenvolva onde a mesma dinâmica ajuda ou se complica e feche com uma resposta concreta. Pode ser um critério para decidir, uma maneira de conversar ou uma mudança de hábito que faça sentido só para aquela situação. Varie a construção dos parágrafos e o tipo de fechamento no lote.

## Como ler as chaves

| Seção | Formato |
|---|---|
| Posições e estacionárias | `corpo\|signo\|casa\|movimento` |
| Casas | `numero\|signo\|ocupantes=POSICAO;POSICAO\|regente=CORPO\|posicao=POSICAO\|aspecto=DEPENDENCIA` |
| Aspectos | `primeiro:tipo:segundo:EXTREMO1:EXTREMO2` |

`POSICAO` tem o formato da chave de posição. `EXTREMO` contém uma posição completa para corpos e pontos, ou apenas o signo para ASC, DSC, MC e IC. `DEPENDENCIA` é `nenhum` ou `primeiro\|tipo\|segundo:EXTREMO1:EXTREMO2`. A lista de ocupantes vazia aparece como `ocupantes=`. Em chaves legadas, o campo `aspecto` pode faltar. Nesse caso, desenvolva os dados presentes. `false` significa direto ou movimento inaplicável ao ponto, `true` significa retrógrado e `stationary` significa estacionário. As chaves trazem a ordem técnica dos extremos. A interpretação pode começar por qualquer um deles.

**Posição.** Combine o que o corpo ou ponto expressa, o modo de agir do signo e a área de experiência da casa em uma só dinâmica. Use o movimento quando ele diferencia a leitura. Em retrogradação, desenvolva um modo específico de reconsiderar, retomar ou testar o tema daquele corpo. Em estacionariedade, explore como a função ganha presença, demora a mudar de direção ou pede um ajuste naquele contexto. Escolha apenas o que faz sentido para a chave. Em posição direta, concentre-se no padrão da combinação. Fortuna e Vertex são pontos. Eles não recebem uma interpretação de movimento.

**Casa.** Comece pelo tema que o leitor vive naquela área. Use o signo da cúspide para mostrar como entra no assunto. Integre todos os ocupantes listados, o regente tradicional e a casa, o signo e o movimento desse regente, de modo que o leitor entenda por onde o tema se desenvolve. Quando houver um aspecto do regente, explique como ele afeta o assunto da casa e conserve a interpretação principal do aspecto para a seção de aspectos. Quando a casa estiver vazia, desenvolva o tema pelo signo e pelo regente. Quando a dependência for `nenhum`, a frase pode se apoiar no regente e nos ocupantes. Use apenas a regência tradicional codificada. Uma referência individualizada a regente moderno exigiria dados fora da chave atual.

**Aspecto.** Identifique o que acontece quando as duas funções se encontram na relação indicada. Use a modalidade do aspecto e o contexto de cada extremo. Quando um extremo for um ângulo, use seu papel e seu signo. Situe a dinâmica em uma cena que dependa dos dois extremos. Desenvolva essa dinâmica uma vez e termine com uma consequência prática. Orbe e fase não fazem parte da chave editorial. O motor mostra esses dados no cabeçalho técnico. Evite adivinhar sua intensidade ou seu momento.

## Vocabulário editorial

| Fator | Ideia de partida |
|---|---|
| Sol, Lua e Mercúrio | Sol orienta autoria e vitalidade. Lua trata de resposta emocional, cuidado e segurança. Mercúrio trata de perceber, organizar e comunicar informação. |
| Vênus, Marte e Júpiter | Vênus trata de aproximação, gosto e valor. Marte trata de iniciativa, desejo e defesa de limites. Júpiter trata de expansão, confiança e sentido. |
| Saturno, Urano, Netuno e Plutão | Saturno trata de estrutura e responsabilidade. Urano trata de autonomia e ruptura de padrões. Netuno trata de imaginação e permeabilidade. Plutão trata de intensidade, poder e mudanças profundas. |
| Nodo Norte, Lilith e Quíron | Nodo Norte aponta uma direção de desenvolvimento. Lilith trata de autonomia diante de expectativas e incômodos. Quíron trata de uma sensibilidade que pode virar habilidade. |
| Fortuna e Vertex | Fortuna aponta condições em que o fluxo ou o aproveitamento de recursos se torna mais fácil. Vertex trata de encontros e situações que mobilizam o leitor. |
| ASC, DSC, MC e IC | ASC trata de entrada e presença. DSC trata de reciprocidade e vínculos próximos. MC trata de direção pública. IC trata de base íntima e pertencimento. |

| Signo | Modo de operar |
|---|---|
| Áries `Aries` | Inicia por tentativa direta e ganha clareza ao agir. |
| Touro `Taurus` | Estabiliza pelo contato com o que tem valor e dura. |
| Gêmeos `Gemini` | Compara versões e ganha margem pela troca de informação. |
| Câncer `Cancer` | Observa o clima, protege vínculos e constrói confiança pela continuidade. |
| Leão `Leo` | Dá expressão pessoal, direção e presença ao que considera importante. |
| Virgem `Virgo` | Percebe detalhes, corrige o processo e transforma atenção em utilidade. |
| Libra `Libra` | Percebe posições em relação, negocia e busca reciprocidade. |
| Escorpião `Scorpio` | Investiga o que está em jogo e aprofunda o compromisso. |
| Sagitário `Sagittarius` | Amplia a perspectiva e testa o sentido de uma ideia em outra situação. |
| Capricórnio `Capricorn` | Organiza tempo, responsabilidade e experiência para chegar a um resultado. |
| Aquário `Aquarius` | Revê a regra, compara sistemas e preserva autonomia dentro do coletivo. |
| Peixes `Pisces` | Capta nuances, liga imagens e responde ao clima em que está inserido. |

| Casas | Temas |
|---|---|
| 1 a 4 | 1 presença e iniciativa. 2 recursos e valores. 3 conversas e aprendizagem cotidiana. 4 base íntima e pertencimento. |
| 5 a 8 | 5 criação, prazer e expressão. 6 rotina, trabalho cotidiano e cuidado. 7 vínculos e acordos. 8 intimidade, confiança e recursos partilhados. |
| 9 a 12 | 9 visão de mundo e aprendizagem ampla. 10 direção pública e responsabilidade. 11 grupos, amizades e projetos coletivos. 12 recolhimento e processos pouco visíveis. |

| Aspecto | Relação |
|---|---|
| `Conjunction` conjunção | As funções se intensificam ou passam a agir juntas. |
| `Sextile` sextil | Há uma cooperação que se torna útil com iniciativa. |
| `Square` quadratura | As funções pedem respostas diferentes e exigem ajuste. |
| `Trine` trígono | Uma função dá fluidez à outra e a facilidade pode passar despercebida. |
| `Opposition` oposição | As funções alternam prioridade ou aparecem em lados diferentes de uma relação. |

Use as tabelas como guia para construir o raciocínio. O vocabulário final deve nascer da situação descrita. Antes de entregar, confirme que cada texto corresponde à sua chave, desenvolve uma ideia própria e fecha com algo que o leitor consegue aplicar. Se dois textos servirem à mesma chave após trocar apenas os nomes, reescreva as situações e os fechamentos para mostrar a diferença.
