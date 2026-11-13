# Validade contextual de casas e aspectos

O inventário verifica as mesmas chaves que o motor consulta para selecionar textos. A execução começa com a entrada de referência A e aceita caminhos de mapas adicionais. Para servir de evidência, uma entrada deve passar pelo leitor, ter ASC–DSC e MC–IC em oposição, ter cada ocupante no intervalo da casa informada e ter os orbes compatíveis com as longitudes dos dois extremos. O intervalo inclui a cúspide inicial e termina antes da próxima. A comparação de orbes e eixos admite até 1,5′ de diferença para acomodar a precisão da entrada.

## Casas

A chave contém número, signo da cúspide, lista ordenada de ocupantes e posição do regente tradicional. Cada ocupante e regente carrega corpo, signo, casa e movimento editorial. Uma casa vazia tem lista vazia e conserva o regente na chave. O signo do regente vem da sua posição, enquanto a escolha de qual corpo rege a casa vem do signo da cúspide.

Para novos textos, o aspecto que orienta a leitura da casa é o de menor orbe entre os aspectos recebidos que envolvem o regente tradicional. Em empate, vale a ordem lexicográfica da chave do aspecto, com os extremos em ordem canônica. A chave guarda o aspecto e as posições de seus dois extremos. Uma entrada sem aspecto do regente usa `aspecto=nenhum`. Dois mapas que mudam esse aspecto ou as posições dos extremos pedem chaves diferentes. A casa explica a consequência desse vínculo para o seu tema e pode remeter à interpretação principal do aspecto. Os demais aspectos constam de suas próprias leituras.

Os 12 textos de A conservam a dependência já revisada. Os 36 textos de B a D conservam as chaves que sustentam sua prosa. O motor tenta primeiro a chave contextual nova e usa uma chave existente quando o texto correspondente já foi cadastrado e os seus dados coincidem. Uma referência personalizada a regente moderno fica para revisão do catálogo, pois exigirá declarar e verificar a posição ou o aspecto citado.

## Aspectos

A chave contém par em ordem canônica, tipo de aspecto e posição dos dois extremos. Para um corpo ou ponto, a posição contém signo, casa e movimento editorial. Para ASC, DSC, MC e IC, contém o signo do ângulo. Trocar a ordem dos extremos preserva a chave. Orbe e fase permanecem como informação técnica de cada ocorrência. O orbe também determina qual aspecto do regente orienta a leitura de uma casa.

