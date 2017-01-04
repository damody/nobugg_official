local lapis = require("lapis")
do
  local _class_0
  local _parent_0 = lapis.Application
  local _base_0 = {
    ["/zhcn/list_hero"] = function(self)
      self.params.language = "zhcn"
      self.params.webpath = "list_hero"
      return {
        layout = false,
        render = "list_hero2"
      }
    end,
    ["/zhtw/list_hero"] = function(self)
      self.params.language = "zhtw"
      self.params.webpath = "list_hero"
      return {
        layout = false,
        render = "list_hero2"
      }
    end,
    ["/en/list_hero"] = function(self)
      self.params.language = "en"
      self.params.webpath = "list_hero"
      return {
        layout = false,
        render = "list_hero2"
      }
    end,
    ["/jp/list_hero"] = function(self)
      self.params.language = "jp"
      self.params.webpath = "list_hero"
      return {
        layout = false,
        render = "list_hero2"
      }
    end,
    ["/zhcn/hero/:hero"] = function(self)
      self.params.language = "zhcn"
      self.params.webpath = "hero/" .. self.params.hero
      return {
        layout = false,
        render = "hero2"
      }
    end,
    ["/zhtw/hero/:hero"] = function(self)
      self.params.language = "zhtw"
      self.params.webpath = "hero/" .. self.params.hero
      return {
        layout = false,
        render = "hero2"
      }
    end,
    ["/en/hero/:hero"] = function(self)
      self.params.language = "en"
      self.params.webpath = "hero/" .. self.params.hero
      return {
        layout = false,
        render = "hero2"
      }
    end,
    ["/jp/hero/:hero"] = function(self)
      self.params.language = "jp"
      self.params.webpath = "hero/" .. self.params.hero
      return {
        layout = false,
        render = "hero2"
      }
    end,
    ["/"] = function(self)
      return {
        layout = false,
        render = "index"
      }
    end,
    ["/*"] = function(self)
      return {
        layout = false,
        render = "index"
      }
    end,
    ["/zhcn/thanx"] = function(self)
      self.params.language = "zhcn"
      self.params.webpath = "thanx"
      return {
        layout = false,
        render = "thanx"
      }
    end,
    ["/zhtw/thanx"] = function(self)
      self.params.language = "zhtw"
      self.params.webpath = "thanx"
      return {
        layout = false,
        render = "thanx"
      }
    end,
    ["/en/thanx"] = function(self)
      self.params.language = "en"
      self.params.webpath = "thanx"
      return {
        layout = false,
        render = "thanx"
      }
    end,
    ["/jp/thanx"] = function(self)
      self.params.language = "jp"
      self.params.webpath = "thanx"
      return {
        layout = false,
        render = "thanx"
      }
    end,
    ["/zhcn/equipment"] = function(self)
      self.params.language = "zhcn"
      self.params.webpath = "equipment"
      return {
        layout = false,
        render = "equipment"
      }
    end,
    ["/zhtw/equipment"] = function(self)
      self.params.language = "zhtw"
      self.params.webpath = "equipment"
      return {
        layout = false,
        render = "equipment"
      }
    end,
    ["/en/equipment"] = function(self)
      self.params.language = "en"
      self.params.webpath = "equipment"
      return {
        layout = false,
        render = "equipment"
      }
    end,
    ["/jp/equipment"] = function(self)
      self.params.language = "jp"
      self.params.webpath = "equipment"
      return {
        layout = false,
        render = "equipment"
      }
    end
  }
  _base_0.__index = _base_0
  setmetatable(_base_0, _parent_0.__base)
  _class_0 = setmetatable({
    __init = function(self, ...)
      return _class_0.__parent.__init(self, ...)
    end,
    __base = _base_0,
    __name = nil,
    __parent = _parent_0
  }, {
    __index = function(cls, name)
      local val = rawget(_base_0, name)
      if val == nil then
        local parent = rawget(cls, "__parent")
        if parent then
          return parent[name]
        end
      else
        return val
      end
    end,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  local self = _class_0
  self:enable("etlua")
  if _parent_0.__inherited then
    _parent_0.__inherited(_parent_0, _class_0)
  end
  return _class_0
end
