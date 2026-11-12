local composed = dofile("leitura-composta.lua")
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
do
  for _, position in ipairs(chart.positions) do
    local index = position_library[position_key(position)]
    selected[#selected+1] = ("\\NatalLeituraPosicao{%d}{%s}{%s}{%s}{%d}{%s}"):format(
        index or 0, names[position.name], signs[position.sign], angle(position.degree*60+position.minute),
        position.house, position.retrograde and " · Retrógrado" or "")
    if not index then selected[#selected] = selected[#selected] .. composed.position(position) .. "\\par " end
  end
end
token.set_macro("NatalTotalLeituras", tostring(#selected), "global")
token.set_macro("NatalLeiturasSelecionadas", table.concat(selected), "global")
if #selected > 0 then
  texio.write_nl("log", ("[Mapa Natal] Posições apresentadas: %d de %d leituras"):format(
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
do
  for axis_index, axis in ipairs(axis_pairs) do
    local first, second = chart.angles[axis[1]], chart.angles[axis[2]]
    local index = axis_library[axis_index][first.sign .. "|" .. second.sign]
    selected_axes[#selected_axes+1] = ("\\NatalLeituraEixo{%d}{%s}{%s}{%s}{%s}{%s}"):format(
        index or 0, axis[3], signs[first.sign], angle(first.degree*60+first.minute),
        signs[second.sign], angle(second.degree*60+second.minute))
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

local house_library = {
  {13, 1, "Gemini", "Saturn|Gemini|1|true;North Node|Gemini|1|true", "Mercury", "Mercury|Capricorn|8|false"},
  {14, 2, "Cancer", "", "Moon", "Moon|Scorpio|6|false"},
  {15, 3, "Leo", "Jupiter|Leo|3|true", "Sun", "Sun|Aquarius|9|false"},
  {16, 4, "Virgo", "", "Mercury", "Mercury|Capricorn|8|false"},
  {17, 5, "Libra", "", "Venus", "Venus|Sagittarius|7|false"},
  {18, 6, "Scorpio", "Moon|Scorpio|6|false", "Mars", "Mars|Sagittarius|7|false"},
  {19, 7, "Sagittarius", "Venus|Sagittarius|7|false;Mars|Sagittarius|7|false;Pluto|Sagittarius|7|false", "Jupiter", "Jupiter|Leo|3|true"},
  {20, 8, "Capricorn", "Mercury|Capricorn|8|false;Chiron|Capricorn|8|false", "Saturn", "Saturn|Gemini|1|true"},
  {21, 9, "Aquarius", "Sun|Aquarius|9|false;Uranus|Aquarius|9|false;Neptune|Aquarius|9|false;Vertex|Aquarius|9|false", "Saturn", "Saturn|Gemini|1|true"},
  {22, 10, "Pisces", "Fortune|Pisces|10|false", "Jupiter", "Jupiter|Leo|3|true"},
  {23, 11, "Aries", "Lilith|Aries|11|false", "Mars", "Mars|Sagittarius|7|false"},
  {24, 12, "Taurus", "", "Venus", "Venus|Sagittarius|7|false"},
  {25, 1, "Scorpio", "Sun|Sagittarius|1|false;Pluto|Sagittarius|1|false", "Mars", "Mars|Scorpio|12|false"},
  {26, 2, "Sagittarius", "Mercury|Capricorn|2|false;Chiron|Capricorn|2|false", "Jupiter", "Jupiter|Leo|10|true"},
  {27, 3, "Capricorn", "Neptune|Aquarius|3|false", "Saturn", "Saturn|Gemini|8|true"},
  {28, 4, "Aquarius", "Moon|Pisces|4|false;Uranus|Aquarius|4|false", "Saturn", "Saturn|Gemini|8|true"},
  {29, 5, "Pisces", "Vertex|Aries|5|false", "Jupiter", "Jupiter|Leo|10|true"},
  {30, 6, "Aries", "Lilith|Aries|6|false", "Mars", "Mars|Scorpio|12|false"},
  {31, 7, "Taurus", "North Node|Gemini|7|true", "Venus", "Venus|Scorpio|12|false"},
  {32, 8, "Gemini", "Saturn|Gemini|8|true", "Mercury", "Mercury|Capricorn|2|false"},
  {33, 9, "Cancer", "", "Moon", "Moon|Pisces|4|false"},
  {34, 10, "Leo", "Jupiter|Leo|10|true;Fortune|Virgo|10|false", "Sun", "Sun|Sagittarius|1|false"},
  {35, 11, "Virgo", "", "Mercury", "Mercury|Capricorn|2|false"},
  {36, 12, "Libra", "Venus|Scorpio|12|false;Mars|Scorpio|12|false", "Venus", "Venus|Scorpio|12|false"},
}
local selected_houses = {}
do
  local current_positions, current_occupants, current_aspects = editorial_facts(chart)
  local reviewed_positions, reviewed_occupants = editorial_facts(reviewed)
  local by_house = {}
  for house, rule in ipairs(house_rules) do
    local ruler, aspect = rule[1], rule[2]
    local first, second = aspect:match("^([^|]+)|[^|]+|([^|]+)$")
    if chart.cusps[house].sign == reviewed.cusps[house].sign and
      current_occupants[house] == reviewed_occupants[house] and
      current_positions[ruler] == reviewed_positions[ruler] and current_aspects[aspect] and
      current_positions[first] == reviewed_positions[first] and
      current_positions[second] == reviewed_positions[second] then
      by_house[house] = ("\\NatalLeituraCasa{%d}{%s}{%s}"):format(
        house, signs[chart.cusps[house].sign], angle(chart.cusps[house].degree*60+chart.cusps[house].minute))
    end
  end
  do
    for _, entry in ipairs(house_library) do
      local index, house, sign, occupants, ruler, ruler_key = table.unpack(entry)
      local cusp = chart.cusps[house]
      if not by_house[house] and cusp.sign == sign and current_occupants[house] == occupants and
        current_positions[ruler] == ruler_key then
        by_house[house] = ("\\NatalLeituraCasa{%d}{%s}{%s}"):format(
          index, signs[cusp.sign], angle(cusp.degree*60+cusp.minute))
      end
    end
  end
  for house = 1, 12 do
    local cusp = chart.cusps[house]
    selected_houses[#selected_houses+1] = by_house[house] or
      ("\\NatalCasaComposta{%d}{%s}{%s}%s\\par "):format(house, signs[cusp.sign],
        angle(cusp.degree*60+cusp.minute), composed.house(chart, house, names))
  end
end
token.set_macro("NatalTotalCasas", tostring(#selected_houses), "global")
token.set_macro("NatalLeiturasCasas", table.concat(selected_houses), "global")
if #selected_houses > 0 then
  texio.write_nl("log", ("[Mapa Natal] Casas apresentadas: %d de 12 leituras"):format(#selected_houses))
end
local function aspect_key(aspect)
  local first, second = aspect.first, aspect.second
  if second < first then first, second = second, first end
  return table.concat({first, aspect.kind, second}, "|")
end

local contextual_aspects = {
  ["Mars:Sextile:Sun:Mars|Sagittarius|7|false:Sun|Aquarius|9|false"] = 59,
  ["Jupiter:Opposition:Sun:Jupiter|Leo|3|true:Sun|Aquarius|9|false"] = 60,
  ["Neptune:Conjunction:Sun:Neptune|Aquarius|9|false:Sun|Aquarius|9|false"] = 61,
  ["Jupiter:Square:Moon:Jupiter|Leo|3|true:Moon|Scorpio|6|false"] = 62,
  ["Moon:Square:Uranus:Moon|Scorpio|6|false:Uranus|Aquarius|9|false"] = 63,
  ["Jupiter:Trine:Venus:Jupiter|Leo|3|true:Venus|Sagittarius|7|false"] = 64,
  ["Saturn:Opposition:Venus:Saturn|Gemini|1|true:Venus|Sagittarius|7|false"] = 65,
  ["Pluto:Conjunction:Venus:Pluto|Sagittarius|7|false:Venus|Sagittarius|7|false"] = 66,
  ["Jupiter:Opposition:Neptune:Jupiter|Leo|3|true:Neptune|Aquarius|9|false"] = 67,
  ["Jupiter:Trine:Pluto:Jupiter|Leo|3|true:Pluto|Sagittarius|7|false"] = 68,
  ["Saturn:Trine:Uranus:Saturn|Gemini|1|true:Uranus|Aquarius|9|false"] = 69,
  ["Pluto:Opposition:Saturn:Pluto|Sagittarius|7|false:Saturn|Gemini|1|true"] = 70,
  ["Ascendant:Trine:Sun:Gemini:Sun|Aquarius|9|false"] = 71,
  ["Ascendant:Opposition:Moon:Gemini:Moon|Scorpio|6|false"] = 72,
  ["Ascendant:Opposition:Mars:Gemini:Mars|Sagittarius|7|false"] = 73,
  ["Ascendant:Square:Uranus:Gemini:Uranus|Aquarius|9|false"] = 74,
  ["Ascendant:Conjunction:North Node:Gemini:North Node|Gemini|1|true"] = 75,
  ["DSC:Sextile:Sun:Sagittarius:Sun|Aquarius|9|false"] = 76,
  ["DSC:Conjunction:Moon:Sagittarius:Moon|Scorpio|6|false"] = 77,
  ["DSC:Conjunction:Mars:Sagittarius:Mars|Sagittarius|7|false"] = 78,
  ["DSC:Square:Uranus:Sagittarius:Uranus|Aquarius|9|false"] = 79,
  ["DSC:Opposition:North Node:Sagittarius:North Node|Gemini|1|true"] = 80,
  ["MC:Square:Mars:Pisces:Mars|Sagittarius|7|false"] = 81,
  ["MC:Conjunction:Uranus:Pisces:Uranus|Aquarius|9|false"] = 82,
  ["MC:Square:North Node:Pisces:North Node|Gemini|1|true"] = 83,
  ["IC:Square:Mars:Virgo:Mars|Sagittarius|7|false"] = 84,
  ["IC:Opposition:Uranus:Virgo:Uranus|Aquarius|9|false"] = 85,
  ["IC:Square:North Node:Virgo:North Node|Gemini|1|true"] = 86,
  ["IC:Trine:Lilith:Virgo:Lilith|Aries|11|false"] = 87,
  ["North Node:Trine:Sun:North Node|Gemini|1|true:Sun|Aquarius|9|false"] = 88,
  ["Mars:Opposition:North Node:Mars|Sagittarius|7|false:North Node|Gemini|1|true"] = 89,
  ["Neptune:Trine:North Node:Neptune|Aquarius|9|false:North Node|Gemini|1|true"] = 90,
  ["Lilith:Square:Sun:Lilith|Aries|11|false:Sun|Aquarius|9|false"] = 91,
  ["Lilith:Sextile:Uranus:Lilith|Aries|11|false:Uranus|Aquarius|9|false"] = 92,
  ["Chiron:Conjunction:Mercury:Chiron|Capricorn|8|false:Mercury|Capricorn|8|false"] = 93,
  ["Fortune:Trine:Moon:Fortune|Pisces|10|false:Moon|Scorpio|6|false"] = 94,
  ["Fortune:Square:Venus:Fortune|Pisces|10|false:Venus|Sagittarius|7|false"] = 95,
  ["Fortune:Square:Saturn:Fortune|Pisces|10|false:Saturn|Gemini|1|true"] = 96,
  ["Fortune:Square:Pluto:Fortune|Pisces|10|false:Pluto|Sagittarius|7|false"] = 97,
  ["Moon:Square:Vertex:Moon|Scorpio|6|false:Vertex|Aquarius|9|false"] = 98,
  ["Saturn:Trine:Vertex:Saturn|Gemini|1|true:Vertex|Aquarius|9|false"] = 99,
  ["Uranus:Conjunction:Vertex:Uranus|Aquarius|9|false:Vertex|Aquarius|9|false"] = 100,
  ["Lilith:Sextile:Vertex:Lilith|Aries|11|false:Vertex|Aquarius|9|false"] = 101,
  ["Ascendant:Square:Vertex:Gemini:Vertex|Aquarius|9|false"] = 102,
  ["DSC:Square:Vertex:Sagittarius:Vertex|Aquarius|9|false"] = 103,
  ["Jupiter:Trine:Sun:Jupiter|Leo|10|true:Sun|Sagittarius|1|false"] = 104,
  ["Saturn:Opposition:Sun:Saturn|Gemini|8|true:Sun|Sagittarius|1|false"] = 105,
  ["Pluto:Conjunction:Sun:Pluto|Sagittarius|1|false:Sun|Sagittarius|1|false"] = 106,
  ["Mercury:Sextile:Moon:Mercury|Capricorn|2|false:Moon|Pisces|4|false"] = 107,
  ["Moon:Trine:Venus:Moon|Pisces|4|false:Venus|Scorpio|12|false"] = 108,
  ["Mars:Trine:Moon:Mars|Scorpio|12|false:Moon|Pisces|4|false"] = 109,
  ["Moon:Trine:Saturn:Moon|Pisces|4|false:Saturn|Gemini|8|true"] = 110,
  ["Moon:Conjunction:Uranus:Moon|Pisces|4|false:Uranus|Aquarius|4|false"] = 111,
  ["Mars:Sextile:Mercury:Mars|Scorpio|12|false:Mercury|Capricorn|2|false"] = 112,
  ["Mercury:Opposition:Saturn:Mercury|Capricorn|2|false:Saturn|Gemini|8|true"] = 113,
  ["Mars:Conjunction:Venus:Mars|Scorpio|12|false:Venus|Scorpio|12|false"] = 114,
  ["Neptune:Square:Venus:Neptune|Aquarius|3|false:Venus|Scorpio|12|false"] = 115,
  ["Mars:Square:Neptune:Mars|Scorpio|12|false:Neptune|Aquarius|3|false"] = 116,
  ["Jupiter:Trine:Pluto:Jupiter|Leo|10|true:Pluto|Sagittarius|1|false"] = 117,
  ["Saturn:Trine:Uranus:Saturn|Gemini|8|true:Uranus|Aquarius|4|false"] = 118,
  ["Ascendant:Square:Moon:Scorpio:Moon|Pisces|4|false"] = 119,
  ["Ascendant:Square:Uranus:Scorpio:Uranus|Aquarius|4|false"] = 120,
  ["DSC:Square:Moon:Taurus:Moon|Pisces|4|false"] = 121,
  ["DSC:Square:Uranus:Taurus:Uranus|Aquarius|4|false"] = 122,
  ["MC:Trine:Sun:Leo:Sun|Sagittarius|1|false"] = 123,
  ["Jupiter:Conjunction:MC:Jupiter|Leo|10|true:Leo"] = 124,
  ["MC:Trine:Pluto:Leo:Pluto|Sagittarius|1|false"] = 125,
  ["Lilith:Trine:MC:Lilith|Aries|6|false:Leo"] = 126,
  ["IC:Sextile:Sun:Aquarius:Sun|Sagittarius|1|false"] = 127,
  ["IC:Opposition:Jupiter:Aquarius:Jupiter|Leo|10|true"] = 128,
  ["IC:Sextile:Pluto:Aquarius:Pluto|Sagittarius|1|false"] = 129,
  ["North Node:Opposition:Sun:North Node|Gemini|7|true:Sun|Sagittarius|1|false"] = 130,
  ["Moon:Square:North Node:Moon|Pisces|4|false:North Node|Gemini|7|true"] = 131,
  ["Neptune:Trine:North Node:Neptune|Aquarius|3|false:North Node|Gemini|7|true"] = 132,
  ["Lilith:Trine:Sun:Lilith|Aries|6|false:Sun|Sagittarius|1|false"] = 133,
  ["Jupiter:Trine:Lilith:Jupiter|Leo|10|true:Lilith|Aries|6|false"] = 134,
  ["Lilith:Sextile:Saturn:Lilith|Aries|6|false:Saturn|Gemini|8|true"] = 135,
  ["Lilith:Sextile:Uranus:Lilith|Aries|6|false:Uranus|Aquarius|4|false"] = 136,
  ["Lilith:Trine:Pluto:Lilith|Aries|6|false:Pluto|Sagittarius|1|false"] = 137,
  ["Chiron:Conjunction:Mercury:Chiron|Capricorn|2|false:Mercury|Capricorn|2|false"] = 138,
  ["Chiron:Sextile:Venus:Chiron|Capricorn|2|false:Venus|Scorpio|12|false"] = 139,
  ["Chiron:Sextile:Mars:Chiron|Capricorn|2|false:Mars|Scorpio|12|false"] = 140,
  ["Fortune:Square:Sun:Fortune|Virgo|10|false:Sun|Sagittarius|1|false"] = 141,
  ["Fortune:Opposition:Moon:Fortune|Virgo|10|false:Moon|Pisces|4|false"] = 142,
  ["Fortune:Square:Pluto:Fortune|Virgo|10|false:Pluto|Sagittarius|1|false"] = 143,
  ["Fortune:Square:North Node:Fortune|Virgo|10|false:North Node|Gemini|7|true"] = 144,
  ["Chiron:Trine:Fortune:Chiron|Capricorn|2|false:Fortune|Virgo|10|false"] = 145,
  ["Sun:Trine:Vertex:Sun|Sagittarius|1|false:Vertex|Aries|5|false"] = 146,
  ["Jupiter:Trine:Vertex:Jupiter|Leo|10|true:Vertex|Aries|5|false"] = 147,
  ["Pluto:Trine:Vertex:Pluto|Sagittarius|1|false:Vertex|Aries|5|false"] = 148,
  ["Lilith:Conjunction:Vertex:Lilith|Aries|6|false:Vertex|Aries|5|false"] = 149,
  ["MC:Trine:Vertex:Leo:Vertex|Aries|5|false"] = 150,
  ["IC:Sextile:Vertex:Aquarius:Vertex|Aries|5|false"] = 151,
}
local selected_aspects, specific_aspects = {}, 0
local aspect_ids = {}
do
  local current_positions = editorial_facts(chart)
  local reviewed_positions = editorial_facts(reviewed)
  local library, locations = {}, {}
  for name, cusp in pairs(chart.angles) do locations[name] = cusp end
  for _, p in ipairs(chart.positions) do locations[p.name] = p end
  for index, aspect in ipairs(reviewed.aspects) do library[aspect_key(aspect)] = index end
  for id, aspect in ipairs(chart.aspects) do
    aspect_ids[aspect_key(aspect)] = id
    local index = library[aspect_key(aspect)]
    if current_positions[aspect.first] ~= reviewed_positions[aspect.first] or
      current_positions[aspect.second] ~= reviewed_positions[aspect.second] then index = nil end
    local first, second = aspect.first, aspect.second
    if second < first then first, second = second, first end
    local key = table.concat({first,aspect.kind,second,current_positions[first],current_positions[second]}, ":")
    index = contextual_aspects[key] or index
    if index then specific_aspects = specific_aspects + 1 end
    selected_aspects[#selected_aspects+1] = ("\\NatalLeituraAspecto{%d}{%s}{%s}{%s}{%s}{%s}{%d}"):format(
        index or 0, names[aspect.first], types[aspect.kind][1], names[aspect.second],
        angle(aspect.orb), phases[aspect.phase], id)
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