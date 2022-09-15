local model = {}
local req_pref = (...):match("(.-)[^%.]+$")
local req = require
local function require(path) req(req_pref .. path) end

local vec3 = require("../math/vec3")
local mat4 = require("../math/mat4")

local util = require("../util")

local vertexFormat = {
    {"VertexPosition", "float", 3}, {"VertexTexCoord", "float", 2},
    {"VertexColor", "byte", 4}
}

model.Model = {
    vertices = nil,
    texture = nil,
    scale = vec3.new {1, 1, 1}, -- x, y, z scale factors
    rotAxis = util.deepcopy(vec3.xAxis),
    rotAngle = 0,
    position = vec3.new {0, 0, 0}, -- x, y, z coords in world
    modelMatrix = nil,
    mesh = nil,

    update = function(self, dt)
        -- do nothing
    end
}

function model.Model:new(arg)
    arg = arg or {}
    setmetatable(arg, self)
    self.__index = self

    if arg.vertices then
        arg.mesh = love.graphics
                       .newMesh(vertexFormat, arg.vertices, "triangles")
        if arg.texture then arg.mesh:setTexture(arg.texture) end
    end

    arg:update_matrix()
    return arg
end

function model.Model:clone() return util.deepcopy(self) end

function model.Model:draw(shader)
    if self.mesh then
        shader:send("mat_model", self.modelMatrix)
        love.graphics.draw(self.mesh)
    end
end

-- call me whenever the texture or vertices are changed!
function model.Model:update_mesh()
    self.mesh = love.graphics.newMesh(vertexFormat, self.vertices, "triangles")
    self.mesh:setTexture(self.texture)
end

function model.Model:update_matrix()
    local scaleMatrix = mat4.scale(self.scale)
    local rotMatrix = mat4.rotate(self.rotAxis, self.rotAngle)
    local transMatrix = mat4.translate(self.position)
    self.modelMatrix = transMatrix * scaleMatrix * rotMatrix
end

return model
