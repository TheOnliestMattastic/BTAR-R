-- states/init.lua
local StateManager = {}

local currentState = nil
local states = {}



-- Load available state modules from the states/ folder
function StateManager.setup()
-- Require known states; keep names in states table
states.game = require "states.game"
states.menu = require "states.menu"
end

-- Switch to a named state (calls load if present)
function StateManager.switch(stateName, ...)
    local state = states[stateName]
if not state then
    error("Unknown state: " .. tostring(stateName))
end
currentState = state
if currentState.load then currentState.load(...) end
end

-- Delegation helpers
function StateManager.update(deltaTime)
    if currentState and currentState.update then currentState.update(deltaTime) end
end

function StateManager.draw()
    if currentState and currentState.draw then currentState.draw() end
end

function StateManager.mousepressed(x, y, button, istouch)
    if currentState and currentState.mousepressed then currentState.mousepressed(x, y, button, istouch) end
end

function StateManager.keypressed(key)
    if currentState and currentState.keypressed then currentState.keypressed(key) end
end

return StateManager