A conferência parte da menor distância circular em longitude. O orbe esperado é o módulo da diferença entre essa distância e o ângulo exato do tipo. O leitor emite aviso se a diferença entre o orbe fornecido e o esperado passar de 1,5′. A geração em modo estrito bloqueia o relatório diante dessa incompatibilidade. A mesma conferência é obrigatória na auditoria contextual. A tolerância de 1,5′ acomoda a precisão da exportação. Para enumerar os aspectos além dos observados, ainda faltam os orbes máximos por par e tipo usados na origem. O inventário lista o maior orbe observado para cada par e tipo do lote. Esses valores são limites inferiores para a política de seleção da fonte. [Elongação dos planetas interiores](https://ntrs.nasa.gov/api/citations/20230003802/downloads/Sheppard_2022_AJ_164_168.pdf)

## Resultado do lote

O lote reúne A a D e as entradas 01 a 07 do acervo. São onze mapas, com as seguintes chaves observadas.

| Seção | Observadas | Com texto próprio | Sem texto próprio |
|---|---:|---:|---:|
| Casas | 131 | 131 | 0 |
| Aspectos | 529 | 529 | 0 |

O caso 05 passou em modo estrito com 15 posições, 2 eixos, 12 casas e 59 aspectos na cópia de comparação. O lote acrescentou 85 textos. Os 11 mapas agora passam em modo estrito e os dez já validados preservaram a seleção editorial. As 131 chaves de casas e as 529 de aspectos correspondem ao que foi observado no lote.

A cópia de comparação do caso 05 registra a exclusão do trígono Fortuna–Vertex. A linha original informa 2°28′ e o orbe pelas posições para esse trígono é 50°10′. Recolocar a linha fez o modo estrito bloquear a geração.

O caso 02 passou em modo estrito com 15 posições, 2 eixos, 12 casas e 54 aspectos. O caso 01 passou com 15 posições, 2 eixos, 12 casas e 55 aspectos na cópia de comparação. Os dois casos acrescentaram 163 textos próprios. A seleção dos oito mapas já validados foi preservada.

A cópia de comparação do caso 01 traz a exclusão documentada do sextil Fortuna–Vertex. A linha original informa 2°38′ e o orbe pelas posições para esse sextil é 52°36′. Recolocar a linha fez o modo estrito bloquear a geração. O caso 02 usa os 54 aspectos da entrada do acervo.

O caso 03 passou em modo estrito com 15 posições, 2 eixos, 12 casas e 52 aspectos. O leitor conferiu as 52 relações da entrada do acervo com zero avisos. O lote adicionou 79 textos. Os mapas A a D e os casos 04, 06 e 07 mantiveram as seleções já verificadas.

O caso 04 passou em modo estrito com 15 posições, 2 eixos, 12 casas e 46 aspectos. Foram cadastrados 73 textos próprios. A geração usou as 46 relações da entrada do acervo, com zero avisos no leitor. Os mapas A a D e os casos 06 e 07 mantiveram a seleção editorial já verificada.

O caso 06 informa `Stationary` na posição de Netuno e no bloco de velocidades. O leitor preserva a entrada original, identifica a posição estacionária e usa `Neptune|Scorpio|5|stationary` na seleção. A posição estacionária participa também das chaves dos aspectos de Netuno. O caso 06 tem textos próprios para as 15 posições, os 2 eixos, as 12 casas e os 40 aspectos. O lote de 65 novos textos preserva as dependências cadastradas nos mapas A a D.

O relatório do caso 06 usa a cópia de comparação do acervo. Nela, `ALTERACOES.txt` registra que a quadratura Fortuna–Vertex foi retirada dessa cópia. O original informa 6°22′ e as longitudes publicadas resultam em 70°14′ de orbe para quadratura. Recolocar a linha original provocou um erro geométrico no modo estrito. O PDF validado corresponde aos 40 aspectos da cópia de comparação.

O caso 07 passou em modo estrito com 15 posições, 2 eixos, 12 casas e 44 aspectos. Foram cadastrados 3 textos de posições, 11 de casas e 21 de aspectos. A casa 2 seleciona o texto já cadastrado para o caso 06 porque as posições e o aspecto do regente coincidem na chave editorial.

O caso 07 também usa a cópia de comparação do acervo. O registro `ALTERACOES.txt` identifica a quadratura Fortuna–Vertex retirada da cópia. O original informa 2°43′ e as longitudes publicadas resultam em 72°43′ de orbe para quadratura. O modo estrito bloqueou a entrada com a linha original recolocada.

## Ampliação com mapas sintéticos

Foram acrescentadas quatro entradas reproduzíveis com Sol em Áries e Virgem na casa 10 e em Câncer e Aquário na casa 12. Cada uma deriva de um instante e local presentes no TSV de evidências. As quatro passaram no leitor sem avisos e selecionaram o texto solar correspondente. [Método de reprodução](validade-posicoes.md)

O mapa de Sol em Aquário na casa 12 passou em modo estrito com 15 posições, 2 eixos, 12 casas e 29 aspectos. Ele acrescentou 54 textos próprios à biblioteca, incluindo 13 posições. Os 11 mapas de referência mantiveram a seleção de textos.

O mapa de Sol em Virgem na casa 10 passou em modo estrito com 15 posições, 2 eixos, 12 casas e 33 aspectos. Ele acrescentou 58 textos próprios e preservou a seleção dos 12 mapas já validados. Ainda faltam 59 textos para o mapa de Sol em Câncer na casa 12 e 60 para o de Sol em Áries na casa 10.

| Seção | Observadas em 15 mapas | Com texto próprio | Sem texto próprio |
|---|---:|---:|---:|
| Casas | 179 | 155 | 24 |
| Aspectos | 660 | 591 | 69 |

Os números são lacunas confirmadas neste lote. A enumeração de todos os contextos válidos depende das regras de orbe da fonte, das convenções dos pontos e da definição uniforme das dependências de cada texto de casa. A grade básica continua disponível para localizar lacunas por casa e signo ou por par e tipo de aspecto.

```sh
texlua motor/inventario-editorial.lua mapa-b.txt mapa-c.txt mapa-d.txt
```
