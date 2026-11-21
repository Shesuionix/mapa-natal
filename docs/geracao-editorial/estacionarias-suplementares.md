# Evidências das 288 estacionárias suplementares

Foram demonstradas 144 posições de Nodo Norte verdadeiro e 144 de Lilith osculante, nos 12 signos e nas 12 casas. As variantes médias não são intercambiáveis com essas variantes na reprodução.

As evidências estão em evidencias-288-estacionarias.tsv. A busca iniciou em 1800 e encontrou raízes da velocidade em longitude por bisseção, a partir de mudanças de sinal em intervalos de meio dia. Cada testemunho foi aceito com módulo da velocidade inferior a 0,000001 grau/dia e velocidades de sinais opostos 0,02 dia antes e depois. O registro contém os valores e as coordenadas utilizadas. As casas Placidus foram conferidas com o arredondamento em minutos do leitor. Swiss Ephemeris 2.10.03 e hashes das efemérides foram verificados.

O limiar é um critério desta auditoria para identificar uma estação real; não altera o contrato do motor, que recebe Stationary explicitamente. Não significa que todo delta arredondado para zero deva receber essa classificação.

O verificador pode repetir o cálculo:

```sh
python ferramentas/verificar-reconciliacao-posicoes.py DIRETORIO_EFEMERIDES --deps DIRETORIO_SWISSEPH --arquivo docs/geracao-editorial/evidencias-288-estacionarias.tsv
```

As 288 chaves foram acrescentadas ao fim da fila, preservando as linhas anteriores e a proveniência separada. Seus textos ainda precisam ser produzidos. A frente de redação autorizada nesta execução contempla as 12 estacionárias de Vênus em Virgem já existentes na fila. As 288 novas não são contadas como publicadas.

O universo admitido de estacionárias contém 1.584 chaves. Antes da redação das 12 de Vênus, são 1.284 publicadas e 300 pendentes, agora todas representadas na fila. Sol, Lua, Fortuna e Vertex estacionários permanecem excluídos pelo contrato de movimento.
