local rex = require("rex_pcre")
local lfs = require("lfs")
local inspect = require("inspect")

en_heroname = {
A04 = "Takenaka Shigeharu",
A06 = "Ii Naomasa",
A07 = "Honda Tadakatsu",
A12 = "Otani Yoshitsugu",
A13 = "Hattori Hanzo",
A16 = "Torii Mototada",
A17 = "Sassa Narimasa",
A25 = "Oda Nobunaga",
A27 = "Shibata Katsuie",
A28 = "Hashiba Hideyoshi",
A29 = "Ishida Mitsunari",
A31 = "Mori Ranmaru",
A34 = "Omatsu",
B01 = "Saika Magoichi",
B02 = "Fuma Kotaro",
B05 = "Mori Motonari",
B06 = "Sanada Yukimura",
B08 = "Azai Nagamasa",
B15 = "Imagawa Yoshimoto",
B24 = "Akiyama Nobutomo",
B25 = "honganji Kennyo",
B26 = "Okuma Tomohide",
B32 = "Uesugi Kenshin",
B33 = "Mogami Yoshihime",
B34 = "Takeda Katsuyori",
C01 = "Akechi Mitsuhide",
C07 = "Tachibana Dosetsu",
C10 = "Kosokabe Chikayasu",
C15 = "Tamako",
C17 = "Oichi",
C19 = "matsuhime",
C21 = "Miyamoto Musashi",
C22 = "Sasaki Kojiro",
}

zhcn_heroname = {
A04 = "竹中重治",
A06 = "井伊直政",
A07 = "本多忠胜",
A12 = "大谷吉继",
A13 = "服部半藏",
A16 = "鸟居元忠",
A17 = "佐佐成政",
A25 = "织田信长",
A27 = "柴田胜家",
A28 = "羽柴秀吉",
A29 = "石田三成",
A31 = "森兰丸",
A34 = "阿松",
B01 = "杂贺孙市",
B02 = "风魔小太郎",
B05 = "毛利元就",
B06 = "真田幸村",
B08 = "浅井长政",
B15 = "今川义元",
B24 = "秋山信友",
B25 = "本愿寺显如",
B26 = "大熊朝秀",
B32 = "上杉谦信",
B33 = "最上义姬",
B34 = "武田胜赖",
C01 = "明智光秀",
C07 = "立花道雪",
C10 = "香宗我部亲泰",
C15 = "玉子",
C17 = "阿市",
C19 = "松姬",
C21 = "宫本武藏",
C22 = "佐佐木小次郎",
}

zhtw_heroname = {
A04 = "竹中重治",
A06 = "井伊直政",
A07 = "本多忠勝",
A12 = "大谷吉繼",
A13 = "服部半藏",
A16 = "鳥居元忠",
A17 = "佐佐成政",
A25 = "織田信長",
A27 = "柴田勝家",
A28 = "羽柴秀吉",
A29 = "石田三成",
A31 = "森蘭丸",
A34 = "阿松",
B01 = "雜賀孫市",
B02 = "風魔小太郎",
B05 = "毛利元就",
B06 = "真田幸村",
B08 = "淺井長政",
B15 = "今川義元",
B24 = "秋山信友",
B25 = "本願寺顯如",
B26 = "大熊朝秀",
B32 = "上杉謙信",
B33 = "最上義姬",
B34 = "武田勝賴",
C01 = "明智光秀",
C07 = "立花道雪",
C10 = "香宗我部親泰",
C15 = "玉子",
C17 = "阿市",
C19 = "松姬",
C21 = "宮本武藏",
C22 = "佐佐木小次郎",
}

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
    for ability, _, _, content in rex.gmatch(text, [["([ABC][0-9][0-9](W|E|R|T|D)(_old|))"...{(.+)}]], "Usm", 0) do
      --print(ability, content)
      local cooldown = rex.match(content, [["AbilityCooldown".+"(.+)"]], 0, "U")
      local mana = rex.match(content, [["AbilityManaCost".+"(.+)"]], 0, "U")
      local radius = rex.match(content, [["AOERadius".+"(.+)"]], 0, "U")
      local pic = rex.match(content, [["AbilityTextureName".+"(.+)"]], 0, "U")
      if radius~=nil and string.match(radius, "%%") then
        radius = string.gsub(radius, "%%", "")
        radius = rex.match(content, [["]]..radius..[[".+"(.+)"]], 0, "U")
      end
      
      hero[name][ability] = {}
      hero[name][ability]["cooldown"] = cooldown
      hero[name][ability]["mana"] = mana
      hero[name][ability]["radius"] = radius
      hero[name][ability]["pic"] = pic
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

for ability, name, _, old, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D)(_old|))".+"(.+)"]], "U", 0) do
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
for ability, name, _, _, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D)(_old|))_Description"[ \t]+"(.+)"]], "", 0) do
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

for ability, name, _, old, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D)(_old|))".+"(.+)"]], "U", 0) do
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
for ability, name, _, old, content in rex.gmatch(text, [["DOTA_Tooltip_Ability_(([ABC][0-9][0-9])(W|E|R|T|D)(_old|))_Description"[ \t]+"(.+)"]], "", 0) do
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
--print(inspect(hero))
return hero
end
