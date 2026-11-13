local function position_key(position)
  local motion = position.stationary and "stationary" or tostring(position.retrograde)
  return table.concat({position.name, position.sign, position.house, motion}, "|")
end

local position_library = {
  ["Sun|Aries|4|false"] = 94,
  ["Moon|Cancer|6|false"] = 95,
  ["Mercury|Pisces|3|false"] = 96,
  ["Venus|Aries|3|false"] = 97,
  ["Mars|Taurus|4|false"] = 98,
  ["Jupiter|Taurus|4|false"] = 99,
  ["Saturn|Taurus|4|false"] = 100,
  ["Uranus|Aquarius|2|false"] = 101,
  ["Neptune|Aquarius|1|false"] = 102,
  ["Pluto|Sagittarius|11|true"] = 103,
  ["North Node|Cancer|7|true"] = 104,
  ["Lilith|Capricorn|12|false"] = 105,
  ["Chiron|Sagittarius|11|true"] = 106,
  ["Fortune|Libra|10|false"] = 107,
  ["Vertex|Aries|4|false"] = 108,
  ["Sun|Taurus|11|false"] = 79,
  ["Moon|Libra|3|false"] = 80,
  ["Mercury|Taurus|10|false"] = 81,
  ["Venus|Gemini|1|false"] = 82,
  ["Mars|Leo|2|false"] = 83,
  ["Jupiter|Cancer|1|false"] = 84,
  ["Saturn|Leo|2|false"] = 85,
  ["Uranus|Scorpio|5|true"] = 86,
  ["Neptune|Sagittarius|6|true"] = 87,
  ["Pluto|Libra|4|true"] = 88,
  ["North Node|Libra|3|true"] = 89,
  ["Lilith|Cancer|1|false"] = 90,
  ["Chiron|Taurus|10|false"] = 91,
  ["Fortune|Scorpio|4|false"] = 92,
  ["Vertex|Aquarius|8|false"] = 93,
  ["Jupiter|Gemini|12|false"] = 76,
  ["Neptune|Scorpio|5|false"] = 77,
  ["Fortune|Gemini|12|false"] = 78,
  ["Sun|Leo|1|false"] = 62,
  ["Moon|Virgo|2|false"] = 63,
  ["Mercury|Leo|2|false"] = 64,
  ["Venus|Virgo|2|false"] = 65,
  ["Mars|Libra|4|false"] = 66,
  ["Jupiter|Gemini|11|false"] = 67,
  ["Saturn|Pisces|9|true"] = 68,
  ["Uranus|Virgo|3|false"] = 69,
  ["Pluto|Virgo|3|false"] = 70,
  ["North Node|Gemini|11|true"] = 71,
  ["Lilith|Aquarius|7|false"] = 72,
  ["Chiron|Pisces|9|true"] = 73,
  ["Fortune|Cancer|12|false"] = 74,
  ["Vertex|Sagittarius|5|false"] = 75,
  ["Neptune|Scorpio|5|stationary"] = 61,
  ["Sun|Libra|6|false"] = 46,
  ["Moon|Pisces|11|false"] = 47,
  ["Mercury|Virgo|6|false"] = 48,
  ["Venus|Scorpio|7|false"] = 49,
  ["Mars|Libra|7|false"] = 50,
  ["Jupiter|Gemini|2|true"] = 51,
  ["Saturn|Leo|5|false"] = 52,
  ["Uranus|Scorpio|7|false"] = 53,
  ["Neptune|Sagittarius|8|false"] = 54,
  ["Pluto|Libra|6|false"] = 55,
  ["North Node|Scorpio|7|true"] = 56,
  ["Lilith|Taurus|1|false"] = 57,
  ["Chiron|Taurus|1|true"] = 58,
  ["Fortune|Scorpio|8|false"] = 59,
  ["Vertex|Virgo|6|false"] = 60,
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

local axis_pairs = {
  {"Ascendant", "DSC", "Ascendente e Descendente"},
  {"MC", "IC", "Meio do Céu e Fundo do Céu"}
}

local axis_library = {
  [1] = {["Aries|Libra"]=7, ["Taurus|Scorpio"]=8, ["Cancer|Capricorn"]=9, ["Leo|Aquarius"]=10, ["Virgo|Pisces"]=11, ["Sagittarius|Gemini"]=12, ["Capricorn|Cancer"]=13, ["Aquarius|Leo"]=14, ["Pisces|Virgo"]=15, ["Libra|Aries"]=1, ["Gemini|Sagittarius"]=3, ["Scorpio|Taurus"]=5},
  [2] = {["Aries|Libra"]=16, ["Taurus|Scorpio"]=17, ["Gemini|Sagittarius"]=18, ["Virgo|Pisces"]=19, ["Libra|Aries"]=20, ["Scorpio|Taurus"]=21, ["Sagittarius|Gemini"]=22, ["Capricorn|Cancer"]=23, ["Aquarius|Leo"]=24, ["Cancer|Capricorn"]=2, ["Pisces|Virgo"]=4, ["Leo|Aquarius"]=6}
}

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

local traditional_rulers = {
  Aries="Mars", Taurus="Venus", Gemini="Mercury", Cancer="Moon", Leo="Sun",
  Virgo="Mercury", Libra="Venus", Scorpio="Mars", Sagittarius="Jupiter",
  Capricorn="Saturn", Aquarius="Saturn", Pisces="Jupiter"
}

local function house_key(number, sign, members, ruler_position)
  return ("%d|%s|ocupantes=%s|regente=%s|posicao=%s"):format(
    number, sign, members, traditional_rulers[sign], ruler_position)
end

local function editorial_facts(data)
  local positions, occupants, aspects = {}, {}, {}
  for house = 1, 12 do occupants[house] = {} end
  for _, position in ipairs(data.positions) do
    local key = position_key(position)
    positions[position.name] = key
    local house = occupants[position.house]
    house[#house+1] = key
  end
  for name, cusp in pairs(data.angles) do positions[name] = cusp.sign end
  for _, aspect in ipairs(data.aspects) do
    local first, second = aspect.first, aspect.second
    if second < first then first, second = second, first end
    aspects[table.concat({first, aspect.kind, second}, "|")] = aspect
  end
  for house = 1, 12 do occupants[house] = table.concat(occupants[house], ";") end
  return positions, occupants, aspects
end

local house_entries = {
  {84, 1, "Capricorn", "Neptune|Aquarius|1|false", "Saturn", "Saturn|Taurus|4|false",
    "Moon|Sextile|Saturn", "Moon|Cancer|6|false", "Saturn|Taurus|4|false"},
  {85, 2, "Aquarius", "Uranus|Aquarius|2|false", "Saturn", "Saturn|Taurus|4|false",
    "Moon|Sextile|Saturn", "Moon|Cancer|6|false", "Saturn|Taurus|4|false"},
  {86, 3, "Pisces", "Mercury|Pisces|3|false;Venus|Aries|3|false", "Jupiter", "Jupiter|Taurus|4|false",
    "Jupiter|Conjunction|Mars", "Jupiter|Taurus|4|false", "Mars|Taurus|4|false"},
  {87, 4, "Aries", "Sun|Aries|4|false;Mars|Taurus|4|false;Jupiter|Taurus|4|false;Saturn|Taurus|4|false;Vertex|Aries|4|false", "Mars", "Mars|Taurus|4|false",
    "Mars|Sextile|Moon", "Mars|Taurus|4|false", "Moon|Cancer|6|false"},
  {88, 5, "Taurus", "", "Venus", "Venus|Aries|3|false",
    "Lilith|Square|Venus", "Lilith|Capricorn|12|false", "Venus|Aries|3|false"},
  {89, 6, "Gemini", "Moon|Cancer|6|false", "Mercury", "Mercury|Pisces|3|false",
    "Mercury|Trine|North Node", "Mercury|Pisces|3|false", "North Node|Cancer|7|true"},
  {90, 7, "Cancer", "North Node|Cancer|7|true", "Moon", "Moon|Cancer|6|false",
    "Moon|Sextile|Saturn", "Moon|Cancer|6|false", "Saturn|Taurus|4|false"},
  {91, 8, "Leo", "", "Sun", "Sun|Aries|4|false",
    "Sun|Conjunction|Vertex", "Sun|Aries|4|false", "Vertex|Aries|4|false"},
  {92, 9, "Virgo", "", "Mercury", "Mercury|Pisces|3|false",
    "Mercury|Trine|North Node", "Mercury|Pisces|3|false", "North Node|Cancer|7|true"},
  {93, 10, "Libra", "Fortune|Libra|10|false", "Venus", "Venus|Aries|3|false",
    "Lilith|Square|Venus", "Lilith|Capricorn|12|false", "Venus|Aries|3|false"},
  {94, 11, "Scorpio", "Pluto|Sagittarius|11|true;Chiron|Sagittarius|11|true", "Mars", "Mars|Taurus|4|false",
    "Mars|Sextile|Moon", "Mars|Taurus|4|false", "Moon|Cancer|6|false"},
  {95, 12, "Sagittarius", "Lilith|Capricorn|12|false", "Jupiter", "Jupiter|Taurus|4|false",
    "Jupiter|Conjunction|Mars", "Jupiter|Taurus|4|false", "Mars|Taurus|4|false"},
  {72, 1, "Gemini", "Venus|Gemini|1|false;Jupiter|Cancer|1|false;Lilith|Cancer|1|false", "Mercury", "Mercury|Taurus|10|false",
    "Fortune|Opposition|Mercury", "Fortune|Scorpio|4|false", "Mercury|Taurus|10|false"},
  {73, 2, "Cancer", "Mars|Leo|2|false;Saturn|Leo|2|false", "Moon", "Moon|Libra|3|false",
    "Moon|Conjunction|North Node", "Moon|Libra|3|false", "North Node|Libra|3|true"},
  {74, 3, "Virgo", "Moon|Libra|3|false;North Node|Libra|3|true", "Mercury", "Mercury|Taurus|10|false",
    "Fortune|Opposition|Mercury", "Fortune|Scorpio|4|false", "Mercury|Taurus|10|false"},
  {75, 4, "Libra", "Pluto|Libra|4|true;Fortune|Scorpio|4|false", "Venus", "Venus|Gemini|1|false",
    "Ascendant|Conjunction|Venus", "Gemini", "Venus|Gemini|1|false"},
  {76, 5, "Scorpio", "Uranus|Scorpio|5|true", "Mars", "Mars|Leo|2|false",
    "Mars|Trine|Neptune", "Mars|Leo|2|false", "Neptune|Sagittarius|6|true"},
  {77, 6, "Sagittarius", "Neptune|Sagittarius|6|true", "Jupiter", "Jupiter|Cancer|1|false",
    "Chiron|Sextile|Jupiter", "Chiron|Taurus|10|false", "Jupiter|Cancer|1|false"},
  {78, 7, "Sagittarius", "", "Jupiter", "Jupiter|Cancer|1|false",
    "Chiron|Sextile|Jupiter", "Chiron|Taurus|10|false", "Jupiter|Cancer|1|false"},
  {79, 8, "Capricorn", "Vertex|Aquarius|8|false", "Saturn", "Saturn|Leo|2|false",
    "Ascendant|Sextile|Saturn", "Gemini", "Saturn|Leo|2|false"},
  {80, 9, "Pisces", "", "Jupiter", "Jupiter|Cancer|1|false",
    "Chiron|Sextile|Jupiter", "Chiron|Taurus|10|false", "Jupiter|Cancer|1|false"},
  {81, 10, "Aries", "Mercury|Taurus|10|false;Chiron|Taurus|10|false", "Mars", "Mars|Leo|2|false",
    "Mars|Trine|Neptune", "Mars|Leo|2|false", "Neptune|Sagittarius|6|true"},
  {82, 11, "Taurus", "Sun|Taurus|11|false", "Venus", "Venus|Gemini|1|false",
    "Ascendant|Conjunction|Venus", "Gemini", "Venus|Gemini|1|false"},
  {83, 12, "Gemini", "", "Mercury", "Mercury|Taurus|10|false",
    "Fortune|Opposition|Mercury", "Fortune|Scorpio|4|false", "Mercury|Taurus|10|false"},
  {61, 1, "Cancer", "Sun|Leo|1|false", "Moon", "Moon|Virgo|2|false",
    "Moon|Conjunction|Venus", "Moon|Virgo|2|false", "Venus|Virgo|2|false"},
  {62, 3, "Virgo", "Uranus|Virgo|3|false;Pluto|Virgo|3|false", "Mercury", "Mercury|Leo|2|false",
    "Fortune|Sextile|Mercury", "Fortune|Gemini|12|false", "Mercury|Leo|2|false"},
  {63, 4, "Libra", "Mars|Libra|4|false", "Venus", "Venus|Virgo|2|false",
    "Moon|Conjunction|Venus", "Moon|Virgo|2|false", "Venus|Virgo|2|false"},
  {64, 5, "Scorpio", "Neptune|Scorpio|5|false;Vertex|Sagittarius|5|false", "Mars", "Mars|Libra|4|false",
    "Jupiter|Trine|Mars", "Jupiter|Gemini|12|false", "Mars|Libra|4|false"},
  {65, 6, "Sagittarius", "", "Jupiter", "Jupiter|Gemini|12|false",
    "Chiron|Square|Jupiter", "Chiron|Pisces|9|true", "Jupiter|Gemini|12|false"},
  {66, 7, "Capricorn", "Lilith|Aquarius|7|false", "Saturn", "Saturn|Pisces|9|true",
    "Neptune|Trine|Saturn", "Neptune|Scorpio|5|false", "Saturn|Pisces|9|true"},
  {67, 8, "Aquarius", "", "Saturn", "Saturn|Pisces|9|true",
    "Neptune|Trine|Saturn", "Neptune|Scorpio|5|false", "Saturn|Pisces|9|true"},
  {68, 9, "Pisces", "Saturn|Pisces|9|true;Chiron|Pisces|9|true", "Jupiter", "Jupiter|Gemini|12|false",
    "Chiron|Square|Jupiter", "Chiron|Pisces|9|true", "Jupiter|Gemini|12|false"},
  {69, 10, "Aries", "", "Mars", "Mars|Libra|4|false",
    "Jupiter|Trine|Mars", "Jupiter|Gemini|12|false", "Mars|Libra|4|false"},
  {70, 11, "Taurus", "North Node|Gemini|11|true", "Venus", "Venus|Virgo|2|false",
    "Moon|Conjunction|Venus", "Moon|Virgo|2|false", "Venus|Virgo|2|false"},
  {71, 12, "Gemini", "Jupiter|Gemini|12|false;Fortune|Gemini|12|false", "Mercury", "Mercury|Leo|2|false",
    "Fortune|Sextile|Mercury", "Fortune|Gemini|12|false", "Mercury|Leo|2|false"},
  {50, 1, "Leo", "Sun|Leo|1|false", "Sun", "Sun|Leo|1|false",
    "IC|Sextile|Sun", "Libra", "Sun|Leo|1|false"},
  {51, 2, "Leo", "Moon|Virgo|2|false;Mercury|Leo|2|false;Venus|Virgo|2|false", "Sun", "Sun|Leo|1|false",
    "IC|Sextile|Sun", "Libra", "Sun|Leo|1|false"},
  {52, 3, "Virgo", "Uranus|Virgo|3|false;Pluto|Virgo|3|false", "Mercury", "Mercury|Leo|2|false",
    "Mercury|Conjunction|Moon", "Mercury|Leo|2|false", "Moon|Virgo|2|false"},
  {53, 4, "Libra", "Mars|Libra|4|false", "Venus", "Venus|Virgo|2|false",
    "Fortune|Sextile|Venus", "Fortune|Cancer|12|false", "Venus|Virgo|2|false"},
  {54, 6, "Sagittarius", "", "Jupiter", "Jupiter|Gemini|11|false",
    "Chiron|Square|Jupiter", "Chiron|Pisces|9|true", "Jupiter|Gemini|11|false"},
  {55, 7, "Aquarius", "Lilith|Aquarius|7|false", "Saturn", "Saturn|Pisces|9|true",
    "Saturn|Square|Vertex", "Saturn|Pisces|9|true", "Vertex|Sagittarius|5|false"},
  {56, 8, "Aquarius", "", "Saturn", "Saturn|Pisces|9|true",
    "Saturn|Square|Vertex", "Saturn|Pisces|9|true", "Vertex|Sagittarius|5|false"},
  {57, 9, "Pisces", "Saturn|Pisces|9|true;Chiron|Pisces|9|true", "Jupiter", "Jupiter|Gemini|11|false",
    "Chiron|Square|Jupiter", "Chiron|Pisces|9|true", "Jupiter|Gemini|11|false"},
  {58, 10, "Aries", "", "Mars", "Mars|Libra|4|false",
    "Mars|Sextile|Vertex", "Mars|Libra|4|false", "Vertex|Sagittarius|5|false"},
  {59, 11, "Taurus", "Jupiter|Gemini|11|false;North Node|Gemini|11|true", "Venus", "Venus|Virgo|2|false",
    "Fortune|Sextile|Venus", "Fortune|Cancer|12|false", "Venus|Virgo|2|false"},
  {60, 12, "Gemini", "Fortune|Cancer|12|false", "Mercury", "Mercury|Leo|2|false",
    "Mercury|Conjunction|Moon", "Mercury|Leo|2|false", "Moon|Virgo|2|false"},
  {49, 5, "Scorpio", "Neptune|Scorpio|5|stationary;Vertex|Sagittarius|5|false", "Mars", "Mars|Libra|4|false",
    "Mars|Sextile|Vertex", "Mars|Libra|4|false", "Vertex|Sagittarius|5|false"},
  {37, 1, "Aries", "Lilith|Taurus|1|false;Chiron|Taurus|1|true", "Mars", "Mars|Libra|7|false"},
  {38, 2, "Taurus", "Jupiter|Gemini|2|true", "Venus", "Venus|Scorpio|7|false"},
  {39, 3, "Gemini", "", "Mercury", "Mercury|Virgo|6|false"},
  {40, 4, "Cancer", "", "Moon", "Moon|Pisces|11|false"},
  {41, 5, "Leo", "Saturn|Leo|5|false", "Sun", "Sun|Libra|6|false"},
  {42, 6, "Virgo", "Sun|Libra|6|false;Mercury|Virgo|6|false;Pluto|Libra|6|false;Vertex|Virgo|6|false", "Mercury", "Mercury|Virgo|6|false"},
  {43, 7, "Libra", "Venus|Scorpio|7|false;Mars|Libra|7|false;Uranus|Scorpio|7|false;North Node|Scorpio|7|true", "Venus", "Venus|Scorpio|7|false"},
  {44, 8, "Scorpio", "Neptune|Sagittarius|8|false;Fortune|Scorpio|8|false", "Mars", "Mars|Libra|7|false"},
  {45, 9, "Sagittarius", "", "Jupiter", "Jupiter|Gemini|2|true"},
  {46, 10, "Capricorn", "", "Saturn", "Saturn|Leo|5|false"},
  {47, 11, "Aquarius", "Moon|Pisces|11|false", "Saturn", "Saturn|Leo|5|false"},
  {48, 12, "Pisces", "", "Jupiter", "Jupiter|Gemini|2|true"},
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

local function aspect_key(aspect)
  local first, second = aspect.first, aspect.second
  if second < first then first, second = second, first end
  return table.concat({first, aspect.kind, second}, "|")
end

local function contextual_aspect_key(aspect, locations)
  local first, second = aspect.first, aspect.second
  if second < first then first, second = second, first end
  return table.concat({first, aspect.kind, second, locations[first], locations[second]}, ":")
end

local function house_dependency_key(key, dependency, first_position, second_position)
  if dependency == "nenhum" then return key .. "|aspecto=nenhum" end
  return key .. "|aspecto=" .. dependency .. ":" .. first_position .. ":" .. second_position
end

local function house_aspect_key(key, dependency, locations)
  local first, second = dependency:match("^([^|]+)|[^|]+|([^|]+)$")
  return house_dependency_key(key, dependency, locations[first], locations[second])
end

local function houses(reviewed)
  local library = {}
  local positions, occupants, aspects = editorial_facts(reviewed)
  for number, rule in ipairs(house_rules) do
    local ruler, dependency = table.unpack(rule)
    local sign = reviewed.cusps[number].sign
    assert(ruler == traditional_rulers[sign] and aspects[dependency], "Dependência inválida na casa " .. number)
    local key = house_key(number, sign, occupants[number], positions[ruler])
    library[house_aspect_key(key, dependency, positions)] = number
  end
  for _, entry in ipairs(house_entries) do
    local id, number, sign, members, ruler, ruler_position, dependency, first_position, second_position = table.unpack(entry)
    assert(ruler == traditional_rulers[sign], "Regente inválido no texto " .. id)
    local key = house_key(number, sign, members, ruler_position)
    if dependency then
      if dependency ~= "nenhum" then
        local first, second = dependency:match("^([^|]+)|[^|]+|([^|]+)$")
        assert(first and first < second and first_position and second_position and
          ((first == ruler and first_position == ruler_position) or (second == ruler and second_position == ruler_position)),
          "Dependência de aspecto inválida no texto " .. id)
      end
      key = house_dependency_key(key, dependency, first_position, second_position)
    end
    assert(not library[key], "Chave duplicada: " .. key)
    library[key] = id
  end
  return library
end

local function select_house(number, chart, positions, occupants, aspects, library)
  local sign = chart.cusps[number].sign
  local ruler = traditional_rulers[sign]
  local key = house_key(number, sign, occupants[number], positions[ruler])
  local primary, orb
  for dependency, aspect in pairs(aspects) do
    if (aspect.first == ruler or aspect.second == ruler) and
      (not primary or aspect.orb < orb or (aspect.orb == orb and dependency < primary)) then
      primary, orb = dependency, aspect.orb
    end
  end
  local contextual = primary and house_aspect_key(key, primary, positions) or house_dependency_key(key, "nenhum")
  if library[contextual] then return library[contextual], contextual end
  local reviewed_dependency = house_rules[number][2]
  if aspects[reviewed_dependency] then
    local reviewed_key = house_aspect_key(key, reviewed_dependency, positions)
    if library[reviewed_key] then return library[reviewed_key], reviewed_key end
  end
  if library[key] then return library[key], key end
  return nil, contextual
end

local contextual_aspects = {
  ["Moon:Square:Sun:Moon|Cancer|6|false:Sun|Aries|4|false"] = 310,
  ["Sun:Sextile:Uranus:Sun|Aries|4|false:Uranus|Aquarius|2|false"] = 311,
  ["Pluto:Trine:Sun:Pluto|Sagittarius|11|true:Sun|Aries|4|false"] = 312,
  ["Mars:Sextile:Moon:Mars|Taurus|4|false:Moon|Cancer|6|false"] = 313,
  ["Jupiter:Sextile:Moon:Jupiter|Taurus|4|false:Moon|Cancer|6|false"] = 314,
  ["Moon:Sextile:Saturn:Moon|Cancer|6|false:Saturn|Taurus|4|false"] = 315,
  ["Neptune:Sextile:Venus:Neptune|Aquarius|1|false:Venus|Aries|3|false"] = 316,
  ["Jupiter:Conjunction:Mars:Jupiter|Taurus|4|false:Mars|Taurus|4|false"] = 317,
  ["Mars:Conjunction:Saturn:Mars|Taurus|4|false:Saturn|Taurus|4|false"] = 318,
  ["Mars:Square:Uranus:Mars|Taurus|4|false:Uranus|Aquarius|2|false"] = 319,
  ["Jupiter:Conjunction:Saturn:Jupiter|Taurus|4|false:Saturn|Taurus|4|false"] = 320,
  ["Jupiter:Square:Neptune:Jupiter|Taurus|4|false:Neptune|Aquarius|1|false"] = 321,
  ["Saturn:Square:Uranus:Saturn|Taurus|4|false:Uranus|Aquarius|2|false"] = 322,
  ["Ascendant:Square:Sun:Capricorn:Sun|Aries|4|false"] = 323,
  ["Ascendant:Opposition:Moon:Capricorn:Moon|Cancer|6|false"] = 324,
  ["Ascendant:Trine:Mars:Capricorn:Mars|Taurus|4|false"] = 325,
  ["Ascendant:Trine:Saturn:Capricorn:Saturn|Taurus|4|false"] = 326,
  ["DSC:Square:Sun:Cancer:Sun|Aries|4|false"] = 327,
  ["DSC:Conjunction:Moon:Cancer:Moon|Cancer|6|false"] = 328,
  ["DSC:Sextile:Saturn:Cancer:Saturn|Taurus|4|false"] = 329,
  ["MC:Opposition:Sun:Libra:Sun|Aries|4|false"] = 330,
  ["MC:Square:Moon:Libra:Moon|Cancer|6|false"] = 331,
  ["MC:Trine:Uranus:Libra:Uranus|Aquarius|2|false"] = 332,
  ["Chiron:Sextile:MC:Chiron|Sagittarius|11|true:Libra"] = 333,
  ["IC:Conjunction:Sun:Aries:Sun|Aries|4|false"] = 334,
  ["IC:Square:Moon:Aries:Moon|Cancer|6|false"] = 335,
  ["IC:Sextile:Uranus:Aries:Uranus|Aquarius|2|false"] = 336,
  ["Chiron:Trine:IC:Chiron|Sagittarius|11|true:Aries"] = 337,
  ["North Node:Square:Sun:North Node|Cancer|7|true:Sun|Aries|4|false"] = 338,
  ["Mercury:Trine:North Node:Mercury|Pisces|3|false:North Node|Cancer|7|true"] = 339,
  ["North Node:Trine:Venus:North Node|Cancer|7|true:Venus|Aries|3|false"] = 340,
  ["Neptune:Opposition:North Node:Neptune|Aquarius|1|false:North Node|Cancer|7|true"] = 341,
  ["Lilith:Square:Venus:Lilith|Capricorn|12|false:Venus|Aries|3|false"] = 342,
  ["Jupiter:Trine:Lilith:Jupiter|Taurus|4|false:Lilith|Capricorn|12|false"] = 343,
  ["Chiron:Trine:Sun:Chiron|Sagittarius|11|true:Sun|Aries|4|false"] = 344,
  ["Chiron:Sextile:Uranus:Chiron|Sagittarius|11|true:Uranus|Aquarius|2|false"] = 345,
  ["Chiron:Conjunction:Pluto:Chiron|Sagittarius|11|true:Pluto|Sagittarius|11|true"] = 346,
  ["Fortune:Opposition:Sun:Fortune|Libra|10|false:Sun|Aries|4|false"] = 347,
  ["Fortune:Trine:Uranus:Fortune|Libra|10|false:Uranus|Aquarius|2|false"] = 348,
  ["Fortune:Square:North Node:Fortune|Libra|10|false:North Node|Cancer|7|true"] = 349,
  ["Ascendant:Square:Fortune:Capricorn:Fortune|Libra|10|false"] = 350,
  ["Fortune:Conjunction:MC:Fortune|Libra|10|false:Libra"] = 351,
  ["Fortune:Opposition:IC:Fortune|Libra|10|false:Aries"] = 352,
  ["DSC:Square:Fortune:Cancer:Fortune|Libra|10|false"] = 353,
  ["Sun:Conjunction:Vertex:Sun|Aries|4|false:Vertex|Aries|4|false"] = 354,
  ["Moon:Square:Vertex:Moon|Cancer|6|false:Vertex|Aries|4|false"] = 355,
  ["Uranus:Sextile:Vertex:Uranus|Aquarius|2|false:Vertex|Aries|4|false"] = 356,
  ["Chiron:Trine:Vertex:Chiron|Sagittarius|11|true:Vertex|Aries|4|false"] = 357,
  ["Ascendant:Square:Vertex:Capricorn:Vertex|Aries|4|false"] = 358,
  ["MC:Opposition:Vertex:Libra:Vertex|Aries|4|false"] = 359,
  ["IC:Conjunction:Vertex:Aries:Vertex|Aries|4|false"] = 360,
  ["DSC:Square:Vertex:Cancer:Vertex|Aries|4|false"] = 361,
  ["Moon:Trine:Sun:Moon|Libra|3|false:Sun|Taurus|11|false"] = 264,
  ["Saturn:Square:Sun:Saturn|Leo|2|false:Sun|Taurus|11|false"] = 265,
  ["Moon:Square:Venus:Moon|Libra|3|false:Venus|Gemini|1|false"] = 266,
  ["Jupiter:Square:Moon:Jupiter|Cancer|1|false:Moon|Libra|3|false"] = 267,
  ["Moon:Conjunction:Pluto:Moon|Libra|3|false:Pluto|Libra|4|true"] = 268,
  ["Jupiter:Sextile:Mercury:Jupiter|Cancer|1|false:Mercury|Taurus|10|false"] = 269,
  ["Saturn:Sextile:Venus:Saturn|Leo|2|false:Venus|Gemini|1|false"] = 270,
  ["Mars:Square:Uranus:Mars|Leo|2|false:Uranus|Scorpio|5|true"] = 271,
  ["Mars:Trine:Neptune:Mars|Leo|2|false:Neptune|Sagittarius|6|true"] = 272,
  ["Mars:Sextile:Pluto:Mars|Leo|2|false:Pluto|Libra|4|true"] = 273,
  ["Neptune:Trine:Saturn:Neptune|Sagittarius|6|true:Saturn|Leo|2|false"] = 274,
  ["Neptune:Sextile:Pluto:Neptune|Sagittarius|6|true:Pluto|Libra|4|true"] = 275,
  ["Ascendant:Square:Moon:Gemini:Moon|Libra|3|false"] = 276,
  ["Ascendant:Conjunction:Venus:Gemini:Venus|Gemini|1|false"] = 277,
  ["Ascendant:Sextile:Saturn:Gemini:Saturn|Leo|2|false"] = 278,
  ["DSC:Square:Moon:Sagittarius:Moon|Libra|3|false"] = 279,
  ["DSC:Opposition:Venus:Sagittarius:Venus|Gemini|1|false"] = 280,
  ["DSC:Trine:Saturn:Sagittarius:Saturn|Leo|2|false"] = 281,
  ["MC:Opposition:Moon:Aries:Moon|Libra|3|false"] = 282,
  ["MC:Trine:Mars:Aries:Mars|Leo|2|false"] = 283,
  ["Jupiter:Square:MC:Jupiter|Cancer|1|false:Aries"] = 284,
  ["MC:Opposition:Pluto:Aries:Pluto|Libra|4|true"] = 285,
  ["Lilith:Square:MC:Lilith|Cancer|1|false:Aries"] = 286,
  ["IC:Conjunction:Moon:Libra:Moon|Libra|3|false"] = 287,
  ["IC:Square:Jupiter:Libra:Jupiter|Cancer|1|false"] = 288,
  ["IC:Conjunction:Pluto:Libra:Pluto|Libra|4|true"] = 289,
  ["IC:Square:Lilith:Libra:Lilith|Cancer|1|false"] = 290,
  ["North Node:Trine:Sun:North Node|Libra|3|true:Sun|Taurus|11|false"] = 291,
  ["Moon:Conjunction:North Node:Moon|Libra|3|false:North Node|Libra|3|true"] = 292,
  ["Jupiter:Square:North Node:Jupiter|Cancer|1|false:North Node|Libra|3|true"] = 293,
  ["Lilith:Square:Moon:Lilith|Cancer|1|false:Moon|Libra|3|false"] = 294,
  ["Lilith:Trine:Uranus:Lilith|Cancer|1|false:Uranus|Scorpio|5|true"] = 295,
  ["Lilith:Square:Pluto:Lilith|Cancer|1|false:Pluto|Libra|4|true"] = 296,
  ["Chiron:Conjunction:Mercury:Chiron|Taurus|10|false:Mercury|Taurus|10|false"] = 297,
  ["Chiron:Sextile:Jupiter:Chiron|Taurus|10|false:Jupiter|Cancer|1|false"] = 298,
  ["Fortune:Opposition:Mercury:Fortune|Scorpio|4|false:Mercury|Taurus|10|false"] = 299,
  ["Fortune:Trine:Venus:Fortune|Scorpio|4|false:Venus|Gemini|1|false"] = 300,
  ["Fortune:Trine:Jupiter:Fortune|Scorpio|4|false:Jupiter|Cancer|1|false"] = 301,
  ["Chiron:Opposition:Fortune:Chiron|Taurus|10|false:Fortune|Scorpio|4|false"] = 302,
  ["Moon:Trine:Vertex:Moon|Libra|3|false:Vertex|Aquarius|8|false"] = 303,
  ["Mars:Opposition:Vertex:Mars|Leo|2|false:Vertex|Aquarius|8|false"] = 304,
  ["Uranus:Square:Vertex:Uranus|Scorpio|5|true:Vertex|Aquarius|8|false"] = 305,
  ["Pluto:Trine:Vertex:Pluto|Libra|4|true:Vertex|Aquarius|8|false"] = 306,
  ["Chiron:Square:Vertex:Chiron|Taurus|10|false:Vertex|Aquarius|8|false"] = 307,
  ["MC:Sextile:Vertex:Aries:Vertex|Aquarius|8|false"] = 308,
  ["IC:Trine:Vertex:Libra:Vertex|Aquarius|8|false"] = 309,
  ["Moon:Conjunction:Uranus:Moon|Virgo|2|false:Uranus|Virgo|3|false"] = 243,
  ["Jupiter:Trine:Mars:Jupiter|Gemini|12|false:Mars|Libra|4|false"] = 244,
  ["Jupiter:Square:Saturn:Jupiter|Gemini|12|false:Saturn|Pisces|9|true"] = 245,
  ["Neptune:Trine:Saturn:Neptune|Scorpio|5|false:Saturn|Pisces|9|true"] = 246,
  ["Neptune:Sextile:Pluto:Neptune|Scorpio|5|false:Pluto|Virgo|3|false"] = 247,
  ["Ascendant:Square:Mars:Cancer:Mars|Libra|4|false"] = 248,
  ["Ascendant:Trine:Neptune:Cancer:Neptune|Scorpio|5|false"] = 249,
  ["Ascendant:Trine:Chiron:Cancer:Chiron|Pisces|9|true"] = 250,
  ["DSC:Square:Mars:Capricorn:Mars|Libra|4|false"] = 251,
  ["Chiron:Sextile:DSC:Chiron|Pisces|9|true:Capricorn"] = 252,
  ["MC:Sextile:North Node:Aries:North Node|Gemini|11|true"] = 253,
  ["Moon:Square:North Node:Moon|Virgo|2|false:North Node|Gemini|11|true"] = 254,
  ["Chiron:Square:Jupiter:Chiron|Pisces|9|true:Jupiter|Gemini|12|false"] = 255,
  ["Chiron:Trine:Neptune:Chiron|Pisces|9|true:Neptune|Scorpio|5|false"] = 256,
  ["Fortune:Sextile:Mercury:Fortune|Gemini|12|false:Mercury|Leo|2|false"] = 257,
  ["Fortune:Conjunction:Jupiter:Fortune|Gemini|12|false:Jupiter|Gemini|12|false"] = 258,
  ["Chiron:Square:Fortune:Chiron|Pisces|9|true:Fortune|Gemini|12|false"] = 259,
  ["Moon:Square:Vertex:Moon|Virgo|2|false:Vertex|Sagittarius|5|false"] = 260,
  ["Venus:Square:Vertex:Venus|Virgo|2|false:Vertex|Sagittarius|5|false"] = 261,
  ["MC:Trine:Vertex:Aries:Vertex|Sagittarius|5|false"] = 262,
  ["IC:Sextile:Vertex:Libra:Vertex|Sagittarius|5|false"] = 263,
  ["Mercury:Conjunction:Moon:Mercury|Leo|2|false:Moon|Virgo|2|false"] = 203,
  ["Moon:Conjunction:Venus:Moon|Virgo|2|false:Venus|Virgo|2|false"] = 204,
  ["Mercury:Conjunction:Venus:Mercury|Leo|2|false:Venus|Virgo|2|false"] = 205,
  ["Jupiter:Trine:Mars:Jupiter|Gemini|11|false:Mars|Libra|4|false"] = 206,
  ["Jupiter:Square:Saturn:Jupiter|Gemini|11|false:Saturn|Pisces|9|true"] = 207,
  ["Saturn:Opposition:Uranus:Saturn|Pisces|9|true:Uranus|Virgo|3|false"] = 208,
  ["Neptune:Trine:Saturn:Neptune|Scorpio|5|stationary:Saturn|Pisces|9|true"] = 209,
  ["Pluto:Opposition:Saturn:Pluto|Virgo|3|false:Saturn|Pisces|9|true"] = 210,
  ["Pluto:Conjunction:Uranus:Pluto|Virgo|3|false:Uranus|Virgo|3|false"] = 211,
  ["Neptune:Sextile:Pluto:Neptune|Scorpio|5|stationary:Pluto|Virgo|3|false"] = 212,
  ["Ascendant:Conjunction:Sun:Leo:Sun|Leo|1|false"] = 213,
  ["Ascendant:Opposition:Lilith:Leo:Lilith|Aquarius|7|false"] = 214,
  ["DSC:Opposition:Sun:Aquarius:Sun|Leo|1|false"] = 215,
  ["DSC:Conjunction:Lilith:Aquarius:Lilith|Aquarius|7|false"] = 216,
  ["MC:Trine:Sun:Aries:Sun|Leo|1|false"] = 217,
  ["Lilith:Sextile:MC:Lilith|Aquarius|7|false:Aries"] = 218,
  ["IC:Sextile:Sun:Libra:Sun|Leo|1|false"] = 219,
  ["IC:Trine:North Node:Libra:North Node|Gemini|11|true"] = 220,
  ["IC:Trine:Lilith:Libra:Lilith|Aquarius|7|false"] = 221,
  ["North Node:Sextile:Sun:North Node|Gemini|11|true:Sun|Leo|1|false"] = 222,
  ["North Node:Square:Venus:North Node|Gemini|11|true:Venus|Virgo|2|false"] = 223,
  ["Mars:Trine:North Node:Mars|Libra|4|false:North Node|Gemini|11|true"] = 224,
  ["North Node:Square:Saturn:North Node|Gemini|11|true:Saturn|Pisces|9|true"] = 225,
  ["North Node:Square:Uranus:North Node|Gemini|11|true:Uranus|Virgo|3|false"] = 226,
  ["North Node:Square:Pluto:North Node|Gemini|11|true:Pluto|Virgo|3|false"] = 227,
  ["Lilith:Opposition:Sun:Lilith|Aquarius|7|false:Sun|Leo|1|false"] = 228,
  ["Chiron:Square:Jupiter:Chiron|Pisces|9|true:Jupiter|Gemini|11|false"] = 229,
  ["Chiron:Conjunction:Saturn:Chiron|Pisces|9|true:Saturn|Pisces|9|true"] = 230,
  ["Chiron:Trine:Neptune:Chiron|Pisces|9|true:Neptune|Scorpio|5|stationary"] = 231,
  ["Fortune:Sextile:Venus:Fortune|Cancer|12|false:Venus|Virgo|2|false"] = 232,
  ["Fortune:Square:MC:Fortune|Cancer|12|false:Aries"] = 233,
  ["Fortune:Square:IC:Fortune|Cancer|12|false:Libra"] = 234,
  ["Sun:Trine:Vertex:Sun|Leo|1|false:Vertex|Sagittarius|5|false"] = 235,
  ["Mars:Sextile:Vertex:Mars|Libra|4|false:Vertex|Sagittarius|5|false"] = 236,
  ["Jupiter:Opposition:Vertex:Jupiter|Gemini|11|false:Vertex|Sagittarius|5|false"] = 237,
  ["Saturn:Square:Vertex:Saturn|Pisces|9|true:Vertex|Sagittarius|5|false"] = 238,
  ["Uranus:Square:Vertex:Uranus|Virgo|3|false:Vertex|Sagittarius|5|false"] = 239,
  ["Pluto:Square:Vertex:Pluto|Virgo|3|false:Vertex|Sagittarius|5|false"] = 240,
  ["North Node:Opposition:Vertex:North Node|Gemini|11|true:Vertex|Sagittarius|5|false"] = 241,
  ["Chiron:Square:Vertex:Chiron|Pisces|9|true:Vertex|Sagittarius|5|false"] = 242,
  ["Saturn:Sextile:Sun:Saturn|Leo|5|false:Sun|Libra|6|false"] = 152,
  ["Neptune:Sextile:Sun:Neptune|Sagittarius|8|false:Sun|Libra|6|false"] = 153,
  ["Pluto:Conjunction:Sun:Pluto|Libra|6|false:Sun|Libra|6|false"] = 154,
  ["Moon:Trine:Venus:Moon|Pisces|11|false:Venus|Scorpio|7|false"] = 155,
  ["Mars:Trine:Moon:Mars|Libra|7|false:Moon|Pisces|11|false"] = 156,
  ["Jupiter:Square:Moon:Jupiter|Gemini|2|true:Moon|Pisces|11|false"] = 157,
  ["Moon:Trine:Uranus:Moon|Pisces|11|false:Uranus|Scorpio|7|false"] = 158,
  ["Moon:Square:Neptune:Moon|Pisces|11|false:Neptune|Sagittarius|8|false"] = 159,
  ["Jupiter:Trine:Mercury:Jupiter|Gemini|2|true:Mercury|Virgo|6|false"] = 160,
  ["Saturn:Square:Venus:Saturn|Leo|5|false:Venus|Scorpio|7|false"] = 161,
  ["Uranus:Conjunction:Venus:Uranus|Scorpio|7|false:Venus|Scorpio|7|false"] = 162,
  ["Neptune:Trine:Saturn:Neptune|Sagittarius|8|false:Saturn|Leo|5|false"] = 163,
  ["Pluto:Sextile:Saturn:Pluto|Libra|6|false:Saturn|Leo|5|false"] = 164,
  ["Neptune:Sextile:Pluto:Neptune|Sagittarius|8|false:Pluto|Libra|6|false"] = 165,
  ["Ascendant:Opposition:Sun:Aries:Sun|Libra|6|false"] = 166,
  ["Ascendant:Trine:Saturn:Aries:Saturn|Leo|5|false"] = 167,
  ["Ascendant:Trine:Neptune:Aries:Neptune|Sagittarius|8|false"] = 168,
  ["Ascendant:Opposition:Pluto:Aries:Pluto|Libra|6|false"] = 169,
  ["DSC:Conjunction:Sun:Libra:Sun|Libra|6|false"] = 170,
  ["DSC:Sextile:Saturn:Libra:Saturn|Leo|5|false"] = 171,
  ["DSC:Sextile:Neptune:Libra:Neptune|Sagittarius|8|false"] = 172,
  ["DSC:Conjunction:Pluto:Libra:Pluto|Libra|6|false"] = 173,
  ["MC:Square:Sun:Capricorn:Sun|Libra|6|false"] = 174,
  ["MC:Sextile:Venus:Capricorn:Venus|Scorpio|7|false"] = 175,
  ["MC:Square:Pluto:Capricorn:Pluto|Libra|6|false"] = 176,
  ["Lilith:Trine:MC:Lilith|Taurus|1|false:Capricorn"] = 177,
  ["IC:Square:Sun:Cancer:Sun|Libra|6|false"] = 178,
  ["IC:Trine:Moon:Cancer:Moon|Pisces|11|false"] = 179,
  ["IC:Trine:Venus:Cancer:Venus|Scorpio|7|false"] = 180,
  ["IC:Trine:Uranus:Cancer:Uranus|Scorpio|7|false"] = 181,
  ["IC:Square:Pluto:Cancer:Pluto|Libra|6|false"] = 182,
  ["Moon:Trine:North Node:Moon|Pisces|11|false:North Node|Scorpio|7|true"] = 183,
  ["North Node:Conjunction:Venus:North Node|Scorpio|7|true:Venus|Scorpio|7|false"] = 184,
  ["North Node:Conjunction:Uranus:North Node|Scorpio|7|true:Uranus|Scorpio|7|false"] = 185,
  ["Lilith:Opposition:North Node:Lilith|Taurus|1|false:North Node|Scorpio|7|true"] = 186,
  ["Chiron:Opposition:North Node:Chiron|Taurus|1|true:North Node|Scorpio|7|true"] = 187,
  ["Lilith:Sextile:Moon:Lilith|Taurus|1|false:Moon|Pisces|11|false"] = 188,
  ["Lilith:Opposition:Venus:Lilith|Taurus|1|false:Venus|Scorpio|7|false"] = 189,
  ["Lilith:Square:Saturn:Lilith|Taurus|1|false:Saturn|Leo|5|false"] = 190,
  ["Lilith:Opposition:Uranus:Lilith|Taurus|1|false:Uranus|Scorpio|7|false"] = 191,
  ["Chiron:Sextile:Moon:Chiron|Taurus|1|true:Moon|Pisces|11|false"] = 192,
  ["Chiron:Opposition:Mars:Chiron|Taurus|1|true:Mars|Libra|7|false"] = 193,
  ["Chiron:Opposition:Uranus:Chiron|Taurus|1|true:Uranus|Scorpio|7|false"] = 194,
  ["Fortune:Sextile:Mercury:Fortune|Scorpio|8|false:Mercury|Virgo|6|false"] = 195,
  ["Fortune:Square:Saturn:Fortune|Scorpio|8|false:Saturn|Leo|5|false"] = 196,
  ["Moon:Opposition:Vertex:Moon|Pisces|11|false:Vertex|Virgo|6|false"] = 197,
  ["Venus:Sextile:Vertex:Venus|Scorpio|7|false:Vertex|Virgo|6|false"] = 198,
  ["Neptune:Square:Vertex:Neptune|Sagittarius|8|false:Vertex|Virgo|6|false"] = 199,
  ["Lilith:Trine:Vertex:Lilith|Taurus|1|false:Vertex|Virgo|6|false"] = 200,
  ["MC:Trine:Vertex:Capricorn:Vertex|Virgo|6|false"] = 201,
  ["IC:Sextile:Vertex:Cancer:Vertex|Virgo|6|false"] = 202,
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

local function positions(reviewed)
  local library = {}
  for key, index in pairs(position_library) do library[key] = index end
  for index, position in ipairs(reviewed.positions) do
    local key = position_key(position)
    assert(not library[key], "Posição cadastrada duas vezes: " .. key)
    library[key] = index
  end
  return library
end

local function aspects(reviewed)
  local library = {}
  local locations = editorial_facts(reviewed)
  for index, aspect in ipairs(reviewed.aspects) do
    local key = contextual_aspect_key(aspect, locations)
    library[key] = index
  end
  for key, index in pairs(contextual_aspects) do
    assert(not library[key], "Aspecto cadastrado duas vezes: " .. key)
    library[key] = index
  end
  return library
end

return {
  positions=positions, position_key=position_key,
  axis_pairs=axis_pairs, axes=axis_library,
  facts=editorial_facts, houses=houses, select_house=select_house,
  aspect_key=aspect_key, contextual_aspect_key=contextual_aspect_key, aspects=aspects
}
