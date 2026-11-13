local function position_key(position)
  return table.concat({position.name, position.sign, position.house, tostring(position.retrograde)}, "|")
end

local position_library = {
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

local function editorial_facts(data)
  local positions, occupants, aspects = {}, {}, {}
  for house = 1, 12 do occupants[house] = {} end
  for _, position in ipairs(data.positions) do
    local key = table.concat({position.name, position.sign, position.house, tostring(position.retrograde)}, "|")
    positions[position.name] = key
    local house = occupants[position.house]
    house[#house+1] = key
  end
  for name, cusp in pairs(data.angles) do positions[name] = cusp.sign end
  for _, aspect in ipairs(data.aspects) do
    local first, second = aspect.first, aspect.second
    if second < first then first, second = second, first end
    aspects[table.concat({first, aspect.kind, second}, "|")] = true
  end
  for house = 1, 12 do occupants[house] = table.concat(occupants[house], ";") end
  return positions, occupants, aspects
end

local house_library = {
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

local contextual_aspects = {
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

return {
  positions=positions, position_key=position_key,
  axis_pairs=axis_pairs, axes=axis_library, house_rules=house_rules,
  facts=editorial_facts, houses=house_library, aspect_key=aspect_key,
  contextual_aspects=contextual_aspects
}