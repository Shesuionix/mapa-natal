# Validade contextual de casas e aspectos

O inventário verifica as mesmas chaves que o motor consulta para selecionar textos. A execução começa com a entrada de referência A e aceita caminhos de mapas adicionais. Para servir de evidência, uma entrada deve passar pelo leitor, ter ASC–DSC e MC–IC em oposição, ter cada ocupante no intervalo da casa informada e ter os orbes compatíveis com as longitudes dos dois extremos. O intervalo inclui a cúspide inicial e termina antes da próxima. A comparação de orbes e eixos admite até 1,5′ de diferença para acomodar a precisão da entrada.

## Casas

A chave contém número, signo da cúspide, lista ordenada de ocupantes e posição do regente tradicional. Cada ocupante e regente carrega corpo, signo, casa e marca de retrogradação. Uma casa vazia tem lista vazia e conserva o regente na chave. O signo do regente vem da sua posição, enquanto a escolha de qual corpo rege a casa vem do signo da cúspide.

Os 12 textos de A também exigem o aspecto citado na prosa e as posições de seus dois extremos. Para os outros 36 textos, a seleção atual se apoia na cúspide, nos ocupantes e no regente. Antes de expandir o catálogo, a regra para referências a aspectos adicionais e regentes modernos precisa ser expressa de modo uniforme nas novas chaves. A presença de uma casa com determinado signo em um mapa só comprova a combinação completa observada naquele mapa.

## Aspectos

A chave contém par em ordem canônica, tipo de aspecto e posição dos dois extremos. Para um corpo ou ponto, a posição contém signo, casa e retrogradação. Para ASC, DSC, MC e IC, contém o signo do ângulo. Trocar a ordem dos extremos preserva a chave. Orbe e fase permanecem como informação técnica de cada ocorrência.

A conferência parte da menor distância circular em longitude. O orbe esperado é o módulo da diferença entre essa distância e o ângulo exato do tipo. Para enumerar possibilidades além das observadas, falta confirmar quais orbes o cálculo de origem admite para cada par e tipo. Essa política é relevante, por exemplo, para decidir quais aspectos o Sol pode formar com Mercúrio e Vênus dentro de sua separação máxima. [Elongação dos planetas interiores](https://ntrs.nasa.gov/api/citations/20230003802/downloads/Sheppard_2022_AJ_164_168.pdf)

## Resultado do lote

O lote reúne A a D e as entradas 01, 02, 03, 04, 05 e 07 do acervo. São dez mapas, com as seguintes chaves observadas.

| Seção | Observadas | Com texto próprio | Sem texto próprio |
|---|---:|---:|---:|
| Casas | 120 | 48 | 72 |
| Aspectos | 512 | 202 | 310 |

O caso 06 informa `Stationary` na posição de Netuno. O leitor atual reconhece o rótulo no bloco de velocidades, mas exige posição com ou sem `Retrograde`. O caso foi separado do lote e a entrada original foi preservada. A ampliação precisa definir a representação editorial da estacionariedade explícita e preservar o estado técnico informado no arquivo.

Os números são lacunas confirmadas neste lote. A enumeração de todos os contextos válidos depende das regras de orbe da fonte, das convenções dos pontos e da definição uniforme das dependências de cada texto de casa. A grade básica continua disponível para localizar lacunas por casa e signo ou por par e tipo de aspecto.

```sh
texlua motor/inventario-editorial.lua mapa-b.txt mapa-c.txt mapa-d.txt
```
