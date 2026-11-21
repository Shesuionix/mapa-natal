local root = arg[1] or '.'
local reader = dofile(root .. '/motor/entrada.lua')
local domain = reader.domain()
local file = assert(io.open(root .. '/motor/mapa-editorial-v1.txt', 'rb'))
local source = file:read('*a'); file:close()
reader.read(root .. '/motor/mapa-editorial-v1.txt')
local tested = 0
for _, sign in ipairs(domain.signs) do
  for _, house in ipairs({1,2,3,11,12}) do
    assert(reader.position_exclusion('Vertex', false, house))
    local replacement = 'Vertex in ' .. sign .. " 15°00', in " .. house .. 'th House'
    local modified, count = source:gsub('Vertex in [^\r\n]+', replacement)
    assert(count == 1)
    local path = os.tmpname()
    local tmp = assert(io.open(path, 'wb')); tmp:write(modified); tmp:close()
    local ok, err = pcall(reader.read, path)
    os.remove(path)
    assert(not ok and tostring(err):find('Vertex ocidental', 1, true), tostring(err))
    tested = tested + 1
  end
end
for house=4,10 do assert(not reader.position_exclusion('Vertex', false, house)) end
assert(reader.position_exclusion('Vertex', true, 6))
assert(not reader.position_exclusion('Moon', false, 1))
assert(reader.position_exclusion('Moon', true, 1))
print(tested .. ' chaves excluidas rejeitadas pelo leitor; mapa base e regras de movimento conferidos')
