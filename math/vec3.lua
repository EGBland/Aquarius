local vec3 = {}

function vec3.dot(a, b) return a[1] * b[1] + a[2] * b[2] + a[3] * b[3] end

function vec3.cross(a, b)
    return vec3.new {
        a[2] * b[3] - a[3] * b[2], a[3] * b[1] - a[1] * b[3],
        a[1] * b[2] - a[2] * b[1]
    }
end

function vec3.scalar_mult(t, a) return vec3.new {t * a[1], t * a[2], t * a[3]} end

function vec3.mag(a) return math.sqrt(a[1] * a[1] + a[2] * a[2] + a[3] * a[3]) end

function vec3.normalise(a)
    local mag = vec3.mag(a)
    return vec3.new {a[1] / mag, a[2] / mag, a[3] / mag}
end

function vec3.mat4_apply(a, mat)
    return vec3.new {
        mat[1] * a[1] + mat[2] * a[2] + mat[3] * a[3] + mat[4],
        mat[5] * a[1] + mat[6] * a[2] + mat[7] * a[3] + mat[8],
        mat[9] * a[1] + mat[10] * a[2] + mat[11] * a[3] + mat[12]
    }
end

local function vec3_add(a, b)
    return vec3.new {a[1] + b[1], a[2] + b[2], a[3] + b[3]}
end

local function vec3_uminus(a) return vec3.new {-a[1], -a[2], -a[3]} end

local function vec3_tostring(a)
    return "(" .. a[1] .. " " .. a[2] .. " " .. a[3] .. ")"
end

local function vec3_minus(a, b)
    return vec3.new {a[1] - b[1], a[2] - b[2], a[3] - b[3]}
end

local function vec3_eq(a, b)
    return a[1] == b[1] and a[2] == b[2] and a[3] == b[3]
end

function vec3.new(vals)
    local mt = {}
    vals = vals or {0, 0, 0}
    if #vals ~= 3 then vals = {0, 0, 0} end
    setmetatable(vals, mt)
    mt.__add = vec3_add
    mt.__mul = vec3.cross
    mt.__unm = vec3_uminus
    mt.__tostring = vec3_tostring
    mt.__sub = vec3_minus
    mt.__eq = vec3_eq
    return vals
end

vec3.xAxis = vec3.new {1, 0, 0}
vec3.yAxis = vec3.new {0, 1, 0}
vec3.zAxis = vec3.new {0, 0, 1}

return vec3
