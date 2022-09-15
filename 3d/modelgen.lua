local modelgen = {}
local req_pref = (...):match("(.-)[^%.]+$")
local req = require
local function require(path) req(req_pref .. path) end

local model = require("model")

function modelgen.square(tex)
    local verts = {}
    local v00 = {-1.0, -1.0, 0.0, 0.0, 1.0}
    local v01 = {1.0, -1.0, 0.0, 1.0, 1.0}
    local v10 = {-1.0, 1.0, 0.0, 0.0, 0.0}
    local v11 = {1.0, 1.0, 0.0, 1.0, 0.0}

    table.insert(verts, v00)
    table.insert(verts, v01)
    table.insert(verts, v10)
    table.insert(verts, v01)
    table.insert(verts, v10)
    table.insert(verts, v11)

    return model.Model:new{vertices = verts, texture = tex}
end

return modelgen
