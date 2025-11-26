local lapis = require("lapis")
local db = require("lapis.db")
local app = lapis.Application()

app:enable("etlua")
app.layout = require "views.layout"

-- Source - https://stackoverflow.com/a
-- Posted by hookenz, modified by community. See post 'Timeline' for change history
-- Retrieved 2025-11-26, License - CC BY-SA 4.0

local function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end


app:get("/", function(self)
    local res = db.query("SELECT * FROM asunnot")
    self.dump = dump(res)
    self.asunnot = res
    return { render = "index" }
end)

return app
