# Escopo de produção

A primeira oferta é um relatório natal em PDF sob encomenda para pessoa física, com pagamento único por relatório. A operação começa com data, horário e local de nascimento validados. O cálculo fica com o operador, que fornece ao motor posições, cúspides, aspectos e velocidades. Horário informado é obrigatório. Há uma reemissão gratuita por correção de dados informados pelo cliente, dentro de prazo a definir.

## Leitura e estrutura

- Resumo executivo e roda TikZ na abertura.
- Capítulos sobre pensamento e expressão, relações e trabalho, seguidos de orientações concretas.
- Dez aspectos destacados no demonstrativo. O apêndice contém glossário, posições, dois eixos, doze casas e catálogo de 58 aspectos.
- Interpretação psicológica e prática em linguagem acessível. Referências rastreáveis. Um texto principal por aspecto, com orbe e fase para consulta.
- Casas interpretadas pelo regente tradicional, sua posição, seus aspectos e os ocupantes. Regência moderna quando acrescenta informação relevante.
- Biblioteca de textos preparada antes da operação comercial, revisada pelo responsável e versionada. A produção do relatório opera localmente, sem IA.

## Motor e critérios de entrega

- Lua para ingestão, validação e cálculo. LaTeX para apresentação.
- Gerar um PDF por pedido e log local. Registrar versões do motor e da biblioteca e SHA-256 do insumo.
- Reproduzir o PDF byte a byte com os mesmos dados e versões de compilador, fontes e pacotes.
- Painel de velocidades: delta em graus por dia como premissa, direção pelo sinal e razão pelo módulo do delta dividido pela velocidade de referência. Registrar divergências de rótulo e razão no log.
- Meta operacional: menos de 15 minutos para gerar, revisar e enviar. Medir atendimento, validação e cálculo para estimar o custo total.

## Estado atual

O demonstrativo integrado tem leitura temática, sumário, links, roda TikZ e tabelas de posições e cúspides. Os textos e os dados estão fixos no fonte do demonstrativo. Faltam ingestão dos quatro blocos, seleção determinística da biblioteca, linhas e grade de aspectos, painel de velocidades, rastreabilidade, verificação de reprodutibilidade e revisão para uso comercial.

Preço, canal, prazo de entrega, janela de reemissão e verificação de autoria e licenças continuam pendentes. Insumos e relatórios que identificam clientes são tratados localmente.
