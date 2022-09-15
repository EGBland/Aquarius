local tween = {}

local function clamp(xmin, xmax, x) -- for carers
    if x < xmin then return xmin end
    if x > xmax then return xmax end
    return x
end

-- tweening functions
tween.funcs = {}

-- linear
function tween.funcs.linear(x0, x1, t0, t1, t)
    return (t - t0) * (x1 - x0) / (t0 - t1) + x0
end

-- quarter sine
function tween.funcs.q_sin(x0, x1, t0, t1, t)
    local amp = x1 - x0
    local period = math.pi / (2 * (t1 - t0))
    t = clamp(t0, t1, t) - t0
    return amp * math.sin(t * period) + x0
end

-- half sine
function tween.funcs.h_sin(x0, x1, t0, t1, t)
    local amp = x1 - x0
    local period = math.pi / (t1 - t0)
    t = clamp(t0, t1, t) - t0
    return amp * math.sin(t * period) + x0
end

-- sine
function tween.funcs.sin(x0, x1, t0, t1, t)
    local amp = (x1 - x0) / 2
    local period = 2 * math.pi / (t1 - t0)
    t = clamp(t0, t1, t) - t0
    return amp * math.sin(t * period) + x0 + amp
end

-- heaviside H(t-t0)
function tween.funcs.heaviside(x0, x1, t0, t1, t)
    if t <= t0 then
        return x0
    else
        return x1
    end
end

-- heaviside difference H(t-t0) - H(t-t1)
function tween.funcs.heaviside_difference(x0, x1, t0, t1, t)
    if t <= t0 or t >= t1 then
        return x0
    else
        return x1
    end
end

-- tweening repetition behaviours
tween.repeat_funcs = {}
function tween.repeat_funcs.once(t0, t1, t) return t end

function tween.repeat_funcs.loop(t0, t1, t)
    if t < t0 then
        return t
    else
        return t0 + ((t - t0) % (t1 - t0))
    end
end

tween.Tweener = {}

function tween.Tweener:new(arg)
    arg = arg or {}
    arg.tweens = arg.tweens or {}

    setmetatable(arg, self)
    self.__index = self
    return arg
end

function tween.Tweener:to(object, property, x0, x1, t0, t1, func, repeat_func)
    self:finish(object, property)
    local entry = {
        x0 = x0,
        x1 = x1,
        t0 = t0,
        t1 = t1,
        t = 0,
        func = func,
        repeat_func = repeat_func or tween.repeat_funcs.once
    }
    self.tweens[object] = self.tweens[object] or {}
    self.tweens[object][property] = entry

    object[property] = func(x0, x1, t0, t1, t0)
end

function tween.Tweener:finish(object, property)
    if self.tweens[object] and self.tweens[object][property] then
        local params = self.tweens[object][property]
        object[property] = params.func(params.x0, params.x1, params.t0,
                                       params.t1, params.t1)
        self.tweens[object][property] = nil
    end
end

function tween.Tweener:update(dt)
    for obj, entries in pairs(self.tweens) do
        for property, params in pairs(entries) do
            -- print(obj,property)
            params.t = params.t + dt
            local t = params.repeat_func(params.t0, params.t1, params.t)
            obj[property] = params.func(params.x0, params.x1, params.t0,
                                        params.t1, t)
            if t > params.t1 then self.tweens[obj][property] = nil end
        end
    end
end

return tween
