local lapis = require("lapis")
local bcrypt = require("bcrypt")
local db = require("lapis.db")
local app = lapis.Application()
local respond_to = require("lapis.application").respond_to

app:enable("etlua")
app.layout = require "views.layout"

-- removes leading and trailing spaces
local function strip(str)
   return str:match( "^%s*(.-)%s*$" )
end

-- checks if str is number (not float)
local function isNumber(str)
    if not str:match("^%-?%d+$") then
	return false
    else
	return true
    end
end

-- opens and checks if file exists
local function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- returns a table with lines in file
local function lines_from(file)
  if not file_exists(file) then return {} end
  local lines = {}
  for line in io.lines(file) do
    lines[#lines + 1] = line
  end
  return lines
end


local function readTeamDesc()
    local lines = lines_from("team-description.txt")
    if lines then
	return lines[1]
    end
    return nil
end

app:get("index", "/", function(self)
    local res = db.query("SELECT * FROM asunnot")
    self.asunnot = res
    self.team_desc = readTeamDesc()
    return { render = true }
end)

app:post("edit-description", "/edit-description", function(self)
    if not self.session.user then
	return { redirect_to = "/" }
    end

    local new_desc = strip(self.params.description)
    if not file_exists("team-description.txt") then return {} end
    local f = io.open("team-description.txt", "w")

    if f == nil then
	return { redirect_to = "/" }
    end

    f:write(new_desc)
    f:close()
    return { redirect_to = "/" }
end)

app:match("kirjaudu", "/kirjaudu", respond_to({
  GET = function(self)
    self.err = self.params.error
    return { render = true }
  end,

  POST = function(self)
    local name = strip(self.params.name)
    local password = strip(self.params.password)

    if name == "" or password == "" then
	return { redirect_to = "/kirjaudu"}
    end

    local user = db.query("SELECT * FROM kayttajat WHERE nimi = ?", name)[1]
    if not user then
	return { redirect_to = self:url_for("kirjaudu", {}, { error = "Käyttäjää ei löytynyt " }) }
    end

    local ok, _ = pcall(function()
	assert(bcrypt.verify(password, user["salasana_hash"]))
    end)

    if user["nimi"] == name and ok then
	self.session.user = {}
	self.session.user.id = user["id"]
	self.session.user.name = user["nimi"]
    else
	return { redirect_to = self:url_for("kirjaudu", {}, { error = "Väärä salasana" }) }
    end

    return { redirect_to = "/hallintapaneeli" }
  end
}))

app:match("kirjaudu-ulos", "/kirjaudu-ulos", function(self)
    self.session.user = nil
    return { redirect_to = "/"}
end)

app:match("hallintapaneeli", "/hallintapaneeli", respond_to({
  before = function(self)
    if not self.session.user then
      self:write({ redirect_to = "/kirjaudu" })
    end
  end,

  GET = function()
    return { render = true }
  end,
  -- luo asunto entry ja muokkaa sivua
  POST = function(self)
    local address = strip(self.params.address)
    local picture_file = self.params.file
    local price = strip(self.params.price)

    local picture = ""
    -- write img binary to file, risky and not validation :D. all params are TRUSTED
    -- path traversal attacks possible
    -- https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Headers/Content-Disposition#Directives
    local out = io.open("./static/images/" .. picture_file.filename, "wb")
    if out == nil then
	return { redirect_to = "/" }
    end
    -- nginx limits the img size to 1mb by defaykt

    local data = picture_file.content
    data = string.gsub(data, "\r\n", "\n") -- for unix
    out:write(data)
    out:close()

    picture = "http://localhost:8080/static/images/" .. picture_file.filename

    if address == "" or picture == "" or price == "" then
	return { redirect_to = "/hallintapaneeli"}
    end

    if not isNumber(price) then
	return { redirect_to = "/hallintapaneeli"}
    end

    db.query("INSERT INTO asunnot (osoite, kuva, hinta) VALUES (?, ?, ?)", address, picture, price)
    return { redirect_to = "/" }
  end
}))


return app

