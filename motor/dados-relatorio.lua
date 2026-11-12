local reader = dofile("entrada.lua")
local chart = reader.read(os.getenv("NATAL_ENTRADA") or "exemplo.txt")
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
    cells[#cells+1] = symbol and glyph(symbol) or (j == i and "—" or "")
  end
  row(grid, table.unpack(cells))
  grid[#grid+1] = "\\hline"
end

for _, speed in ipairs(chart.speeds) do
  local seconds = math.abs(speed.delta_arcseconds)
  local direction = speed.delta_arcseconds < 0 and "Retrógrado" or
    (speed.delta_arcseconds == 0 and "Estacionário" or "Direto")
  local delta = ("%s%d°%02d\\ensuremath{^{\\prime}}%02d\\ensuremath{^{\\prime\\prime}}"):format(
    speed.delta_arcseconds < 0 and "-" or "", seconds // 3600, (seconds // 60) % 60, seconds % 60)
  row(speeds, names[speed.name], delta, direction, speed.label, speed.ratio_text)
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