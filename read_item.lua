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

equiment = {}

function ProcessText(text)
  for name in rex.gmatch(text, [[\r\n\t"item_(.+)"]], "U", 0) do
    if not string.match(name, "recipe") then
      --print(name)
      equiment[name] = {}
      local content = rex.match(text, [["item_]]..name..[["\r\n\t{.+\r\n\t}]], 0, "Usm") 
        --print(content)
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
        equiment[name] = {}
        equiment[name]["cooldown"] = cooldown
        equiment[name]["mana"] = mana
        equiment[name]["radius"] = radius
        equiment[name]["pic"] = pic
        equiment[name]["range"] = range
        --print(ability, content)
     
    end
  end
end

function read_item()
text = readAll("npc/npc_items_custom_load.txt")
ProcessText(text)

text = readAll("addon_tchinese2.txt")
text = string.gsub(text, [[\"]], [["]])

for name, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_item_(.+)"[ \t]+"(.+)"]], "U", 0) do
  if (equiment[name] ~= nil) then
    if (equiment[name]) == nil then
      equiment[name] = {}
    end
    if (equiment[name]["name"]) == nil then
      equiment[name]["name"] = {}
    end
    
    equiment[name]["name"]["zhtw"] = content
  end
end

for name, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_item_(.+)_Description"[ \t]+"(.+)"]], "", 0) do
  if (equiment[name] ~= nil) then
    if (equiment[name]) == nil then
      equiment[name] = {}
    end
    if (equiment[name]["Description"]) == nil then
      equiment[name]["Description"] = {}
    end
    equiment[name]["Description"]["zhtw"] = content
  end
end

text = readAll("addon_schinese2.txt")
text = string.gsub(text, [[\"]], [["]])

for name, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_item_(.+)"[ \t]+"(.+)"]], "U", 0) do
  if (equiment[name] ~= nil) then
    if (equiment[name]) == nil then
      equiment[name] = {}
    end
    if (equiment[name]["name"]) == nil then
      equiment[name]["name"] = {}
    end
    
    equiment[name]["name"]["zhcn"] = content
  end
end

for name, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_item_(.+)_Description".+"(.+)"]], "", 0) do
  if (equiment[name] ~= nil) then
    if (equiment[name]) == nil then
      equiment[name] = {}
    end
    if (equiment[name]["Description"]) == nil then
      equiment[name]["Description"] = {}
    end
    equiment[name]["Description"]["zhcn"] = content
  end
end

for i, item in pairs(equiment) do
  if item["Description"] == nil then
    equiment[i] = nil
  end
end
text = readAll("shops.txt")
--print(text)

for name, content in rex.gmatch(text, [[\n"(.+)"\n{(.+)\n}]], "Usm", 0) do
  --print(name, content)
  local count = 1
  for item in rex.gmatch(content, [["item"[ \t]+"item_(.+)"]], "U", 0) do
    newequiment[name][count] = equiment[item]
    count = count + 1
  end
end

--print(inspect(newequiment))
return newequiment
end