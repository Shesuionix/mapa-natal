local catalog = dofile("catalogo-editorial.lua")
local position_key, aspect_key, editorial_facts = catalog.position_key, catalog.aspect_key, catalog.facts
local axis_pairs, axis_library = catalog.axis_pairs, catalog.axes
local composed = dofile("leitura-composta.lua")
local reader = dofile("entrada.lua")
local strict = os.getenv("NATAL_EXIGIR_TEXTOS_PROPRIOS") == "1"
local chart, raw = reader.read(os.getenv("NATAL_ENTRADA") or "exemplo.txt")
local digest = require("sha2").digest256(raw)
if #digest == 32 then
  digest = digest:gsub(".", function(byte) return ("%02x"):format(byte:byte()) end)
end
assert(#digest == 64 and digest:match("^%x+$"), "SHA-256 inválido")
texio.write_nl("term and log", "[Mapa Natal] SHA-256 " .. digest:lower())
for _, warning in ipairs(chart.warnings) do
  texio.write_nl("term and log", "[Mapa Natal] " .. warning)
end
if strict and chart.aspect_orb_errors > 0 then
  error(("Geometria incompatível. Total de orbes divergentes: %d. Consulte o log."):format(chart.aspect_orb_errors), 0)
end

local signs = {
  Aries="Áries", Taurus="Touro", Gemini="Gêmeos", Cancer="Câncer",
  Leo="Leão", Virgo="Virgem", Libra="Libra", Scorpio="Escorpião",
  Sagittarius="Sagitário", Capricorn="Capricórnio", Aquarius="Aquário", Pisces="Peixes"
}
local names = {
  Sun="Sol", Moon="Lua", Mercury="Mercúrio", Venus="Vênus", Mars="Marte",
  Jupiter="Júpiter", Saturn="Saturno", Uranus="Urano", Neptune="Netuno",
  Pluto="Plutão", ["North Node"]="Nodo Norte", Lilith="Lilith", Chiron="Quíron",
  Fortune="Fortuna", Vertex="Vertex", Ascendant="ASC", DSC="DSC", MC="MC", IC="IC"
}
local types = {
  Conjunction={"Conjunção","☌"}, Sextile={"Sextil","⚹"}, Square={"Quadratura","□"},
  Trine={"Trígono","△"}, Opposition={"Oposição","☍"}
}
local phases = {Applying="Aplicativo", Separating="Separativo"}
local angles = {[1]="ASC", [4]="IC", [7]="DSC", [10]="MC"}
local planet_csv, cusp_csv, aspect_text = {}, {}, {}
local positions, cusps, aspects, speeds, grid = {}, {}, {}, {}, {}

local function row(rows, ...)
  rows[#rows+1] = table.concat({...}, " & ") .. [[\\]]
end

local function angle(minutes)
  return ("%d°%02d\\ensuremath{^{\\prime}}"):format(minutes // 60, minutes % 60)
end

for index, position in ipairs(chart.positions) do
  planet_csv[index] = ("%.10f"):format(position.arcminutes / 60)
  row(positions, names[position.name], signs[position.sign], angle(position.degree*60+position.minute),
    position.house, position.stationary and "E" or (position.retrograde and "R" or ""))
end
for house, cusp in ipairs(chart.cusps) do
  cusp_csv[house] = ("%.10f"):format(cusp.arcminutes / 60)
  row(cusps, house, signs[cusp.sign], angle(cusp.degree*60+cusp.minute), angles[house] or "")
end

local pairs_by_body = {}
for _, position in ipairs(chart.positions) do pairs_by_body[position.name] = {} end
local function wheel_name(name)
  return name == "North Node" and "Node" or name
end
for index, aspect in ipairs(chart.aspects) do
  aspect_text[index] = ("%s %s %s (Orb: %d°%02d', %s)"):format(
    wheel_name(aspect.first), aspect.kind, wheel_name(aspect.second),
    aspect.orb // 60, aspect.orb % 60, aspect.phase)
  row(aspects, names[aspect.first], names[aspect.second], types[aspect.kind][1], angle(aspect.orb), phases[aspect.phase])
  if pairs_by_body[aspect.first] and pairs_by_body[aspect.second] then
    pairs_by_body[aspect.first][aspect.second] = types[aspect.kind][2]
    pairs_by_body[aspect.second][aspect.first] = types[aspect.kind][2]
  end
end

local symbols = {"☉", "☽", "☿", "♀", "♂", "♃", "♄", "♅", "♆", "♇", "☊", "⚸", "⚷", "⊗", "VX"}
local function glyph(symbol)
  return "\\NatalGlifo{" .. symbol .. "}"
end
local grid_header = {"Corpo ou ponto"}
for _, symbol in ipairs(symbols) do
  grid_header[#grid_header+1] = glyph(symbol)
end
row(grid, table.unpack(grid_header))
grid[#grid+1] = "\\hline"

for i, first in ipairs(chart.positions) do
  local cells = {glyph(symbols[i]) .. " " .. names[first.name]}
  for j, second in ipairs(chart.positions) do
    local symbol = j < i and pairs_by_body[first.name][second.name]
    cells[#cells+1] = symbol and glyph(symbol) or (j == i and "\\cellcolor{black}" or "")
  end
  row(grid, table.unpack(cells))
  grid[#grid+1] = "\\hline"
end

local motor_version = "0.2.0"
texio.write_nl("log", "[Mapa Natal] Motor " .. motor_version)
local reference_path = os.getenv("NATAL_VELOCIDADES")
local reference, reference_version = {}, "Sem referência de velocidades"
if reference_path and reference_path ~= "" then
  local file = assert(io.open(reference_path, "r"))
  local header = file:read("*l") or ""
  reference_version = assert(header:match("^versao=([%w%.%-]+)%s*$"), "Cabeçalho esperado: versao=IDENTIFICADOR")
  local line_number = 1
  for line in file:lines() do
    line_number = line_number + 1
    if line:match("%S") then
      local name, value = line:match("^%s*([%a ]-)%s*=%s*(%d+%.?%d*)%s*$")
      local rate = tonumber(value)
      assert(name and names[name] and name ~= "Ascendant" and name ~= "DSC" and name ~= "MC" and name ~= "IC" and rate and rate > 0 and rate < math.huge and not reference[name],
        ("%s:%d: corpo ou velocidade de referência inválida ou repetida"):format(reference_path, line_number))
      reference[name] = rate
    end
  end
  file:close()
  reference_version = "Referência de velocidades " .. reference_version
end
texio.write_nl("log", "[Mapa Natal] " .. reference_version)
for _, speed in ipairs(chart.speeds) do
  local seconds = math.abs(speed.delta_arcseconds)
  local direction = speed.delta_arcseconds < 0 and "Retrógrado" or
    (speed.delta_arcseconds > 0 and "Direto" or (speed.stationary and "Estacionário" or "Indefinida"))
  local delta = ("%s%d°%02d\\ensuremath{^{\\prime}}%02d\\ensuremath{^{\\prime\\prime}}"):format(
    speed.delta_arcseconds < 0 and "-" or "", seconds // 3600, (seconds // 60) % 60, seconds % 60)
  local ratio_text = "—"
  local rate = reference[speed.name]
  if rate then
    local ratio = seconds / 3600 / rate
    assert(ratio < math.huge, "Razão recalculada fora do intervalo: " .. speed.name)
    ratio_text = ("%.2f"):format(ratio)
    if math.abs(ratio - speed.ratio) > 0.05 then
      texio.write_nl("term and log", ("[Mapa Natal] Linha %d (%s): razão informada %s, recalculada %s"):format(
        speed.line, speed.name, speed.ratio_text, ratio_text))
    end
  elseif reference_path and reference_path ~= "" then
    texio.write_nl("term and log", "[Mapa Natal] Sem velocidade de referência para " .. speed.name)
  end
  row(speeds, names[speed.name], delta, direction, speed.label, speed.ratio_text, ratio_text)
end

token.set_macro("NatalPlanetsCSV", table.concat(planet_csv, ","), "global")
token.set_macro("NatalHousesCSV", table.concat(cusp_csv, ","), "global")
token.set_macro("NatalAspectsText", table.concat(aspect_text, ", "), "global")
for macro, rows in pairs({
  NatalPosicoes=positions, NatalCusps=cusps, NatalAspectos=aspects,
  NatalVelocidades=speeds, NatalGrade=grid
}) do
  token.set_macro(macro, table.concat(rows, " "), "global")
end
-- Match the chart behind the reviewed text, independent of file formatting.
local function editorial_key(data)
  local parts, aspects = {}, {}
  for _, position in ipairs(data.positions) do
    parts[#parts+1] = ("%d:%s"):format(position.arcminutes, position_key(position))
  end
  for _, cusp in ipairs(data.cusps) do parts[#parts+1] = tostring(cusp.arcminutes) end
  for _, aspect in ipairs(data.aspects) do
    local first, second = aspect.first, aspect.second
    if second < first then first, second = second, first end
    aspects[#aspects+1] = ("%s:%s:%s:%d:%s"):format(first, second, aspect.kind, aspect.orb, aspect.phase)
  end
  table.sort(aspects)
  return table.concat(parts, "|") .. "|" .. table.concat(aspects, "|")
end

local reviewed = reader.read("mapa-editorial-v1.txt")
local matched = editorial_key(chart) == editorial_key(reviewed)
token.set_macro("NatalTemLeitura", matched and "1" or "0", "global")
if matched then texio.write_nl("log", "[Mapa Natal] Biblioteca editorial demonstrativa 1.0") end

-- Texts describe sign, house and motion together. Degrees are taken from the input.
local position_library = catalog.positions(reviewed)
local missing = {}
local function gap(section, key)
  missing[#missing+1] = section .. ": " .. key
end

local selected, specific_positions = {}, 0
do
  for _, position in ipairs(chart.positions) do
    local index = position_library[position_key(position)]
    if index then specific_positions = specific_positions + 1 end
    selected[#selected+1] = ("\\NatalLeituraPosicao{%d}{%s}{%s}{%s}{%d}{%s}"):format(
        index or 0, names[position.name], signs[position.sign], angle(position.degree*60+position.minute),
        position.house, position.stationary and " · Estacionário" or (position.retrograde and " · Retrógrado" or ""))
    if not index then gap("posicao", position_key(position)) end
    if not index then selected[#selected] = selected[#selected] .. composed.position(position) .. "\\par " end
  end
end
token.set_macro("NatalTotalLeituras", tostring(#selected), "global")
token.set_macro("NatalLeiturasSelecionadas", table.concat(selected), "global")
if #selected > 0 then
  texio.write_nl("log", ("[Mapa Natal] Posições apresentadas: %d de %d leituras"):format(
    #selected, #chart.positions))
end
local selected_axes, specific_axes = {}, 0
do
  for axis_index, axis in ipairs(axis_pairs) do
    local first, second = chart.angles[axis[1]], chart.angles[axis[2]]
    local index = axis_library[axis_index][first.sign .. "|" .. second.sign]
    if index then specific_axes = specific_axes + 1 end
    selected_axes[#selected_axes+1] = ("\\NatalLeituraEixo{%d}{%s}{%s}{%s}{%s}{%s}"):format(
        index or 0, axis[3], signs[first.sign], angle(first.degree*60+first.minute),
        signs[second.sign], angle(second.degree*60+second.minute))
    if not index then gap("eixo", axis[1] .. "|" .. first.sign .. "|" .. second.sign) end
    if not index then selected_axes[#selected_axes] = selected_axes[#selected_axes] ..
      composed.axis(axis[1], first, axis[2], second, axis_index) .. "\\par " end
  end
end
token.set_macro("NatalTotalEixos", tostring(#selected_axes), "global")
token.set_macro("NatalLeiturasEixos", table.concat(selected_axes), "global")
if #selected_axes > 0 then
  texio.write_nl("log", ("[Mapa Natal] Eixos apresentados: %d de 2 leituras"):format(#selected_axes))
end
-- Dependencies of the reviewed prose, in house order.

local selected_houses, specific_houses = {}, 0
do
  local current_positions, current_occupants, current_aspects = editorial_facts(chart)
  local library = catalog.houses(reviewed)
  for house = 1, 12 do
    local cusp = chart.cusps[house]
    local index, key = catalog.select_house(house, chart, current_positions, current_occupants, current_aspects, library)
    local degree = angle(cusp.degree*60+cusp.minute)
    if index then
      specific_houses = specific_houses + 1
      selected_houses[#selected_houses+1] = ("\\NatalLeituraCasa{%d}{%s}{%s}"):format(index, signs[cusp.sign], degree)
    else
      gap("casa", key)
      selected_houses[#selected_houses+1] = ("\\NatalCasaComposta{%d}{%s}{%s}%s\\par "):format(
        house, signs[cusp.sign], degree, composed.house(chart, house, names))
    end
  end
end
token.set_macro("NatalTotalCasas", tostring(#selected_houses), "global")
token.set_macro("NatalLeiturasCasas", table.concat(selected_houses), "global")
if #selected_houses > 0 then
  texio.write_nl("log", ("[Mapa Natal] Casas apresentadas: %d de 12 leituras"):format(#selected_houses))
end

local selected_aspects, specific_aspects = {}, 0
local aspect_ids = {}
do
  local current_positions = editorial_facts(chart)
  local library, locations = catalog.aspects(reviewed), {}
  for name, cusp in pairs(chart.angles) do locations[name] = cusp end
  for _, p in ipairs(chart.positions) do locations[p.name] = p end
  for id, aspect in ipairs(chart.aspects) do
    aspect_ids[aspect_key(aspect)] = id
    local key = catalog.contextual_aspect_key(aspect, current_positions)
    local index = library[key]
    if index then specific_aspects = specific_aspects + 1 end
    selected_aspects[#selected_aspects+1] = ("\\NatalLeituraAspecto{%d}{%s}{%s}{%s}{%s}{%s}{%d}"):format(
        index or 0, names[aspect.first], types[aspect.kind][1], names[aspect.second],
        angle(aspect.orb), phases[aspect.phase], id)
    if not index then gap("aspecto", key) end
    if not index then selected_aspects[#selected_aspects] = selected_aspects[#selected_aspects] ..
      composed.aspect(aspect, locations) .. "\\par " end
  end
end
token.set_macro("NatalTotalAspectos", tostring(#selected_aspects), "global")
token.set_macro("NatalAspectosEntrada", tostring(#chart.aspects), "global")
token.set_macro("NatalLeiturasAspectos", table.concat(selected_aspects), "global")
if #selected_aspects > 0 then
  texio.write_nl("log", ("[Mapa Natal] Aspectos apresentados: %d de %d leituras"):format(
    #selected_aspects, #chart.aspects))
end
texio.write_nl("log", ("[Mapa Natal] Aspectos com texto específico: %d de %d"):format(specific_aspects, #chart.aspects))
-- Pick distinct pairs so each chapter develops a different part of the map.
local topics = {
  {title="Expressão e aprendizado", bodies={Sun=true,Mercury=true,Ascendant=true}, houses={[1]=true,[3]=true,[9]=true},
    action="Explique uma ideia com suas palavras e dê um exemplo do que ela muda na prática."},
  {title="Relações e compromissos", bodies={Moon=true,Venus=true,DSC=true}, houses={[7]=true,[8]=true},
    action="Numa decisão a dois, diga o que já consegue assumir e combinem quando o acordo será revisto."},
  {title="Trabalho e direção", bodies={Mars=true,Saturn=true,MC=true}, houses={[2]=true,[6]=true,[10]=true},
    action="Escolha uma entrega concreta e mostre qual decisão sua ajudou a produzir o resultado."}
}
local synthesis_notes = {
  ["Ascendant|Trine|Sun:Gemini:Sun|Aquarius|9|false"]="Uma pergunta bem feita pode mudar o rumo de um estudo ou de uma conversa. Quando perceber que duas pessoas estão partindo de premissas diferentes, diga qual delas quer testar e proponha uma situação em que a diferença possa ser observada.",
  ["Pluto|Conjunction|Venus:Pluto|Sagittarius|7|false:Venus|Sagittarius|7|false"]="Uma parceria ganha intensidade quando vocês encontram algo importante para descobrir juntos. Antes de investir muito tempo, combinem o que farão em conjunto e o que cada pessoa quer manter como decisão própria.",
  ["MC|Square|Mars:Pisces:Mars|Sagittarius|7|false"]="Você pode querer responder logo ao pedido de um parceiro e perceber depois que ele compete com uma entrega do trabalho. Antes de confirmar, diga qual prazo precisaria mudar e proponha uma ordem para as duas demandas.",
  ["Pluto|Conjunction|Sun:Pluto|Sagittarius|1|false:Sun|Sagittarius|1|false"]="Quando uma convicção muda, suas escolhas tendem a mudar junto. Ao comunicar uma decisão, explique primeiro o problema que fez você rever sua posição e depois qual passo pretende dar.",
  ["Moon|Trine|Venus:Moon|Pisces|4|false:Venus|Scorpio|12|false"]="Um tempo protegido em casa ajuda você a reconhecer o afeto que ainda estava elaborando em silêncio. Quando o que sente ficar mais claro, escolha um gesto ou uma frase que dê à outra pessoa algo concreto para reconhecer.",
  ["Jupiter|Conjunction|MC:Jupiter|Leo|10|true:Leo"]="Seu trabalho ganha alcance quando você mostra como uma ideia pode ser usada. Ao apresentar um resultado, conte qual problema assumiu, o que mudou e como outras pessoas podem aproveitar a solução.",
  ["Ascendant|Opposition|Sun:Aries:Sun|Libra|6|false"]="Você pode entrar numa situação com vontade de resolver logo e, na rotina, descobrir que a tarefa exige acordo entre várias pessoas. Nomeie o primeiro passo que consegue dar e consulte quem será afetado antes de mudar o procedimento.",
  ["Moon|Trine|Venus:Moon|Pisces|11|false:Venus|Scorpio|7|false"]="Você percebe com facilidade quando alguém fica à margem de um grupo e tende a cuidar de vínculos próximos com atenção mais concentrada. Se uma pessoa importante precisar de apoio, pergunte que tipo de presença faria diferença antes de assumir a tarefa.",
  ["MC|Square|Sun:Capricorn:Sun|Libra|6|false"]="Uma responsabilidade visível pode exigir prazo e decisão enquanto a equipe ainda está ajustando a divisão do trabalho. Antes de apresentar uma data, confirme quem assume cada parte e diga o que precisa estar resolvido para que a entrega seja viável."
}
local function synthesis()
  local placements = {}
  for _, p in ipairs(chart.positions) do placements[p.name] = p end
  for name, cusp in pairs(chart.angles) do placements[name] = cusp end
  local used = {}
  local positions = editorial_facts(chart)
  local result = {
    ("O Sol em %s na casa %d, a Lua em %s na casa %d e o Ascendente em %s orientam a leitura."):format(
      signs[placements.Sun.sign], placements.Sun.house,
      signs[placements.Moon.sign], placements.Moon.house, signs[placements.Ascendant.sign]),
    "\\par "
  }
  for _, topic in ipairs(topics) do
    local best, best_score
    for _, a in ipairs(chart.aspects) do
      local key = aspect_key(a)
      if not used[key] then
        local score = 0
        for _, name in ipairs({a.first,a.second}) do
          if topic.bodies[name] then score = score + 2 end
          if topic.houses[placements[name].house] then score = score + 1 end
        end
        if score > 0 and (not best or score > best_score or
          (score == best_score and (a.orb < best.orb or (a.orb == best.orb and key < aspect_key(best))))) then
          best, best_score = a, score
        end
      end
    end
    result[#result+1] = "\\subsection*{" .. topic.title .. "}"
    if best then
      used[aspect_key(best)] = true
      local first, second = best.first, best.second
      if second < first then first, second = second, first end
      local key = aspect_key(best) .. ":" .. positions[first] .. ":" .. positions[second]
      local note = synthesis_notes[key]
      result[#result+1] = ("\\hyperref[aspecto:%d]{%s e %s em %s}. %s"):format(
        aspect_ids[aspect_key(best)], names[best.first], names[best.second],
        types[best.kind][1]:lower(), note or composed.aspect(best, placements))
      if not note then result[#result+1] = "\\par\\smallskip " .. topic.action end
    else
      local p = placements[({["Expressão e aprendizado"]="Mercury",["Relações e compromissos"]="Venus",["Trabalho e direção"]="Saturn"})[topic.title]]
      result[#result+1] = composed.position(p) .. "\\par\\smallskip " .. topic.action
    end
    result[#result+1] = "\\par "
  end
  return table.concat(result, " ")
end

if not matched then token.set_macro("NatalSinteseTematica", synthesis(), "global") end
local ranked = {}
for _, aspect in ipairs(chart.aspects) do ranked[#ranked+1] = aspect end
table.sort(ranked, function(a, b)
  if a.orb ~= b.orb then return a.orb < b.orb end
  return aspect_key(a) < aspect_key(b)
end)

-- Opposite angles often restate the same geometry. Keep one highlight per axis and partner.
local axis_group = {Ascendant="horizonte",DSC="horizonte",MC="meridiano",IC="meridiano"}
local seen, highlights = {}, {}
for _, aspect in ipairs(ranked) do
  local first, second = axis_group[aspect.first] or aspect.first, axis_group[aspect.second] or aspect.second
  if second < first then first, second = second, first end
  local key = first .. "|" .. second
  if not seen[key] then
    seen[key] = true
    highlights[#highlights+1] = ("\\item \\hyperref[aspecto:%d]{%s e %s em %s} · %s."):format(
      aspect_ids[aspect_key(aspect)], names[aspect.first], names[aspect.second],
      types[aspect.kind][1]:lower(), angle(aspect.orb))
    if #highlights == 10 then break end
  end
end
token.set_macro("NatalTotalDestaques", tostring(#highlights), "global")
token.set_macro("NatalDestaques", table.concat(highlights, " "), "global")
local coverage = {
  {"posicoes", specific_positions, #chart.positions},
  {"eixos", specific_axes, #axis_pairs},
  {"casas", specific_houses, #chart.cusps},
  {"aspectos", specific_aspects, #chart.aspects}
}
for _, section in ipairs(coverage) do
  local label, specific, total = table.unpack(section)
  texio.write_nl("log", ("[Cobertura] %s: %d proprios, %d compostos"):format(label, specific, total-specific))
end
for _, item in ipairs(missing) do
  texio.write_nl("log", "[Lacuna editorial] " .. item)
end
if strict and #missing > 0 then
  error(("Cobertura editorial incompleta: %d leituras sem texto próprio. Consulte o log."):format(#missing), 0)
end
