local rex = require("rex_pcre")
local lfs = require("lfs")
local inspect = require("inspect")
require("langtext")

function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

hero = {}


function ProcessText(file, text)
  if not string.match(file, "_2.txt") and #file > 4 then
    local name = rex.match(file, "[ABC][0-9][0-9]")
    --print(name)
    hero[name] = {}
    hero[name]["name"] = {}
    hero[name]["name"]["zhtw"] = zhtw_heroname[name]
    hero[name]["name"]["zhcn"] = zhcn_heroname[name]
    hero[name]["name"]["en"] = en_heroname[name]
    hero[name]["name"]["jp"] = jp_heroname[name]
    if video[name] == nil then
      video[name] = {}
    end
    if video[name]["16"] == nil then
      video[name]["16"] = {}
    end
    if video[name]["11"] == nil then
      video[name]["11"] = {}
    end
    for ability, _, _, _, content in rex.gmatch(text, [["([ABC][0-9][0-9](W|E|R|T|D|F)(_old|))"(\r|)\n\t{(.+)}]], "Usm", 0) do
      local cooldown = rex.match(content, [["AbilityCooldown".+"(.+)"]], 0, "U")
      local mana = rex.match(content, [["AbilityManaCost".+"(.+)"]], 0, "U")
      local radius = rex.match(content, [["AOERadius".+"(.+)"]], 0, "U")
      local pic = rex.match(content, [["AbilityTextureName".+"(.+)"]], 0, "U")
      local range = rex.match(content, [["AbilityCastRange".+"(.+)"]], 0, "U")
      if radius~=nil and string.match(radius, "%%") then
        radius = string.gsub(radius, "%%", "")
        radius = rex.match(content, [["]]..radius..[[".+"(.+)"]], 0, "U")
      end
      if cooldown ~= nil then
        cooldown = string.gsub(cooldown, " ", "/")
      end
      if mana ~= nil then
        mana = string.gsub(mana, " ", "/")
      end
      if radius ~= nil then
        radius = string.gsub(radius, " ", "/")
      end
      if range ~= nil then
        range = string.gsub(range, " ", "/")
      end
      hero[name][ability] = {}
      hero[name][ability]["cooldown"] = cooldown
      hero[name][ability]["mana"] = mana
      hero[name][ability]["radius"] = radius
      hero[name][ability]["pic"] = pic
      hero[name][ability]["range"] = range
      --print(ability, content)
    end
  end
end

function read_hero()
for file in lfs.dir("npc/A_Oda") do
  text = readAll("npc/A_Oda/"..file)
  ProcessText(file, text)
end

for file in lfs.dir("npc/B_Unified") do
	text = readAll("npc/B_Unified/"..file)
  ProcessText(file, text)
end

for file in lfs.dir("npc/C_Neutral") do
	text = readAll("npc/C_Neutral/"..file)
  ProcessText(file, text)
end

text = readAll("addon_tchinese2.txt")
text = string.gsub(text, [[\"]], [["]])

for ability, name, _, old, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D|F)(_old|))".+"(.+)"]], "U", 0) do
  if (hero[name] ~= nil) then
    if (hero[name][ability]) == nil then
      hero[name][ability] = {}
    end
    if (hero[name][ability]["name"]) == nil then
      hero[name][ability]["name"] = {}
    end
    
    hero[name][ability]["name"]["zhtw"] = content
  end
end

for ability, name, _, _, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D|F)(_old|))_Description"[ \t]+"(.+)"]], "", 0) do
  if (hero[name] ~= nil) then
    if (hero[name][ability]) == nil then
      hero[name][ability] = {}
    end
    if (hero[name][ability]["Description"]) == nil then
      hero[name][ability]["Description"] = {}
    end
    hero[name][ability]["Description"]["zhtw"] = content
  end
end

text = readAll("addon_schinese2.txt")
text = string.gsub(text, [[\"]], [["]])
for ability, name, _, old, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D|F)(_old|))".+"(.+)"]], "U", 0) do
  if (hero[name] ~= nil) then
    if (hero[name][ability]) == nil then
      hero[name][ability] = {}
    end
    if (hero[name][ability]["name"]) == nil then
      hero[name][ability]["name"] = {}
    end
    hero[name][ability]["name"]["zhcn"] = content
  end
end
for ability, name, _, old, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D|F)(_old|))_Description"[ \t]+"(.+)"]], "", 0) do
  if (hero[name] ~= nil) then
    if (hero[name][ability]) == nil then
      hero[name][ability] = {}
    end
    if (hero[name][ability]["Description"]) == nil then
      hero[name][ability]["Description"] = {}
    end
    hero[name][ability]["Description"]["zhcn"] = content
  end
end

text = readAll("addon_japanese2.txt")
text = string.gsub(text, [[\"]], [["]])
for ability, name, _, old, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D|F)(_old|))".+"(.+)"]], "U", 0) do
  if (hero[name] ~= nil) then
    if (hero[name][ability]) == nil then
      hero[name][ability] = {}
    end
    if (hero[name][ability]["name"]) == nil then
      hero[name][ability]["name"] = {}
    end
    hero[name][ability]["name"]["jp"] = content
  end
end
for ability, name, _, old, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D|F)(_old|))_Description"[ \t]+"(.+)"]], "", 0) do
  if (hero[name] ~= nil) then
    if (hero[name][ability]) == nil then
      hero[name][ability] = {}
    end
    if (hero[name][ability]["Description"]) == nil then
      hero[name][ability]["Description"] = {}
    end
    hero[name][ability]["Description"]["jp"] = content
  end
end

text = readAll("addon_english2.txt")
text = string.gsub(text, [[\"]], [["]])
for ability, name, _, old, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D|F)(_old|))".+"(.+)"]], "U", 0) do
  if (hero[name] ~= nil) then
    if (hero[name][ability]) == nil then
      hero[name][ability] = {}
    end
    if (hero[name][ability]["name"]) == nil then
      hero[name][ability]["name"] = {}
    end
    hero[name][ability]["name"]["en"] = content
  end
end
for ability, name, _, old, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D|F)(_old|))_Description"[ \t]+"(.+)"]], "", 0) do
  if (hero[name] ~= nil) then
    if (hero[name][ability]) == nil then
      hero[name][ability] = {}
    end
    if (hero[name][ability]["Description"]) == nil then
      hero[name][ability]["Description"] = {}
    end
    hero[name][ability]["Description"]["en"] = content
  end
end
--print(inspect(hero))
return hero
end
