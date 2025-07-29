local redis = require 'redis'
local client = redis.connect('127.0.0.1', 6379)
local http = require("socket.http")
local inspect = require("inspect")
require("langtext")

for key,name in pairs(zhtw_heroname) do
  key = string.lower(key)
  print(key.."_16")
  local respbody = {}
  local result, respcode, respheaders, respstatus =  http.request{
    url = "http://127.0.0.1:82/get_winning?hero="..key.."_16",
    sink = ltn12.sink.table(respbody),
  }
  if respbody[1] and respbody[1] ~= "" then
    local ss = string.gsub(respbody[1], "&quot;", "\"")
    client:set(key.."_16", ss)
    print(inspect(ss))
  else
    print("No data for " .. key .. "_16")
  end
  print(key.."_11")
  local respbody = {}
  local result, respcode, respheaders, respstatus =  http.request{
    url = "http://127.0.0.1:82/get_winning?hero="..key.."_11",
    sink = ltn12.sink.table(respbody),
  }
  if respbody[1] and respbody[1] ~= "" then
    local ss = string.gsub(respbody[1], "&quot;", "\"")
    client:set(key.."_11", ss)
    print(ss)
  else
    print("No data for " .. key .. "_11")
  end
end
