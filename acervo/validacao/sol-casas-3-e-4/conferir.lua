local reader = dofile("entrada.lua")
local catalog = dofile("catalogo-editorial.lua")
local library = catalog.positions(reader.read("mapa-editorial-v1.txt"))
local path = assert(os.getenv("NATAL_ENTRADA"))
local chart = reader.read(path)
local key = catalog.position_key(chart.positions[1])
local index = assert(tonumber(arg[2]))

assert(key == arg[1], key)
assert(library[key] == index, key)
assert(#chart.warnings == 0, table.concat(chart.warnings, "\n"))

local macros = {}
token = {set_macro = function(name, value) macros[name] = value end}
texio = {write_nl = function() end}
dofile("dados-relatorio.lua")

local selected = macros.NatalLeiturasSelecionadas
assert(selected:find("\\NatalLeituraPosicao{" .. index .. "}{Sol}", 1, true), key)
print(("%s\t%d\t%s"):format(key, index, path:match("[^/\\]+$")))
