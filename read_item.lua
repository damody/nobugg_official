local rex = require("rex_pcre")
local lfs = require("lfs")
local inspect = require("inspect")
require("langtext")

local function readAll(file)
    local f = io.open(file, "rb")
    local content = f:read("*all")
    f:close()
    return content
end

local equiment = {}

local function ProcessText(text)
  for name in rex.gmatch(text, [[\r\n\t"item_(.+)"]], "U", 0) do
    if not string.match(name, "recipe") then
      --print(name)
      equiment[name] = {}
      local content = rex.match(text, [["item_]]..name..[["\r\n\t{.+\r\n\t}]], 0, "Usm") 
        --print(content)
        local cooldown = rex.match(content, [["AbilityCooldown".+"(.+)"]], 0, "U")
        local mana = rex.match(content, [["AbilityManaCost".+"(.+)"]], 0, "U")
        local _,radius = rex.match(content, [["A(O|o)ERadius".+"(.+)"]], 0, "U")
        local pic = rex.match(content, [["AbilityTextureName".+"item_(.+)"]], 0, "U")
        local range = rex.match(content, [["AbilityCastRange".+"(.+)"]], 0, "U")
        local cost = rex.match(content, [["ItemCost".+"(.+)"]], 0, "U")
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
        equiment[name]["cost"] = cost
        --print(ability, content)
     
    end
  end
end

function read_item()
local text = readAll("npc/npc_items_custom_load.txt")
ProcessText(text)

local text = readAll("addon_tchinese2.txt")
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

local text = readAll("addon_schinese2.txt")
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

for name, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_item_(.+)_Description"[ \t]+"(.+)"]], "", 0) do
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

local text = readAll("addon_japanese2.txt")
text = string.gsub(text, [[\"]], [["]])

for name, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_item_(.+)"[ \t]+"(.+)"]], "U", 0) do
  if (equiment[name] ~= nil) then
    if (equiment[name]) == nil then
      equiment[name] = {}
    end
    if (equiment[name]["name"]) == nil then
      equiment[name]["name"] = {}
    end
    
    equiment[name]["name"]["jp"] = content
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
    equiment[name]["Description"]["jp"] = content
  end
end


local text = readAll("addon_english2.txt")
text = string.gsub(text, [[\"]], [["]])

for name, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_item_(.+)"[ \t]+"(.+)"]], "U", 0) do
  if (equiment[name] ~= nil) then
    if (equiment[name]) == nil then
      equiment[name] = {}
    end
    if (equiment[name]["name"]) == nil then
      equiment[name]["name"] = {}
    end
    
    equiment[name]["name"]["en"] = content
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
    equiment[name]["Description"]["en"] = content
  end
end

for i, item in pairs(equiment) do
  if item["Description"] == nil then
    --equiment[i] = nil
    --print(inspect(item))
  end
end

local newequiment = {}

-- 添加商店名稱翻譯
local shop_names = {
  ["consumables"] = {
    ["zhtw"] = "消耗品",
    ["zhcn"] = "消耗品", 
    ["en"] = "Consumables",
    ["jp"] = "消耗品"
  },
  ["attributes"] = {
    ["zhtw"] = "武器",
    ["zhcn"] = "武器",
    ["en"] = "Weapon", 
    ["jp"] = "武器"
  },
  ["weapons_armor"] = {
    ["zhtw"] = "基礎物品",
    ["zhcn"] = "基礎物品",
    ["en"] = "Basic",
    ["jp"] = "基礎アイテム"
  },
  ["misc"] = {
    ["zhtw"] = "法術書籍", 
    ["zhcn"] = "法術書籍",
    ["en"] = "Magic Book",
    ["jp"] = "法術書籍"
  },
  ["basics"] = {
    ["zhtw"] = "高階武器",
    ["zhcn"] = "高階武器", 
    ["en"] = "Enchantment Weapon",
    ["jp"] = "高階武器"
  },
  ["support"] = {
    ["zhtw"] = "高階道具",
    ["zhcn"] = "高階道具",
    ["en"] = "Enchantment Item", 
    ["jp"] = "高級アイテム"
  },
  ["magics"] = {
    ["zhtw"] = "高階法書",
    ["zhcn"] = "高階法書",
    ["en"] = "High Magic Book",
    ["jp"] = "高階法書"
  },
  ["defense"] = {
    ["zhtw"] = "高階防具", 
    ["zhcn"] = "高階防具",
    ["en"] = "High Defense",
    ["jp"] = "高階防具"
  },
  ["weapons"] = {
    ["zhtw"] = "高階武器",
    ["zhcn"] = "高階武器",
    ["en"] = "High Weapons", 
    ["jp"] = "高階武器"
  },
  ["artifacts"] = {
    ["zhtw"] = "升級類裝備",
    ["zhcn"] = "升級類裝備",
    ["en"] = "Upgrade Equipment",
    ["jp"] = "アップグレード装備"
  },
  ["sideshop1"] = {
    ["zhtw"] = "路邊商店",
    ["zhcn"] = "路邊商店", 
    ["en"] = "Side Shop",
    ["jp"] = "路邊商店"
  },
  ["secretshop"] = {
    ["zhtw"] = "名刀舖",
    ["zhcn"] = "名刀舖",
    ["en"] = "Secret Shop",
    ["jp"] = "名刀舖"
  }
}

local text = readAll("shops.txt")
--print(text)

for name, content in rex.gmatch(text, [["([^"]+)"\s*\{([^}]+)\}]], "Usm", 0) do
  if name ~= "pregame" then
      newequiment[name] = {}
      newequiment[name]["name"] = shop_names[name] or {}
      local count = 1
      for item in rex.gmatch(content, [["item"[ \t]+"item_(.+)"]], "U", 0) do
        newequiment[name][count] = equiment[item]
        count = count + 1
      end
  end
end
--print(inspect(newequiment, {depth = 2}))
return newequiment
end