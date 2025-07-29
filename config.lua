local config = require("lapis.config")

config("development", {
  port = 82,
  num_workers = 1,
  code_cache = "off",
  server = "nginx"
})

config("production", {
  port = 82,
  num_workers = 4,
  code_cache = "on",
  server = "nginx"
})