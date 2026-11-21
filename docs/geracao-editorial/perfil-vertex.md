# Vertex no perfil por quadrantes

As 60 combinações de Vertex nos 12 signos e nas casas 1, 2, 3, 11 e 12 são excluídas do perfil de produção atual. O leitor e o inventário aplicam a mesma regra por corpo e casa, incluindo entradas sem marcador de movimento.

O Vertex ocidental pertence à metade eclíptica entre IC e MC, correspondente às casas 4 a 9 na divisão convencional em quadrantes. A exportação junto ao MC pode atribuí-lo à casa 10 quando ponto e cúspide coincidem no minuto arredondado. Essa convenção já faz parte das evidências do projeto. As casas investigadas ficam fora da metade admissível.

A conclusão é específica do perfil com ASC, IC, DSC e MC nas cúspides 1, 4, 7 e 10 e cúspides em ordem zodiacal. Não é uma declaração de impossibilidade em todos os sistemas de casas. Foram encontrados exemplos externos de casa 3 em Morinus e Carter, além de casos em casas fixadas em Áries. Esses sistemas não satisfazem o contrato de ângulos usado pelo motor.

A investigação calculou 1.345.680 configurações amostrais em 21 sistemas com Swiss Ephemeris 2.10.03. A amostragem corrobora o argumento geométrico, mas não é, isoladamente, prova universal. A definição e as convenções são descritas na [documentação oficial, seções 6.3 e 6.4](https://www.astro.com/swisseph/swisseph.htm) e no [código oficial de casas](https://github.com/aloistr/swisseph/blob/master/swehouse.c).

Os 60 rascunhos do lote 32 foram preservados em arquivo-vertex-60.jsonl. São conteúdo arquivado fora da biblioteca operacional, sem contagem como leituras publicadas. Para aceitar outros perfis futuramente, será necessário revisar explicitamente o contrato dos ângulos e esta exclusão.

A grade não estacionária passa de 3.744 para 3.684 chaves admitidas. As exclusões totais nessa grade passam de 576 para 636: 576 por movimento incompatível e mais 60 posições de Vertex sem marcador. Não há remoção de nenhuma leitura já cadastrada.
