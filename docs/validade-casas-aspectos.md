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
| Casas | 131 | 49 | 82 |
| Aspectos | 529 | 202 | 327 |

O caso 06 informa `Stationary` na posição de Netuno e no bloco de velocidades. O leitor preserva a entrada original, identifica a posição estacionária e usa `Neptune|Scorpio|5|stationary` na seleção. A posição e a casa 5 desse caso já têm textos próprios. A posição estacionária participa também das chaves dos aspectos de Netuno no mapa.

Os números são lacunas confirmadas neste lote. A enumeração de todos os contextos válidos depende das regras de orbe da fonte, das convenções dos pontos e da definição uniforme das dependências de cada texto de casa. A grade básica continua disponível para localizar lacunas por casa e signo ou por par e tipo de aspecto.

```sh
texlua motor/inventario-editorial.lua mapa-b.txt mapa-c.txt mapa-d.txt
```
