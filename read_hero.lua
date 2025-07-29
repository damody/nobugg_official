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

-- 函數：為 _old 技能回填缺失的語言文本
local function fill_old_skill_text(lang_code, version_suffix)
  version_suffix = version_suffix or " (11版)"
  
  for heroname, herodata in pairs(hero) do
    for skillname, skilldata in pairs(herodata) do
      if string.match(skillname, "_old$") and skilldata then
        local base_skill = string.gsub(skillname, "_old$", "")
        if herodata[base_skill] then
          -- 回填技能名稱
          if (not skilldata["name"] or not skilldata["name"][lang_code]) and 
             herodata[base_skill]["name"] and herodata[base_skill]["name"][lang_code] then
            if not skilldata["name"] then skilldata["name"] = {} end
            skilldata["name"][lang_code] = herodata[base_skill]["name"][lang_code] .. version_suffix
          end
          -- 回填技能描述
          if (not skilldata["Description"] or not skilldata["Description"][lang_code]) and 
             herodata[base_skill]["Description"] and herodata[base_skill]["Description"][lang_code] then
            if not skilldata["Description"] then skilldata["Description"] = {} end
            skilldata["Description"][lang_code] = herodata[base_skill]["Description"][lang_code] .. version_suffix
          end
        end
      end
    end
  end
end

function ProcessText(file, text)
  if not string.match(file, "_2.txt") and #file > 4 then
    local name = rex.match(file, "[ABC][0-9][0-9]")
    if name == nil then
      return 
    end
    print(name)
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
  local success, text = pcall(readAll, "npc/A_Oda/"..file)
  if success and text then
    ProcessText(file, text)
  end
end

for file in lfs.dir("npc/B_Unified") do
  local success, text = pcall(readAll, "npc/B_Unified/"..file)
  if success and text then
    ProcessText(file, text)
  end
end

for file in lfs.dir("npc/C_Neutral") do
  local success, text = pcall(readAll, "npc/C_Neutral/"..file)
  if success and text then
    ProcessText(file, text)
  end
end

local success, text = pcall(readAll, "addon_tchinese2.txt")
if success and text then
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

-- 為繁體中文回填缺失的 _old 技能文本
fill_old_skill_text("zhtw")

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

end

local success, text = pcall(readAll, "addon_schinese2.txt")
if success and text then
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

-- 為簡體中文回填缺失的 _old 技能文本
fill_old_skill_text("zhcn", " (11版)")
end

local success, text = pcall(readAll, "addon_japanese2.txt")
if success and text then
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

-- 為日語回填缺失的 _old 技能文本
fill_old_skill_text("jp", " (11版)")
end

local success, text = pcall(readAll, "addon_english2.txt")
if success and text then
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

-- 為英語回填缺失的 _old 技能文本
fill_old_skill_text("en", " (Ver.11)")
end
--print(inspect(hero))
return hero
end
