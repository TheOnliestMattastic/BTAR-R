-- states/init.lua
local M = {}

local active = nil
local registry = {}

-- Load available state modules from the states/ folder
function M.setup()
    -- require known states; keep names in registry
    registry.menu = require "states.menu"
    registry.inGame = require "states.game"
end

-- Switch to a named state (calls load if present)
function M.switch(name, ...)
    local s = registry[name]
    if not s then
        error("Unknown state: " .. tostring(name))
    end
    active = s
    if active.load then active.load(...) end
end

-- Delegation helpers
function M.update(dt)
    if active and active.update then active.update(dt) end
end

function M.draw()
    if active and active.draw then active.draw() end
end

function M.mousepressed(x, y, button, istouch)
    if active and active.mousepressed then active.mousepressed(x, y, button, istouch) end
end

function M.keypressed(key)
    if active and active.keypressed then active.keypressed(key) end
end

return M
