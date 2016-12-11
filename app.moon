lapis = require "lapis"

class extends lapis.Application
  @enable "etlua"
  "/zhcn/list_hero": =>
    @params.language = "zhcn"
    layout: false, render: "list_hero2"
  "/zhtw/list_hero": =>
    @params.language = "zhtw"
    layout: false, render: "list_hero2"
  "/en/list_hero": =>
    @params.language = "en"
    layout: false, render: "list_hero2"
  "/jp/list_hero": =>
    @params.language = "jp"
    layout: false, render: "list_hero2"
  "/zhcn/hero/:hero": =>
    @params.language = "zhcn"
    layout: false, render: "hero2"
  "/zhtw/hero/:hero": =>
    @params.language = "zhtw"
    layout: false, render: "hero2"
  "/en/hero/:hero": =>
    @params.language = "en"
    layout: false, render: "hero2"
  "/jp/hero/:hero": =>
    @params.language = "jp"
    layout: false, render: "hero2"
  "/": =>
    layout: false, render: "index"
  "/*": =>
    layout: false, render: "index"
