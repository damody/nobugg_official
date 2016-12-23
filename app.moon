lapis = require "lapis"

class extends lapis.Application
  @enable "etlua"
  "/zhcn/list_hero": =>
    @params.language = "zhcn"
    @params.webpath = "list_hero"
    layout: false, render: "list_hero2"
  "/zhtw/list_hero": =>
    @params.language = "zhtw"
    @params.webpath = "list_hero"
    layout: false, render: "list_hero2"
  "/en/list_hero": =>
    @params.language = "en"
    @params.webpath = "list_hero"
    layout: false, render: "list_hero2"
  "/jp/list_hero": =>
    @params.language = "jp"
    @params.webpath = "list_hero"
    layout: false, render: "list_hero2"
  "/zhcn/hero/:hero": =>
    @params.language = "zhcn"
    @params.webpath = "hero/"..@params.hero
    layout: false, render: "hero2"
  "/zhtw/hero/:hero": =>
    @params.language = "zhtw"
    @params.webpath = "hero/"..@params.hero
    layout: false, render: "hero2"
  "/en/hero/:hero": =>
    @params.language = "en"
    @params.webpath = "hero/"..@params.hero
    layout: false, render: "hero2"
  "/jp/hero/:hero": =>
    @params.language = "jp"
    @params.webpath = "hero/"..@params.hero
    layout: false, render: "hero2"
  "/": =>
    layout: false, render: "index"
  "/*": =>
    layout: false, render: "index"
  "/zhcn/thanx": =>
    @params.language = "zhcn"
    @params.webpath = "thanx"
    layout: false, render: "thanx"
  "/zhtw/thanx": =>
    @params.language = "zhtw"
    @params.webpath = "thanx"
    layout: false, render: "thanx"
  "/en/thanx": =>
    @params.language = "en"
    @params.webpath = "thanx"
    layout: false, render: "thanx"
  "/jp/thanx": =>
    @params.language = "jp"
    @params.webpath = "thanx"
    layout: false, render: "thanx"