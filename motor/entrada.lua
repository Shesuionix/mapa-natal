local input = {}

local signs = {
  Aries=0, Taurus=30, Gemini=60, Cancer=90, Leo=120, Virgo=150,
  Libra=180, Scorpio=210, Sagittarius=240, Capricorn=270, Aquarius=300, Pisces=330
}
local bodies = {
  "Sun", "Moon", "Mercury", "Venus", "Mars", "Jupiter", "Saturn", "Uranus",
  "Neptune", "Pluto", "North Node", "Lilith", "Chiron", "Fortune", "Vertex"
}
local body_ids = {}
for index, name in ipairs(bodies) do body_ids[name] = index end
local angles = {Ascendant=1, DSC=7, MC=10, IC=4}
local aliases = {ASC="Ascendant", Node="North Node"}
local aspect_angles = {Conjunction=0, Sextile=60, Square=90, Trine=120, Opposition=180}
local aspect_types = {"Conjunction", "Sextile", "Square", "Trine", "Opposition"}
local labels = {Fast=true, Average=true, Slow=true, Retrograde=true, Direct=true, Stationary=true}
local movement_exclusions = {
  Sun="longitude geocêntrica direta",
  Moon="longitude geocêntrica direta",
  Fortune="ponto calculado sem marcador de movimento",
  Vertex="ponto geométrico sem marcador de movimento"
}

function input.position_exclusion(name, marker)
  return marker and movement_exclusions[name] or nil
end

function input.in_house(position, cusp, next_cusp)
  return (position.arcminutes - cusp.arcminutes) % 21600 < (next_cusp.arcminutes - cusp.arcminutes) % 21600
end

local function expected_orb(first, kind, second)
  local distance = math.abs(first.arcminutes - second.arcminutes)
  return math.abs(math.min(distance, 21600 - distance) - aspect_angles[kind] * 60)
end

function input.orb_matches(aspect, first, second)
  return math.abs(expected_orb(first, aspect.kind, second) - aspect.orb) <= 1.5
end

local function trim(value)
  return value:match("^%s*(.-)%s*$")
end

local function canonical(name)
  return aliases[name] or name
end

