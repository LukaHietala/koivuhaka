local config = require("lapis.config")

config("development", {
  server = "nginx",
  code_cache = "off",
  num_workers = "1",
  session_name = "auth",
  secret = "pomerianille-talvitossut",
  sqlite = {
    database = "koivuhaka.sqlite",
  }
})
