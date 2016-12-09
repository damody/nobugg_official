lapis = require "lapis"

class extends lapis.Application
  @enable "etlua"
  "/zhcn/list_hero": =>
    @params.language = "zhcn"
    layout: false, render: "list_hero"
  "/zhtw/list_hero": =>
    @params.language = "zhtw"
    layout: false, render: "list_hero"
  "/en/list_hero": =>
    @params.language = "en"
    layout: false, render: "list_hero"
  "/zhcn/hero/:hero": =>
    @params.language = "zhcn"
    layout: false, render: "hero"
  "/zhtw/hero/:hero": =>
    @params.language = "zhtw"
    layout: false, render: "hero"
  "/en/hero/:hero": =>
    @params.language = "en"
    layout: false, render: "hero"
  "/": =>
<<<<<<< HEAD
    layout: false, render: "index"
=======
    @params.language = "zhtw"
    layout: false, render: "list_hero"
  "/hero/:hero": =>
    @params.language = "zhtw"
    layout: false, render: "hero"
>>>>>>> 2bda47e2811af94804e7bd8e9b4bc003cb570842
  "/*": =>
    layout: false, render: "index"