function input.read(path)
  local file, reason = io.open(path, "rb")
  if not file then error(reason, 0) end
  local raw = file:read("*a")
  file:close()

  local chart = {positions={}, cusps={}, aspects={}, speeds={}, warnings={}, angles={}, aspect_orb_errors=0}
  local position_by_name, supplied_angles, aspect_pairs, speed_names = {}, {}, {}, {}
  local line_number = 0
  local function fail(line, message)
    error(("%s:%d: %s"):format(path, line, message), 0)
  end
  local function warn(line, message)
    chart.warnings[#chart.warnings+1] = ("%s:%d: %s"):format(path, line, message)
  end
  local function location(sign, degree, minute)
    degree, minute = tonumber(degree), tonumber(minute)
    if signs[sign] == nil or degree >= 30 or minute >= 60 then
      fail(line_number, "signo, grau ou minuto inválido")
    end
    return {sign=sign, degree=degree, minute=minute, arcminutes=(signs[sign]+degree)*60+minute, line=line_number}
  end
  local block = 1
  local clean = raw:gsub("^\239\187\191", ""):gsub("\r\n", "\n"):gsub("\r", "\n")
  for source in (clean .. "\n"):gmatch("(.-)\n") do
    line_number = line_number + 1
    local line = trim(source):gsub("’", "'"):gsub("′", "'"):gsub("″", "''"):gsub("−", "-")
    if line ~= "" then
      local house, sign, degree, minute = line:match("^(%d+)%a%a House in (%a+) (%d+)°(%d+)'$")
      if house then
        if block > 2 then fail(line_number, "cúspide fora do bloco de casas") end
        block = 2
        house = tonumber(house)
        if house < 1 or house > 12 or chart.cusps[house] then fail(line_number, "casa inválida ou repetida") end
        chart.cusps[house] = location(sign, degree, minute)
      elseif line:find(" %(Orb:") then
        if block < 2 or block > 3 then fail(line_number, "aspecto fora do bloco de aspectos") end
        block = 3
        local pair, deg, min, phase = line:match("^(.-) %(Orb: (%d+)°(%d+)', (%a+)%)$")
        if not pair or tonumber(min) >= 60 or (phase ~= "Applying" and phase ~= "Separating") then
          fail(line_number, "orbe ou fase inválidos")
        end
        local first, second, kind
        for _, candidate in ipairs(aspect_types) do
          first, second = pair:match("^(.-) " .. candidate .. " (.-)$")
          if first then kind = candidate; break end
        end
        if not kind then fail(line_number, "tipo de aspecto desconhecido") end
        first, second = canonical(first), canonical(second)
        if first == second or not (body_ids[first] or angles[first]) or not (body_ids[second] or angles[second]) then
          fail(line_number, "par de aspecto inválido")
        end
        local key = first < second and first .. "|" .. second or second .. "|" .. first
        if aspect_pairs[key] then fail(line_number, "par de aspecto repetido") end
        aspect_pairs[key] = true
        chart.aspects[#chart.aspects+1] = {first=first, second=second, kind=kind, orb=tonumber(deg)*60+tonumber(min), phase=phase, line=line_number}
      elseif line:find(": ", 1, true) then
        if block < 2 then fail(line_number, "velocidade antes do bloco de casas") end
        block = 4
        local name, direction, deg, min, sec, label, ratio = line:match(
          "^([^:]+): ([+-]?)(%d+)°(%d+)'(%d+)'' %((%a+), cca (%d+%.?%d*)x avg speed%)$")
        if not name or tonumber(min) >= 60 or tonumber(sec) >= 60 or not labels[label] then
          fail(line_number, "velocidade, rótulo ou razão inválida")
        end
        name = canonical(name)
        if not body_ids[name] or speed_names[name] then fail(line_number, "corpo de velocidade desconhecido ou repetido") end
        local delta = (tonumber(deg)*3600 + tonumber(min)*60 + tonumber(sec)) * (direction == "-" and -1 or 1)
        if not (math.abs(delta) < math.huge and tonumber(ratio) < math.huge) then fail(line_number, "velocidade ou razão fora do intervalo numérico") end
        speed_names[name] = true
        chart.speeds[#chart.speeds+1] = {name=name, delta_arcseconds=delta, label=label, ratio=tonumber(ratio), ratio_text=ratio, line=line_number}
      else
        if block ~= 1 then fail(line_number, "linha não reconhecida neste bloco") end
        local name, pos_sign, deg, min, tail = line:match("^(.-) in (%a+) (%d+)°(%d+)'(.*)$")
        if not name then fail(line_number, "posição não reconhecida") end
        name = canonical(name)
        local position = location(pos_sign, deg, min)
        if angles[name] then
          if tail ~= "" or supplied_angles[name] then fail(line_number, "ângulo inválido ou repetido") end
          supplied_angles[name] = position
        else
          local marker, pos_house = tail:match("^, (.-)in (%d+)%a%a House$")
          if not body_ids[name] or position_by_name[name] or not pos_house or
            tonumber(pos_house) < 1 or tonumber(pos_house) > 12 or
            (marker ~= "" and marker ~= "Retrograde, " and marker ~= "Stationary, ") then
            fail(line_number, "corpo, casa ou indicação de movimento inválida ou repetida")
          end
          position.name, position.house = name, tonumber(pos_house)
          position.retrograde = marker == "Retrograde, "
          position.stationary = marker == "Stationary, "
          local exclusion = input.position_exclusion(name, position.retrograde or position.stationary)
          if exclusion then fail(line_number, ("marcador %s inválido para %s (%s)"):format(marker:match("^%a+"), name, exclusion)) end
          position_by_name[name] = position
        end
      end
    end
  end

  for index, name in ipairs(bodies) do
    chart.positions[index] = position_by_name[name] or fail(line_number, "posição ausente: " .. name)
  end
  local total = 0
  for house=1,12 do
    if not chart.cusps[house] then fail(line_number, "cúspide ausente: " .. house) end
  end
  for house=1,12 do
    local cusp, next_cusp = chart.cusps[house], chart.cusps[house%12+1]
    local width = (next_cusp.arcminutes - cusp.arcminutes)%21600
    if width == 0 then fail(next_cusp.line, "cúspide coincide com a anterior") end
    total = total + width
  end
  if total ~= 21600 then fail(chart.cusps[12].line, "cúspides fora da ordem zodiacal") end
  for name, house in pairs(angles) do
    local supplied, cusp = supplied_angles[name], chart.cusps[house]
    if supplied and supplied.arcminutes ~= cusp.arcminutes then fail(supplied.line, "ângulo difere da cúspide " .. house) end
    chart.angles[name] = cusp
  end
  for _, position in ipairs(chart.positions) do
    local cusp = chart.cusps[position.house]
    local next_cusp = chart.cusps[position.house%12+1]
    if not input.in_house(position, cusp, next_cusp) then
      warn(position.line, "casa informada diverge das cúspides: " .. position.name)
    end
  end
  for _, aspect in ipairs(chart.aspects) do
    local first = position_by_name[aspect.first] or chart.angles[aspect.first]
    local second = position_by_name[aspect.second] or chart.angles[aspect.second]
    if not input.orb_matches(aspect, first, second) then
      local expected = expected_orb(first, aspect.kind, second)
      warn(aspect.line, ("orbe informado %d′; orbe pelas posições %d′"):format(aspect.orb, expected))
      chart.aspect_orb_errors = chart.aspect_orb_errors + 1
    end
  end
  if #chart.speeds == 0 then fail(line_number, "bloco de velocidades ausente") end
  for _, speed in ipairs(chart.speeds) do
    local position = position_by_name[speed.name]
    speed.stationary = position.stationary or speed.label == "Stationary"
    if not position.stationary and speed.delta_arcseconds ~= 0 and (speed.delta_arcseconds < 0) ~= position.retrograde then
      warn(speed.line, "sinal do delta diverge da indicação de retrogradação: " .. speed.name)
    end
  end
  return chart, raw
end

function input.domain()
  local zodiac = {}
  for name, degrees in pairs(signs) do zodiac[degrees // 30 + 1] = name end
  return {
    signs=zodiac, bodies={table.unpack(bodies)}, angles={"Ascendant","DSC","MC","IC"},
    aspects={table.unpack(aspect_types)}
  }
end

return input
