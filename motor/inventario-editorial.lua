local folder = (arg[0] or ""):match("^(.*[/\\])") or ""
local reader = dofile(folder .. "entrada.lua")
local catalog = dofile(folder .. "catalogo-editorial.lua")
local domain = reader.domain()
local reviewed = reader.read(folder .. "mapa-editorial-v1.txt")
local positions, occupants = catalog.facts(reviewed)

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
local function house_key(number, sign, members, ruler, ruler_position)
  local base = number .. "|" .. sign
  house_bases[base] = true
  return ("%s|ocupantes=%s|regente=%s|posicao=%s"):format(base, members, ruler, ruler_position)
end
for number, rule in ipairs(catalog.house_rules) do
  local ruler, aspect = table.unpack(rule)
  local first, second = aspect:match("^([^|]+)|[^|]+|([^|]+)$")
  local key = house_key(number, reviewed.cusps[number].sign, occupants[number], ruler, positions[ruler])
  add(houses, key .. "|aspecto=" .. aspect .. ":" .. positions[first] .. ":" .. positions[second], number)
end
for _, entry in ipairs(catalog.houses) do
  local id, number, sign, members, ruler, ruler_position = table.unpack(entry)
  add(houses, house_key(number, sign, members, ruler, ruler_position), id)
end

local function add_aspect(key, id)
  local first, kind, second, context = key:match("^([^:]+):([^:]+):([^:]+):(.+)$")
  assert(first, "Chave de aspecto inválida: " .. key)
  aspect_bases[catalog.aspect_key({first=first, kind=kind, second=second})] = true
  add(aspects, first .. ":" .. kind .. ":" .. second .. ":" .. context, id)
end
for id, aspect in ipairs(reviewed.aspects) do
  local first, second = aspect.first, aspect.second
  if second < first then first, second = second, first end
  add_aspect(table.concat({first, aspect.kind, second, positions[first], positions[second]}, ":"), id)
end
for key, id in pairs(catalog.contextual_aspects) do add_aspect(key, id) end

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
        local exclusion = reader.position_exclusion(name, retrograde)
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

matrix(placements, placement_keys, placements.entries)
matrix(axes, axis_keys, axes.entries)
matrix(houses, house_keys, house_bases)
matrix(aspects, aspect_keys, aspect_bases)

local evidence = read_placement_evidence(arg[1] or folder .. "../docs/evidencias-posicoes.tsv")
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

print("MAPA NATAL — INVENTÁRIO DE COBERTURA EDITORIAL")
print("Somente textos próprios cadastrados. Composição não conta como cobertura.")
print("Posições: cada evidência aponta para uma configuração reproduzível. Chaves sem evidência ficam em aberto.")
print("Casas e aspectos usam projeções básicas. A presença de uma chave básica não cobre outros contextos.")
print()
print(("Posições | %d chaves demonstradas | %d chaves demonstradas sem texto | %d chaves em aberto | %d excluídas"):format(
  proven, #proven_missing, #pending, #excluded))
for _, item in ipairs(sections) do
  print(("%s | %d textos próprios | %d/%d chaves na grade | %d chaves sem texto na grade"):format(
    item.label, item.count, item.covered, item.candidates, #item.missing))
end
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
