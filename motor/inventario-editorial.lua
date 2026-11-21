local folder = (arg[0] or ""):match("^(.*[/\\])") or ""
local reader = dofile(folder .. "entrada.lua")
local catalog = dofile(folder .. "catalogo-editorial.lua")
local domain = reader.domain()
local reviewed = reader.read(folder .. "mapa-editorial-v1.txt")

local function read_placement_evidence(path)
  local file = assert(io.open(path, "rb"))
  local header = file:read("*l")
  assert(header and header:gsub("\r$", "") == "chave\tdia_juliano_ut\tlatitude\tlongitude\tsistema\tvariante",
    "Cabeçalho inválido no inventário de evidências: " .. path)
  local evidence = {}
  for line in file:lines() do
    local key, jd, lat, lon, system, variant = line:gsub("\r$", ""):match(
      "^([^\t]+)\t([^\t]+)\t([^\t]+)\t([^\t]+)\t([PC])\t([%a%-]+)$")
    assert(key and tonumber(jd) and tonumber(lat) and tonumber(lon), "Evidência inválida: " .. line)
    assert(not evidence[key], "Evidência duplicada: " .. key)
    evidence[key] = true
  end
  file:close()
  return evidence
end

local function read_text_ids(filename, macro)
  local file = assert(io.open(folder .. filename, "rb"))
  local source = file:read("*a")
  file:close()
  local ids = {}
  for value in source:gmatch("\\csname " .. macro .. "(%d+)\\endcsname%s*{") do
    local id = tonumber(value)
    assert(not ids[id], "Texto duplicado: " .. macro .. id)
    ids[id] = true
  end
  return ids
end

local function add(section, key, id)
  assert(not section.entries[key], "Chave duplicada: " .. key)
  assert(section.texts[id] == true, "Texto ausente ou referenciado duas vezes: " .. section.label .. " " .. id)
  section.entries[key] = id
  section.texts[id] = false
  section.count = section.count + 1
end

local function section(label, filename, macro)
  return {label=label, texts=read_text_ids(filename, macro), entries={}, count=0}
end

local placements = section("Posições", "leituras-posicoes-v1.tex", "NatalPosicaoTexto")
local axes = section("Eixos", "leituras-posicoes-v1.tex", "NatalEixoTexto")
local houses = section("Casas", "leituras-casas-v1.tex", "NatalCasaTexto")
local aspects = section("Aspectos", "leituras-aspectos-v1.tex", "NatalAspectoTexto")
local sections = {placements, axes, houses, aspects}

for key, id in pairs(catalog.positions(reviewed)) do add(placements, key, id) end
for axis, library in ipairs(catalog.axes) do
  for key, id in pairs(library) do add(axes, catalog.axis_pairs[axis][1] .. "|" .. key, id) end
end

local house_bases, aspect_bases = {}, {}
local house_library = catalog.houses(reviewed)
for key, id in pairs(house_library) do
  house_bases[assert(key:match("^(%d+|%a+)|"))] = true
  add(houses, key, id)
end

for key, id in pairs(catalog.aspects(reviewed)) do
  local first, kind, second = key:match("^([^:]+):([^:]+):([^:]+):")
  assert(first, "Chave de aspecto inválida: " .. key)
  aspect_bases[catalog.aspect_key({first=first, kind=kind, second=second})] = true
  add(aspects, key, id)
end

for _, item in ipairs(sections) do
  for id, unused in pairs(item.texts) do
    assert(not unused, "Texto sem chave: " .. item.label .. " " .. id)
  end
end

