local macros = {}
token = {set_macro=function(name, value) macros[name]=value end}
texio = {write_nl=function(_,value)
  if value:find("[Cobertura]",1,true) then print(value) end
end}
dofile(arg[1])
local keys = {}
for name in pairs(macros) do keys[#keys+1]=name end
table.sort(keys)
local values = {}
for _, name in ipairs(keys) do values[#values+1]=name .. "=" .. macros[name] end
local digest = require("sha2").digest256(table.concat(values,"\n"))
if #digest == 32 then digest=digest:gsub(".",function(byte) return ("%02x"):format(byte:byte()) end) end
print(digest)