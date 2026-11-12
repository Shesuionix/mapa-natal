# Leitura dos dados do mapa

Na raiz do repositório, execute:

```sh
texlua motor/validar.lua motor/exemplo.txt
```

O arquivo UTF-8 segue a exportação em inglês usada no demonstrativo, na ordem de posições, cúspides, aspectos e velocidades. O leitor aceita apóstrofos tipográficos e simples. ASC e MC podem aparecer no bloco de posições. Os quatro ângulos são obtidos pelas cúspides.

O validador retorna código 1 para erros de entrada e informa arquivo e linha. As divergências de casa, orbe e retrogradação são registradas como avisos. O leitor mantém o rótulo e a razão de velocidade informados, inclusive grafias como 115.x. A normalização das velocidades por uma referência versionada ainda será integrada.

Para integrar à geração, carregue entrada.lua e chame read(caminho). A função devolve positions, cusps, aspects, speeds, angles e warnings. Posições e orbes usam minutos de arco inteiros e velocidades usam segundos de arco com sinal. O demonstrativo integrado ainda compila com seus dados internos.
