local text = {}

local body = {
  Sun="sua maneira de tomar a frente", Moon="o que ajuda você a se recompor",
  Mercury="seu jeito de organizar e comunicar ideias", Venus="o que você valoriza nas trocas",
  Mars="a forma como você põe uma decisão em prática", Jupiter="sua disposição para ampliar possibilidades",
  Saturn="a maneira como você dá continuidade aos compromissos", Uranus="sua disposição para mudar um arranjo",
  Neptune="o espaço que você dá à imaginação", Pluto="o que leva você a rever um padrão de fundo",
  ["North Node"]="as experiências que convidam você a aprender", Lilith="a maneira como você reivindica espaço",
  Chiron="os pontos em que agir exige mais cuidado", Fortune="onde um esforço encontra apoio",
  Vertex="os encontros que pedem uma resposta", Ascendant="seu jeito de chegar a uma situação",
  DSC="o que as parcerias pedem de você", MC="a contribuição pela qual você quer ser reconhecido",
  IC="o que dá sustentação à sua vida privada"
}
local sign = {
  Aries="dar o primeiro passo", Taurus="construir com regularidade", Gemini="perguntar e comparar versões",
  Cancer="perceber e acolher necessidades", Leo="expressar uma contribuição própria",
  Virgo="examinar detalhes e ajustar o processo", Libra="considerar os dois lados de um acordo",
  Scorpio="investigar o que está em jogo", Sagittarius="experimentar uma perspectiva mais ampla",
  Capricorn="organizar recursos e prazos", Aquarius="rever a lógica de um arranjo",
  Pisces="adaptar-se ao que a situação pede"
}
local house = {
  "nas primeiras impressões e iniciativas", "nas escolhas sobre tempo, dinheiro e valor",
  "nas conversas, estudos e trocas cotidianas", "na vida privada e nos acordos de casa",
  "na criação, no prazer e na expressão pessoal", "na rotina e na divisão do trabalho",
  "nas relações próximas e nas decisões a dois", "na intimidade e no uso de recursos compartilhados",
  "nos estudos de longo alcance e no contato com outras perspectivas",
  "no trabalho público e nas responsabilidades visíveis", "nas amizades e nos projetos de grupo",
  "nos momentos de recolhimento e elaboração"
}
local practice = {
  "Antes de agir, diga qual primeiro passo você pretende assumir.",
  "Antes de aceitar uma troca, explicite o custo e o que espera receber.",
  "Explique a ideia em suas palavras e mostre onde ela pode ser usada.",
  "Faça um combinado que proteja seu tempo e o de quem divide a rotina.",
  "Escolha uma primeira tentativa curta e observe o que dá vontade de continuar.",
  "Mude uma etapa do processo e confira se ela facilita a próxima.",
  "Combine o que cada pessoa pode assumir e quando vocês vão rever a decisão.",
  "Diga quem terá acesso, quem assume a responsabilidade e como o acordo será revisto.",
  "Experimente aplicar uma perspectiva nova a uma situação que você já conhece.",
  "Ao mostrar um resultado, diga qual decisão você tomou e o que ela tornou possível.",
  "Proponha uma contribuição delimitada e combine como ela se conecta ao trabalho do grupo.",
  "Reserve um intervalo para elaborar o que aconteceu antes de decidir sua resposta."
}
local ruler = {
  Aries="Mars", Taurus="Venus", Gemini="Mercury", Cancer="Moon", Leo="Sun",
  Virgo="Mercury", Libra="Venus", Scorpio="Mars", Sagittarius="Jupiter",
  Capricorn="Saturn", Aquarius="Saturn", Pisces="Jupiter"
}
local link = {
  Conjunction="Quando as duas aparecem na mesma situação, observe qual delas costuma assumir a frente e dê espaço à outra.",
  Sextile="Uma pode oferecer o primeiro passo para a outra. Escolha uma situação pequena para experimentar essa passagem.",
  Square="Elas podem pedir respostas diferentes no mesmo momento. Separe o que exige uma decisão agora do que pode ser retomado depois.",
  Trine="Uma tende a facilitar a outra. Observe em que situação isso já acontece e use o mesmo procedimento de forma deliberada.",
  Opposition="Cada uma pode puxar a decisão para um lado. Coloque as duas necessidades em palavras e procure um acordo que possa ser testado."
}

function text.position(p)
  local retrograde = p.retrograde and " Dê tempo para rever como você costuma responder antes de assumir um novo compromisso." or ""
  return ("Nesta parte do mapa, %s ganha forma %s. Seu ponto de partida tende a ser %s. %s%s"):format(
    body[p.name], house[p.house], sign[p.sign], practice[p.house], retrograde)
end

function text.axis(first_name, first, second_name, second, index)
  local action = index == 1 and "Numa decisão a dois, nomeie a sua preferência e abra espaço para a resposta da outra pessoa."
    or "Ao aceitar uma responsabilidade pública, combine qual parte da sua rotina privada precisa de proteção."
  return ("Para %s, você pode começar por %s. Para %s, o movimento pede %s. %s"):format(
    body[first_name], sign[first.sign], body[second_name], sign[second.sign], action)
end

function text.house(chart, number, names)
  local cusp = chart.cusps[number]
  local ruler_name = ruler[cusp.sign]
  local occupants, ruler_position = {}, nil
  for _, p in ipairs(chart.positions) do
    if p.name == ruler_name then ruler_position = p end
    if p.house == number then occupants[#occupants+1] = names[p.name] end
  end
  local occupied = #occupants > 0 and (" Aqui também entram os temas de %s, que ocupam esta casa."):format(table.concat(occupants,", ")) or ""
  return ("Para lidar com o que acontece %s, um ponto de partida é %s. O regente tradicional, %s, está na casa %d e liga esse tema às situações que você vive %s.%s %s"):format(
    house[number], sign[cusp.sign], names[ruler_name], ruler_position.house, house[ruler_position.house],
    occupied, practice[number])
end

function text.aspect(aspect, locations)
  local function placement(name)
    local p = locations[name]
    return p.house and (body[name] .. " " .. house[p.house] .. ", com a tendência a " .. sign[p.sign])
      or (body[name] .. " com ênfase em " .. sign[p.sign])
  end
  return ("Esta relação reúne %s e %s. %s"):format(
    placement(aspect.first), placement(aspect.second), link[aspect.kind])
end

return text