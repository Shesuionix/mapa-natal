local reader = dofile("entrada.lua")
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
    position.house, position.retrograde and "R" or "")
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

local motor_version = "0.1.0"
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
    (speed.delta_arcseconds == 0 and "Estacionário" or "Direto")
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
    parts[#parts+1] = ("%s:%d:%d:%s"):format(position.name, position.arcminutes,
      position.house, tostring(position.retrograde))
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
local function position_key(position)
  return table.concat({position.name, position.sign, position.house, tostring(position.retrograde)}, "|")
end
local position_library = {
  ["Sun|Aquarius|9|false"] = 16,
  ["Moon|Scorpio|6|false"] = 17,
  ["Mercury|Capricorn|8|false"] = 18,
  ["Venus|Sagittarius|7|false"] = 19,
  ["Mars|Sagittarius|7|false"] = 20,
  ["Jupiter|Leo|3|true"] = 21,
  ["Saturn|Gemini|1|true"] = 22,
  ["Uranus|Aquarius|9|false"] = 23,
  ["Neptune|Aquarius|9|false"] = 24,
  ["Pluto|Sagittarius|7|false"] = 25,
  ["North Node|Gemini|1|true"] = 26,
  ["Lilith|Aries|11|false"] = 27,
  ["Chiron|Capricorn|8|false"] = 28,
  ["Fortune|Pisces|10|false"] = 29,
  ["Vertex|Aquarius|9|false"] = 30,
  ["Sun|Sagittarius|1|false"] = 31,
  ["Moon|Pisces|4|false"] = 32,
  ["Mercury|Capricorn|2|false"] = 33,
  ["Venus|Scorpio|12|false"] = 34,
  ["Mars|Scorpio|12|false"] = 35,
  ["Jupiter|Leo|10|true"] = 36,
  ["Saturn|Gemini|8|true"] = 37,
  ["Uranus|Aquarius|4|false"] = 38,
  ["Neptune|Aquarius|3|false"] = 39,
  ["Pluto|Sagittarius|1|false"] = 40,
  ["North Node|Gemini|7|true"] = 41,
  ["Lilith|Aries|6|false"] = 42,
  ["Chiron|Capricorn|2|false"] = 43,
  ["Fortune|Virgo|10|false"] = 44,
  ["Vertex|Aries|5|false"] = 45,
}
for index, position in ipairs(reviewed.positions) do
  position_library[position_key(position)] = index
end
local selected = {}
if not matched then
  for _, position in ipairs(chart.positions) do
    local index = position_library[position_key(position)]
    if index then
      selected[#selected+1] = ("\\NatalLeituraPosicao{%d}{%s}{%s}{%s}{%d}{%s}"):format(
        index, names[position.name], signs[position.sign], angle(position.degree*60+position.minute),
        position.house, position.retrograde and " · Retrógrado" or "")
    end
  end
