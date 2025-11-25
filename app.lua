local lapis = require("lapis")
local db = require("lapis.db")
local app = lapis.Application()

app:enable("etlua")
app.layout = require "views.layout"

app:get("/", function(self)
    local res = db.query("SELECT * FROM asunnot")
    self.asunnot = res
    return { render = "index" }
end)

return app