local function matrix(item, candidates, registered)
  local missing, covered = {}, 0
  local known = {}
  for _, key in ipairs(candidates) do
    assert(not known[key], "Chave duplicada na grade: " .. key)
    known[key] = true
    if registered[key] then covered = covered + 1 else missing[#missing+1] = key end
  end
  for key in pairs(registered) do
    assert(known[key], "Chave cadastrada fora da grade: " .. key)
  end
  item.candidates, item.covered, item.missing = #candidates, covered, missing
end

local placement_keys, axis_keys, house_keys, aspect_keys = {}, {}, {}, {}
local excluded, placement_set = {}, {}
for _, name in ipairs(domain.bodies) do
  for _, sign in ipairs(domain.signs) do
    for house = 1, 12 do
      for _, retrograde in ipairs({false, true}) do
        local key = catalog.position_key({name=name, sign=sign, house=house, retrograde=retrograde})
        local exclusion = reader.position_exclusion(name, retrograde, house)
        if exclusion then
          excluded[#excluded+1] = {key=key, reason=exclusion}
        else
          placement_keys[#placement_keys+1] = key
          placement_set[key] = true
        end
      end
    end
  end
end
for _, axis in ipairs(catalog.axis_pairs) do
  for index, sign in ipairs(domain.signs) do
    axis_keys[#axis_keys+1] = axis[1] .. "|" .. sign .. "|" .. domain.signs[(index+5)%12+1]
  end
end
for house = 1, 12 do
  for _, sign in ipairs(domain.signs) do house_keys[#house_keys+1] = house .. "|" .. sign end
end
local endpoints = {table.unpack(domain.bodies)}
for _, name in ipairs(domain.angles) do endpoints[#endpoints+1] = name end
for i, first in ipairs(endpoints) do
  for j = i+1, #endpoints do
    for _, kind in ipairs(domain.aspects) do
      aspect_keys[#aspect_keys+1] = catalog.aspect_key({first=first, kind=kind, second=endpoints[j]})
    end
  end
end

local moving_entries, stationary_entries = {}, {}
for key, id in pairs(placements.entries) do
  if key:match("|stationary$") then
    assert(placement_set[key:gsub("|stationary$", "|true")], "Posição estacionária incompatível: " .. key)
    stationary_entries[key] = id
  else
    moving_entries[key] = id
  end
end
matrix(placements, placement_keys, moving_entries)
matrix(axes, axis_keys, axes.entries)
matrix(houses, house_keys, house_bases)
matrix(aspects, aspect_keys, aspect_bases)

local evidence = read_placement_evidence(folder .. "../docs/evidencias-posicoes.tsv")
for key in pairs(evidence) do
  assert(placement_set[key], "Evidência de posição fora da grade: " .. key)
end
local proven, proven_missing, pending = 0, {}, {}
for _, key in ipairs(placement_keys) do
  if evidence[key] then
    proven = proven + 1
    if not placements.entries[key] then proven_missing[#proven_missing+1] = key end
  else
    pending[#pending+1] = key
  end
end

local stationary_keys, observed_orbs = {}, {}
local function contextual_inventory(chart, house_evidence, aspect_evidence)
  local current_positions, current_occupants, current_aspects = catalog.facts(chart)
  local locations = {}
  for name, cusp in pairs(chart.angles) do locations[name] = cusp end
  for _, axis in ipairs(catalog.axis_pairs) do
    assert(reader.orb_matches({kind="Opposition", orb=0}, locations[axis[1]], locations[axis[2]]),
      "Ângulos do eixo fora de oposição na evidência: " .. axis[1] .. "–" .. axis[2])
  end
  for _, position in ipairs(chart.positions) do
    locations[position.name] = position
    local house = position.house
    assert(reader.in_house(position, chart.cusps[house], chart.cusps[house % 12 + 1]),
      "Posição fora da casa na evidência: linha " .. position.line)
    if position.stationary then stationary_keys[catalog.position_key(position)] = true end
  end
  for _, aspect in ipairs(chart.aspects) do
    assert(reader.orb_matches(aspect, locations[aspect.first], locations[aspect.second]),
      "Orbe incompatível na evidência: linha " .. aspect.line)
    aspect_evidence[catalog.contextual_aspect_key(aspect, current_positions)] = true
    local base = catalog.aspect_key(aspect)
    observed_orbs[base] = math.max(observed_orbs[base] or 0, aspect.orb)
  end
  for number = 1, 12 do
    local _, key = catalog.select_house(number, chart, current_positions, current_occupants, current_aspects, house_library)
    house_evidence[key] = true
  end
end

local contextual_houses, contextual_aspects = {}, {}
contextual_inventory(reviewed, contextual_houses, contextual_aspects)
for _, path in ipairs(arg) do
  local ok, failure = pcall(function()
    contextual_inventory(reader.read(path), contextual_houses, contextual_aspects)
  end)
  if not ok then error(path .. ": " .. tostring(failure), 0) end
end

local function contextual_status(registered, observed)
  local total, missing, unverified = 0, {}, 0
  for key in pairs(observed) do
    total = total + 1
    if not registered[key] then missing[#missing + 1] = key end
  end
  for key in pairs(registered) do
    if not observed[key] then unverified = unverified + 1 end
  end
  table.sort(missing)
  return total, missing, unverified
end
local house_total, house_missing, house_unverified = contextual_status(houses.entries, contextual_houses)
local aspect_total, aspect_missing, aspect_unverified = contextual_status(aspects.entries, contextual_aspects)
local stationary_total, stationary_missing = contextual_status(stationary_entries, stationary_keys)

print("MAPA NATAL — INVENTÁRIO DE COBERTURA EDITORIAL")
print("Somente textos próprios cadastrados. Composição não conta como cobertura.")
print("Posições: cada evidência aponta para uma configuração reproduzível. Chaves sem evidência ficam em aberto.")
print("Casas e aspectos: a grade básica é uma projeção. A auditoria contextual conta apenas as entradas conferidas nesta execução.")
print()
print(("Posições sem marca estacionária | %d chaves demonstradas | %d chaves demonstradas sem texto | %d chaves em aberto | %d excluídas"):format(
  proven, #proven_missing, #pending, #excluded))
print(("Posições estacionárias no lote | chaves observadas: %d | sem texto próprio: %d"):format(stationary_total, #stationary_missing))
for _, item in ipairs(sections) do
  print(("%s | %d textos próprios | %d/%d chaves na grade | %d chaves sem texto na grade"):format(
    item.label, item.count, item.covered, item.candidates, #item.missing))
end
print(("Casas | %d chaves observadas | %d sem texto próprio | %d textos sem evidência neste lote"):format(
  house_total, #house_missing, house_unverified))
print(("Aspectos | %d chaves observadas | %d sem texto próprio | %d textos sem evidência neste lote"):format(
  aspect_total, #aspect_missing, aspect_unverified))
print("Entradas adicionais na auditoria contextual: " .. #arg)
for _, item in ipairs(sections) do
  print("\n" .. item.label .. " — textos cadastrados")
  local by_id = {}
  for key, id in pairs(item.entries) do by_id[#by_id+1] = {key=key, id=id} end
  table.sort(by_id, function(a,b) return a.id < b.id end)
  for _, entry in ipairs(by_id) do print(("%03d\t%s"):format(entry.id, entry.key)) end
  if item == placements then
    print("\nPosições — combinações demonstradas sem texto próprio")
    for _, key in ipairs(proven_missing) do print(key) end
    print("\nPosições — combinações em aberto")
    for _, key in ipairs(pending) do
      print(("%s\t%s"):format(key, placements.entries[key] and "texto cadastrado" or "sem texto"))
    end
    print("\nPosições — combinações excluídas e motivo")
    for _, entry in ipairs(excluded) do print(entry.key .. "\t" .. entry.reason) end
  else
    print("\n" .. item.label .. " — chaves sem texto na grade")
    for _, key in ipairs(item.missing) do print(key) end
  end
end
print("\nPosições estacionárias — combinações observadas sem texto próprio")
for _, key in ipairs(stationary_missing) do print(key) end
print("\nCasas — combinações observadas sem texto próprio")
for _, key in ipairs(house_missing) do print(key) end
print("\nAspectos — combinações observadas sem texto próprio")
for _, key in ipairs(aspect_missing) do print(key) end
print("\nAspectos — maior orbe observado por par e tipo (minutos de arco)")
local orb_keys = {}
for key in pairs(observed_orbs) do orb_keys[#orb_keys + 1] = key end
table.sort(orb_keys)
for _, key in ipairs(orb_keys) do print(key .. "\t" .. observed_orbs[key]) end
