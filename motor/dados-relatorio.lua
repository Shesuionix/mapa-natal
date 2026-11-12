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
local selected = {}
if not matched then
  for index, position in ipairs(chart.positions) do
    local model = reviewed.positions[index]
    if position.name == model.name and position.sign == model.sign and
      position.house == model.house and position.retrograde == model.retrograde then
      selected[#selected+1] = ("\\NatalLeituraPosicao{%d}{%s}{%s}{%s}{%d}{%s}"):format(
        index, names[position.name], signs[position.sign], angle(position.degree*60+position.minute),
        position.house, position.retrograde and " · Retrógrado" or "")
    end
  end
end
token.set_macro("NatalTotalLeituras", tostring(#selected), "global")
token.set_macro("NatalLeiturasSelecionadas", table.concat(selected), "global")
if #selected > 0 then
  texio.write_nl("log", ("[Mapa Natal] Biblioteca de posições 1.0: %d de %d leituras"):format(
    #selected, #chart.positions))
end
local axis_pairs = {
  {"Ascendant", "DSC", "Ascendente e Descendente"},
  {"MC", "IC", "Meio do Céu e Fundo do Céu"}
}
local selected_axes = {}
if not matched then
  for index, axis in ipairs(axis_pairs) do
    local first, second = chart.angles[axis[1]], chart.angles[axis[2]]
    if first.sign == reviewed.angles[axis[1]].sign and second.sign == reviewed.angles[axis[2]].sign then
      selected_axes[#selected_axes+1] = ("\\NatalLeituraEixo{%d}{%s}{%s}{%s}{%s}{%s}"):format(
        index, axis[3], signs[first.sign], angle(first.degree*60+first.minute),
        signs[second.sign], angle(second.degree*60+second.minute))
    end
  end
end
token.set_macro("NatalTotalEixos", tostring(#selected_axes), "global")
token.set_macro("NatalLeiturasEixos", table.concat(selected_axes), "global")
if #selected_axes > 0 then
  texio.write_nl("log", ("[Mapa Natal] Biblioteca de eixos 1.0: %d de 2 leituras"):format(#selected_axes))
end