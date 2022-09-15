local mat4 = {}

local req_pref = (...):match("(.-)[^%.]+$")
local req = require
local function require(path) req(req_pref .. path) end

local vec3 = require("vec3")
local util = require("../util")

local deepcopy = util.deepcopy

mat4.Mat4 = {}

local idtab = {1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1}

local sin = math.sin
local cos = math.cos

local function mat4_mul(a, b)
    local vals = {
        a[1] * b[1] + a[2] * b[5] + a[3] * b[9] + a[4] * b[13],
        a[1] * b[2] + a[2] * b[6] + a[3] * b[10] + a[4] * b[14],
        a[1] * b[3] + a[2] * b[7] + a[3] * b[11] + a[4] * b[15],
        a[1] * b[4] + a[2] * b[8] + a[3] * b[12] + a[4] * b[16],
        a[5] * b[1] + a[6] * b[5] + a[7] * b[9] + a[8] * b[13],
        a[5] * b[2] + a[6] * b[6] + a[7] * b[10] + a[8] * b[14],
        a[5] * b[3] + a[6] * b[7] + a[7] * b[11] + a[8] * b[15],
        a[5] * b[4] + a[6] * b[8] + a[7] * b[12] + a[8] * b[16],
        a[9] * b[1] + a[10] * b[5] + a[11] * b[9] + a[12] * b[13],
        a[9] * b[2] + a[10] * b[6] + a[11] * b[10] + a[12] * b[14],
        a[9] * b[3] + a[10] * b[7] + a[11] * b[11] + a[12] * b[15],
        a[9] * b[4] + a[10] * b[8] + a[11] * b[12] + a[12] * b[16],
        a[13] * b[1] + a[14] * b[5] + a[15] * b[9] + a[16] * b[13],
        a[13] * b[2] + a[14] * b[6] + a[15] * b[10] + a[16] * b[14],
        a[13] * b[3] + a[14] * b[7] + a[15] * b[11] + a[16] * b[15],
        a[13] * b[4] + a[14] * b[8] + a[15] * b[12] + a[16] * b[16]
    }
    return mat4.new(vals)
end

local function mat4_tostring(a)
    local ret =
        string.format("%.3f\t%.3f\t%.3f\t%.3f\n", a[1], a[2], a[3], a[4])
    ret = ret ..
              string.format("%.3f\t%.3f\t%.3f\t%.3f\n", a[5], a[6], a[7], a[8])
    ret = ret ..
              string.format("%.3f\t%.3f\t%.3f\t%.3f\n", a[9], a[10], a[11],
                            a[12])
    ret = ret ..
              string.format("%.3f\t%.3f\t%.3f\t%.3f\n", a[13], a[14], a[15],
                            a[16])
    return ret
end

function mat4.new(vals)
    local mt = {}
    vals = vals or deepcopy(idtab)
    if #vals ~= 16 then vals = deepcopy(idtab) end
    setmetatable(vals, mt)
    mt.__mul = mat4_mul
    mt.__tostring = mat4_tostring
    return vals
end

mat4.id = mat4.new(idtab)

function mat4.scale(sv)
    return mat4.new {sv[1], 0, 0, 0, 0, sv[2], 0, 0, 0, 0, sv[3], 0, 0, 0, 0, 1}
end

function mat4.translate(ds)
    return mat4.new {1, 0, 0, ds[1], 0, 1, 0, ds[2], 0, 0, 1, ds[3], 0, 0, 0, 1}
end

function mat4.rotateXY(theta)
    return mat4.new {
        cos(theta), -sin(theta), 0, 0, sin(theta), cos(theta), 0, 0, 0, 0, 1, 0,
        0, 0, 0, 1
    }
end

function mat4.rotateXZ(theta)
    return mat4.new {
        cos(theta), 0, sin(theta), 0, 0, 1, 0, 0, -sin(theta), 0, cos(theta), 0,
        0, 0, 0, 1
    }
end

function mat4.rotateYZ(theta)
    return mat4.new {
        1, 0, 0, 0, 0, cos(theta), -sin(theta), 0, 0, sin(theta), cos(theta), 0,
        0, 0, 0, 1
    }
end

function mat4.rotate(axis, theta)
    local sin = math.sin(theta)
    local cos = math.cos(theta)

    local na = vec3.normalise(axis)
    -- rodrigues' rotation formula
    return mat4.new {
        cos + na[1] * na[1] * (1 - cos),
        na[1] * na[2] * (1 - cos) - na[3] * sin,
        na[2] * sin + na[1] * na[3] * (1 - cos), 0,

        na[3] * sin + na[1] * na[2] * (1 - cos),
        cos + na[2] * na[2] * (1 - cos),
        -na[1] * sin + na[2] * na[3] * (1 - cos), 0,

        -na[2] * sin + na[1] * na[3] * (1 - cos),
        na[1] * sin + na[2] * na[3] * (1 - cos),
        cos + na[3] * na[3] * (1 - cos), 0, 0, 0, 0, 1
    }
end

return mat4
