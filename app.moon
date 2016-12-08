lapis = require "lapis"

class extends lapis.Application
   @enable "etlua"
   "/zhcn/hero/:hero": =>
    @params.language = "zhcn"
    layout: false, render: "hero"
   "/zhtw/hero/:hero": =>
    @params.language = "zhtw"
    layout: false, render: "hero"
   "/en/hero/:hero": =>
      @params.language = "zhtw"
      layout: false, render: "hero"
   "/*": =>
      layout: false, render: "index"