end
token.set_macro("NatalTotalLeituras", tostring(#selected), "global")
token.set_macro("NatalLeiturasSelecionadas", table.concat(selected), "global")
if #selected > 0 then
  texio.write_nl("log", ("[Mapa Natal] Biblioteca de posições 1.1: %d de %d leituras"):format(
    #selected, #chart.positions))
end
local axis_pairs = {
  {"Ascendant", "DSC", "Ascendente e Descendente"},
  {"MC", "IC", "Meio do Céu e Fundo do Céu"}
}
local axis_library = {
  [1] = {["Libra|Aries"]=1, ["Gemini|Sagittarius"]=3, ["Scorpio|Taurus"]=5},
  [2] = {["Cancer|Capricorn"]=2, ["Pisces|Virgo"]=4, ["Leo|Aquarius"]=6}
}
local selected_axes = {}
if not matched then
  for axis_index, axis in ipairs(axis_pairs) do
    local first, second = chart.angles[axis[1]], chart.angles[axis[2]]
    local index = axis_library[axis_index][first.sign .. "|" .. second.sign]
    if index then
      selected_axes[#selected_axes+1] = ("\\NatalLeituraEixo{%d}{%s}{%s}{%s}{%s}{%s}"):format(
        index, axis[3], signs[first.sign], angle(first.degree*60+first.minute),
        signs[second.sign], angle(second.degree*60+second.minute))
    end
  end
end
token.set_macro("NatalTotalEixos", tostring(#selected_axes), "global")
token.set_macro("NatalLeiturasEixos", table.concat(selected_axes), "global")
if #selected_axes > 0 then
  texio.write_nl("log", ("[Mapa Natal] Biblioteca de eixos 1.1: %d de 2 leituras"):format(#selected_axes))
end
-- Dependencies of the reviewed prose, in house order.
local house_rules = {
  {"Venus", "Moon|Square|Venus"},
  {"Mars", "Mars|Sextile|Sun"},
  {"Jupiter", "Jupiter|Square|Mercury"},
  {"Saturn", "Jupiter|Opposition|Saturn"},
  {"Saturn", "Saturn|Trine|Venus"},
  {"Jupiter", "Jupiter|Opposition|Saturn"},
  {"Mars", "Mars|Sextile|Sun"},
  {"Venus", "Saturn|Trine|Venus"},
  {"Mercury", "Jupiter|Square|Mercury"},
  {"Moon", "MC|Square|Moon"},
  {"Sun", "Sun|Conjunction|Venus"},
  {"Mercury", "Mercury|Trine|Pluto"}
}
local function editorial_facts(data)
  local positions, occupants, aspects = {}, {}, {}
  for house = 1, 12 do occupants[house] = {} end
  for _, position in ipairs(data.positions) do
    local key = table.concat({position.name, position.sign, position.house, tostring(position.retrograde)}, "|")
    positions[position.name] = key
    local house = occupants[position.house]
    house[#house+1] = key
  end
  for name, cusp in pairs(data.angles) do positions[name] = cusp.sign end
  for _, aspect in ipairs(data.aspects) do
    local first, second = aspect.first, aspect.second
    if second < first then first, second = second, first end
    aspects[table.concat({first, aspect.kind, second}, "|")] = true
  end
  for house = 1, 12 do occupants[house] = table.concat(occupants[house], ";") end
  return positions, occupants, aspects
end

local selected_houses = {}
if not matched then
  local current_positions, current_occupants, current_aspects = editorial_facts(chart)
  local reviewed_positions, reviewed_occupants = editorial_facts(reviewed)
  for house, rule in ipairs(house_rules) do
    local ruler, aspect = rule[1], rule[2]
    local first, second = aspect:match("^([^|]+)|[^|]+|([^|]+)$")
    if chart.cusps[house].sign == reviewed.cusps[house].sign and
      current_occupants[house] == reviewed_occupants[house] and
      current_positions[ruler] == reviewed_positions[ruler] and current_aspects[aspect] and
      current_positions[first] == reviewed_positions[first] and
      current_positions[second] == reviewed_positions[second] then
      selected_houses[#selected_houses+1] = ("\\NatalLeituraCasa{%d}{%s}{%s}"):format(
        house, signs[chart.cusps[house].sign], angle(chart.cusps[house].degree*60+chart.cusps[house].minute))
    end
  end
end
token.set_macro("NatalTotalCasas", tostring(#selected_houses), "global")
token.set_macro("NatalLeiturasCasas", table.concat(selected_houses), "global")
if #selected_houses > 0 then
  texio.write_nl("log", ("[Mapa Natal] Biblioteca de casas 1.0: %d de 12 leituras"):format(#selected_houses))
end
local function aspect_key(aspect)
  local first, second = aspect.first, aspect.second
  if second < first then first, second = second, first end
  return table.concat({first, aspect.kind, second}, "|")
end

local selected_aspects = {}
if not matched then
  local current_positions = editorial_facts(chart)
  local reviewed_positions = editorial_facts(reviewed)
  local library = {}
  for index, aspect in ipairs(reviewed.aspects) do library[aspect_key(aspect)] = index end
  for _, aspect in ipairs(chart.aspects) do
    local index = library[aspect_key(aspect)]
    if index and current_positions[aspect.first] == reviewed_positions[aspect.first] and
      current_positions[aspect.second] == reviewed_positions[aspect.second] then
      selected_aspects[#selected_aspects+1] = ("\\NatalLeituraAspecto{%d}{%s}{%s}{%s}{%s}{%s}"):format(
        index, names[aspect.first], types[aspect.kind][1], names[aspect.second],
        angle(aspect.orb), phases[aspect.phase])
    end
  end
end
token.set_macro("NatalTotalAspectos", tostring(#selected_aspects), "global")
token.set_macro("NatalAspectosEntrada", tostring(#chart.aspects), "global")
token.set_macro("NatalLeiturasAspectos", table.concat(selected_aspects), "global")
if #selected_aspects > 0 then
  texio.write_nl("log", ("[Mapa Natal] Biblioteca de aspectos 1.0: %d de %d leituras"):format(
    #selected_aspects, #chart.aspects))
end