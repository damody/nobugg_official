local redis = require 'redis'
local client = redis.connect('127.0.0.1', 6379)
local http = require("socket.http")
local inspect = require("inspect")

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

for key,name in pairs(zhtw_heroname) do
  key = string.lower(key)
  print(key.."_16")
  local respbody = {}
  local result, respcode, respheaders, respstatus =  http.request{
    url = "http://140.114.235.19/get_winning?hero="..key.."_16",
    sink = ltn12.sink.table(respbody),
  }
  local ss = string.gsub(respbody[1], "&quot;", "\"")
  client:set(key.."_16", ss)
  print(inspect(ss))
  print(key.."_11")
  local respbody = {}
  local result, respcode, respheaders, respstatus =  http.request{
    url = "http://140.114.235.19/get_winning?hero="..key.."_11",
    sink = ltn12.sink.table(respbody),
  }
  local ss = string.gsub(respbody[1], "&quot;", "\"")
  client:set(key.."_11", ss)
  print(ss)
end
