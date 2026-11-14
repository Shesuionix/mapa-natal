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

## Pipeline de produção

Entrada → Validação → Modelo normalizado → Análise → Plano editorial → Conteúdo → Renderização → PDF → Controle de qualidade

1. **Entrada.** Receber do operador o arquivo com posições, cúspides, aspectos e velocidades.
2. **Validação.** Conferir o contrato de entrada e registrar erros e divergências com a localização no arquivo. Interromper a geração se houver erro bloqueante.
3. **Modelo normalizado.** Usar os mesmos dados normalizados para a análise, a roda e as tabelas.
4. **Análise.** Aplicar regras versionadas para identificar regências, relações e fatores relevantes. Vincular os resultados aos dados de origem.
5. **Plano editorial.** Selecionar e ordenar os temas e seus destaques com regras determinísticas. Evitar repetições entre a síntese e as leituras detalhadas.
6. **Conteúdo.** Selecionar um texto próprio para cada combinação válida no contrato suportado. Registrar cada lacuna e bloquear a geração final quando faltar um texto obrigatório. A composição pode ser usada em prévias de desenvolvimento.
7. **Renderização.** Compilar localmente com LuaLaTeX, em pasta isolada, com as passagens necessárias para estabilizar as referências.
8. **PDF.** Entregar o relatório e manter o SHA-256, as versões e o diagnóstico no registro interno.
9. **Controle de qualidade.** Conferir a correspondência entre entrada, interpretação, roda e tabelas, além da integridade do PDF, dos links e da diagramação.

A prioridade atual é completar e validar a biblioteca de textos próprios para as combinações válidas do motor. A revisão de apresentação e layout começa depois dessa etapa. O produto permanece em desenvolvimento e ainda não está liberado para venda.

## Estado atual

O motor já lê os quatro blocos, seleciona textos, gera a roda e as tabelas e registra o SHA-256 no log local. O modo de verificação estrita pode ser ativado com `NATAL_EXIGIR_TEXTOS_PROPRIOS=1`. A cobertura integral da biblioteca e a tabela de referência de velocidades continuam pendentes.

A auditoria demonstrou 3.684 combinações de posições sem marca estacionária. Destas, 360 têm texto próprio. A biblioteca tem 1.224 textos próprios. Cobre as 144 combinações do Sol e as 24 combinações de Lua nas casas 1 e 2. Os 11 mapas de referência e os quatro mapas sintéticos passam em modo estrito, com cobertura das 179 chaves de casas e 660 de aspectos observadas. Os limites de seleção de orbe e as convenções de movimento e dos pontos na fonte seguem em aberto. [Validade de posições](validade-posicoes.md) · [Validade de casas e aspectos](validade-casas-aspectos.md)

Os relatórios e logs dos mapas auditados, as versões de trabalho e as entradas descartadas estão no [acervo](../acervo/).

Preço, canal, prazo de entrega, janela de reemissão e verificação de autoria e licenças continuam pendentes. Insumos e relatórios que identificam clientes são tratados localmente.
