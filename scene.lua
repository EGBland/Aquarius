local scene = {}

scene.Scene = {
    id = nil,
    previous_scene = nil,

    do_load = nil,
    do_init = nil,
    do_exit = nil,
    do_dispose = nil,

    do_draw = nil,
    do_update = nil,
    do_keypressed = nil,
    do_keyreleased = nil,

    on_focus = nil,
    on_unfocus = nil
}

function scene.Scene:new(arg)
    arg = arg or {}
    setmetatable(arg, self)
    self.__index = self
    return arg
end

function scene.Scene:init()
    if self.do_load then self:do_load() end
    if self.do_init then self:do_init() end
end
function scene.Scene:exit() if self.do_exit then self:do_exit() end end
function scene.Scene:draw() if self.do_draw then self:do_draw() end end
function scene.Scene:update(dt) if self.do_update then self:do_update(dt) end end
function scene.Scene:keypressed(k, sc, r)
    if self.do_keypressed then self:do_keypressed(k, sc, r) end
end
function scene.Scene:keyreleased(k, sc)
    if self.do_keyreleased then self:do_keyreleased(k, sc) end
end

scene.SceneManager = {current_scene = nil}

function scene.SceneManager:new(arg)
    arg = arg or {}
    setmetatable(arg, self)
    self.__index = self
    return arg
end

function scene.SceneManager:push(scene)
    local prev_scene = self.current_scene
    scene.previous_scene = prev_scene
    self.current_scene = scene
    scene:init()
end

function scene.SceneManager:pop()
    local next_scene = self.current_scene.previous_scene
    self.current_scene:exit()
    -- TODO transition
    self.current_scene = next_scene
end

function scene.SceneManager:draw()
    if self.current_scene then self.current_scene:draw() end
end

function scene.SceneManager:update(dt)
    if self.current_scene then self.current_scene:update(dt) end
end

return scene
