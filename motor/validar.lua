local folder = (arg[0] or ""):match("^(.*[/\\])") or ""
local reader = dofile(folder .. "entrada.lua")
if #arg ~= 1 then
  io.stderr:write("Uso: texlua validar.lua arquivo.txt\n")
  os.exit(2)
end
local ok, result = pcall(reader.read, arg[1])
if not ok then
  io.stderr:write(result, "\n")
  os.exit(1)
end
for _, warning in ipairs(result.warnings) do io.stderr:write("Aviso: ", warning, "\n") end
print(("%d posições, %d cúspides, %d aspectos, %d velocidades, %d avisos"):format(
  #result.positions, #result.cusps, #result.aspects, #result.speeds, #result.warnings))