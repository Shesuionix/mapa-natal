# Refino das 12 evidências de Vênus em Virgem

O instante histórico JD 2398878.9280905863 tinha velocidade de aproximadamente -0,0002773135 grau/dia na instalação Swiss Ephemeris 2.10.03 verificada. Uma bisseção local refinou a estação para JD 2398878.935010532, com velocidade residual de aproximadamente +0,0000000007511 grau/dia e mudança de sinal no intervalo de ±0,02 dia.

O ajuste de cerca de 9,96 minutos preserva signo e as 12 casas das evidências Placidus da fila. Apenas os 12 instantes foram corrigidos, sem alterar chaves editoriais ou atribuir uma nova interpretação ao grau de Vênus. O arquivo evidencias-12-venus-estacionaria.tsv preserva os parâmetros com variante planeta.

O recálculo pode ser repetido pelo verificador de reconciliação com --arquivo docs/geracao-editorial/evidencias-12-venus-estacionaria.tsv. Todas as 12 evidências passaram no critério de módulo da velocidade abaixo de 0,000001 grau/dia, sinais opostos antes/depois e casa/signo recalculados.
